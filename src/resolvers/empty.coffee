class EmptyResolver
  constructor: (@resource, @node, @connectors, @options={}) ->
    @ready()

  ready: -> @_ready ?= new Promise (resolve) => resolve(@)

  resolve: (refresh=false) ->
    @ready().then =>
      {
        version: 0,
        status: 'empty',
        name: 'Empty Record',
        description: "This zone doesn't have a record set"
      }

EmptyResolver.id = 'empty'

module.exports = EmptyResolver

