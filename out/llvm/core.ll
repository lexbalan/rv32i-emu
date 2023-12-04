
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
%Char = type i8
%ConstChar = type i8
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double
%SizeT = type i64
%SSizeT = type i64

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp([0 x i8]*, [0 x i8]*, i64)
declare i32 @strcmp([0 x i8]*, [0 x i8]*)
declare [0 x i8]* @strcpy([0 x i8]*, [0 x i8]*)
declare i64 @strlen([0 x i8]*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat(%Str*, i32)
declare i32 @open(%Str*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str*)
declare i32 @closedir(%DIR*)


declare %Str* @getcwd(%Str*, i64)
declare %Str* @getenv(%Str*)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/core.hm



%MemoryInterface = type {
	i8(i32)*,
	i16(i32)*,
	i32(i32)*,
	void(i32, i8)*,
	void(i32, i16)*,
	void(i32, i32)*
}

%Core = type {
	[32 x i32],
	i32,
	i32,
	i1,
	%MemoryInterface*,
	[0 x i32]*,
	i32
}









; -- SOURCE: src/core.cm

@str1 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 105, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [18 x i8] [i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [19 x i8] [i8 115, i8 117, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str14 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str15 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str16 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str17 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str18 = private constant [18 x i8] [i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str19 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str20 = private constant [25 x i8] [i8 91, i8 37, i8 48, i8 52, i8 120, i8 93, i8 32, i8 37, i8 48, i8 50, i8 120, i8 37, i8 48, i8 50, i8 120, i8 37, i8 48, i8 50, i8 120, i8 37, i8 48, i8 50, i8 120, i8 32, i8 0]
@str21 = private constant [14 x i8] [i8 73, i8 78, i8 83, i8 84, i8 82, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str22 = private constant [11 x i8] [i8 79, i8 80, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str23 = private constant [15 x i8] [i8 108, i8 117, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str24 = private constant [17 x i8] [i8 97, i8 117, i8 105, i8 112, i8 99, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str25 = private constant [13 x i8] [i8 106, i8 97, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str26 = private constant [14 x i8] [i8 106, i8 97, i8 108, i8 114, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str27 = private constant [18 x i8] [i8 98, i8 101, i8 113, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str28 = private constant [18 x i8] [i8 98, i8 110, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str29 = private constant [18 x i8] [i8 98, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str30 = private constant [18 x i8] [i8 98, i8 103, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str31 = private constant [19 x i8] [i8 98, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str32 = private constant [19 x i8] [i8 98, i8 103, i8 101, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str33 = private constant [13 x i8] [i8 98, i8 103, i8 101, i8 117, i8 32, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str34 = private constant [5 x i8] [i8 74, i8 77, i8 79, i8 33, i8 0]
@str35 = private constant [8 x i8] [i8 78, i8 73, i8 45, i8 74, i8 77, i8 79, i8 33, i8 0]
@str36 = private constant [17 x i8] [i8 108, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str37 = private constant [17 x i8] [i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str38 = private constant [17 x i8] [i8 108, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str39 = private constant [18 x i8] [i8 76, i8 87, i8 32, i8 91, i8 48, i8 120, i8 37, i8 120, i8 93, i8 32, i8 40, i8 48, i8 120, i8 37, i8 120, i8 41, i8 10, i8 0]
@str40 = private constant [18 x i8] [i8 108, i8 98, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str41 = private constant [18 x i8] [i8 76, i8 66, i8 85, i8 91, i8 48, i8 120, i8 37, i8 120, i8 93, i8 32, i8 40, i8 48, i8 120, i8 37, i8 120, i8 41, i8 10, i8 0]
@str42 = private constant [18 x i8] [i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str43 = private constant [17 x i8] [i8 115, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str44 = private constant [17 x i8] [i8 115, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str45 = private constant [17 x i8] [i8 115, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str46 = private constant [7 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 10, i8 0]
@str47 = private constant [8 x i8] [i8 69, i8 66, i8 82, i8 69, i8 65, i8 75, i8 10, i8 0]
@str48 = private constant [7 x i8] [i8 80, i8 65, i8 85, i8 83, i8 69, i8 10, i8 0]
@str49 = private constant [14 x i8] [i8 10, i8 10, i8 42, i8 32, i8 42, i8 32, i8 42, i8 32, i8 83, i8 84, i8 79, i8 80, i8 10, i8 0]
@str50 = private constant [22 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 79, i8 80, i8 67, i8 79, i8 68, i8 69, i8 58, i8 32, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl, i32 %sp) {
    %1 = bitcast %Core* %core to i8*
    %2 = call i8*(i8*, i32, i64) @memset (i8* %1, i32 0, i64 168)
    %3 = bitcast %MemoryInterface* %memctl to %MemoryInterface*
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store %MemoryInterface* %3, %MemoryInterface** %4
    ;core.text := text
    ;core.textlen := textlen
    %5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %5
    %6 = bitcast i32 %sp to i32
    %7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %8 = getelementptr inbounds [32 x i32], [32 x i32]* %7, i32 0, i32 2
    store i32 %6, i32* %8
    ret void
}

define i8 @extract_op(i32 %instr) {
    %1 = and i32 %instr, 127
    %2 = trunc i32 %1 to i8
    ret i8 %2
}

define i8 @extract_funct3(i32 %instr) {
    %1 = lshr i32 %instr, 12
    %2 = and i32 %1, 7
    %3 = trunc i32 %2 to i8
    ret i8 %3
}

define i8 @extract_rd(i32 %instr) {
    %1 = lshr i32 %instr, 7
    %2 = and i32 %1, 31
    %3 = trunc i32 %2 to i8
    ret i8 %3
}

define i8 @extract_rs1(i32 %instr) {
    %1 = lshr i32 %instr, 15
    %2 = and i32 %1, 31
    %3 = trunc i32 %2 to i8
    ret i8 %3
}

define i8 @extract_rs2(i32 %instr) {
    %1 = lshr i32 %instr, 20
    %2 = and i32 %1, 31
    %3 = trunc i32 %2 to i8
    ret i8 %3
}

define i8 @extract_funct7(i32 %instr) {
    %1 = lshr i32 %instr, 25
    %2 = and i32 %1, 127
    %3 = trunc i32 %2 to i8
    ret i8 %3
}

define i32 @extract_imm12(i32 %instr) {
    %1 = lshr i32 %instr, 20
    %2 = and i32 %1, 4095
    %3 = trunc i32 %2 to i16
    %imm = alloca i16
    store i16 %3, i16* %imm
    ; распространяем знак
    %4 = load i16, i16* %imm
    %5 = and i16 %4, 2048
    %6 = icmp eq i16 %5, 2048
    br i1 %6 , label %then_0, label %endif_0
then_0:
    %7 = load i16, i16* %imm
    %8 = or i16 %7, 61440
    store i16 %8, i16* %imm
    br label %endif_0
endif_0:
    %9 = load i16, i16* %imm
    %10 = sext i16 %9 to i32
    ret i32 %10
}

define i32 @extract_imm31_12(i32 %instr) {
    %1 = lshr i32 %instr, 12
    %2 = and i32 %1, 1048575
    %3 = bitcast i32 %2 to i32
    %imm = alloca i32
    store i32 %3, i32* %imm
    %4 = load i32, i32* %imm
    ret i32 %4
}

define i16 @expand12(i16 %val12bit) {
    %v = alloca i16
    store i16 %val12bit, i16* %v
    %1 = load i16, i16* %v
    %2 = and i16 %1, 2048
    %3 = icmp ne i16 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = load i16, i16* %v
    %5 = or i16 %4, 61440
    store i16 %5, i16* %v
    br label %endif_0
endif_0:
    %6 = load i16, i16* %v
    %7 = bitcast i16 %6 to i16
    ret i16 %7
}

define i32 @expand20(i32 %val_20bit) {
    %v = alloca i32
    store i32 %val_20bit, i32* %v
    %1 = load i32, i32* %v
    %2 = and i32 %1, 524288
    %3 = icmp ne i32 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = load i32, i32* %v
    %5 = or i32 %4, 4293918720
    store i32 %5, i32* %v
    br label %endif_0
endif_0:
    %6 = load i32, i32* %v
    %7 = bitcast i32 %6 to i32
    ret i32 %7
}

define void @i_type_op(%Core* %core, i32 %instr) {
    %1 = call i8(i32) @extract_funct3 (i32 %instr)
    %2 = call i8(i32) @extract_funct7 (i32 %instr)
    %3 = call i32(i32) @extract_imm12 (i32 %instr)
    %4 = call i8(i32) @extract_rd (i32 %instr)
    %5 = call i8(i32) @extract_rs1 (i32 %instr)
    %6 = icmp eq i8 %4, 0
    br i1 %6 , label %then_0, label %endif_0
then_0:
    ret void
    br label %endif_0
endif_0:
    %8 = icmp eq i8 %1, 0
    br i1 %8 , label %then_1, label %else_1
then_1:
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %10 = icmp ne i8 %4, 0
    br i1 %10 , label %then_2, label %endif_2
then_2:
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %12 = getelementptr inbounds [32 x i32], [32 x i32]* %11, i32 0, i8 %5
    %13 = load i32, i32* %12
    %14 = add i32 %13, %3
    %15 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %16 = getelementptr inbounds [32 x i32], [32 x i32]* %15, i32 0, i8 %4
    store i32 %14, i32* %16
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    %17 = icmp eq i8 %1, 1
    %18 = icmp eq i8 %2, 0
    %19 = and i1 %17, %18
    br i1 %19 , label %then_3, label %else_3
then_3:

    %20 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %21 = icmp ne i8 %4, 0
    br i1 %21 , label %then_4, label %endif_4
then_4:
    %22 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %23 = getelementptr inbounds [32 x i32], [32 x i32]* %22, i32 0, i8 %5
    %24 = load i32, i32* %23
    %25 = bitcast i32 %24 to i32
    %26 = shl i32 %25, %3
    %27 = bitcast i32 %26 to i32
    %28 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %29 = getelementptr inbounds [32 x i32], [32 x i32]* %28, i32 0, i8 %4
    store i32 %27, i32* %29
    br label %endif_4
endif_4:
    br label %endif_3
else_3:
    %30 = icmp eq i8 %1, 2
    br i1 %30 , label %then_5, label %else_5
then_5:
    ; SLTI - set [1 to rd if rs1] less than immediate
    %31 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %32 = icmp ne i8 %4, 0
    br i1 %32 , label %then_6, label %endif_6
then_6:
    %33 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %34 = getelementptr inbounds [32 x i32], [32 x i32]* %33, i32 0, i8 %5
    %35 = load i32, i32* %34
    %36 = icmp slt i32 %35, %3
    %37 = sext i1 %36 to i32
    %38 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %39 = getelementptr inbounds [32 x i32], [32 x i32]* %38, i32 0, i8 %4
    store i32 %37, i32* %39
    br label %endif_6
endif_6:
    br label %endif_5
else_5:
    %40 = icmp eq i8 %1, 3
    br i1 %40 , label %then_7, label %else_7
then_7:
    %41 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str4 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %42 = icmp ne i8 %4, 0
    br i1 %42 , label %then_8, label %endif_8
then_8:
    %43 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %44 = getelementptr inbounds [32 x i32], [32 x i32]* %43, i32 0, i8 %5
    %45 = load i32, i32* %44
    %46 = bitcast i32 %45 to i32
    %47 = bitcast i32 %3 to i32
    %48 = icmp ult i32 %46, %47
    %49 = sext i1 %48 to i32
    %50 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %51 = getelementptr inbounds [32 x i32], [32 x i32]* %50, i32 0, i8 %4
    store i32 %49, i32* %51
    br label %endif_8
endif_8:
    br label %endif_7
else_7:
    %52 = icmp eq i8 %1, 4
    br i1 %52 , label %then_9, label %else_9
then_9:
    %53 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str5 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %54 = icmp ne i8 %4, 0
    br i1 %54 , label %then_10, label %endif_10
then_10:
    %55 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %56 = getelementptr inbounds [32 x i32], [32 x i32]* %55, i32 0, i8 %5
    %57 = load i32, i32* %56
    %58 = xor i32 %57, %3
    %59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %60 = getelementptr inbounds [32 x i32], [32 x i32]* %59, i32 0, i8 %4
    store i32 %58, i32* %60
    br label %endif_10
endif_10:
    br label %endif_9
else_9:
    %61 = icmp eq i8 %1, 5
    %62 = icmp eq i8 %2, 0
    %63 = and i1 %61, %62
    br i1 %63 , label %then_11, label %else_11
then_11:
    %64 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str6 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %65 = icmp ne i8 %4, 0
    br i1 %65 , label %then_12, label %endif_12
then_12:
    %66 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %67 = getelementptr inbounds [32 x i32], [32 x i32]* %66, i32 0, i8 %5
    %68 = load i32, i32* %67
    %69 = bitcast i32 %68 to i32
    %70 = lshr i32 %69, %3
    %71 = bitcast i32 %70 to i32
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %4
    store i32 %71, i32* %73
    br label %endif_12
endif_12:
    br label %endif_11
else_11:
    %74 = icmp eq i8 %1, 5
    %75 = icmp eq i8 %2, 32
    %76 = and i1 %74, %75
    br i1 %76 , label %then_13, label %else_13
then_13:
    %77 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str7 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %78 = icmp ne i8 %4, 0
    br i1 %78 , label %then_14, label %endif_14
then_14:
    %79 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %80 = getelementptr inbounds [32 x i32], [32 x i32]* %79, i32 0, i8 %5
    %81 = load i32, i32* %80
    %82 = ashr i32 %81, %3
    %83 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %84 = getelementptr inbounds [32 x i32], [32 x i32]* %83, i32 0, i8 %4
    store i32 %82, i32* %84
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %85 = icmp eq i8 %1, 6
    br i1 %85 , label %then_15, label %else_15
then_15:
    %86 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str8 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %87 = icmp ne i8 %4, 0
    br i1 %87 , label %then_16, label %endif_16
then_16:
    %88 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %89 = getelementptr inbounds [32 x i32], [32 x i32]* %88, i32 0, i8 %5
    %90 = load i32, i32* %89
    %91 = or i32 %90, %3
    %92 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %93 = getelementptr inbounds [32 x i32], [32 x i32]* %92, i32 0, i8 %4
    store i32 %91, i32* %93
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %94 = icmp eq i8 %1, 7
    br i1 %94 , label %then_17, label %endif_17
then_17:
    %95 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), i8 %4, i8 %5, i32 %3)
    %96 = icmp ne i8 %4, 0
    br i1 %96 , label %then_18, label %endif_18
then_18:
    %97 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %98 = getelementptr inbounds [32 x i32], [32 x i32]* %97, i32 0, i8 %5
    %99 = load i32, i32* %98
    %100 = and i32 %99, %3
    %101 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %102 = getelementptr inbounds [32 x i32], [32 x i32]* %101, i32 0, i8 %4
    store i32 %100, i32* %102
    br label %endif_18
endif_18:
    br label %endif_17
endif_17:
    br label %endif_15
endif_15:
    br label %endif_13
endif_13:
    br label %endif_11
endif_11:
    br label %endif_9
endif_9:
    br label %endif_7
endif_7:
    br label %endif_5
endif_5:
    br label %endif_3
endif_3:
    br label %endif_1
endif_1:
    ret void
}

define void @r_type_op(%Core* %core, i32 %instr) {
    %1 = call i8(i32) @extract_funct3 (i32 %instr)
    %2 = call i8(i32) @extract_funct7 (i32 %instr)
    %3 = call i32(i32) @extract_imm12 (i32 %instr)
    %4 = call i8(i32) @extract_rd (i32 %instr)
    %5 = call i8(i32) @extract_rs1 (i32 %instr)
    %6 = call i8(i32) @extract_rs2 (i32 %instr)
    %7 = icmp eq i8 %4, 0
    br i1 %7 , label %then_0, label %endif_0
then_0:
    ret void
    br label %endif_0
endif_0:
    %9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %10 = getelementptr inbounds [32 x i32], [32 x i32]* %9, i32 0, i8 %5
    %11 = load i32, i32* %10
    %12 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %13 = getelementptr inbounds [32 x i32], [32 x i32]* %12, i32 0, i8 %6
    %14 = load i32, i32* %13
    %15 = icmp eq i8 %1, 0
    %16 = icmp eq i8 %2, 0
    %17 = and i1 %15, %16
    br i1 %17 , label %then_1, label %else_1
then_1:
    %18 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str10 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %19 = add i32 %11, %14
    %20 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %21 = getelementptr inbounds [32 x i32], [32 x i32]* %20, i32 0, i8 %4
    store i32 %19, i32* %21
    br label %endif_1
else_1:
    %22 = icmp eq i8 %1, 0
    %23 = icmp eq i8 %2, 32
    %24 = and i1 %22, %23
    br i1 %24 , label %then_2, label %else_2
then_2:
    %25 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str11 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %26 = sub i32 %11, %14
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %4
    store i32 %26, i32* %28
    br label %endif_2
else_2:
    %29 = icmp eq i8 %1, 1
    br i1 %29 , label %then_3, label %else_3
then_3:
    ; shift left logical
    %30 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %31 = shl i32 %11, %14
    %32 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %33 = getelementptr inbounds [32 x i32], [32 x i32]* %32, i32 0, i8 %4
    store i32 %31, i32* %33
    br label %endif_3
else_3:
    %34 = icmp eq i8 %1, 2
    br i1 %34 , label %then_4, label %else_4
then_4:
    ; set less than
    %35 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %36 = icmp slt i32 %11, %14
    %37 = sext i1 %36 to i32
    %38 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %39 = getelementptr inbounds [32 x i32], [32 x i32]* %38, i32 0, i8 %4
    store i32 %37, i32* %39
    br label %endif_4
else_4:
    %40 = icmp eq i8 %1, 3
    br i1 %40 , label %then_5, label %else_5
then_5:
    ; set less than unsigned
    %41 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str14 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %42 = bitcast i32 %11 to i32
    %43 = bitcast i32 %14 to i32
    %44 = icmp ult i32 %42, %43
    %45 = sext i1 %44 to i32
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %4
    store i32 %45, i32* %47
    br label %endif_5
else_5:
    %48 = icmp eq i8 %1, 4
    br i1 %48 , label %then_6, label %else_6
then_6:
    %49 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str15 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %50 = xor i32 %11, %14
    %51 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %52 = getelementptr inbounds [32 x i32], [32 x i32]* %51, i32 0, i8 %4
    store i32 %50, i32* %52
    br label %endif_6
else_6:
    %53 = icmp eq i8 %1, 5
    %54 = icmp eq i8 %2, 0
    %55 = and i1 %53, %54
    br i1 %55 , label %then_7, label %else_7
then_7:
    ; shift right logical
    %56 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str16 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %57 = bitcast i32 %11 to i32
    %58 = lshr i32 %57, %14
    %59 = bitcast i32 %58 to i32
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %61 = getelementptr inbounds [32 x i32], [32 x i32]* %60, i32 0, i8 %4
    store i32 %59, i32* %61
    br label %endif_7
else_7:
    %62 = icmp eq i8 %1, 5
    %63 = icmp eq i8 %2, 32
    %64 = and i1 %62, %63
    br i1 %64 , label %then_8, label %else_8
then_8:
    ; shift right arithmetical
    %65 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str17 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %66 = ashr i32 %11, %14
    %67 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %68 = getelementptr inbounds [32 x i32], [32 x i32]* %67, i32 0, i8 %4
    store i32 %66, i32* %68
    br label %endif_8
else_8:
    %69 = icmp eq i8 %1, 6
    br i1 %69 , label %then_9, label %else_9
then_9:
    %70 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str18 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %71 = or i32 %11, %14
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %4
    store i32 %71, i32* %73
    br label %endif_9
else_9:
    %74 = icmp eq i8 %1, 7
    br i1 %74 , label %then_10, label %endif_10
then_10:
    %75 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str19 to [0 x i8]*), i8 %4, i8 %5, i8 %6)
    %76 = and i32 %11, %14
    %77 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %78 = getelementptr inbounds [32 x i32], [32 x i32]* %77, i32 0, i8 %4
    store i32 %76, i32* %78
    br label %endif_10
endif_10:
    br label %endif_9
endif_9:
    br label %endif_8
endif_8:
    br label %endif_7
endif_7:
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
endif_1:
    ret void
}

define i32 @jal_imm_recode(i32 %imm) {
    %1 = lshr i32 %imm, 0
    %2 = and i32 %1, 255
    %3 = lshr i32 %imm, 8
    %4 = and i32 %3, 1
    %5 = lshr i32 %imm, 9
    %6 = and i32 %5, 1023
    %7 = lshr i32 %imm, 20
    %8 = and i32 %7, 1

    %9 = shl i32 %8, 20
    %10 = shl i32 %2, 12
    %11 = shl i32 %4, 11
    %12 = shl i32 %6, 1
    %13 = or i32 %11, %12
    %14 = or i32 %10, %13
    %15 = or i32 %9, %14
    ret i32 %15
}

define i32 @fetch(%Core* %core) {
    ;let instr_adr = core.ip / 4
    ;let instr = core.text[instr_adr]
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %4 = load %MemoryInterface*, %MemoryInterface** %3
    %5 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %4, i32 0, i32 2
    %6 = load i32(i32)*, i32(i32)** %5
    %7 = call i32(i32) %6 (i32 %2)
    ret i32 %7
}


@cnt = global i32 zeroinitializer

define i1 @core_tick(%Core* %core) {
    %1 = bitcast %Core* %core to %Core*
    %2 = call i32(%Core*) @fetch (%Core* %1)
    %3 = lshr i32 %2, 24
    %4 = trunc i32 %3 to i8
    %5 = and i8 %4, 255
    %6 = lshr i32 %2, 16
    %7 = trunc i32 %6 to i8
    %8 = and i8 %7, 255
    %9 = lshr i32 %2, 8
    %10 = trunc i32 %9 to i8
    %11 = and i8 %10, 255
    %12 = lshr i32 %2, 0
    %13 = trunc i32 %12 to i8
    %14 = and i8 %13, 255
    %15 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %16 = load i32, i32* %15
    %17 = zext i8 %14 to i32
    %18 = zext i8 %11 to i32
    %19 = zext i8 %8 to i32
    %20 = zext i8 %5 to i32
    %21 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([25 x i8]* @str20 to [0 x i8]*), i32 %16, i32 %17, i32 %18, i32 %19, i32 %20)
    %22 = call i8(i32) @extract_op (i32 %2)
    %23 = call i8(i32) @extract_rd (i32 %2)
    %24 = call i8(i32) @extract_rs1 (i32 %2)
    %25 = call i8(i32) @extract_rs2 (i32 %2)
    %26 = call i8(i32) @extract_funct3 (i32 %2)
    br i1 0 , label %then_0, label %endif_0
then_0:
    %27 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str21 to [0 x i8]*), i32 %2)
    %28 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([11 x i8]* @str22 to [0 x i8]*), i8 %22)
    br label %endif_0
endif_0:
    %29 = icmp eq i8 %22, 19
    br i1 %29 , label %then_1, label %else_1
then_1:
    %30 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %30, i32 %2)
    br label %endif_1
else_1:
    %31 = icmp eq i8 %22, 51
    br i1 %31 , label %then_2, label %else_2
then_2:
    %32 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %32, i32 %2)
    br label %endif_2
else_2:
    %33 = icmp eq i8 %22, 55
    br i1 %33 , label %then_3, label %else_3
then_3:
    ; U-type
    %34 = call i32(i32) @extract_imm31_12 (i32 %2)
    %35 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str23 to [0 x i8]*), i8 %23, i32 %34)
    %36 = shl i32 %34, 12
    %37 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %38 = getelementptr inbounds [32 x i32], [32 x i32]* %37, i32 0, i8 %23
    store i32 %36, i32* %38
    br label %endif_3
else_3:
    %39 = icmp eq i8 %22, 23
    br i1 %39 , label %then_4, label %else_4
then_4:
    ; U-type
    %40 = call i32(i32) @extract_imm31_12 (i32 %2)
    %41 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %42 = load i32, i32* %41
    %43 = bitcast i32 %42 to i32
    %44 = shl i32 %40, 12
    %45 = add i32 %43, %44
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %23
    store i32 %45, i32* %47
    %48 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str24 to [0 x i8]*), i8 %23, i32 %40)
    br label %endif_4
else_4:
    %49 = icmp eq i8 %22, 111
    br i1 %49 , label %then_5, label %else_5
then_5:
    ; U-type
    %50 = call i32(i32) @extract_imm31_12 (i32 %2)
    %51 = bitcast i32 %50 to i32
    %52 = call i32(i32) @jal_imm_recode (i32 %51)
    %53 = call i32(i32) @expand20 (i32 %52)
    %54 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str25 to [0 x i8]*), i8 %23, i32 %53)
    %55 = icmp ne i8 %23, 0
    br i1 %55 , label %then_6, label %endif_6
then_6:
    %56 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %57 = load i32, i32* %56
    %58 = add i32 %57, 4
    %59 = bitcast i32 %58 to i32
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %61 = getelementptr inbounds [32 x i32], [32 x i32]* %60, i32 0, i8 %23
    store i32 %59, i32* %61
    br label %endif_6
endif_6:
    %62 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %63 = load i32, i32* %62
    %64 = bitcast i32 %63 to i32
    %65 = add i32 %64, %53
    %66 = bitcast i32 %65 to i32
    %67 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %66, i32* %67
    %68 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %68
    br label %endif_5
else_5:
    %69 = icmp eq i8 %22, 103
    %70 = icmp eq i8 %26, 0
    %71 = and i1 %69, %70
    br i1 %71 , label %then_7, label %else_7
then_7:
    %72 = call i32(i32) @extract_imm12 (i32 %2)
    %73 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str26 to [0 x i8]*), i32 %72, i8 %24)
    ; pc <- (rs1 + imm) & ~1
    ; rd <- pc + 4
    %74 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %75 = load i32, i32* %74
    %76 = add i32 %75, 4
    %77 = bitcast i32 %76 to i32
    %78 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %79 = getelementptr inbounds [32 x i32], [32 x i32]* %78, i32 0, i8 %24
    %80 = load i32, i32* %79
    %81 = add i32 %80, %72
    %82 = bitcast i32 %81 to i32
    %83 = and i32 %82, 4294967294
    %84 = icmp ne i8 %23, 0
    br i1 %84 , label %then_8, label %endif_8
then_8:
    %85 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %86 = getelementptr inbounds [32 x i32], [32 x i32]* %85, i32 0, i8 %23
    store i32 %77, i32* %86
    br label %endif_8
endif_8:
    %87 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %83, i32* %87
    %88 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %88
    br label %endif_7
else_7:
    %89 = icmp eq i8 %22, 99
    br i1 %89 , label %then_9, label %else_9
then_9:
    %90 = call i8(i32) @extract_funct7 (i32 %2)
    %91 = call i8(i32) @extract_rd (i32 %2)
    %92 = and i8 %91, 30
    %93 = zext i8 %92 to i16
    %94 = and i8 %90, 63
    %95 = zext i8 %94 to i16
    %96 = shl i16 %95, 5
    %97 = and i8 %91, 1
    %98 = zext i8 %97 to i16
    %99 = shl i16 %98, 11
    %100 = and i8 %90, 64
    %101 = zext i8 %100 to i16
    %102 = shl i16 %101, 6
    %103 = or i16 %96, %93
    %104 = or i16 %99, %103
    %105 = or i16 %102, %104
    %bits = alloca i16
    store i16 %105, i16* %bits
    ; распространяем знак, если он есть
    %106 = load i16, i16* %bits
    %107 = and i16 %106, 4096
    %108 = icmp ne i16 %107, 0
    br i1 %108 , label %then_10, label %endif_10
then_10:
    %109 = load i16, i16* %bits
    %110 = or i16 61440, %109
    store i16 %110, i16* %bits
    br label %endif_10
endif_10:
    %111 = load i16, i16* %bits
    %112 = bitcast i16 %111 to i16
    %113 = icmp eq i8 %26, 0
    br i1 %113 , label %then_11, label %else_11
then_11:
    ;beq
    %114 = sext i16 %112 to i32
    %115 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str27 to [0 x i8]*), i8 %24, i8 %25, i32 %114)
    %116 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %117 = getelementptr inbounds [32 x i32], [32 x i32]* %116, i32 0, i8 %24
    %118 = load i32, i32* %117
    %119 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %120 = getelementptr inbounds [32 x i32], [32 x i32]* %119, i32 0, i8 %25
    %121 = load i32, i32* %120
    %122 = icmp eq i32 %118, %121
    br i1 %122 , label %then_12, label %endif_12
then_12:
    %123 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %124 = load i32, i32* %123
    %125 = bitcast i32 %124 to i32
    %126 = sext i16 %112 to i32
    %127 = add i32 %125, %126
    %128 = bitcast i32 %127 to i32
    %129 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %128, i32* %129
    %130 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %130
    br label %endif_12
endif_12:
    br label %endif_11
else_11:
    %131 = icmp eq i8 %26, 1
    br i1 %131 , label %then_13, label %else_13
then_13:
    ;bne
    %132 = sext i16 %112 to i32
    %133 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str28 to [0 x i8]*), i8 %24, i8 %25, i32 %132)
    %134 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %135 = getelementptr inbounds [32 x i32], [32 x i32]* %134, i32 0, i8 %24
    %136 = load i32, i32* %135
    %137 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %138 = getelementptr inbounds [32 x i32], [32 x i32]* %137, i32 0, i8 %25
    %139 = load i32, i32* %138
    %140 = icmp ne i32 %136, %139
    br i1 %140 , label %then_14, label %endif_14
then_14:
    %141 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %142 = load i32, i32* %141
    %143 = bitcast i32 %142 to i32
    %144 = sext i16 %112 to i32
    %145 = add i32 %143, %144
    %146 = bitcast i32 %145 to i32
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %146, i32* %147
    %148 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %148
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %149 = icmp eq i8 %26, 4
    br i1 %149 , label %then_15, label %else_15
then_15:
    ;blt
    %150 = sext i16 %112 to i32
    %151 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str29 to [0 x i8]*), i8 %24, i8 %25, i32 %150)
    %152 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %153 = getelementptr inbounds [32 x i32], [32 x i32]* %152, i32 0, i8 %24
    %154 = load i32, i32* %153
    %155 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %156 = getelementptr inbounds [32 x i32], [32 x i32]* %155, i32 0, i8 %25
    %157 = load i32, i32* %156
    %158 = icmp slt i32 %154, %157
    br i1 %158 , label %then_16, label %endif_16
then_16:
    %159 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %160 = load i32, i32* %159
    %161 = bitcast i32 %160 to i32
    %162 = sext i16 %112 to i32
    %163 = add i32 %161, %162
    %164 = bitcast i32 %163 to i32
    %165 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %164, i32* %165
    %166 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %166
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %167 = icmp eq i8 %26, 5
    br i1 %167 , label %then_17, label %else_17
then_17:
    ;bge
    %168 = sext i16 %112 to i32
    %169 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str30 to [0 x i8]*), i8 %24, i8 %25, i32 %168)
    %170 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %171 = getelementptr inbounds [32 x i32], [32 x i32]* %170, i32 0, i8 %24
    %172 = load i32, i32* %171
    %173 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %174 = getelementptr inbounds [32 x i32], [32 x i32]* %173, i32 0, i8 %25
    %175 = load i32, i32* %174
    %176 = icmp sge i32 %172, %175
    br i1 %176 , label %then_18, label %endif_18
