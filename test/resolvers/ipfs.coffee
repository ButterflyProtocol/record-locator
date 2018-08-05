chai = require 'chai'
expect = chai.expect

cbor = require 'borc'

ipfs = require 'ipfs-api'

Protocols = require '../../src/protocols'
IPFSResolver = require '../../src/resolvers/ipfs'

describe 'IPFSConnector', ->
  before ->
    @ipfs = new ipfs()
    @resource = new Protocols.ipfs('QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

  describe 'Class', ->
    describe 'constructor', ->
      it 'should create a resolver when passed an ipfs resource', ->
        result = new IPFSResolver(@resource, [], {ipfs: @ipfs})
        expect(result.record).to.be.undefined

      it 'should create a resolver when passed a record', ->
        result = await new IPFSResolver({hello: 'world'}, [], {ipfs: @ipfs}).ready()
        expect(result.record).to.eql({hello: 'world'})
        expect(result.resource.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

  describe 'resolve', ->
    it 'should return an object', ->
      result = await new IPFSResolver(@resource, [], {ipfs: @ipfs}).resolve()
      expect(result).to.eql({hello: 'world'})



