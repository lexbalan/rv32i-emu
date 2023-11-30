
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
@str20 = private constant [14 x i8] [i8 73, i8 78, i8 83, i8 84, i8 82, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str21 = private constant [11 x i8] [i8 79, i8 80, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str22 = private constant [15 x i8] [i8 108, i8 117, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str23 = private constant [17 x i8] [i8 97, i8 117, i8 105, i8 112, i8 99, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str24 = private constant [27 x i8] [i8 97, i8 117, i8 105, i8 112, i8 99, i8 58, i8 58, i8 32, i8 99, i8 111, i8 114, i8 101, i8 46, i8 114, i8 101, i8 103, i8 91, i8 114, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@str25 = private constant [13 x i8] [i8 106, i8 97, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str26 = private constant [21 x i8] [i8 106, i8 97, i8 108, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str27 = private constant [18 x i8] [i8 98, i8 101, i8 113, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str28 = private constant [18 x i8] [i8 98, i8 110, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str29 = private constant [18 x i8] [i8 98, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str30 = private constant [18 x i8] [i8 98, i8 103, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str31 = private constant [19 x i8] [i8 98, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str32 = private constant [19 x i8] [i8 98, i8 103, i8 101, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str33 = private constant [17 x i8] [i8 108, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str34 = private constant [17 x i8] [i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str35 = private constant [17 x i8] [i8 108, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str36 = private constant [18 x i8] [i8 108, i8 98, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str37 = private constant [18 x i8] [i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str38 = private constant [17 x i8] [i8 115, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str39 = private constant [17 x i8] [i8 115, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str40 = private constant [17 x i8] [i8 115, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str41 = private constant [7 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 10, i8 0]
@str42 = private constant [8 x i8] [i8 69, i8 66, i8 82, i8 69, i8 65, i8 75, i8 10, i8 0]
@str43 = private constant [7 x i8] [i8 80, i8 65, i8 85, i8 83, i8 69, i8 10, i8 0]
@str44 = private constant [14 x i8] [i8 10, i8 10, i8 42, i8 32, i8 42, i8 32, i8 42, i8 32, i8 83, i8 84, i8 79, i8 80, i8 10, i8 0]
@str45 = private constant [22 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 79, i8 80, i8 67, i8 79, i8 68, i8 69, i8 58, i8 32, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl, [0 x i32]* %text, i32 %textlen, i32 %sp) {
    %1 = bitcast %Core* %core to i8*
    %2 = call i8*(i8*, i32, i64) @memset (i8* %1, i32 0, i64 168)
    %3 = bitcast %MemoryInterface* %memctl to %MemoryInterface*
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store %MemoryInterface* %3, %MemoryInterface** %4
    %5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    store [0 x i32]* %text, [0 x i32]** %5
    %6 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    store i32 %textlen, i32* %6
    %7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %7
    %8 = bitcast i32 %sp to i32
    %9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %10 = getelementptr inbounds [32 x i32], [32 x i32]* %9, i32 0, i32 2
    store i32 %8, i32* %10
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

define i16 @extract_imm12(i32 %instr) {
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
    ret i16 %9
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
    %3 = call i16(i32) @extract_imm12 (i32 %instr)
    %4 = sext i16 %3 to i32
    %5 = call i8(i32) @extract_rd (i32 %instr)
    %6 = call i8(i32) @extract_rs1 (i32 %instr)
    ;printf("funct7 = %x\n", instr and 0xff000000)
    %7 = icmp eq i8 %5, 0
    br i1 %7 , label %then_0, label %endif_0
then_0:
    ret void
    br label %endif_0
endif_0:
    ;printf("RRI: funct7 = %d\n", funct7)
    %9 = icmp eq i8 %1, 0
    br i1 %9 , label %then_1, label %else_1
then_1:
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %12 = getelementptr inbounds [32 x i32], [32 x i32]* %11, i32 0, i8 %6
    %13 = load i32, i32* %12
    %14 = add i32 %13, %4
    %15 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %16 = getelementptr inbounds [32 x i32], [32 x i32]* %15, i32 0, i8 %5
    store i32 %14, i32* %16
    br label %endif_1
else_1:
    %17 = icmp eq i8 %1, 1
    %18 = icmp eq i8 %2, 0
    %19 = and i1 %17, %18
    br i1 %19 , label %then_2, label %else_2
then_2:

    ; TODO
    %20 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %21 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %22 = getelementptr inbounds [32 x i32], [32 x i32]* %21, i32 0, i8 %6
    %23 = load i32, i32* %22
    %24 = bitcast i32 %23 to i32
    %25 = shl i32 %24, %4
    %26 = bitcast i32 %25 to i32
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %5
    store i32 %26, i32* %28
    br label %endif_2
else_2:
    %29 = icmp eq i8 %1, 2
    br i1 %29 , label %then_3, label %else_3
then_3:
    ; SLTI - set [1 to rd if rs1] less than immediate
    %30 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %31 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %32 = getelementptr inbounds [32 x i32], [32 x i32]* %31, i32 0, i8 %6
    %33 = load i32, i32* %32
    %34 = icmp slt i32 %33, %4
    %35 = sext i1 %34 to i32
    %36 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %37 = getelementptr inbounds [32 x i32], [32 x i32]* %36, i32 0, i8 %5
    store i32 %35, i32* %37
    br label %endif_3
else_3:
    %38 = icmp eq i8 %1, 3
    br i1 %38 , label %then_4, label %else_4
then_4:
    %39 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([20 x i8]* @str4 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    br label %endif_4
else_4:
    %40 = icmp eq i8 %1, 4
    br i1 %40 , label %then_5, label %else_5
then_5:
    %41 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str5 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %43 = getelementptr inbounds [32 x i32], [32 x i32]* %42, i32 0, i8 %6
    %44 = load i32, i32* %43
    %45 = xor i32 %44, %4
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %5
    store i32 %45, i32* %47
    br label %endif_5
else_5:
    %48 = icmp eq i8 %1, 5
    %49 = icmp eq i8 %2, 0
    %50 = and i1 %48, %49
    br i1 %50 , label %then_6, label %else_6
then_6:
    ; TODO
    %51 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str6 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %53 = getelementptr inbounds [32 x i32], [32 x i32]* %52, i32 0, i8 %6
    %54 = load i32, i32* %53
    %55 = bitcast i32 %54 to i32
    %56 = lshr i32 %55, %4
    %57 = bitcast i32 %56 to i32
    %58 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %59 = getelementptr inbounds [32 x i32], [32 x i32]* %58, i32 0, i8 %5
    store i32 %57, i32* %59
    br label %endif_6
else_6:
    %60 = icmp eq i8 %1, 5
    %61 = icmp eq i8 %2, 32
    %62 = and i1 %60, %61
    br i1 %62 , label %then_7, label %else_7
then_7:
    ; TODO
    %63 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str7 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    br label %endif_7
else_7:
    %64 = icmp eq i8 %1, 6
    br i1 %64 , label %then_8, label %else_8
then_8:
    %65 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str8 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %66 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %67 = getelementptr inbounds [32 x i32], [32 x i32]* %66, i32 0, i8 %6
    %68 = load i32, i32* %67
    %69 = or i32 %68, %4
    %70 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %71 = getelementptr inbounds [32 x i32], [32 x i32]* %70, i32 0, i8 %5
    store i32 %69, i32* %71
    br label %endif_8
else_8:
    %72 = icmp eq i8 %1, 7
    br i1 %72 , label %then_9, label %endif_9
then_9:
    %73 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str9 to [0 x i8]*), i8 %5, i8 %6, i32 %4)
    %74 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %75 = getelementptr inbounds [32 x i32], [32 x i32]* %74, i32 0, i8 %6
    %76 = load i32, i32* %75
    %77 = and i32 %76, %4
    %78 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %79 = getelementptr inbounds [32 x i32], [32 x i32]* %78, i32 0, i8 %5
    store i32 %77, i32* %79
    ;printf("ANDI=%x\n", core.reg[rd])
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

define void @r_type_op(%Core* %core, i32 %instr) {
    %1 = call i8(i32) @extract_funct3 (i32 %instr)
    %2 = call i8(i32) @extract_funct7 (i32 %instr)
    %3 = call i16(i32) @extract_imm12 (i32 %instr)
    %4 = call i8(i32) @extract_rd (i32 %instr)
    %5 = call i8(i32) @extract_rs1 (i32 %instr)
    %6 = call i8(i32) @extract_rs2 (i32 %instr)
    ;printf("funct7 = %x\n", funct7)
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
    ; TODO: shift right arithmetical
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
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %2 = load i32, i32* %1
    %3 = udiv i32 %2, 4
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %5 = load [0 x i32]*, [0 x i32]** %4
    %6 = getelementptr inbounds [0 x i32], [0 x i32]* %5, i32 0, i32 %3
    %7 = load i32, i32* %6
    ret i32 %7
}


@cnt = global i32 zeroinitializer

define i1 @core_tick(%Core* %core) {
    %1 = bitcast %Core* %core to %Core*
    %2 = call i32(%Core*) @fetch (%Core* %1)
    %3 = call i8(i32) @extract_op (i32 %2)
    %4 = call i8(i32) @extract_rd (i32 %2)
    %5 = call i8(i32) @extract_rs1 (i32 %2)
    %6 = call i8(i32) @extract_rs2 (i32 %2)
    %7 = call i8(i32) @extract_funct3 (i32 %2)
    br i1 0 , label %then_0, label %endif_0
then_0:
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str20 to [0 x i8]*), i32 %2)
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([11 x i8]* @str21 to [0 x i8]*), i8 %3)
    br label %endif_0
endif_0:
    %10 = icmp eq i8 %3, 19
    br i1 %10 , label %then_1, label %else_1
then_1:
    %11 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %11, i32 %2)
    br label %endif_1
else_1:
    %12 = icmp eq i8 %3, 51
    br i1 %12 , label %then_2, label %else_2
then_2:
    %13 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %13, i32 %2)
    br label %endif_2
else_2:
    %14 = icmp eq i8 %3, 55
    br i1 %14 , label %then_3, label %else_3
then_3:
    ; U-type
    %15 = call i32(i32) @extract_imm31_12 (i32 %2)
    %16 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str22 to [0 x i8]*), i8 %4, i32 %15)
    %17 = shl i32 %15, 12
    %18 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %19 = getelementptr inbounds [32 x i32], [32 x i32]* %18, i32 0, i8 %4
    store i32 %17, i32* %19
    br label %endif_3
else_3:
    %20 = icmp eq i8 %3, 23
    br i1 %20 , label %then_4, label %else_4
then_4:
    ; U-type
    %21 = call i32(i32) @extract_imm31_12 (i32 %2)
    %22 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str23 to [0 x i8]*), i8 %4, i32 %21)
    %23 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %24 = load i32, i32* %23
    %25 = bitcast i32 %24 to i32
    %26 = add i32 %25, %21
    %27 = shl i32 %26, 12
    %28 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %29 = getelementptr inbounds [32 x i32], [32 x i32]* %28, i32 0, i8 %4
    store i32 %27, i32* %29
    %30 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %31 = getelementptr inbounds [32 x i32], [32 x i32]* %30, i32 0, i8 %4
    %32 = load i32, i32* %31
    %33 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([27 x i8]* @str24 to [0 x i8]*), i32 %32)
    br label %endif_4
else_4:
    %34 = icmp eq i8 %3, 111
    br i1 %34 , label %then_5, label %else_5
then_5:
    ; U-type
    %35 = call i32(i32) @extract_imm31_12 (i32 %2)
    %36 = bitcast i32 %35 to i32
    %37 = call i32(i32) @jal_imm_recode (i32 %36)
    %38 = call i32(i32) @expand20 (i32 %37)
    ;jal_imm_recode(extract_imm31_12(instr) to Nat32)
    ;let imm = jal_imm_recode(extract_imm31_12(instr) to Nat32)
    ;printf("raw_imm = %x\n", raw_imm)
    ;printf("imm = %d\n", imm)
    %39 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str25 to [0 x i8]*), i8 %4, i32 %38)
    %40 = icmp ne i8 %4, 0
    br i1 %40 , label %then_6, label %endif_6
then_6:
    %41 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %42 = load i32, i32* %41
    %43 = add i32 %42, 4
    %44 = bitcast i32 %43 to i32
    %45 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %46 = getelementptr inbounds [32 x i32], [32 x i32]* %45, i32 0, i8 %4
    store i32 %44, i32* %46
    br label %endif_6
endif_6:
    %47 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %48 = load i32, i32* %47
    %49 = bitcast i32 %48 to i32
    %50 = add i32 %49, %38
    %51 = bitcast i32 %50 to i32
    %52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %51, i32* %52
    %53 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %53
    br label %endif_5
else_5:
    %54 = icmp eq i8 %3, 103
    %55 = icmp eq i8 %7, 0
    %56 = and i1 %54, %55
    br i1 %56 , label %then_7, label %else_7
then_7:
    %57 = call i16(i32) @extract_imm12 (i32 %2)
    %58 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([21 x i8]* @str26 to [0 x i8]*), i8 %4, i8 %5, i16 %57)
    br label %endif_7
else_7:
    %59 = icmp eq i8 %3, 99
    br i1 %59 , label %then_8, label %else_8
then_8:
    %60 = call i8(i32) @extract_funct7 (i32 %2)
    %61 = call i8(i32) @extract_rd (i32 %2)
    ;printf("imm12_10to5 = %d\n", imm12_10to5)
    ;printf("imm4to1_11 = %d\n", imm4to1_11)
    %62 = and i8 %61, 30
    %63 = zext i8 %62 to i16
    %64 = and i8 %60, 63
    %65 = zext i8 %64 to i16
    %66 = shl i16 %65, 5
    %67 = and i8 %61, 1
    %68 = zext i8 %67 to i16
    %69 = shl i16 %68, 11
    %70 = and i8 %60, 64
    %71 = zext i8 %70 to i16
    %72 = shl i16 %71, 6
    %73 = or i16 %66, %63
    %74 = or i16 %69, %73
    %75 = or i16 %72, %74
    %bits = alloca i16
    store i16 %75, i16* %bits
    ; распространяем знак, если он есть
    %76 = load i16, i16* %bits
    %77 = and i16 %76, 4096
    %78 = icmp ne i16 %77, 0
    br i1 %78 , label %then_9, label %endif_9
then_9:
    %79 = load i16, i16* %bits
    %80 = or i16 61440, %79
    store i16 %80, i16* %bits
    br label %endif_9
endif_9:
    %81 = load i16, i16* %bits
    %82 = bitcast i16 %81 to i16
    %83 = icmp eq i8 %7, 0
    br i1 %83 , label %then_10, label %else_10
then_10:
    ;beq
    %84 = sext i16 %82 to i32
    %85 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str27 to [0 x i8]*), i8 %5, i8 %6, i32 %84)
    %86 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %87 = getelementptr inbounds [32 x i32], [32 x i32]* %86, i32 0, i8 %5
    %88 = load i32, i32* %87
    %89 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %90 = getelementptr inbounds [32 x i32], [32 x i32]* %89, i32 0, i8 %6
    %91 = load i32, i32* %90
    %92 = icmp eq i32 %88, %91
    br i1 %92 , label %then_11, label %endif_11
then_11:
    %93 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %94 = load i32, i32* %93
    %95 = bitcast i32 %94 to i32
    %96 = sext i16 %82 to i32
    %97 = add i32 %95, %96
    %98 = bitcast i32 %97 to i32
    %99 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %98, i32* %99
    %100 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %100
    br label %endif_11
endif_11:
    br label %endif_10
else_10:
    %101 = icmp eq i8 %7, 1
    br i1 %101 , label %then_12, label %else_12
then_12:
    ;bne
    %102 = sext i16 %82 to i32
    %103 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str28 to [0 x i8]*), i8 %5, i8 %6, i32 %102)
    %104 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %105 = getelementptr inbounds [32 x i32], [32 x i32]* %104, i32 0, i8 %5
    %106 = load i32, i32* %105
    %107 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %108 = getelementptr inbounds [32 x i32], [32 x i32]* %107, i32 0, i8 %6
    %109 = load i32, i32* %108
    %110 = icmp ne i32 %106, %109
    br i1 %110 , label %then_13, label %endif_13
then_13:
    %111 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %112 = load i32, i32* %111
    %113 = bitcast i32 %112 to i32
    %114 = sext i16 %82 to i32
    %115 = add i32 %113, %114
    %116 = bitcast i32 %115 to i32
    %117 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %116, i32* %117
    %118 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %118
    br label %endif_13
endif_13:
    br label %endif_12
else_12:
    %119 = icmp eq i8 %7, 4
    br i1 %119 , label %then_14, label %else_14
then_14:
    ;blt
    %120 = sext i16 %82 to i32
    %121 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str29 to [0 x i8]*), i8 %5, i8 %6, i32 %120)
    ;printf("{%d} < {%d}\n", core.reg[rs1], core.reg[rs2])
    %122 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %123 = getelementptr inbounds [32 x i32], [32 x i32]* %122, i32 0, i8 %5
    %124 = load i32, i32* %123
    %125 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %126 = getelementptr inbounds [32 x i32], [32 x i32]* %125, i32 0, i8 %6
    %127 = load i32, i32* %126
    %128 = icmp slt i32 %124, %127
    br i1 %128 , label %then_15, label %endif_15
then_15:
    %129 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %130 = load i32, i32* %129
    %131 = bitcast i32 %130 to i32
    %132 = sext i16 %82 to i32
    %133 = add i32 %131, %132
    %134 = bitcast i32 %133 to i32
    %135 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %134, i32* %135
    %136 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %136
    br label %endif_15
endif_15:

    br label %endif_14
else_14:
    %137 = icmp eq i8 %7, 5
    br i1 %137 , label %then_16, label %else_16
then_16:
    ;bge
    %138 = sext i16 %82 to i32
    %139 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str30 to [0 x i8]*), i8 %5, i8 %6, i32 %138)
    %140 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %141 = getelementptr inbounds [32 x i32], [32 x i32]* %140, i32 0, i8 %5
    %142 = load i32, i32* %141
    %143 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %144 = getelementptr inbounds [32 x i32], [32 x i32]* %143, i32 0, i8 %6
    %145 = load i32, i32* %144
    %146 = icmp sge i32 %142, %145
    br i1 %146 , label %then_17, label %endif_17
then_17:
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %148 = load i32, i32* %147
    %149 = bitcast i32 %148 to i32
    %150 = sext i16 %82 to i32
    %151 = add i32 %149, %150
    %152 = bitcast i32 %151 to i32
    %153 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %152, i32* %153
    %154 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %154
    br label %endif_17
endif_17:
    br label %endif_16
else_16:
    %155 = icmp eq i8 %7, 6
    br i1 %155 , label %then_18, label %else_18
then_18:
    ;bltu
    %156 = sext i16 %82 to i32
    %157 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str31 to [0 x i8]*), i8 %5, i8 %6, i32 %156)
    %158 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %159 = getelementptr inbounds [32 x i32], [32 x i32]* %158, i32 0, i8 %5
    %160 = load i32, i32* %159
    %161 = bitcast i32 %160 to i32
    %162 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %163 = getelementptr inbounds [32 x i32], [32 x i32]* %162, i32 0, i8 %6
    %164 = load i32, i32* %163
    %165 = bitcast i32 %164 to i32
    %166 = icmp ult i32 %161, %165
    br i1 %166 , label %then_19, label %endif_19