then_18:
    %177 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %178 = load i32, i32* %177
    %179 = bitcast i32 %178 to i32
    %180 = sext i16 %112 to i32
    %181 = add i32 %179, %180
    %182 = bitcast i32 %181 to i32
    %183 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %182, i32* %183
    %184 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %184
    br label %endif_18
endif_18:
    br label %endif_17
else_17:
    %185 = icmp eq i8 %26, 6
    br i1 %185 , label %then_19, label %else_19
then_19:
    ;bltu
    %186 = sext i16 %112 to i32
    %187 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str31 to [0 x i8]*), i8 %24, i8 %25, i32 %186)
    %188 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %189 = getelementptr inbounds [32 x i32], [32 x i32]* %188, i32 0, i8 %24
    %190 = load i32, i32* %189
    %191 = bitcast i32 %190 to i32
    %192 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %193 = getelementptr inbounds [32 x i32], [32 x i32]* %192, i32 0, i8 %25
    %194 = load i32, i32* %193
    %195 = bitcast i32 %194 to i32
    %196 = icmp ult i32 %191, %195
    br i1 %196 , label %then_20, label %endif_20
then_20:
    %197 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %198 = load i32, i32* %197
    %199 = bitcast i32 %198 to i32
    %200 = sext i16 %112 to i32
    %201 = add i32 %199, %200
    %202 = bitcast i32 %201 to i32
    %203 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %202, i32* %203
    %204 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %204
    br label %endif_20
