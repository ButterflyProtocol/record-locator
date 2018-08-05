bs58 = require 'bs58'
BaseProtocol = require './base'

class IPFSProtocol extends BaseProtocol
  constructor: (value) -> super(IPFSProtocol, value)

  toBuf: (str) -> bs58.decode(str)
  toStr: (buf) -> bs58.encode(buf)

IPFSProtocol.type = 'resource'
IPFSProtocol.id = 'ipfs'
IPFSProtocol.code = 0x01a5
IPFSProtocol.len = BaseProtocol.variable

module.exports = IPFSProtocol