then_19:
    %167 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %168 = load i32, i32* %167
    %169 = bitcast i32 %168 to i32
    %170 = sext i16 %82 to i32
    %171 = add i32 %169, %170
    %172 = bitcast i32 %171 to i32
    %173 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %172, i32* %173
    %174 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %174
    br label %endif_19
endif_19:
    br label %endif_18
else_18:
    %175 = icmp eq i8 %7, 7
    br i1 %175 , label %then_20, label %endif_20
then_20:
    ;bgeu
    %176 = sext i16 %82 to i32
    %177 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([19 x i8]* @str32 to [0 x i8]*), i8 %5, i8 %6, i32 %176)
    %178 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %179 = getelementptr inbounds [32 x i32], [32 x i32]* %178, i32 0, i8 %5
    %180 = load i32, i32* %179
    %181 = bitcast i32 %180 to i32
    %182 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %183 = getelementptr inbounds [32 x i32], [32 x i32]* %182, i32 0, i8 %6
    %184 = load i32, i32* %183
    %185 = bitcast i32 %184 to i32
    %186 = icmp uge i32 %181, %185
    br i1 %186 , label %then_21, label %endif_21
then_21:
    %187 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %188 = load i32, i32* %187
    %189 = bitcast i32 %188 to i32
    %190 = sext i16 %82 to i32
    %191 = add i32 %189, %190
    %192 = bitcast i32 %191 to i32
    %193 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %192, i32* %193
    %194 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %194
    br label %endif_21