endif_20:
    br label %endif_19
else_19:
    %205 = icmp eq i8 %26, 7
    br i1 %205 , label %then_21, label %endif_21
then_21:
    ;bgeu
    %206 = sext i16 %112 to i32
    %207 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str32 to [0 x i8]*), i8 %24, i8 %25, i32 %206)
    %208 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %209 = getelementptr inbounds [32 x i32], [32 x i32]* %208, i32 0, i8 %24
    %210 = load i32, i32* %209
    %211 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %212 = getelementptr inbounds [32 x i32], [32 x i32]* %211, i32 0, i8 %25
    %213 = load i32, i32* %212
    %214 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str33 to [0 x i8]*), i32 %210, i32 %213)
    %215 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %216 = getelementptr inbounds [32 x i32], [32 x i32]* %215, i32 0, i8 %24
    %217 = load i32, i32* %216
    %218 = bitcast i32 %217 to i32
    %219 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %220 = getelementptr inbounds [32 x i32], [32 x i32]* %219, i32 0, i8 %25
    %221 = load i32, i32* %220
    %222 = bitcast i32 %221 to i32
    %223 = icmp uge i32 %218, %222
    br i1 %223 , label %then_22, label %else_22
then_22:
    %224 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str34 to [0 x i8]*))
    %225 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %226 = load i32, i32* %225
    %227 = bitcast i32 %226 to i32
    %228 = sext i16 %112 to i32
    %229 = add i32 %227, %228
    %230 = bitcast i32 %229 to i32
    %231 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %230, i32* %231
    %232 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %232
    br label %endif_22
