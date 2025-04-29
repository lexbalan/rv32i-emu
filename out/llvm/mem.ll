
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

; MODULE: mem

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type %Nat8;
%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; -- end print includes --
; -- print imports 'mem' --
; -- 1
; ?? mmio ??
; from included ctypes
; from import
declare void @mmio_write8(%Nat32 %adr, %Word8 %value)
declare void @mmio_write16(%Nat32 %adr, %Word16 %value)
declare void @mmio_write32(%Nat32 %adr, %Word32 %value)
declare %Word8 @mmio_read8(%Nat32 %adr)
declare %Word16 @mmio_read16(%Nat32 %adr)
declare %Word32 @mmio_read32(%Nat32 %adr)
; end from import
; -- end print imports 'mem' --
; -- strings --
@str1 = private constant [38 x i8] [i8 42, i8 42, i8 42, i8 32, i8 77, i8 69, i8 77, i8 79, i8 82, i8 89, i8 32, i8 86, i8 73, i8 79, i8 76, i8 65, i8 84, i8 73, i8 79, i8 78, i8 32, i8 39, i8 37, i8 99, i8 39, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 42, i8 42, i8 42, i8 10, i8 0]
; -- endstrings --
@rom = internal global [1048576 x %Word8] zeroinitializer
@ram = internal global [16384 x %Word8] zeroinitializer
define [0 x %Word8]* @mem_get_ram_ptr() {
	ret [0 x %Word8]* bitcast ([16384 x %Word8]* @ram to [0 x %Word8]*)
}

define [0 x %Word8]* @mem_get_rom_ptr() {
	ret [0 x %Word8]* bitcast ([1048576 x %Word8]* @rom to [0 x %Word8]*)
}

@memviolationCnt = internal global %Nat32 0
define internal void @memoryViolation(%Char8 %rw, %Nat32 %adr) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str1 to [0 x i8]*), %Char8 %rw, %Nat32 %adr)
; if_0
	%2 = load %Nat32, %Nat32* @memviolationCnt
	%3 = icmp ugt %Nat32 %2, 10
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%4 = load %Nat32, %Nat32* @memviolationCnt
	%5 = add %Nat32 %4, 1
	store %Nat32 %5, %Nat32* @memviolationCnt
	;	memoryViolation_event(0x55) // !
	ret void
}

define internal %Bool @isAdressInRange(%Nat32 %x, %Nat32 %a, %Nat32 %b) {
	%1 = icmp uge %Nat32 %x, %a
	%2 = icmp ult %Nat32 %x, %b
	%3 = and %Bool %1, %2
	ret %Bool %3
}

define %Word8 @mem_read8(%Nat32 %adr) {
	%1 = alloca %Word8, align 1
	%2 = bitcast i8 0 to %Word8
	store %Word8 %2, %Word8* %1
; if_0
	%3 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = sub %Nat32 %adr, 268435456
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %5
	%7 = bitcast %Word8* %6 to i8*
	%8 = bitcast i8* %7 to %Word8*
	%9 = load %Word8, %Word8* %8
	store %Word8 %9, %Word8* %1
	br label %endif_0
else_0:
; if_1
	%10 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %10 , label %then_1, label %else_1
then_1:
	;
	br label %endif_1
else_1:
; if_2
	%11 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 0, %Nat32 1048576)
	br %Bool %11 , label %then_2, label %else_2
then_2:
	%12 = sub %Nat32 %adr, 0
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %13
	%15 = bitcast %Word8* %14 to i8*
	%16 = bitcast i8* %15 to %Word8*
	%17 = load %Word8, %Word8* %16
	store %Word8 %17, %Word8* %1
	br label %endif_2
else_2:
	call void @memoryViolation(%Char8 114, %Nat32 %adr)
	%18 = bitcast i8 0 to %Word8
	store %Word8 %18, %Word8* %1
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:

	;printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)
	%19 = load %Word8, %Word8* %1
	ret %Word8 %19
}

define %Word16 @mem_read16(%Nat32 %adr) {
	%1 = alloca %Word16, align 2
	%2 = zext i8 0 to %Word16
	store %Word16 %2, %Word16* %1
; if_0
	%3 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = sub %Nat32 %adr, 268435456
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %5
	%7 = bitcast %Word8* %6 to i8*
	%8 = bitcast i8* %7 to %Word16*
	%9 = load %Word16, %Word16* %8
	store %Word16 %9, %Word16* %1
	br label %endif_0
else_0:
; if_1
	%10 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %10 , label %then_1, label %else_1
then_1:
	;
	br label %endif_1
else_1:
; if_2
	%11 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 0, %Nat32 1048576)
	br %Bool %11 , label %then_2, label %else_2