endif_21:
    br label %endif_20
endif_20:
    br label %endif_18
endif_18:
    br label %endif_16
endif_16:
    br label %endif_14
endif_14:
    br label %endif_12
endif_12:
    br label %endif_10
endif_10:
    br label %endif_8
else_8:
    %195 = icmp eq i8 %3, 3
    br i1 %195 , label %then_22, label %else_22
then_22:
    %196 = call i16(i32) @extract_imm12 (i32 %2)
    %197 = sext i16 %196 to i32
    %198 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %199 = getelementptr inbounds [32 x i32], [32 x i32]* %198, i32 0, i8 %5
    %200 = load i32, i32* %199
    %201 = add i32 %200, %197
    %202 = bitcast i32 %201 to i32
    ;printf("L adr=%x\n", adr)
    %203 = icmp eq i8 %7, 0
    br i1 %203 , label %then_23, label %else_23
then_23:
    ; lb
    %204 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str33 to [0 x i8]*), i8 %4, i32 %197, i8 %5)
    %205 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %206 = load %MemoryInterface*, %MemoryInterface** %205
    %207 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %206, i32 0, i32 0
    %208 = load i8(i32)*, i8(i32)** %207
    %209 = call i8(i32) %208 (i32 %202)
    %210 = sext i8 %209 to i32
    %211 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %212 = getelementptr inbounds [32 x i32], [32 x i32]* %211, i32 0, i8 %4
    store i32 %210, i32* %212
    br label %endif_23