else_22:
    %233 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([8 x i8]* @str35 to [0 x i8]*))
    br label %endif_22
endif_22:
    br label %endif_21
endif_21:
    br label %endif_19
endif_19:
    br label %endif_17
endif_17:
    br label %endif_15
endif_15:
    br label %endif_13
endif_13:
    br label %endif_11
endif_11:
    br label %endif_9
else_9:
    %234 = icmp eq i8 %22, 3
    br i1 %234 , label %then_23, label %else_23
then_23:
    %235 = call i32(i32) @extract_imm12 (i32 %2)
    %236 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %237 = getelementptr inbounds [32 x i32], [32 x i32]* %236, i32 0, i8 %24
    %238 = load i32, i32* %237
    %239 = add i32 %238, %235
    %240 = bitcast i32 %239 to i32
    %241 = icmp eq i8 %26, 0
    br i1 %241 , label %then_24, label %else_24
then_24:
    ; lb
    %242 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str36 to [0 x i8]*), i8 %23, i32 %235, i8 %24)
    %243 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %244 = load %MemoryInterface*, %MemoryInterface** %243
    %245 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %244, i32 0, i32 0
    %246 = load i8(i32)*, i8(i32)** %245
    %247 = call i8(i32) %246 (i32 %240)
    %248 = sext i8 %247 to i32
    %249 = icmp ne i8 %23, 0
    br i1 %249 , label %then_25, label %endif_25
