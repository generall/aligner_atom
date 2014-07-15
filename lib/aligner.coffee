RangeFinder = require './range-finder'

{spawn} = require 'child_process'

module.exports =
  activate: ->
    atom.workspaceView.command "aligner:align", => @align()


  align: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.getActiveEditor()
    #editor.insertText('Hello, World!')
    #editor.selectToBeginningOfLine()
    #editor.selectToEndOfLine()
    sortableRanges = RangeFinder.rangesFor(editor)

    console.log(__dirname)

    grammar = editor.getGrammar().name

    switch grammar
      when "C" then grammar = "C99"
      when "C++" then grammar = "C99"
      when "Java" then grammar = "java"
      else grammar = "default"

    sortableRanges.forEach (range) ->
      textLines = editor.getTextInBufferRange(range).split("\n")
      #editor.setTextInBufferRange(range, textLines.join("\n"))
      stdout = ""
      stderr = ""
      prev_dir =  process.cwd();
      path  = __dirname + "/ruby"
      process.chdir(path)

      if textLines.length > 1
        proc = spawn process.env.SHELL, ["-l", "-c", "ruby pipe_launch.rb " + grammar]
        proc.stderr.on 'data', (text) ->
          stderr += text
        proc.stdout.on 'data', (text) ->
          stdout += text
        proc.on 'close', (code) ->
          #console.log(stdout);
          #console.log(stderr);
          editor.setTextInBufferRange(range, stdout.replace(/\n$/, ''))
          #editor.setSelectedBufferRange(new Range(range.start, range.start))
        proc.stdin.write(textLines.length.toString() + "\n")
        proc.stdin.write(textLines.join("\n"))
        proc.stdin.end()
      process.chdir(prev_dir)
