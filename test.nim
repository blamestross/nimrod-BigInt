import BigInt

var A: BigInt = initBigInt(10)
var B: BigInt = initBigInt(20)

var C: BigInt = A+B
echo(C)

C = A-B
echo(C)

c = invert(C)
echo(C)

C = C + initBigInt(40)

echo(C)