then_2:
	%12 = sub %Nat32 %adr, 0
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %13
	%15 = bitcast %Word8* %14 to i8*
	%16 = bitcast i8* %15 to %Word16*
	%17 = load %Word16, %Word16* %16
	store %Word16 %17, %Word16* %1
	br label %endif_2
else_2:
	call void @memoryViolation(%Char8 114, %Nat32 %adr)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:

	;printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
	%18 = load %Word16, %Word16* %1
	ret %Word16 %18
}

define %Word32 @mem_read32(%Nat32 %adr) {
	%1 = alloca %Word32, align 4
	%2 = zext i8 0 to %Word32
	store %Word32 %2, %Word32* %1
; if_0
	%3 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 0, %Nat32 1048576)
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = sub %Nat32 %adr, 0
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %5
	%7 = bitcast %Word8* %6 to i8*
	%8 = bitcast i8* %7 to %Word32*
	%9 = load %Word32, %Word32* %8
	store %Word32 %9, %Word32* %1
	br label %endif_0
else_0:
; if_1
	%10 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %10 , label %then_1, label %else_1
then_1:
	%11 = sub %Nat32 %adr, 268435456
	%12 = bitcast %Nat32 %11 to %Nat32
	%13 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %12
	%14 = bitcast %Word8* %13 to i8*
	%15 = bitcast i8* %14 to %Word32*
	%16 = load %Word32, %Word32* %15
	store %Word32 %16, %Word32* %1
	br label %endif_1
else_1:
; if_2
	%17 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %17 , label %then_2, label %else_2
then_2:
	;TODO
	br label %endif_2
else_2:
	call void @memoryViolation(%Char8 114, %Nat32 %adr)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:

	;printf("MEM_READ_32[%x] = 0x%x\n", adr, x)
	%18 = load %Word32, %Word32* %1
	ret %Word32 %18
}

define void @mem_write8(%Nat32 %adr, %Word8 %value) {
; if_0
	%1 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %1 , label %then_0, label %else_0
then_0:
	%2 = sub %Nat32 %adr, 268435456
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %3
	%5 = bitcast %Word8* %4 to i8*
	%6 = bitcast i8* %5 to %Word8*
	store %Word8 %value, %Word8* %6
	br label %endif_0
else_0:
; if_1
	%7 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %7 , label %then_1, label %else_1
then_1:
	%8 = sub %Nat32 %adr, 4027318272
	call void @mmio_write8(%Nat32 %8, %Word8 %value)
	br label %endif_1
else_1:
	call void @memoryViolation(%Char8 119, %Nat32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define void @mem_write16(%Nat32 %adr, %Word16 %value) {
; if_0
	%1 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %1 , label %then_0, label %else_0
then_0:
	%2 = sub %Nat32 %adr, 268435456
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %3
	%5 = bitcast %Word8* %4 to i8*
	%6 = bitcast i8* %5 to %Word16*
	store %Word16 %value, %Word16* %6
	br label %endif_0
else_0:
; if_1
	%7 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %7 , label %then_1, label %else_1
then_1:
	%8 = sub %Nat32 %adr, 4027318272
	call void @mmio_write16(%Nat32 %8, %Word16 %value)
	br label %endif_1
else_1:
	call void @memoryViolation(%Char8 119, %Nat32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define void @mem_write32(%Nat32 %adr, %Word32 %value) {
; if_0
	%1 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %1 , label %then_0, label %else_0
then_0:
	%2 = sub %Nat32 %adr, 268435456
	%3 = bitcast %Nat32 %2 to %Nat32
	%4 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %3
	%5 = bitcast %Word8* %4 to i8*
	%6 = bitcast i8* %5 to %Word32*
	store %Word32 %value, %Word32* %6
	br label %endif_0
else_0:
; if_1
	%7 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %7 , label %then_1, label %else_1
then_1:
	%8 = sub %Nat32 %adr, 4027318272
	call void @mmio_write32(%Nat32 %8, %Word32 %value)
	br label %endif_1
else_1:
	call void @memoryViolation(%Char8 119, %Nat32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:

	;printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
	ret void
}


