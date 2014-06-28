import unsigned
import strutils


type
  BigIntDigits=seq[uint32] #a sequence of digits used for a big integer

  BigInt* =object
    digits*:BigIntDigits  #posetive digits in base maxvalue(uint)+1
    neg*:bool #true if negative, false if zero or posetive

let maxInt*: int64 = int64(high(uint32))


proc initBigInt *(val: uint32): BigInt
proc initBigInt *(): BigInt


proc `shl`*(A:BigInt,i:int) : BigInt
proc invert*(A:BigInt) : BigInt
proc `+` *(A:BigInt,B:BigInt) : BigInt
proc `-` *(A:BigInt,B:BigInt) : BigInt
proc cmp(A:BigInt,B:BigInt) : int
proc `/`*(A:BigInt,B:BigInt) : BigInt
proc `*`*(A:BigInt,B:BigInt) : BigInt 


proc initBigInt *(val: uint32): BigInt =
  result.digits = @[val]
  result.neg = false

proc initBigInt *(): BigInt =
  result.digits = @[]
  result.neg = false

proc invert*(A:BigInt) : BigInt = 
  result = initBigInt()
  result.neg = not result.neg
  var i: int = A.digits.len -1
  while i >= 0:
    var tmp: uint32 = cast[uint32]((not cast[int32](A.digits[i])))
    result.digits.add(cast[uint32](tmp))
    i = i - 1



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
        if tmp > maxInt: #we overflowed
          carry = 1
          tmp=tmp - maxInt
        else:
          carry = 0
      else:
        tmp = int64(A.digits[i]) + carry
        if tmp > maxInt: #we overflowed
          carry = 1
          tmp=tmp - maxInt
        else:
          carry = 0
    else:
      tmp = int(B.digits[i]) + carry
      if tmp > maxInt: #we overflowed
        carry = 1
        tmp = tmp - maxInt
      else:
        carry = 0
    digits.add(cast[uint32](tmp))
    i = i + 1
  if not A.neg and not B.neg:
    result.neg = false
    if carry > 0:
      digits.add(cast[uint32](carry))
  elif A.neg and B.neg:
    result.neg = true
    if carry > 0:
      digits.add(cast[uint32](maxInt - carry))
  else: #one of them is negative
    if carry > 0:
      result.neg = false
    else:
      result.neg = true

  result.digits = digits

proc `-` *(A:BigInt,B:BigInt) : BigInt=
  result = A + invert(B)

#lets deal with all comparison ops via cmp

proc cmp(A:BigInt,B:BigInt) : int =
  #returns 0 if equal
  #returns -1 if A < B
  #returns 1 is A > B
  let tmp : BigInt = A-B
  var zero : bool = true
  for d in tmp.digits:
    if not (d == 0'u32 or d == 4294967295'u32):
      zero = false
  if zero:
    return 0
  if tmp.neg:
    return -1
  else:
    return 1

proc `==`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) == 0


proc `<=`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) <= 0


proc `<`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) < 0

proc `/`*(A:BigInt,B:BigInt) : BigInt = 
  result = initBigInt(0)
  var tmp : BigInt = A
  while tmp > B:
    tmp = tmp - B
    result = result + initBigInt(1)

proc `mod`*(A:BigInt,B:BigInt) : BigInt = 
  var C : BigInt = (A / B) * B
  result = A - C

proc `shl`*(A:BigInt,i:int) : BigInt =
  var j : int = i mod 32
  var C : BigInt = initBigInt()
  C.neg = A.neg
  var val, carry : int64
  if (i div 32) > 0: #we need to shift multiple sections
    for x in 0..((i div 32) - 1):
      C.digits.add(0)
  for k in 1..A.digits.len:
    var d : uint32 = A.digits[A.digits.len-k]
    val = (cast[int64](d) shl j) + carry
    carry = val shr 32
    C.digits.add(uint32(val))
  if carry > 0:
    C.digits.add(uint32(carry))
  echo(carry,C.digits)

  result = C

proc `shr`*(A: BigInt, i: int) : BigInt =
  let
    bigShifts = i div 32
    littleShifts = (i mod 32).uint32
 
  result = BigInt(digits : newSeq[uint32](A.digits.len - bigshifts),
                  neg : A.neg)
 
  for shift in bigShifts..(A.digits.len-1):
    result.digits[shift-bigShifts] = A.digits[shift]
 
  for i in 0..(result.digits.len - 1):
    # current bottom bits are next top bits
    let carry = result.digits[i] shl (32.uint32 - littleShifts)
 
    result.digits[i] = result.digits[i] shr littleShifts
 
    # Make sure bottom bits are thrown away, no OOB errors
    if i != 0:
      result.digits[i-1] = result.digits[i-1] or carry



proc `*`*(A:BigInt,B:BigInt) : BigInt = 
  result = initBigInt(0)
  for i in 0..(A.digits.len-1):
    var d : uint32 = A.digits[i]
    for j in 0..32:
      var one : uint32 = int(d shr uint32(i*32 + j)) and 1
      if one == 1:
        result = result + B shl (i*32 + j)




proc `$`*(A:BigInt) : string =
  result = ""
  for i in 1..A.digits.len:
    var d : int = int(A.digits[A.digits.len - i])
    result = result&toHex(int(d),8)
  return "0x"&result
