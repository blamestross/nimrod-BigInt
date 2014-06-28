import bigints

when isMainModule:
  var a = initBigInt(0x123456)
  echo(a shl 20 shr 24)
