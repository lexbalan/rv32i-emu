
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

; MODULE: main

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
declare [0 x i8]* @mem_get_ram_ptr()
declare [0 x i8]* @mem_get_rom_ptr()
declare i8 @mem_read8(i32 %adr)
declare i16 @mem_read16(i32 %adr)
declare i32 @mem_read32(i32 %adr)
declare void @mem_write8(i32 %adr, i8 %value)
declare void @mem_write16(i32 %adr, i16 %value)
declare void @mem_write32(i32 %adr, i32 %value)
; from included decode
declare i8 @decode_extract_op(i32 %instr)
declare i8 @decode_extract_funct3(i32 %instr)
declare i8 @decode_extract_rd(i32 %instr)
declare i8 @decode_extract_rs1(i32 %instr)
declare i8 @decode_extract_rs2(i32 %instr)
declare i8 @decode_extract_funct7(i32 %instr)
declare i32 @decode_extract_imm12(i32 %instr)
declare i32 @decode_extract_imm31_12(i32 %instr)
declare i32 @decode_extract_jal_imm(i32 %instr)
declare i32 @decode_expand12(i32 %val_12bit)
declare i32 @decode_expand20(i32 %val_20bit)
%core_BusInterface = type {
	i8 (i32)*, 
	i16 (i32)*, 
	i32 (i32)*, 
	void (i32, i8)*, 
	void (i32, i16)*, 
	void (i32, i32)*
};

%core_Core = type {
	[32 x i32], 
	i32, 
	i32, 
	%core_BusInterface*, 
	i1, 
	i32, 
	i32
};

declare void @core_init(%core_Core* %core, %core_BusInterface* %bus)
declare void @core_tick(%core_Core* %core)
declare void @core_irq(%core_Core* %core, i32 %irq)
; -- end print imports --
; -- strings --
@str1 = private constant [11 x i8] [i8 82, i8 73, i8 83, i8 67, i8 45, i8 86, i8 32, i8 86, i8 77, i8 10, i8 0]
@str2 = private constant [11 x i8] [i8 46, i8 47, i8 109, i8 97, i8 105, i8 110, i8 46, i8 98, i8 105, i8 110, i8 0]
@str3 = private constant [15 x i8] [i8 126, i8 126, i8 126, i8 32, i8 83, i8 84, i8 65, i8 82, i8 84, i8 32, i8 126, i8 126, i8 126, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 99, i8 111, i8 114, i8 101, i8 46, i8 99, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 10, i8 67, i8 111, i8 114, i8 101, i8 32, i8 100, i8 117, i8 109, i8 112, i8 58, i8 10, i8 0]
@str6 = private constant [2 x i8] [i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 76, i8 79, i8 65, i8 68, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str8 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str9 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str10 = private constant [19 x i8] [i8 76, i8 79, i8 65, i8 68, i8 69, i8 68, i8 58, i8 32, i8 37, i8 122, i8 117, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str11 = private constant [15 x i8] [i8 37, i8 48, i8 56, i8 122, i8 120, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str12 = private constant [13 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str13 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str14 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str15 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str16 = private constant [5 x i8] [i8 37, i8 48, i8 56, i8 88, i8 0]
@str17 = private constant [6 x i8] [i8 32, i8 37, i8 48, i8 50, i8 88, i8 0]
@str18 = private constant [2 x i8] [i8 10, i8 0]


@core = global %core_Core zeroinitializer

define internal i32 @loader(%Str8* %filename, [0 x i8]* %bufptr, i32 %buf_size) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str7 to [0 x i8]*), %Str8* %filename)
	%2 = call %File* @fopen(%Str8* %filename, %ConstCharStr* bitcast ([3 x i8]* @str8 to [0 x i8]*))
	%3 = bitcast i8* null to %File*
	%4 = icmp eq %File* %2, %3
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str9 to [0 x i8]*), %Str8* %filename)
	ret i32 0
	br label %endif_0
endif_0:
	%7 = bitcast [0 x i8]* %bufptr to i8*
	%8 = zext i32 %buf_size to %SizeT
	%9 = call %SizeT @fread(i8* %7, %SizeT 1, %SizeT %8, %File* %2)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str10 to [0 x i8]*), %SizeT %9)
	br i1 0 , label %then_1, label %endif_1
then_1:
	%11 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %11
	br label %again_1
again_1:
	%12 = load %SizeT, %SizeT* %11
	%13 = udiv %SizeT %9, 4
	%14 = icmp ult %SizeT %12, %13
	br i1 %14 , label %body_1, label %break_1
body_1:
	%15 = load %SizeT, %SizeT* %11
	%16 = bitcast [0 x i8]* %bufptr to [0 x i32]*
	%17 = load %SizeT, %SizeT* %11
	%18 = getelementptr inbounds [0 x i32], [0 x i32]* %16, i32 0, %SizeT %17
	%19 = load i32, i32* %18
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str11 to [0 x i8]*), %SizeT %15, i32 %19)
	%21 = load %SizeT, %SizeT* %11
	%22 = add %SizeT %21, 4
	store %SizeT %22, %SizeT* %11
	br label %again_1