then_25:
    %250 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %251 = getelementptr inbounds [32 x i32], [32 x i32]* %250, i32 0, i8 %23
    store i32 %248, i32* %251
    br label %endif_25
endif_25:
    br label %endif_24
else_24:
    %252 = icmp eq i8 %26, 1
    br i1 %252 , label %then_26, label %else_26
then_26:
    ; lh
    %253 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str37 to [0 x i8]*), i8 %23, i32 %235, i8 %24)
    %254 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %255 = load %MemoryInterface*, %MemoryInterface** %254
    %256 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %255, i32 0, i32 1
    %257 = load i16(i32)*, i16(i32)** %256
    %258 = call i16(i32) %257 (i32 %240)
    %259 = sext i16 %258 to i32
    %260 = icmp ne i8 %23, 0
    br i1 %260 , label %then_27, label %endif_27
then_27:
    %261 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %262 = getelementptr inbounds [32 x i32], [32 x i32]* %261, i32 0, i8 %23
    store i32 %259, i32* %262
    br label %endif_27
endif_27:
    br label %endif_26
else_26:
    %263 = icmp eq i8 %26, 2
    br i1 %263 , label %then_28, label %else_28
then_28:
    ; lw
    %264 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str38 to [0 x i8]*), i8 %23, i32 %235, i8 %24)
    %265 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %266 = load %MemoryInterface*, %MemoryInterface** %265
    %267 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %266, i32 0, i32 2
    %268 = load i32(i32)*, i32(i32)** %267
    %269 = call i32(i32) %268 (i32 %240)
    %270 = bitcast i32 %269 to i32
    %271 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str39 to [0 x i8]*), i32 %240, i32 %270)
    %272 = icmp ne i8 %23, 0
    br i1 %272 , label %then_29, label %endif_29