else_23:
    %213 = icmp eq i8 %7, 1
    br i1 %213 , label %then_24, label %else_24
then_24:
    ; lh
    %214 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str34 to [0 x i8]*), i8 %4, i32 %197, i8 %5)
    %215 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %216 = load %MemoryInterface*, %MemoryInterface** %215
    %217 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %216, i32 0, i32 1
    %218 = load i16(i32)*, i16(i32)** %217
    %219 = call i16(i32) %218 (i32 %202)
    %220 = sext i16 %219 to i32
    %221 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %222 = getelementptr inbounds [32 x i32], [32 x i32]* %221, i32 0, i8 %4
    store i32 %220, i32* %222
    br label %endif_24
else_24:
    %223 = icmp eq i8 %7, 2
    br i1 %223 , label %then_25, label %else_25
then_25:
    ; lw
    %224 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str35 to [0 x i8]*), i8 %4, i32 %197, i8 %5)
    %225 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %226 = load %MemoryInterface*, %MemoryInterface** %225
    %227 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %226, i32 0, i32 2
    %228 = load i32(i32)*, i32(i32)** %227
    %229 = call i32(i32) %228 (i32 %202)
    %230 = bitcast i32 %229 to i32
    ;printf("LW_VAL = %x\n", val)
    %231 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %232 = getelementptr inbounds [32 x i32], [32 x i32]* %231, i32 0, i8 %4
    store i32 %230, i32* %232
    br label %endif_25
