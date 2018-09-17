cbor = require 'borc'
IpfsAPI = require 'ipfs-api'

Protocols = require '../protocols'

class IPFSResolver
  constructor: (@resource, @node, @connectors, @options={}) ->
    if @node.length then @api = new IpfsAPI(Protocols.toString(@node))
    else @api = @connectors.ipfs

    throw new Error('connector not found') unless @api

    @ready()

  ready: ->
    @_ready ?= new Promise (resolve) =>
      if (@resource instanceof Protocols.ipfs) then resolve(@)
      else
        @record = @resource
        @api.files.add(cbor.encode(@record))
        .then (file) => @resource = new Protocols.ipfs(file[0].hash)
        .then => resolve(@)

  resolve: (refresh=false) ->
    return @_resolve if !refresh && @_resolve?
    @ready().then =>
      @_resolve = @api.files.cat(@resource.toString())
      .then (file) => @rocord = cbor.decode(file)

IPFSResolver.id = 'ipfs'

module.exports = IPFSResolver
