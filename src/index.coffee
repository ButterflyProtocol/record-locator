varint = require 'varint'
IPFS = require 'ipfs-api'

Utils = require '@dwns/utils'
Protocols = require './protocols'
Resolvers = require './resolvers'

RecordLocatorFactory = (connectors={}, options={}) ->
  class RecordLocator
    constructor: (@input, @record) ->
      return RecordLocator.from(@input, @record) unless Array.isArray(@input)

      @protos = for part in @input
        [klass, value] = part
        klass = RecordLocator.classFromId if (typeof klass == 'string')
        new klass(value)

      @node = []

      for proto in @protos
        switch proto.type
          when 'node' then @node.push(proto)
          when 'resource' then @resource = proto

      @resolver = new Resolvers[@resource?.id ? 'empty']((@record ? @resource), @node, connectors, options)
      @ready()


    ready: ->
      @_ready ?= new Promise (resolve) =>
        @resolver.ready()
        .then (resolver) =>
          @resource = resolver.resource
          @protos = @node.concat([@resource])
          @record = await resolver.resolve()
        .then => resolve(@)

    toString: -> Protocols.toString(@protos)

    toBuffer: -> Protocols.toBuffer(@protos)

    toHex: -> Utils.hexArrayToHex(@toHexArray())

    toHexArray: -> Utils.bufferToHexArray(@toBuffer(), 8)

  RecordLocator.classFromId = (id) ->
    klass = Protocols[id]
    throw new Error('invalid id') unless klass?.id == id
    klass

  RecordLocator.from = (recordLocator, record) ->
    if (recordLocator instanceof RecordLocator) then return recordLocator
    else if (typeof recordLocator == 'string') then RecordLocator.fromString(recordLocator, record)
    else if Buffer.isBuffer(protcol) then RecordLocator.fromBuffer(recordLocator, record)
    else throw new TypeError('invalid record locator')

  RecordLocator.fromString = (str, record) ->
    throw new TypeError('must be a String') unless (typeof str == 'string')
    switch str.slice(0,1)
      when '/'
        parts = str.split('/').slice(1)
        protos = []
        current = []

        for part in parts
          if current.length
            if current[0]?.len == 0
              protos.push(current)
              current = [RecordLocator.classFromId(part)]
            else
              current.push(part)
              protos.push(current)
              current = []
          else current = [RecordLocator.classFromId(part)]

        protos.push(current) if current.length

        new RecordLocator(protos, record)
      else
        switch str.slice(0,2)
          when '0x' then RecordLocator.fromBuffer(Buffer.from(str.slice(2), 'hex'))
          else throw new TypeError('invalid record locator')


  RecordLocator.fromBuffer = (buf, record) -> new RecordLocator(RecordLocator.argsFromBuffer(buf), record)

  RecordLocator.argsFromBuffer = (buf, memo=[]) ->
    throw new TypeError('must be a Buffer') unless Buffer.isBuffer(buf)
    if buf.length
      return memo if (code = varint.decode(buf)) == 0
      buf = buf.slice(varint.decode.bytes)
      klass = Protocols[code]
      throw new TypeError('invalid protocol') unless klass?.code == code

      if klass.len == -1
        len = varint.decode(buf)
        buf = buf.slice(varint.decode.bytes)
        value = buf.slice(0, len)
        buf = buf.slice(len)
        memo.push([klass, value])
      else if klass.len == 0
        memo.push([klass])
      else if klass.len > 0
        value = buf.slice(klass.len)
        buf = buf.slice(klass.len)
        memo.push([klass, value])
      else throw new Error('invalid proto len')

      RecordLocator.argsFromBuffer(buf, memo)
    else memo

  RecordLocator.Protocols = Protocols
  RecordLocator.IPFS = IPFS
  RecordLocator

module.exports = RecordLocatorFactory