else_25:
    %233 = icmp eq i8 %7, 4
    br i1 %233 , label %then_26, label %else_26
then_26:
    ; lbu
    %234 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str36 to [0 x i8]*), i8 %4, i32 %197, i8 %5)
    %235 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %236 = load %MemoryInterface*, %MemoryInterface** %235
    %237 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %236, i32 0, i32 0
    %238 = load i8(i32)*, i8(i32)** %237
    %239 = call i8(i32) %238 (i32 %202)
    %240 = zext i8 %239 to i32
    %241 = bitcast i32 %240 to i32
    %242 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %243 = getelementptr inbounds [32 x i32], [32 x i32]* %242, i32 0, i8 %4
    store i32 %241, i32* %243
    br label %endif_26
else_26:
    %244 = icmp eq i8 %7, 5
    br i1 %244 , label %then_27, label %endif_27
then_27:
    ; lhu
    %245 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str37 to [0 x i8]*), i8 %4, i32 %197, i8 %5)
    %246 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %247 = load %MemoryInterface*, %MemoryInterface** %246
    %248 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %247, i32 0, i32 1
    %249 = load i16(i32)*, i16(i32)** %248
    %250 = call i16(i32) %249 (i32 %202)
    %251 = zext i16 %250 to i32
    %252 = bitcast i32 %251 to i32
    %253 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %254 = getelementptr inbounds [32 x i32], [32 x i32]* %253, i32 0, i8 %4
    store i32 %252, i32* %254
    br label %endif_27
