chai = require 'chai'
expect = chai.expect

ipfsAPI = require 'ipfs-api'

RecordLocator = require '../src'

describe 'RecordLocator', ->
  before ->
    @ipfs = new ipfsAPI()
    @recordLocator = RecordLocator({ipfs: @ipfs})

  describe 'Class', ->
    describe 'constructor', ->
      it 'should accept a record', ->
        result = await new @recordLocator('/ipfs', {hello: 'world'}).ready()
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')


    describe 'fromString', ->
      it 'should parse an ipfs string', ->
        result = @recordLocator.fromString('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')
        expect(result.toBuffer()).to.eql(Buffer.from('a503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678', 'hex'))

    describe 'fromBuffer', ->
      it 'should parse a buffer', ->
        result = @recordLocator.fromBuffer(Buffer.from('a503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678', 'hex'))
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

  describe 'record', ->
    it 'should resolve the record', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.record).to.eql({hello: 'world'})



