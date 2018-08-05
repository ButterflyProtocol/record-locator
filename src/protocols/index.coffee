ProtocolClasses = [
  require('./ip4'),
  require('./tcp'),
  require('./ipfs')
]

Protocols = {
  toString: (protos) -> (proto.toString() for proto in protos).join('')

  toBuffer: (protos) -> Buffer.concat(proto.toBuffer() for proto in protos)
}

for klass in ProtocolClasses
  Protocols[klass.id] = klass
  Protocols[klass.code] = klass

module.exports = Protocols
