
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


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


; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/mem.hm




declare [0 x i8]* @get_ram_ptr()
declare [0 x i8]* @get_rom_ptr()
declare i8 @vm_mem_read8(i32 %adr)
declare i16 @vm_mem_read16(i32 %adr)
declare i32 @vm_mem_read32(i32 %adr)
declare void @vm_mem_write8(i32 %adr, i8 %value)
declare void @vm_mem_write16(i32 %adr, i16 %value)
declare void @vm_mem_write32(i32 %adr, i32 %value)


; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/core.hm




%MemoryInterface = type {
	i8 (i32)*, 
	i16 (i32)*, 
	i32 (i32)*, 
	void (i32, i8)*, 
	void (i32, i16)*, 
	void (i32, i32)*
}

%Core = type {
	[32 x i32], 
	i32, 
	%MemoryInterface*, 
	i1, 
	i32, 
	i32
}













declare void @core_init(%Core* %core, %MemoryInterface* %memctl)
declare void @core_irq(%Core* %core, i32 %irq)
declare i1 @core_tick(%Core* %core)



; -- SOURCE: src/main.cm

@str1 = private constant [10 x i8] [i8 76, i8 79, i8 65, i8 68, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str2 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str3 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str4 = private constant [19 x i8] [i8 76, i8 79, i8 65, i8 68, i8 69, i8 68, i8 58, i8 32, i8 37, i8 122, i8 117, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str5 = private constant [15 x i8] [i8 37, i8 48, i8 56, i8 122, i8 120, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str6 = private constant [13 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str7 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str8 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str9 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str10 = private constant [5 x i8] [i8 37, i8 48, i8 56, i8 88, i8 0]
@str11 = private constant [6 x i8] [i8 32, i8 37, i8 48, i8 50, i8 88, i8 0]
@str12 = private constant [2 x i8] [i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 82, i8 73, i8 83, i8 67, i8 45, i8 86, i8 32, i8 86, i8 77, i8 10, i8 0]
@str14 = private constant [12 x i8] [i8 46, i8 47, i8 105, i8 109, i8 97, i8 103, i8 101, i8 46, i8 98, i8 105, i8 110, i8 0]
@str15 = private constant [7 x i8] [i8 83, i8 84, i8 65, i8 82, i8 84, i8 10, i8 0]
@str16 = private constant [15 x i8] [i8 99, i8 111, i8 114, i8 101, i8 46, i8 99, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@str17 = private constant [13 x i8] [i8 10, i8 67, i8 111, i8 114, i8 101, i8 32, i8 100, i8 117, i8 109, i8 112, i8 58, i8 10, i8 0]



@memctl = global %MemoryInterface zeroinitializer
@core = global %Core zeroinitializer


@text = global [4096 x i32] zeroinitializer

define i32 @loader(%Str8* %filename, [0 x i8]* %bufptr, i32 %buf_size) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %Str8* %filename)
	%2 = call %File* (%ConstCharStr*, %ConstCharStr*) @fopen(%Str8* %filename, %ConstCharStr* bitcast ([3 x i8]* @str2 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*), %Str8* %filename)
	ret i32 0
	br label %endif_0
endif_0:
	%6 = bitcast [0 x i8]* %bufptr to i8*
	%7 = zext i32 %buf_size to %SizeT
	%8 = call %SizeT (i8*, %SizeT, %SizeT, %File*) @fread(i8* %6, %SizeT 1, %SizeT %7, %File* %2)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str4 to [0 x i8]*), %SizeT %8)
	br i1 0 , label %then_1, label %endif_1
then_1:
	%10 = alloca %SizeT
	store %SizeT 0, %SizeT* %10
	br label %again_1
again_1:
	%11 = load %SizeT, %SizeT* %10
	%12 = udiv %SizeT %8, 4
	%13 = icmp ult %SizeT %11, %12
	br i1 %13 , label %body_1, label %break_1
body_1:
	%14 = load %SizeT, %SizeT* %10
	%15 = bitcast [0 x i8]* %bufptr to [0 x i32]*
	%16 = load %SizeT, %SizeT* %10
	%17 = getelementptr inbounds [0 x i32], [0 x i32]* %15, i32 0, %SizeT %16
	%18 = load i32, i32* %17
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str5 to [0 x i8]*), %SizeT %14, i32 %18)
	%20 = load %SizeT, %SizeT* %10
	%21 = add %SizeT %20, 4
	store %SizeT %21, %SizeT* %10
	br label %again_1
