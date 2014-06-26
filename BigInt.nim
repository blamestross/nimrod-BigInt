import unsigned

type
  BigIntDigits=seq[uint32] #a sequence of digits used for a big integer

  BigInt* =object
    digits*:BigIntDigits  #posetive digits in base maxvalue(uint)+1
    neg*:bool #true if negative, false if zero or posetive

var maxInt: int64 = int64(high(uint32))


proc initBigInt *(val: uint32): BigInt =
  result.digits = BigIntDigits(@[val])
  result.neg = false


proc invert*(A:BigInt) : BigInt = 
  result = initBigInt(0)
  result.neg = not result.neg
  var digits : BigIntDigits = @[]
  var i: int = A.digits.len -1
  while i >= 0:
    var tmp: uint32 = cast[uint32]((not cast[int32](A.digits[i])))
    digits.add(cast[uint32](tmp))
    i = i - 1
  result.digits = digits


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

proc `>=`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) >= 0

proc `<=`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) <= 0

proc `!=`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) != 0

proc `<`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) < 0

proc `>`*(A:BigInt,B:BigInt) : bool = 
  return cmp(A,B) > 0

proc `/`*(A:BigInt,B:BigInt) : BigInt = 
  result = initBigInt(0)
  var tmp : BigInt = A
  while tmp > B:
    tmp = tmp - B
    result = result + initBigInt(1)

proc `*`*(A:BigInt,B:BigInt) : BigInt = 
  var zero : BigInt = initBigInt(0)
  var one : BigInt = initBigInt(1)
  result = zero
  var tmp : BigInt
  if A.neg:
    tmp = invert(A)
  else:
    tmp = A
  while tmp > zero:
    tmp = tmp - one
    result = result + B



proc `mod`*(A:BigInt,B:BigInt) : BigInt = 
  var tmp : BigInt = A
  while tmp > B:
    tmp = tmp - B
  result = tmp

#Big-integers are ordinal

proc `$`*(A:BigInt) : string =
  result = ""
  const HexChars = "0123456789ABCDEF"
  for d in A.digits:
    var tmp : int = int(d)
    for i in 0..8:
      let digit : int = int(tmp mod 16)
      let c : char = HexChars[digit]
      result = c&result
      tmp = tmp /% 16
  return "0x"&result
