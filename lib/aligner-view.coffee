{View} = require 'atom'

module.exports =
class AlignerView extends View
  @content: ->
    @div class: 'aligner overlay from-top', =>
      @div "The Aligner package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "aligner:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "AlignerView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
