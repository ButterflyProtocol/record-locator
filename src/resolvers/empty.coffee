class EmptyResolver
  constructor: (@resource, @node, @connectors, @options={}) ->
    @ready()

  ready: -> @_ready ?= new Promise (resolve) => resolve(@)

  resolve: (refresh=false) ->
    @ready().then =>
      {
        version: '0.0.1',
        name: 'Empty Record',
        description: "This zone doesn't have a record set",
        meta: {
          status: 'empty',
          index: false,
          tags: []
        },
        services: {
          site: []
        },
        links: {
        }
      }

EmptyResolver.id = 'empty'

module.exports = EmptyResolver

