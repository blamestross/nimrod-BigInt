type
  BigIntDigits=seq[uint32] #a sequence of digits used for a big integer

  BigInt* =object
    digits:BigIntDigits  #posetive digits in base maxvalue(uint)+1
    neg:bool #true if negative, false if zero or posetive

var maxInt: int64 = int64(high(int32))

echo(maxInt)

proc initBigInt *(val: uint32): BigInt =
  result.digits = cast[BigIntDigits](@[val])
  result.neg = false


proc invert(A:BigInt) : BigInt = 
  result = initBigInt(0)
  result.neg = not result.neg
  var digits : BigIntDigits = @[]
  var i: int = A.digits.len -1
  while i >= 0:
    var tmp: int64 = int64(A.digits[i])
    tmp = tmp * -1
    digits.add(cast[uint32](tmp))
    i = i - 1
  result.digits = digits


proc `-` *(A:BigInt,B:BigInt) : BigInt=
  result = A + invert(B)

proc `+` *(A:BigInt,B:BigInt) : BigInt=
  result = initBigInt(0)
  var digits : BigIntDigits = @[]
  var i: int = 0
  var carry: int64 = 0
  while i < A.digits.len or i < B.digits.len:
    var tmp: int64
    if i < A.digits.len:
      if i < B.digits.len:
        tmp = int64(A.digits[i]) + int64(B.digits[i]) + carry
        if tmp < 0: #we underflowed
          carry = 1
          tmp=tmp + maxInt
        else:
          carry = 0
      else:
        tmp = int64(A.digits[i]) + carry
        if tmp < 0: #we underflowed
          carry = 1
          tmp=tmp + maxInt
        else:
          carry = 0
    else:
      tmp = int(B.digits[i]) + carry
      if tmp < 0: #we underflowed
        carry = 1
        tmp=tmp + maxInt
      else:
        carry = 0
    digits.add(cast[uint32](tmp))
    i = i + 1
  if carry > 0:
    result.neg = true
  result.digits = digits

  

var A :BigInt = initBigInt(2)
var B :BigInt = initBigInt(10)


let C: BigInt = B+invert(A)
echo(C.digits)