endif_27:
    br label %endif_26
endif_26:
    br label %endif_25
endif_25:
    br label %endif_24
endif_24:
    br label %endif_23
endif_23:
    br label %endif_22
else_22:
    %255 = icmp eq i8 %3, 35
    br i1 %255 , label %then_28, label %else_28
then_28:
    %256 = call i8(i32) @extract_funct7 (i32 %2)
    %257 = zext i8 %256 to i16
    %258 = shl i16 %257, 5
    %259 = zext i8 %4 to i16
    %260 = or i16 %258, %259
    %261 = call i16(i16) @expand12 (i16 %260)
    %262 = sext i16 %261 to i32
    %263 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %264 = getelementptr inbounds [32 x i32], [32 x i32]* %263, i32 0, i8 %5
    %265 = load i32, i32* %264
    %266 = add i32 %265, %262
    %267 = bitcast i32 %266 to i32
    %268 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %269 = getelementptr inbounds [32 x i32], [32 x i32]* %268, i32 0, i8 %6
    %270 = load i32, i32* %269
    ;printf("S adr=%x, val=%x\n", adr, val)
    %271 = icmp eq i8 %7, 0
    br i1 %271 , label %then_29, label %else_29
then_29:
    ; sb
    %272 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str38 to [0 x i8]*), i8 %6, i32 %262, i8 %5)
    %273 = trunc i32 %270 to i8
    %274 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %275 = load %MemoryInterface*, %MemoryInterface** %274
    %276 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %275, i32 0, i32 3
    %277 = load void(i32, i8)*, void(i32, i8)** %276
    call void(i32, i8) %277 (i32 %267, i8 %273)
    br label %endif_29
