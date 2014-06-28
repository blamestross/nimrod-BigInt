import bigints

var A: BigInt = initBigInt(uint32(0x1))
var B: BigInt = initBigInt(uint32(0x123546))
echo((A shl 200) shr 196)