then_29:
    %273 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %274 = getelementptr inbounds [32 x i32], [32 x i32]* %273, i32 0, i8 %23
    store i32 %270, i32* %274
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %275 = icmp eq i8 %26, 4
    br i1 %275 , label %then_30, label %else_30
then_30:
    ; lbu
    %276 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str40 to [0 x i8]*), i8 %23, i32 %235, i8 %24)
    %277 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %278 = load %MemoryInterface*, %MemoryInterface** %277
    %279 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %278, i32 0, i32 0
    %280 = load i8(i32)*, i8(i32)** %279
    %281 = call i8(i32) %280 (i32 %240)
    %282 = zext i8 %281 to i32
    %283 = bitcast i32 %282 to i32
    %284 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str41 to [0 x i8]*), i32 %240, i32 %283)
    %285 = icmp ne i8 %23, 0
    br i1 %285 , label %then_31, label %endif_31
then_31:
    %286 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %287 = getelementptr inbounds [32 x i32], [32 x i32]* %286, i32 0, i8 %23
    store i32 %283, i32* %287
    br label %endif_31
endif_31:
    br label %endif_30
else_30:
    %288 = icmp eq i8 %26, 5
    br i1 %288 , label %then_32, label %endif_32
then_32:
    ; lhu
    %289 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str42 to [0 x i8]*), i8 %23, i32 %235, i8 %24)
    %290 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %291 = load %MemoryInterface*, %MemoryInterface** %290
    %292 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %291, i32 0, i32 1
    %293 = load i16(i32)*, i16(i32)** %292
    %294 = call i16(i32) %293 (i32 %240)
    %295 = zext i16 %294 to i32
    %296 = bitcast i32 %295 to i32
    %297 = icmp ne i8 %23, 0
    br i1 %297 , label %then_33, label %endif_33