break_1:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str6 to [0 x i8]*))
	br label %endif_1
endif_1:
	%23 = call %Int (%File*) @fclose(%File* %2)
	%24 = trunc %SizeT %8 to i32
	ret i32 %24
}

define void @show_regs() {
	%1 = alloca i32
	store i32 0, i32* %1
	br label %again_1
again_1:
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, 16
	br i1 %3 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %1
	%5 = getelementptr inbounds %Core, %Core* @core, i32 0, i32 0
	%6 = load i32, i32* %1
	%7 = getelementptr inbounds [32 x i32], [32 x i32]* %5, i32 0, i32 %6
	%8 = load i32, i32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i32 %4, i32 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str8 to [0 x i8]*))
	%11 = load i32, i32* %1
	%12 = add i32 %11, 16
	%13 = getelementptr inbounds %Core, %Core* @core, i32 0, i32 0
	%14 = load i32, i32* %1
	%15 = add i32 %14, 16
	%16 = getelementptr inbounds [32 x i32], [32 x i32]* %13, i32 0, i32 %15
	%17 = load i32, i32* %16
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), i32 %12, i32 %17)
	%19 = load i32, i32* %1
	%20 = add i32 %19, 1
	store i32 %20, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @show_mem() {
	%1 = alloca i32
	store i32 0, i32* %1
	%2 = call [0 x i8]* () @get_ram_ptr()
	br label %again_1
again_1:
	%3 = load i32, i32* %1
	%4 = icmp slt i32 %3, 256
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = load i32, i32* %1
	%6 = mul i32 %5, 16
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str10 to [0 x i8]*), i32 %6)
	%8 = alloca i32
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
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str11 to [0 x i8]*), i8 %15)
	%17 = load i32, i32* %8
	%18 = add i32 %17, 1
	store i32 %18, i32* %8
	br label %again_2
break_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str12 to [0 x i8]*))
	%20 = load i32, i32* %1
	%21 = add i32 %20, 16
	store i32 %21, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @mem_violation_event(i32 %reason) {
	call void (%Core*, i32) @core_irq(%Core* @core, i32 11)
	ret void
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str13 to [0 x i8]*))
	; memory controller initialize
	%2 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 0
	store i8 (i32)* @vm_mem_read8, i8 (i32)** %2
	%3 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 1
	store i16 (i32)* @vm_mem_read16, i16 (i32)** %3
	%4 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 2
	store i32 (i32)* @vm_mem_read32, i32 (i32)** %4
	%5 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 3
	store void (i32, i8)* @vm_mem_write8, void (i32, i8)** %5
	%6 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 4
	store void (i32, i16)* @vm_mem_write16, void (i32, i16)** %6
	%7 = getelementptr inbounds %MemoryInterface, %MemoryInterface* @memctl, i32 0, i32 5
	store void (i32, i32)* @vm_mem_write32, void (i32, i32)** %7
	%8 = call [0 x i8]* () @get_rom_ptr()
	%9 = call i32 (%Str8*, [0 x i8]*, i32) @loader(%Str8* bitcast ([12 x i8]* @str14 to [0 x i8]*), [0 x i8]* %8, i32 65536)
	call void (%Core*, %MemoryInterface*) @core_init(%Core* @core, %MemoryInterface* @memctl)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str15 to [0 x i8]*))
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	;var cmd: [8]Char8
	;scanf("%c", &cmd[0])
	%11 = call i1 (%Core*) @core_tick(%Core* @core)
	%12 = xor i1 %11, -1
	br i1 %12 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%14 = getelementptr inbounds %Core, %Core* @core, i32 0, i32 5
	%15 = load i32, i32* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str16 to [0 x i8]*), i32 %15)
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str17 to [0 x i8]*))
	call void () @show_regs()
	call void () @show_mem()
	ret %Int 0
}


