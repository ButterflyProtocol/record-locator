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

      it 'should parse a hex string that starts with 0x', ->
        result = @recordLocator.fromString('0xa503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678')
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

      it 'should handle a hex string right padded with 00', ->
        result = @recordLocator.fromString('0xa503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678000000')
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

    describe 'fromBuffer', ->
      it 'should parse a buffer', ->
        result = @recordLocator.fromBuffer(Buffer.from('a503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678', 'hex'))
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

      it 'should handle a buffer right padded with 00', ->
        result = @recordLocator.fromBuffer(Buffer.from('a503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678000000', 'hex'))
        expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')


  describe 'record', ->
    it 'should resolve the record', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.record).to.eql({hello: 'world'})


  describe 'toString', ->
    it 'should return the string representation of the record locator', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.toString()).to.equal('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3')

  describe 'toBuffer', ->
    it 'should return the buffer representation of the record locator', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.toBuffer()).to.eql(Buffer.from('a503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678', 'hex'))

  describe 'toHex', ->
    it 'should return the hex representation of the record locator', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.toHex()).to.equal('0xa503221220f065856cd27b42f04ca64871ef6f51db02460480fb4f3167d471ee4f06251678000000')

  describe 'toHexArray', ->
    it 'should return the hex array representation of the record locator', ->
      result = await new @recordLocator('/ipfs/QmeX4LqdCABAMQtufXHRmnRc8D4eAB4JfC1dCqxtX2xpn3').ready()
      expect(result.toHexArray()).to.eql(['0xa503221220f06585','0x6cd27b42f04ca648','0x71ef6f51db024604','0x80fb4f3167d471ee','0x4f06251678000000'])
