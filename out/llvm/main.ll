
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

; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/mem.hm




declare [0 x i8]* @get_ram_ptr()
declare [0 x i8]* @get_rom_ptr()
declare i8 @vm_mem_read8(i32)
declare i16 @vm_mem_read16(i32)
declare i32 @vm_mem_read32(i32)
declare void @vm_mem_write8(i32, i8)
declare void @vm_mem_write16(i32, i16)
declare void @vm_mem_write32(i32, i32)

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









declare void @core_init(%Core*, %MemoryInterface*, i32)
declare i1 @core_tick(%Core*)

; -- SOURCE: src/main.cm

@str1 = private constant [19 x i8] [i8 46, i8 47, i8 114, i8 105, i8 115, i8 99, i8 118, i8 95, i8 99, i8 47, i8 116, i8 101, i8 120, i8 116, i8 46, i8 98, i8 105, i8 110, i8 0]
@str2 = private constant [19 x i8] [i8 46, i8 47, i8 114, i8 105, i8 115, i8 99, i8 118, i8 95, i8 99, i8 47, i8 100, i8 97, i8 116, i8 97, i8 46, i8 98, i8 105, i8 110, i8 0]
@str3 = private constant [10 x i8] [i8 76, i8 79, i8 65, i8 68, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str5 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str6 = private constant [18 x i8] [i8 76, i8 79, i8 65, i8 68, i8 69, i8 68, i8 58, i8 32, i8 37, i8 100, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 37, i8 48, i8 56, i8 120, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str8 = private constant [13 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str9 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str10 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str11 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str12 = private constant [5 x i8] [i8 37, i8 48, i8 56, i8 88, i8 0]
@str13 = private constant [6 x i8] [i8 32, i8 37, i8 48, i8 50, i8 88, i8 0]
@str14 = private constant [2 x i8] [i8 10, i8 0]
@str15 = private constant [11 x i8] [i8 82, i8 73, i8 83, i8 67, i8 45, i8 86, i8 32, i8 86, i8 77, i8 10, i8 0]
@str16 = private constant [7 x i8] [i8 83, i8 84, i8 65, i8 82, i8 84, i8 10, i8 0]
@str17 = private constant [13 x i8] [i8 10, i8 67, i8 111, i8 114, i8 101, i8 32, i8 100, i8 117, i8 109, i8 112, i8 58, i8 10, i8 0]



@memctl = global %MemoryInterface zeroinitializer
@core = global %Core zeroinitializer


@text = global [4096 x i32] zeroinitializer

define i32 @loader([0 x i8]* %filename, [0 x i8]* %bufptr, i32 %buf_size) {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([10 x i8]* @str3 to [0 x i8]*), [0 x i8]* %filename)
    %2 = call %FILE*(%ConstCharStr*, %ConstCharStr*) @fopen ([0 x i8]* %filename, %ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([29 x i8]* @str5 to [0 x i8]*), [0 x i8]* %filename)
    ret i32 0
    br label %endif_0
endif_0:
    %6 = bitcast [0 x i8]* %bufptr to i8*
    %7 = zext i32 %buf_size to i64
    %8 = call i64(i8*, i64, i64, %FILE*) @fread (i8* %6, i64 1, i64 %7, %FILE* %2)
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([18 x i8]* @str6 to [0 x i8]*), i64 %8)
    br i1 1 , label %then_1, label %endif_1
then_1:
    %i = alloca i64
    store i64 0, i64* %i
    br label %again_1
again_1:
    %10 = load i64, i64* %i
    %11 = udiv i64 %8, 4
    %12 = icmp ult i64 %10, %11
    br i1 %12 , label %body_1, label %break_1
body_1:
    %13 = load i64, i64* %i
    %14 = bitcast [0 x i8]* %bufptr to [0 x i32]*
    %15 = load i64, i64* %i
    %16 = getelementptr inbounds [0 x i32], [0 x i32]* %14, i32 0, i64 %15
    %17 = load i32, i32* %16
    %18 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), i64 %13, i32 %17)
    %19 = load i64, i64* %i
    %20 = add i64 %19, 4
    store i64 %20, i64* %i
    br label %again_1
break_1:
    %21 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*))
    br label %endif_1
endif_1:
    %22 = call i32(%FILE*) @fclose (%FILE* %2)
    %23 = trunc i64 %8 to i32
    ret i32 %23
}