then_33:
    %298 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %299 = getelementptr inbounds [32 x i32], [32 x i32]* %298, i32 0, i8 %23
    store i32 %296, i32* %299
    br label %endif_33
endif_33:
    br label %endif_32
endif_32:
    br label %endif_30
endif_30:
    br label %endif_28
endif_28:
    br label %endif_26
endif_26:
    br label %endif_24
endif_24:
    br label %endif_23
else_23:
    %300 = icmp eq i8 %22, 35
    br i1 %300 , label %then_34, label %else_34
then_34:
    %301 = call i8(i32) @extract_funct7 (i32 %2)
    %302 = zext i8 %301 to i16
    %303 = shl i16 %302, 5
    %304 = zext i8 %23 to i16
    %305 = or i16 %303, %304
    %306 = call i16(i16) @expand12 (i16 %305)
    %307 = sext i16 %306 to i32
    %308 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %309 = getelementptr inbounds [32 x i32], [32 x i32]* %308, i32 0, i8 %24
    %310 = load i32, i32* %309
    %311 = add i32 %310, %307
    %312 = bitcast i32 %311 to i32
    %313 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %314 = getelementptr inbounds [32 x i32], [32 x i32]* %313, i32 0, i8 %25
    %315 = load i32, i32* %314
    %316 = icmp eq i8 %26, 0
    br i1 %316 , label %then_35, label %else_35
