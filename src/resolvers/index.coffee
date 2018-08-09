ResolverClasses = [
  require('./empty'),
  require('./ipfs')
]

Resolvers = {}

for klass in ResolverClasses
  Resolvers[klass.id] = klass

module.exports = Resolvers
