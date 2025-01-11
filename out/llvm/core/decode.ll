
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

; MODULE: decode

; -- print includes --
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
; -- endstrings --
define %Word8 @decode_extract_op(%Word32 %instr) {
	%1 = and %Word32 %instr, 127
	%2 = trunc %Word32 %1 to %Word8
	ret %Word8 %2
}

define %Word8 @decode_extract_funct2(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 25
	%2 = and %Word32 %1, 3
	%3 = trunc %Word32 %2 to %Word8
	ret %Word8 %3
}

define %Word8 @decode_extract_funct3(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 12
	%2 = and %Word32 %1, 7
	%3 = trunc %Word32 %2 to %Word8
	ret %Word8 %3
}

define %Word8 @decode_extract_funct5(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 27
	%2 = and %Word32 %1, 31
	%3 = trunc %Word32 %2 to %Word8
	ret %Word8 %3
}

define %Int8 @decode_extract_rd(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 7
	%2 = and %Word32 %1, 31
	%3 = trunc %Word32 %2 to %Int8
	ret %Int8 %3
}

define %Int8 @decode_extract_rs1(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 15
	%2 = and %Word32 %1, 31
	%3 = trunc %Word32 %2 to %Int8
	ret %Int8 %3
}

define %Int8 @decode_extract_rs2(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 20
	%2 = and %Word32 %1, 31
	%3 = trunc %Word32 %2 to %Int8
	ret %Int8 %3
}

define %Word8 @decode_extract_funct7(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 25
	%2 = and %Word32 %1, 127
	%3 = trunc %Word32 %2 to %Word8
	ret %Word8 %3
}



; bits: (31 .. 20)
define %Word32 @decode_extract_imm12(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 20
	%2 = and %Word32 %1, 4095
	ret %Word32 %2
}

define %Word32 @decode_extract_imm31_12(%Word32 %instr) {
	%1 = lshr %Word32 %instr, 12
	%2 = and %Word32 %1, 1048575
	ret %Word32 %2
}

define %Word32 @decode_extract_jal_imm(%Word32 %instr) {
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = lshr %Word32 %1, 0
	%3 = and %Word32 %2, 255
	%4 = shl %Word32 %3, 12
	%5 = lshr %Word32 %1, 8
	%6 = and %Word32 %5, 1
	%7 = shl %Word32 %6, 11
	%8 = lshr %Word32 %1, 9
	%9 = and %Word32 %8, 1023
	%10 = shl %Word32 %9, 1
	%11 = lshr %Word32 %1, 20
	%12 = and %Word32 %11, 1
	%13 = shl %Word32 %12, 20
	%14 = or %Word32 %7, %10
	%15 = or %Word32 %4, %14
	%16 = or %Word32 %13, %15
	ret %Word32 %16
}



; sign expand (12bit -> 32bit)
define %Int32 @decode_expand12(%Word32 %val_12bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_12bit, %Word32* %1
	%2 = load %Word32, %Word32* %1
	%3 = and %Word32 %2, 2048
	%4 = icmp ne %Word32 %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Word32, %Word32* %1
	%6 = or %Word32 %5, 4294963200
	store %Word32 %6, %Word32* %1
	br label %endif_0
endif_0:
	%7 = load %Word32, %Word32* %1
	%8 = bitcast %Word32 %7 to %Int32
	ret %Int32 %8
}



; sign expand (20bit -> 32bit)
define %Int32 @decode_expand20(%Word32 %val_20bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_20bit, %Word32* %1
	%2 = load %Word32, %Word32* %1
	%3 = and %Word32 %2, 524288
	%4 = icmp ne %Word32 %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Word32, %Word32* %1
	%6 = or %Word32 %5, 4293918720
	store %Word32 %6, %Word32* %1
	br label %endif_0
endif_0:
	%7 = load %Word32, %Word32* %1
	%8 = bitcast %Word32 %7 to %Int32
	ret %Int32 %8
}


