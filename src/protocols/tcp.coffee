BaseProtocol = require './base'

class TCPProtocol extends BaseProtocol
  constructor: (value) -> super(TCPProtocol, value)

  toBuf: (str) ->
    buf = Buffer.alloc(2)
    buf.writeUInt16BE(str, 0)
    buf

  toStr: (buf) -> buf.readUInt16BE(0).toString()

TCPProtocol.type = 'node'
TCPProtocol.id = 'tcp'
TCPProtocol.code = 0x06
TCPProtocol.len = 2

module.exports = TCPProtocol