then_35:
    ; sb
    %317 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str43 to [0 x i8]*), i8 %25, i32 %307, i8 %24)
    %318 = trunc i32 %315 to i8
    %319 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %320 = load %MemoryInterface*, %MemoryInterface** %319
    %321 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %320, i32 0, i32 3
    %322 = load void(i32, i8)*, void(i32, i8)** %321
    call void(i32, i8) %322 (i32 %312, i8 %318)
    br label %endif_35
else_35:
    %323 = icmp eq i8 %26, 1
    br i1 %323 , label %then_36, label %else_36
then_36:
    ; sh
    %324 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str44 to [0 x i8]*), i8 %25, i32 %307, i8 %24)
    %325 = trunc i32 %315 to i16
    %326 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %327 = load %MemoryInterface*, %MemoryInterface** %326
    %328 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %327, i32 0, i32 4
    %329 = load void(i32, i16)*, void(i32, i16)** %328
    call void(i32, i16) %329 (i32 %312, i16 %325)
    br label %endif_36
else_36:
    %330 = icmp eq i8 %26, 2
    br i1 %330 , label %then_37, label %endif_37
then_37:
    ; sw
    %331 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str45 to [0 x i8]*), i8 %25, i32 %307, i8 %24)
    %332 = bitcast i32 %315 to i32
    %333 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %334 = load %MemoryInterface*, %MemoryInterface** %333
    %335 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %334, i32 0, i32 5
    %336 = load void(i32, i32)*, void(i32, i32)** %335
    call void(i32, i32) %336 (i32 %312, i32 %332)
    br label %endif_37
endif_37:
    br label %endif_36
endif_36:
    br label %endif_35
endif_35:
    br label %endif_34
else_34:
    %337 = icmp eq i32 %2, 115
    br i1 %337 , label %then_38, label %else_38
then_38:
    %338 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str46 to [0 x i8]*))
    br label %endif_38
else_38:
    %339 = icmp eq i32 %2, 1048691
    br i1 %339 , label %then_39, label %else_39
then_39:
    %340 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([8 x i8]* @str47 to [0 x i8]*))
    ret i1 0
    br label %endif_39
else_39:
    %342 = icmp eq i32 %2, 16777231
    br i1 %342 , label %then_40, label %else_40
then_40:
    %343 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str48 to [0 x i8]*))
    br label %endif_40
else_40:
    %344 = icmp eq i32 %2, 0
    br i1 %344 , label %then_41, label %else_41
then_41:
    %345 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str49 to [0 x i8]*))
    ret i1 0
    br label %endif_41
else_41:
    %347 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str50 to [0 x i8]*), i8 %22)
    br label %endif_41
endif_41:
    br label %endif_40
endif_40:
    br label %endif_39
endif_39:
    br label %endif_38
endif_38:
    br label %endif_34
endif_34:
    br label %endif_23
endif_23:
    br label %endif_9
endif_9:
    br label %endif_7
endif_7:
    br label %endif_5
endif_5:
    br label %endif_4
endif_4:
    br label %endif_3
endif_3:
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    %348 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %349 = load i1, i1* %348
    br i1 %349 , label %then_42, label %else_42
then_42:
    %350 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %351 = load i32, i32* %350
    %352 = add i32 %351, 4
    %353 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %352, i32* %353
    br label %endif_42
else_42:
    %354 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %354
    br label %endif_42
endif_42:
    ret i1 1
}