break_1:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str12 to [0 x i8]*))
	br label %endif_1
endif_1:
	%24 = call %Int @fclose(%File* %2)
	%25 = trunc %SizeT %9 to i32
	ret i32 %25
}

define internal void @show_regs(%core_Core* %core) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, 16
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = getelementptr inbounds %core_Core, %core_Core* %core, i32 0, i32 0
	%6 = load i32, i32* %1
	%7 = getelementptr inbounds [32 x i32], [32 x i32]* %5, i32 0, i32 %6
	%8 = load i32, i32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), i32 %4, i32 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str14 to [0 x i8]*))
	%11 = load i32, i32* %1
	%12 = add i32 %11, 16
	%13 = getelementptr inbounds %core_Core, %core_Core* %core, i32 0, i32 0
	%14 = load i32, i32* %1
	%15 = add i32 %14, 16
	%16 = getelementptr inbounds [32 x i32], [32 x i32]* %13, i32 0, i32 %15
	%17 = load i32, i32* %16
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str15 to [0 x i8]*), i32 %12, i32 %17)
	%19 = load i32, i32* %1
	%20 = add i32 %19, 1
	store i32 %20, i32* %1
	br label %again_1
break_1:
	ret void
}

define internal void @show_mem() {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	%2 = call [0 x i8]* @mem_get_ram_ptr()
	br label %again_1
again_1:
	%3 = load i32, i32* %1
	%4 = icmp slt i32 %3, 256
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = load i32, i32* %1
	%6 = mul i32 %5, 16
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str16 to [0 x i8]*), i32 %6)
	%8 = alloca i32, align 4
	store i32 0, i32* %8
	br label %again_2
again_2:
	%9 = load i32, i32* %8
	%10 = icmp slt i32 %9, 16
	br i1 %10 , label %body_2, label %break_2
body_2:
	%11 = load i32, i32* %1
	%12 = load i32, i32* %8
	%13 = add i32 %11, %12
	%14 = getelementptr inbounds [0 x i8], [0 x i8]* %2, i32 0, i32 %13
	%15 = load i8, i8* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str17 to [0 x i8]*), i8 %15)
	%17 = load i32, i32* %8
	%18 = add i32 %17, 1
	store i32 %18, i32* %8
	br label %again_2
break_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str18 to [0 x i8]*))
	%20 = load i32, i32* %1
	%21 = add i32 %20, 16
	store i32 %21, i32* %1
	br label %again_1
break_1:
	ret void
}


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %core_BusInterface, align 8
	%3 = insertvalue %core_BusInterface zeroinitializer, i8 (i32)* @mem_read8, 0
	%4 = insertvalue %core_BusInterface %3, i16 (i32)* @mem_read16, 1
	%5 = insertvalue %core_BusInterface %4, i32 (i32)* @mem_read32, 2
	%6 = insertvalue %core_BusInterface %5, void (i32, i8)* @mem_write8, 3
	%7 = insertvalue %core_BusInterface %6, void (i32, i16)* @mem_write16, 4
	%8 = insertvalue %core_BusInterface %7, void (i32, i32)* @mem_write32, 5
	store %core_BusInterface %8, %core_BusInterface* %2
	%9 = call [0 x i8]* @mem_get_rom_ptr()
	%10 = bitcast i17 65536 to i32
	%11 = call i32 @loader(%Str8* bitcast ([11 x i8]* @str2 to [0 x i8]*), [0 x i8]* %9, i32 %10)
	%12 = icmp ule i32 %11, 0
	br i1 %12 , label %then_0, label %endif_0
then_0:
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%13 = bitcast %core_Core* @core to %core_Core*
	%14 = bitcast %core_BusInterface* %2 to %core_BusInterface*
	call void @core_init(%core_Core* %13, %core_BusInterface* %14)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*))
	br label %again_1
again_1:
	%16 = getelementptr inbounds %core_Core, %core_Core* @core, i32 0, i32 4
	%17 = load i1, i1* %16
	%18 = xor i1 %17, -1
	br i1 %18 , label %body_1, label %break_1
body_1:
	%19 = bitcast %core_Core* @core to %core_Core*
	call void @core_tick(%core_Core* %19)
	br label %again_1
break_1:
	%20 = getelementptr inbounds %core_Core, %core_Core* @core, i32 0, i32 6
	%21 = load i32, i32* %20
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), i32 %21)
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*))
	%24 = bitcast %core_Core* @core to %core_Core*
	call void @show_regs(%core_Core* %24)
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str6 to [0 x i8]*))
	call void @show_mem()
	ret %Int 0
}