define void @show_regs() {
    %i = alloca i32
    store i32 0, i32* %i
    br label %again_1
again_1:
    %1 = load i32, i32* %i
    %2 = icmp slt i32 %1, 16
    br i1 %2 , label %body_1, label %break_1
body_1:
    %3 = load i32, i32* %i
    %4 = getelementptr inbounds %Core, %Core* @core, i32 0, i32 0
    %5 = load i32, i32* %i
    %6 = getelementptr inbounds [32 x i32], [32 x i32]* %4, i32 0, i32 %5
    %7 = load i32, i32* %6
    %8 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([15 x i8]* @str9 to [0 x i8]*), i32 %3, i32 %7)
    %9 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str10 to [0 x i8]*))
    %10 = load i32, i32* %i
    %11 = add i32 %10, 16
    %12 = getelementptr inbounds %Core, %Core* @core, i32 0, i32 0
    %13 = load i32, i32* %i
    %14 = add i32 %13, 16
    %15 = getelementptr inbounds [32 x i32], [32 x i32]* %12, i32 0, i32 %14
    %16 = load i32, i32* %15
    %17 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), i32 %11, i32 %16)
    %18 = load i32, i32* %i
    %19 = add i32 %18, 1
    store i32 %19, i32* %i
    br label %again_1
break_1:
    ret void
}

define void @show_mem() {
    %i = alloca i32
    store i32 0, i32* %i
    %1 = call [0 x i8]*() @get_ram_ptr ()
    br label %again_1
again_1:
    %2 = load i32, i32* %i
    %3 = icmp slt i32 %2, 256
    br i1 %3 , label %body_1, label %break_1
body_1:
    %4 = load i32, i32* %i
    %5 = mul i32 %4, 16
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([5 x i8]* @str12 to [0 x i8]*), i32 %5)
    %j = alloca i32
    store i32 0, i32* %j
    br label %again_2
again_2:
    %7 = load i32, i32* %j
    %8 = icmp slt i32 %7, 16
    br i1 %8 , label %body_2, label %break_2
body_2:
    %9 = load i32, i32* %i
    %10 = load i32, i32* %j
    %11 = add i32 %9, %10
    %12 = getelementptr inbounds [0 x i8], [0 x i8]* %1, i32 0, i32 %11
    %13 = load i8, i8* %12
    %14 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([6 x i8]* @str13 to [0 x i8]*), i8 %13)
    %15 = load i32, i32* %j
    %16 = add i32 %15, 1
    store i32 %16, i32* %j
    br label %again_2
break_2:
    %17 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([2 x i8]* @str14 to [0 x i8]*))
    %18 = load i32, i32* %i
    %19 = add i32 %18, 16
    store i32 %19, i32* %i
    br label %again_1
break_1:
    ret void
}

define i32 @main() {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([11 x i8]* @str15 to [0 x i8]*))
    ; memory controller initialize
    %2 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 0
    store i8(i32)* @vm_mem_read8, i8(i32)** %2
    %3 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 1
    store i16(i32)* @vm_mem_read16, i16(i32)** %3
    %4 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 2
    store i32(i32)* @vm_mem_read32, i32(i32)** %4
    %5 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 3
    store void(i32, i8)* @vm_mem_write8, void(i32, i8)** %5
    %6 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 4
    store void(i32, i16)* @vm_mem_write16, void(i32, i16)** %6
    %7 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 5
    store void(i32, i32)* @vm_mem_write32, void(i32, i32)** %7
    %8 = call [0 x i8]*() @get_rom_ptr ()
    %9 = call i32([0 x i8]*, [0 x i8]*, i32) @loader ([0 x i8]* bitcast ([19 x i8]* @str1 to [0 x i8]*), [0 x i8]* %8, i32 65536)
    %10 = bitcast %Core* @core to %Core*
    %11 = bitcast %MemoryInterface* @memctl to %MemoryInterface*
    call void(%Core*, %MemoryInterface*, i32) @core_init (%Core* %10, %MemoryInterface* %11, i32 268435712)
    %12 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([7 x i8]* @str16 to [0 x i8]*))
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    ;var cmd: [8]Char8
    ;scanf("%c", &cmd[0])

    %13 = bitcast %Core* @core to %Core*
    %14 = call i1(%Core*) @core_tick (%Core* %13)
    %15 = xor  i1 %14, -1
    br i1 %15 , label %then_0, label %endif_0
then_0:
    br label %break_1
    br label %endif_0
endif_0:
    br label %again_1
break_1:
    %17 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([13 x i8]* @str17 to [0 x i8]*))
    call void() @show_regs ()
    call void() @show_mem ()
    ret i32 0
}


