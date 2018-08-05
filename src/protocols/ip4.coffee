ip = require 'ip'
ipAddress = require 'ip-address'

BaseProtocol = require './base'

class IP4Protocol extends BaseProtocol
  constructor: (value) -> super(IP4Protocol, value)

  toBuf: (str) ->
    ipaddr = new ipAddress.Address4(str)
    throw new Error('invalid ip address') unless ipaddr.isValid()
    ip.toBuffer(ipaddr.address)

  toStr: (buf) -> ip.toString(buf)

IP4Protocol.type = 'node'
IP4Protocol.id = 'ip4'
IP4Protocol.code = 0x04
IP4Protocol.len = 4

module.exports = IP4Protocol
