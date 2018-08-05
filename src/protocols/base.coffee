varint = require 'varint'

class BaseProtocol
  constructor: (properties, value) ->
    @type = properties.type
    @id = properties.id
    @code = properties.code
    @len = properties.len

    if (typeof value == 'string')
      @str = value
      @buf = @toBuf(@str)
    else if Buffer.isBuffer(value)
      @buf = value
      @str = @toStr(@buf)

  toBuf: (str) -> Buffer.from(str)
  toStr: (buf) -> buf.toString()

  toString: ->
    if @len then "/#{@id}/#{@str}"
    else "/#{@id}"

  toBuffer: ->
    if @len == -1
      Buffer.concat [
        Buffer.from(varint.encode(@code)),
        Buffer.from(varint.encode(@buf.length)),
        @buf
      ]
    else if @len == 0 then Buffer.from(varint.encode(@code))
    else
      Buffer.concat [
        Buffer.from(varint.encode(@code)),
        @buf.slice(0, @len)
      ]

BaseProtocol.variable = -1
module.exports = BaseProtocol