else_29:
    %278 = icmp eq i8 %7, 1
    br i1 %278 , label %then_30, label %else_30
then_30:
    ; sh
    %279 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str39 to [0 x i8]*), i8 %6, i32 %262, i8 %5)
    %280 = trunc i32 %270 to i16
    %281 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %282 = load %MemoryInterface*, %MemoryInterface** %281
    %283 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %282, i32 0, i32 4
    %284 = load void(i32, i16)*, void(i32, i16)** %283
    call void(i32, i16) %284 (i32 %267, i16 %280)
    br label %endif_30
else_30:
    %285 = icmp eq i8 %7, 2
    br i1 %285 , label %then_31, label %endif_31
then_31:
    ; sw
    %286 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str40 to [0 x i8]*), i8 %6, i32 %262, i8 %5)
    %287 = bitcast i32 %270 to i32
    %288 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %289 = load %MemoryInterface*, %MemoryInterface** %288
    %290 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %289, i32 0, i32 5
    %291 = load void(i32, i32)*, void(i32, i32)** %290
    call void(i32, i32) %291 (i32 %267, i32 %287)
    br label %endif_31
endif_31:
    br label %endif_30
endif_30:
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %292 = icmp eq i32 %2, 115
    br i1 %292 , label %then_32, label %else_32
then_32:
    %293 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str41 to [0 x i8]*))
    br label %endif_32
else_32:
    %294 = icmp eq i32 %2, 1048691
    br i1 %294 , label %then_33, label %else_33
then_33:
    %295 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([8 x i8]* @str42 to [0 x i8]*))
    ret i1 0
    br label %endif_33
else_33:
    %297 = icmp eq i32 %2, 16777231
    br i1 %297 , label %then_34, label %else_34
then_34:
    %298 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str43 to [0 x i8]*))
    br label %endif_34
else_34:
    %299 = icmp eq i32 %2, 0
    br i1 %299 , label %then_35, label %else_35
then_35:
    %300 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str44 to [0 x i8]*))
    ret i1 0
    br label %endif_35
else_35:
    %302 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([22 x i8]* @str45 to [0 x i8]*), i8 %3)
    br label %endif_35
endif_35:
    br label %endif_34
endif_34:
    br label %endif_33
endif_33:
    br label %endif_32
endif_32:
    br label %endif_28
endif_28:
    br label %endif_22
endif_22:
    br label %endif_8
endif_8:
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
    %303 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %304 = load i1, i1* %303
    br i1 %304 , label %then_36, label %else_36
then_36:
    %305 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %306 = load i32, i32* %305
    %307 = add i32 %306, 4
    %308 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %307, i32* %308
    br label %endif_36
else_36:
    %309 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %309
    br label %endif_36
endif_36:
    ret i1 1
}


