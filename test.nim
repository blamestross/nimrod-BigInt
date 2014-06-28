import bigints

var A: BigInt = initBigInt(uint32(0x123456))
var B: BigInt 
B = (A shl 200)
echo(B)
echo(B shr 196)#Here A equals B, off by 4-bits