
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
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
%VA_List = type i8*
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
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;
; from included ctypes
; from included stdio
%File = type i8;
%FposT = type i8;
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
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [38 x i8] [i8 42, i8 42, i8 42, i8 32, i8 77, i8 69, i8 77, i8 79, i8 82, i8 89, i8 32, i8 86, i8 73, i8 79, i8 76, i8 65, i8 84, i8 73, i8 79, i8 78, i8 32, i8 39, i8 37, i8 99, i8 39, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 42, i8 42, i8 42, i8 10, i8 0]
@str2 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 117, i8 0]
@str4 = private constant [3 x i8] [i8 37, i8 117, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 120, i8 0]
@str6 = private constant [3 x i8] [i8 37, i8 120, i8 0]


@rom = global [65536 x i8] zeroinitializer
@ram = global [4096 x i8] zeroinitializer

define internal void @memoryViolation(i8 %rw, i32 %adr) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str1 to [0 x i8]*), i8 %rw, i32 %adr)
	;	memoryViolation_event(0x55) // !
	ret void
}

define internal i1 @adressInRange(i32 %x, i32 %a, i32 %b) {
	%1 = icmp uge i32 %x, %a
	%2 = icmp ult i32 %x, %b
	%3 = and i1 %1, %2
	ret i1 %3
}



define [0 x i8]* @mem_get_ram_ptr() {
	%1 = bitcast [4096 x i8]* @ram to [0 x i8]*
	ret [0 x i8]* %1
}

define [0 x i8]* @mem_get_rom_ptr() {
	%1 = bitcast [65536 x i8]* @rom to [0 x i8]*
	ret [0 x i8]* %1
}

define i8 @mem_read8(i32 %adr) {
	%1 = alloca i8, align 1
	store i8 0, i8* %1
	%2 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = sub i32 %adr, 268435456
	%4 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* %5 to i8*
	%7 = load i8, i8* %6
	store i8 %7, i8* %1
	br label %endif_0
else_0:
	%8 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %8 , label %then_1, label %else_1
then_1:
	;
	br label %endif_1
else_1:
	%9 = call i1 @adressInRange(i32 %adr, i32 0, i32 65536)
	br i1 %9 , label %then_2, label %else_2
then_2:
	%10 = sub i32 %adr, 0
	%11 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* %12 to i8*
	%14 = load i8, i8* %13
	store i8 %14, i8* %1
	br label %endif_2
else_2:
	call void @memoryViolation(i8 114, i32 %adr)
	store i8 0, i8* %1
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	;printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)
	%15 = load i8, i8* %1
	ret i8 %15
}

define i16 @mem_read16(i32 %adr) {
	%1 = alloca i16, align 2
	store i16 0, i16* %1
	%2 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = sub i32 %adr, 268435456
	%4 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* %5 to i16*
	%7 = load i16, i16* %6
	store i16 %7, i16* %1
	br label %endif_0
else_0:
	%8 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %8 , label %then_1, label %else_1
then_1:
	;
	br label %endif_1
else_1:
	%9 = call i1 @adressInRange(i32 %adr, i32 0, i32 65536)
	br i1 %9 , label %then_2, label %else_2
then_2:
	%10 = sub i32 %adr, 0
	%11 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* %12 to i16*
	%14 = load i16, i16* %13
	store i16 %14, i16* %1
	br label %endif_2
else_2:
	call void @memoryViolation(i8 114, i32 %adr)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	;printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
	%15 = load i16, i16* %1
	ret i16 %15
}

define i32 @mem_read32(i32 %adr) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	%2 = call i1 @adressInRange(i32 %adr, i32 0, i32 65536)
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = sub i32 %adr, 0
	%4 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* %5 to i32*
	%7 = load i32, i32* %6
	store i32 %7, i32* %1
	br label %endif_0
else_0:
	%8 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %8 , label %then_1, label %else_1
then_1:
	%9 = sub i32 %adr, 268435456
	%10 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* %11 to i32*
	%13 = load i32, i32* %12
	store i32 %13, i32* %1
	br label %endif_1
else_1:
	%14 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %14 , label %then_2, label %else_2
then_2:
	;TODO
	br label %endif_2
else_2:
	call void @memoryViolation(i8 114, i32 %adr)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	;printf("MEM_READ_32[%x] = 0x%x\n", adr, x)
	%15 = load i32, i32* %1
	ret i32 %15
}

define void @mem_write8(i32 %adr, i8 %value) {
	%1 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %1 , label %then_0, label %else_0
then_0:
	%2 = sub i32 %adr, 268435456
	%3 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* %4 to i8*
	store i8 %value, i8* %5
	br label %endif_0
else_0:
	%6 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %6 , label %then_1, label %else_1
then_1:
	%7 = icmp eq i32 %adr, 4027318288
	br i1 %7 , label %then_2, label %endif_2
then_2:
	%8 = bitcast i8 %value to i8
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str2 to [0 x i8]*), i8 %8)
	ret void
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	call void @memoryViolation(i8 119, i32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define void @mem_write16(i32 %adr, i16 %value) {
	%1 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %1 , label %then_0, label %else_0
then_0:
	%2 = sub i32 %adr, 268435456
	%3 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* %4 to i16*
	store i16 %value, i16* %5
	br label %endif_0
else_0:
	%6 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %6 , label %then_1, label %else_1
then_1:
	%7 = icmp eq i32 %adr, 4027318288
	br i1 %7 , label %then_2, label %endif_2
then_2:
	%8 = sext i16 %value to %Int
	%9 = call %Int @putchar(%Int %8)
	ret void
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	call void @memoryViolation(i8 119, i32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define void @mem_write32(i32 %adr, i32 %value) {
	%1 = call i1 @adressInRange(i32 %adr, i32 268435456, i32 268439552)
	br i1 %1 , label %then_0, label %else_0
then_0:
	%2 = sub i32 %adr, 268435456
	%3 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* %4 to i32*
	store i32 %value, i32* %5
	br label %endif_0
else_0:
	%6 = call i1 @adressInRange(i32 %adr, i32 4027318272, i32 4027383807)
	br i1 %6 , label %then_1, label %else_1
then_1:
	%7 = icmp eq i32 %adr, 4027318288
	br i1 %7 , label %then_2, label %else_2
then_2:
	%8 = bitcast i32 %value to %Int
	%9 = call %Int @putchar(%Int %8)
	ret void
	br label %endif_2
else_2:
	%11 = icmp eq i32 %adr, 4027318304
	br i1 %11 , label %then_3, label %else_3
then_3:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), i32 %value)
	ret void
	br label %endif_3
else_3:
	%14 = icmp eq i32 %adr, 4027318308
	br i1 %14 , label %then_4, label %else_4
then_4:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*), i32 %value)
	ret void
	br label %endif_4
else_4:
	%17 = icmp eq i32 %adr, 4027318312
	br i1 %17 , label %then_5, label %else_5
then_5:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32 %value)
	ret void
	br label %endif_5
else_5:
	%20 = icmp eq i32 %adr, 4027318316
	br i1 %20 , label %then_6, label %endif_6
then_6:
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str6 to [0 x i8]*), i32 %value)
	ret void
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	call void @memoryViolation(i8 119, i32 %adr)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	;printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
	ret void
}


