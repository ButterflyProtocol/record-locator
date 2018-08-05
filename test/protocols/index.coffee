chai = require 'chai'
expect = chai.expect

Protocols = require '../../src/protocols'

describe 'Protocols', ->
  before ->

  it 'should lookup a protocol by id', ->
    result = Protocols.ipfs
    expect(result.code).to.equal(421)

  it 'should lookup a protocol by code', ->
    result = Protocols[421]
    expect(result.id).to.equal('ipfs')

  it 'should make protocol properties available on an instance', ->
    result = new Protocols.ipfs()
    expect(result.code).to.equal(421)




