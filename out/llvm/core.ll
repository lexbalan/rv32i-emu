
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
	i1, 
	i32, 
	i32
}














; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/csr.hm



declare void @csr_rw(%Core* %core, i16 %csr, i8 %rd, i8 %rs1)
declare void @csr_rs(%Core* %core, i16 %csr, i8 %rd, i8 %rs1)
declare void @csr_rc(%Core* %core, i16 %csr, i8 %rd, i8 %rs1)


declare void @csr_rwi(%Core* %core, i16 %csr, i8 %rd, i8 %imm)
declare void @csr_rsi(%Core* %core, i16 %csr, i8 %rd, i8 %imm)
declare void @csr_rci(%Core* %core, i16 %csr, i8 %rd, i8 %imm)


; -- SOURCE: src/core.cm

@str1 = private constant [17 x i8] [i8 70, i8 65, i8 84, i8 65, i8 76, i8 58, i8 32, i8 120, i8 48, i8 32, i8 33, i8 61, i8 32, i8 48, i8 33, i8 10, i8 0]
@str2 = private constant [7 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 10, i8 0]
@str3 = private constant [8 x i8] [i8 69, i8 66, i8 82, i8 69, i8 65, i8 75, i8 10, i8 0]
@str4 = private constant [34 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 102, i8 117, i8 110, i8 99, i8 116, i8 51, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl) {
	;    memset(core, 0, sizeof(Core))
	;    core.memctl = memctl
	;    core.need_step = true
	%1 = insertvalue [32 x i32] zeroinitializer, i32 0, 0
	%2 = insertvalue [32 x i32] %1, i32 0, 1
	%3 = insertvalue [32 x i32] %2, i32 0, 2
	%4 = insertvalue [32 x i32] %3, i32 0, 3
	%5 = insertvalue [32 x i32] %4, i32 0, 4
	%6 = insertvalue [32 x i32] %5, i32 0, 5
	%7 = insertvalue [32 x i32] %6, i32 0, 6
	%8 = insertvalue [32 x i32] %7, i32 0, 7
	%9 = insertvalue [32 x i32] %8, i32 0, 8
	%10 = insertvalue [32 x i32] %9, i32 0, 9
	%11 = insertvalue [32 x i32] %10, i32 0, 10
	%12 = insertvalue [32 x i32] %11, i32 0, 11
	%13 = insertvalue [32 x i32] %12, i32 0, 12
	%14 = insertvalue [32 x i32] %13, i32 0, 13
	%15 = insertvalue [32 x i32] %14, i32 0, 14
	%16 = insertvalue [32 x i32] %15, i32 0, 15
	%17 = insertvalue [32 x i32] %16, i32 0, 16
	%18 = insertvalue [32 x i32] %17, i32 0, 17
	%19 = insertvalue [32 x i32] %18, i32 0, 18
	%20 = insertvalue [32 x i32] %19, i32 0, 19
	%21 = insertvalue [32 x i32] %20, i32 0, 20
	%22 = insertvalue [32 x i32] %21, i32 0, 21
	%23 = insertvalue [32 x i32] %22, i32 0, 22
	%24 = insertvalue [32 x i32] %23, i32 0, 23
	%25 = insertvalue [32 x i32] %24, i32 0, 24
	%26 = insertvalue [32 x i32] %25, i32 0, 25
	%27 = insertvalue [32 x i32] %26, i32 0, 26
	%28 = insertvalue [32 x i32] %27, i32 0, 27
	%29 = insertvalue [32 x i32] %28, i32 0, 28
	%30 = insertvalue [32 x i32] %29, i32 0, 29
	%31 = insertvalue [32 x i32] %30, i32 0, 30
	%32 = insertvalue [32 x i32] %31, i32 0, 31
	%33 = insertvalue %Core zeroinitializer, [32 x i32] %32, 0
	%34 = insertvalue %Core %33, i32 0, 1
	%35 = insertvalue %Core %34, %MemoryInterface* %memctl, 2
	%36 = insertvalue %Core %35, i1 1, 3
	%37 = insertvalue %Core %36, i1 0, 4
	%38 = insertvalue %Core %37, i32 0, 5
	%39 = insertvalue %Core %38, i32 0, 6
	store %Core %39, %Core* %core
	ret void
}

define void @core_irq(%Core* %core, i32 %irq) {
	%1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
	%2 = load i32, i32* %1
	%3 = icmp eq i32 %2, 0
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
	store i32 %irq, i32* %4
	br label %endif_0
endif_0:
	ret void
}

define i32 @expand12(i32 %val_12bit) {
	%1 = alloca i32
	store i32 %val_12bit, i32* %1
	%2 = load i32, i32* %1
	%3 = and i32 %2, 2048
	%4 = icmp ne i32 %3, 0
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = load i32, i32* %1
	%6 = or i32 %5, 4294963200
	store i32 %6, i32* %1
	br label %endif_0
endif_0:
	%7 = load i32, i32* %1
	%8 = bitcast i32 %7 to i32
	ret i32 %8
}

define i32 @expand20(i32 %val_20bit) {
	%1 = alloca i32
	store i32 %val_20bit, i32* %1
	%2 = load i32, i32* %1
	%3 = and i32 %2, 524288
	%4 = icmp ne i32 %3, 0
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = load i32, i32* %1
	%6 = or i32 %5, 4293918720
	store i32 %6, i32* %1
	br label %endif_0
endif_0:
	%7 = load i32, i32* %1
	%8 = bitcast i32 %7 to i32
	ret i32 %8
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
	ret i32 %2
}

define i32 @extract_imm31_12(i32 %instr) {
	%1 = lshr i32 %instr, 12
	%2 = and i32 %1, 1048575
	ret i32 %2
}

define i32 @extract_jal_imm(i32 %instr) {
	%1 = call i32 (i32) @extract_imm31_12(i32 %instr)
	%2 = lshr i32 %1, 0
	%3 = and i32 %2, 255
	%4 = shl i32 %3, 12
	%5 = lshr i32 %1, 8
	%6 = and i32 %5, 1
	%7 = shl i32 %6, 11
	%8 = lshr i32 %1, 9
	%9 = and i32 %8, 1023
	%10 = shl i32 %9, 1
	%11 = lshr i32 %1, 20
	%12 = and i32 %11, 1
	%13 = shl i32 %12, 20
	%14 = or i32 %7, %10
	%15 = or i32 %4, %14
	%16 = or i32 %13, %15
	ret i32 %16
}

define void @core_tick(%Core* %core) {
	%1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
	%2 = load i32, i32* %1
	%3 = icmp ugt i32 %2, 0
	br i1 %3 , label %then_0, label %endif_0
then_0:
	;printf("\nINT #%02X\n", core.interrupt)
	%4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
	%5 = load i32, i32* %4
	%6 = mul i32 %5, 4
	%7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	store i32 %6, i32* %7
	%8 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
	store i32 0, i32* %8
	br label %endif_0
endif_0:
	; instruction fetch
	%9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%10 = load i32, i32* %9
	%11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%12 = load %MemoryInterface*, %MemoryInterface** %11
	%13 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %12, i32 0, i32 2
	%14 = load i32 (i32)*, i32 (i32)** %13
	%15 = call i32 (i32) %14(i32 %10)
	%16 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
	%17 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
	%18 = load i32, i32* %17
	%19 = add i32 %18, 1
	store i32 %19, i32* %16
	; assert
	%20 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%21 = getelementptr inbounds [32 x i32], [32 x i32]* %20, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = icmp ne i32 %22, 0
	br i1 %23 , label %then_1, label %endif_1
then_1:
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str1 to [0 x i8]*))
	call void (%Int) @exit(%Int 1)
	br label %endif_1
endif_1:
	%25 = call i8 (i32) @extract_op(i32 %15)
	%26 = call i8 (i32) @extract_funct3(i32 %15)
	%27 = icmp eq i8 %25, 19
	br i1 %27 , label %then_2, label %else_2
then_2:
	call void (%Core*, i32) @do_opi(%Core* %core, i32 %15)
	br label %endif_2
else_2:
	%28 = icmp eq i8 %25, 51
	br i1 %28 , label %then_3, label %else_3
then_3:
	call void (%Core*, i32) @do_opr(%Core* %core, i32 %15)
	br label %endif_3
else_3:
	%29 = icmp eq i8 %25, 55
	br i1 %29 , label %then_4, label %else_4
then_4:
	call void (%Core*, i32) @do_lui(%Core* %core, i32 %15)
	br label %endif_4
else_4:
	%30 = icmp eq i8 %25, 23
	br i1 %30 , label %then_5, label %else_5
then_5:
	call void (%Core*, i32) @do_auipc(%Core* %core, i32 %15)
	br label %endif_5
else_5:
	%31 = icmp eq i8 %25, 111
	br i1 %31 , label %then_6, label %else_6
then_6:
	call void (%Core*, i32) @do_jal(%Core* %core, i32 %15)
	br label %endif_6
else_6:
	%32 = icmp eq i8 %25, 103
	%33 = icmp eq i8 %26, 0
	%34 = and i1 %32, %33
	br i1 %34 , label %then_7, label %else_7
then_7:
	call void (%Core*, i32) @do_jalr(%Core* %core, i32 %15)
	br label %endif_7
else_7:
	%35 = icmp eq i8 %25, 99
	br i1 %35 , label %then_8, label %else_8
then_8:
	call void (%Core*, i32) @do_opb(%Core* %core, i32 %15)
	br label %endif_8
else_8:
	%36 = icmp eq i8 %25, 3
	br i1 %36 , label %then_9, label %else_9
then_9:
	call void (%Core*, i32) @do_opl(%Core* %core, i32 %15)
	br label %endif_9
else_9:
	%37 = icmp eq i8 %25, 35
	br i1 %37 , label %then_10, label %else_10
then_10:
	call void (%Core*, i32) @do_ops(%Core* %core, i32 %15)
	br label %endif_10
else_10:
	%38 = icmp eq i8 %25, 115
	br i1 %38 , label %then_11, label %else_11
then_11:
	call void (%Core*, i32) @do_system(%Core* %core, i32 %15)
	br label %endif_11
else_11:
	%39 = icmp eq i8 %25, 15
	br i1 %39 , label %then_12, label %else_12
then_12:
	call void (%Core*, i32) @do_fence(%Core* %core, i32 %15)
	br label %endif_12
else_12:
	;printf("UNKNOWN OPCODE: %08X\n", op)
	br label %endif_12
endif_12:
	br label %endif_11
endif_11:
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
	%40 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	%41 = load i1, i1* %40
	br i1 %41 , label %then_13, label %else_13
then_13:
	%42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%43 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%44 = load i32, i32* %43
	%45 = add i32 %44, 4
	store i32 %45, i32* %42
	br label %endif_13
else_13:
	%46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 1, i1* %46
	br label %endif_13
endif_13:
	ret void
}

define void @do_opi(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	%4 = call i32 (i32) @expand12(i32 %3)
	%5 = call i8 (i32) @extract_rd(i32 %instr)
	%6 = call i8 (i32) @extract_rs1(i32 %instr)
	%7 = icmp eq i8 %5, 0
	br i1 %7 , label %then_0, label %endif_0
then_0:ret void
	br label %endif_0
endif_0:
	%9 = icmp eq i8 %1, 0
	br i1 %9 , label %then_1, label %else_1
then_1:
	;printf("addi x%d, x%d, %d\n", rd, rs1, imm)
	%10 = icmp ne i8 %5, 0
	br i1 %10 , label %then_2, label %endif_2
then_2:
	%11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%12 = getelementptr inbounds [32 x i32], [32 x i32]* %11, i32 0, i8 %5
	%13 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%14 = getelementptr inbounds [32 x i32], [32 x i32]* %13, i32 0, i8 %6
	%15 = load i32, i32* %14
	%16 = add i32 %15, %4
	store i32 %16, i32* %12
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	%17 = icmp eq i8 %1, 1
	%18 = icmp eq i8 %2, 0
	%19 = and i1 %17, %18
	br i1 %19 , label %then_3, label %else_3
then_3:
	;printf("slli x%d, x%d, %d\n", rd, rs1, imm)
	%20 = icmp ne i8 %5, 0
	br i1 %20 , label %then_4, label %endif_4
then_4:
	%21 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%22 = getelementptr inbounds [32 x i32], [32 x i32]* %21, i32 0, i8 %5
	%23 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%24 = getelementptr inbounds [32 x i32], [32 x i32]* %23, i32 0, i8 %6
	%25 = load i32, i32* %24
	%26 = bitcast i32 %25 to i32
	%27 = shl i32 %26, %4
	%28 = bitcast i32 %27 to i32
	store i32 %28, i32* %22
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
	%29 = icmp eq i8 %1, 2
	br i1 %29 , label %then_5, label %else_5
then_5:
	; SLTI - set [1 to rd if rs1] less than immediate
	;printf("slti x%d, x%d, %d\n", rd, rs1, imm)
	%30 = icmp ne i8 %5, 0
	br i1 %30 , label %then_6, label %endif_6
then_6:
	%31 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%32 = getelementptr inbounds [32 x i32], [32 x i32]* %31, i32 0, i8 %5
	%33 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%34 = getelementptr inbounds [32 x i32], [32 x i32]* %33, i32 0, i8 %6
	%35 = load i32, i32* %34
	%36 = icmp slt i32 %35, %4
	%37 = sext i1 %36 to i32
	store i32 %37, i32* %32
	br label %endif_6
endif_6:
	br label %endif_5
else_5:
	%38 = icmp eq i8 %1, 3
	br i1 %38 , label %then_7, label %else_7
then_7:
	;printf("sltiu x%d, x%d, %d\n", rd, rs1, imm)
	%39 = icmp ne i8 %5, 0
	br i1 %39 , label %then_8, label %endif_8
then_8:
	%40 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%41 = getelementptr inbounds [32 x i32], [32 x i32]* %40, i32 0, i8 %5
	%42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%43 = getelementptr inbounds [32 x i32], [32 x i32]* %42, i32 0, i8 %6
	%44 = load i32, i32* %43
	%45 = bitcast i32 %44 to i32
	%46 = bitcast i32 %4 to i32
	%47 = icmp ult i32 %45, %46
	%48 = sext i1 %47 to i32
	store i32 %48, i32* %41
	br label %endif_8
endif_8:
	br label %endif_7
else_7:
	%49 = icmp eq i8 %1, 4
	br i1 %49 , label %then_9, label %else_9
then_9:
	;printf("xori x%d, x%d, %d\n", rd, rs1, imm)
	%50 = icmp ne i8 %5, 0
	br i1 %50 , label %then_10, label %endif_10
then_10:
	%51 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%52 = getelementptr inbounds [32 x i32], [32 x i32]* %51, i32 0, i8 %5
	%53 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%54 = getelementptr inbounds [32 x i32], [32 x i32]* %53, i32 0, i8 %6
	%55 = load i32, i32* %54
	%56 = xor i32 %55, %4
	store i32 %56, i32* %52
	br label %endif_10
endif_10:
	br label %endif_9
else_9:
	%57 = icmp eq i8 %1, 5
	%58 = icmp eq i8 %2, 0
	%59 = and i1 %57, %58
	br i1 %59 , label %then_11, label %else_11
then_11:
	;printf("srli x%d, x%d, %d\n", rd, rs1, imm)
	%60 = icmp ne i8 %5, 0
	br i1 %60 , label %then_12, label %endif_12
then_12:
	%61 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%62 = getelementptr inbounds [32 x i32], [32 x i32]* %61, i32 0, i8 %5
	%63 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%64 = getelementptr inbounds [32 x i32], [32 x i32]* %63, i32 0, i8 %6
	%65 = load i32, i32* %64
	%66 = bitcast i32 %65 to i32
	%67 = lshr i32 %66, %4
	%68 = bitcast i32 %67 to i32
	store i32 %68, i32* %62
	br label %endif_12
endif_12:
	br label %endif_11
else_11:
	%69 = icmp eq i8 %1, 5
	%70 = icmp eq i8 %2, 32
	%71 = and i1 %69, %70
	br i1 %71 , label %then_13, label %else_13
then_13:
	;printf("srai x%d, x%d, %d\n", rd, rs1, imm)
	%72 = icmp ne i8 %5, 0
	br i1 %72 , label %then_14, label %endif_14
then_14:
	%73 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%74 = getelementptr inbounds [32 x i32], [32 x i32]* %73, i32 0, i8 %5
	%75 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%76 = getelementptr inbounds [32 x i32], [32 x i32]* %75, i32 0, i8 %6
	%77 = load i32, i32* %76
	%78 = ashr i32 %77, %4
	store i32 %78, i32* %74
	br label %endif_14
endif_14:
	br label %endif_13
else_13:
	%79 = icmp eq i8 %1, 6
	br i1 %79 , label %then_15, label %else_15
then_15:
	;printf("ori x%d, x%d, %d\n", rd, rs1, imm)
	%80 = icmp ne i8 %5, 0
	br i1 %80 , label %then_16, label %endif_16
then_16:
	%81 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%82 = getelementptr inbounds [32 x i32], [32 x i32]* %81, i32 0, i8 %5
	%83 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%84 = getelementptr inbounds [32 x i32], [32 x i32]* %83, i32 0, i8 %6
	%85 = load i32, i32* %84
	%86 = or i32 %85, %4
	store i32 %86, i32* %82
	br label %endif_16
endif_16:
	br label %endif_15
else_15:
	%87 = icmp eq i8 %1, 7
	br i1 %87 , label %then_17, label %endif_17
then_17:
	;printf("andi x%d, x%d, %d\n", rd, rs1, imm)
	%88 = icmp ne i8 %5, 0
	br i1 %88 , label %then_18, label %endif_18
then_18:
	%89 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%90 = getelementptr inbounds [32 x i32], [32 x i32]* %89, i32 0, i8 %5
	%91 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%92 = getelementptr inbounds [32 x i32], [32 x i32]* %91, i32 0, i8 %6
	%93 = load i32, i32* %92
	%94 = and i32 %93, %4
	store i32 %94, i32* %90
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

define void @do_opr(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	%4 = call i32 (i32) @expand12(i32 %3)
	%5 = call i8 (i32) @extract_rd(i32 %instr)
	%6 = call i8 (i32) @extract_rs1(i32 %instr)
	%7 = call i8 (i32) @extract_rs2(i32 %instr)
	%8 = icmp eq i8 %5, 0
	br i1 %8 , label %then_0, label %endif_0
then_0:ret void
	br label %endif_0
endif_0:
	%10 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%11 = getelementptr inbounds [32 x i32], [32 x i32]* %10, i32 0, i8 %6
	%12 = load i32, i32* %11
	%13 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%14 = getelementptr inbounds [32 x i32], [32 x i32]* %13, i32 0, i8 %7
	%15 = load i32, i32* %14
	%16 = icmp eq i8 %1, 0
	%17 = icmp eq i8 %2, 0
	%18 = and i1 %16, %17
	br i1 %18 , label %then_1, label %else_1
then_1:
	;printf("add x%d, x%d, x%d\n", rd, rs1, rs2)
	%19 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%20 = getelementptr inbounds [32 x i32], [32 x i32]* %19, i32 0, i8 %5
	%21 = add i32 %12, %15
	store i32 %21, i32* %20
	br label %endif_1
else_1:
	%22 = icmp eq i8 %1, 0
	%23 = icmp eq i8 %2, 32
	%24 = and i1 %22, %23
	br i1 %24 , label %then_2, label %else_2
then_2:
	;printf("sub x%d, x%d, x%d\n", rd, rs1, rs2)
	%25 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%26 = getelementptr inbounds [32 x i32], [32 x i32]* %25, i32 0, i8 %5
	%27 = sub i32 %12, %15
	store i32 %27, i32* %26
	br label %endif_2
else_2:
	%28 = icmp eq i8 %1, 1
	br i1 %28 , label %then_3, label %else_3
then_3:
	; shift left logical
	;printf("sll x%d, x%d, x%d\n", rd, rs1, rs2)
	%29 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%30 = getelementptr inbounds [32 x i32], [32 x i32]* %29, i32 0, i8 %5
	%31 = shl i32 %12, %15
	store i32 %31, i32* %30
	br label %endif_3
else_3:
	%32 = icmp eq i8 %1, 2
	br i1 %32 , label %then_4, label %else_4
then_4:
	; set less than
	;printf("slt x%d, x%d, x%d\n", rd, rs1, rs2)
	%33 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%34 = getelementptr inbounds [32 x i32], [32 x i32]* %33, i32 0, i8 %5
	%35 = icmp slt i32 %12, %15
	%36 = sext i1 %35 to i32
	store i32 %36, i32* %34
	br label %endif_4
else_4:
	%37 = icmp eq i8 %1, 3
	br i1 %37 , label %then_5, label %else_5
then_5:
	; set less than unsigned
	;printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2)
	%38 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%39 = getelementptr inbounds [32 x i32], [32 x i32]* %38, i32 0, i8 %5
	%40 = bitcast i32 %12 to i32
	%41 = bitcast i32 %15 to i32
	%42 = icmp ult i32 %40, %41
	%43 = sext i1 %42 to i32
	store i32 %43, i32* %39
	br label %endif_5
else_5:
	%44 = icmp eq i8 %1, 4
	br i1 %44 , label %then_6, label %else_6
then_6:
	;printf("xor x%d, x%d, x%d\n", rd, rs1, rs2)
	%45 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%46 = getelementptr inbounds [32 x i32], [32 x i32]* %45, i32 0, i8 %5
	%47 = xor i32 %12, %15
	store i32 %47, i32* %46
	br label %endif_6
else_6:
	%48 = icmp eq i8 %1, 5
	%49 = icmp eq i8 %2, 0
	%50 = and i1 %48, %49
	br i1 %50 , label %then_7, label %else_7
then_7:
	; shift right logical
	;printf("srl x%d, x%d, x%d\n", rd, rs1, rs2)
	%51 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%52 = getelementptr inbounds [32 x i32], [32 x i32]* %51, i32 0, i8 %5
	%53 = bitcast i32 %12 to i32
	%54 = lshr i32 %53, %15
	%55 = bitcast i32 %54 to i32
	store i32 %55, i32* %52
	br label %endif_7
else_7:
	%56 = icmp eq i8 %1, 5
	%57 = icmp eq i8 %2, 32
	%58 = and i1 %56, %57
	br i1 %58 , label %then_8, label %else_8
then_8:
	; shift right arithmetical
	;printf("sra x%d, x%d, x%d\n", rd, rs1, rs2)
	%59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%60 = getelementptr inbounds [32 x i32], [32 x i32]* %59, i32 0, i8 %5
	%61 = ashr i32 %12, %15
	store i32 %61, i32* %60
	br label %endif_8
else_8:
	%62 = icmp eq i8 %1, 6
	br i1 %62 , label %then_9, label %else_9
then_9:
	;printf("or x%d, x%d, x%d\n", rd, rs1, rs2)
	%63 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%64 = getelementptr inbounds [32 x i32], [32 x i32]* %63, i32 0, i8 %5
	%65 = or i32 %12, %15
	store i32 %65, i32* %64
	br label %endif_9
else_9:
	%66 = icmp eq i8 %1, 7
	br i1 %66 , label %then_10, label %endif_10
then_10:
	;printf("and x%d, x%d, x%d\n", rd, rs1, rs2)
	%67 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%68 = getelementptr inbounds [32 x i32], [32 x i32]* %67, i32 0, i8 %5
	%69 = and i32 %12, %15
	store i32 %69, i32* %68
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

define void @do_lui(%Core* %core, i32 %instr) {
	; U-type
	%1 = call i32 (i32) @extract_imm31_12(i32 %instr)
	%2 = call i32 (i32) @expand12(i32 %1)
	;printf("lui x%d, 0x%X\n", rd, imm)
	%3 = call i8 (i32) @extract_rd(i32 %instr)
	%4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%5 = getelementptr inbounds [32 x i32], [32 x i32]* %4, i32 0, i8 %3
	%6 = shl i32 %2, 12
	store i32 %6, i32* %5
	ret void
}

define void @do_auipc(%Core* %core, i32 %instr) {
	; U-type
	%1 = call i32 (i32) @extract_imm31_12(i32 %instr)
	%2 = call i32 (i32) @expand12(i32 %1)
	%3 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%4 = load i32, i32* %3
	%5 = bitcast i32 %4 to i32
	%6 = shl i32 %2, 12
	%7 = add i32 %5, %6
	%8 = call i8 (i32) @extract_rd(i32 %instr)
	%9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%10 = getelementptr inbounds [32 x i32], [32 x i32]* %9, i32 0, i8 %8
	store i32 %7, i32* %10
	;printf("auipc x%d, 0x%X\n", rd, imm)
	ret void
}

define void @do_jal(%Core* %core, i32 %instr) {
	; U-type
	%1 = call i8 (i32) @extract_rd(i32 %instr)
	%2 = call i32 (i32) @extract_jal_imm(i32 %instr)
	%3 = call i32 (i32) @expand20(i32 %2)
	;printf("jal x%d, %d\n", rd, imm)
	%4 = icmp ne i8 %1, 0
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%6 = getelementptr inbounds [32 x i32], [32 x i32]* %5, i32 0, i8 %1
	%7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%8 = load i32, i32* %7
	%9 = add i32 %8, 4
	%10 = bitcast i32 %9 to i32
	store i32 %10, i32* %6
	br label %endif_0
endif_0:
	%11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%12 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%13 = load i32, i32* %12
	%14 = bitcast i32 %13 to i32
	%15 = add i32 %14, %3
	%16 = bitcast i32 %15 to i32
	store i32 %16, i32* %11
	%17 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %17
	ret void
}

define void @do_jalr(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_rs1(i32 %instr)
	%2 = call i8 (i32) @extract_rd(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	%4 = call i32 (i32) @expand12(i32 %3)
	;printf("jalr %d(x%d)\n", imm, rs1)
	; rd <- pc + 4
	; pc <- (rs1 + imm) & ~1
	%5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = add i32 %6, 4
	%8 = bitcast i32 %7 to i32
	%9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%10 = getelementptr inbounds [32 x i32], [32 x i32]* %9, i32 0, i8 %1
	%11 = load i32, i32* %10
	%12 = add i32 %11, %4
	%13 = bitcast i32 %12 to i32
	%14 = and i32 %13, 4294967294
	%15 = icmp ne i8 %2, 0
	br i1 %15 , label %then_0, label %endif_0
then_0:
	%16 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%17 = getelementptr inbounds [32 x i32], [32 x i32]* %16, i32 0, i8 %2
	store i32 %8, i32* %17
	br label %endif_0
endif_0:
	%18 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	store i32 %14, i32* %18
	%19 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %19
	ret void
}

define void @do_opb(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i8 (i32) @extract_rd(i32 %instr)
	%4 = call i8 (i32) @extract_rs1(i32 %instr)
	%5 = call i8 (i32) @extract_rs2(i32 %instr)
	%6 = and i8 %3, 30
	%7 = zext i8 %6 to i16
	%8 = and i8 %2, 63
	%9 = zext i8 %8 to i16
	%10 = shl i16 %9, 5
	%11 = and i8 %3, 1
	%12 = zext i8 %11 to i16
	%13 = shl i16 %12, 11
	%14 = and i8 %2, 64
	%15 = zext i8 %14 to i16
	%16 = shl i16 %15, 6
	%17 = alloca i16
	%18 = or i16 %10, %7
	%19 = or i16 %13, %18
	%20 = or i16 %16, %19
	store i16 %20, i16* %17
	; распространяем знак, если он есть
	%21 = load i16, i16* %17
	%22 = and i16 %21, 4096
	%23 = icmp ne i16 %22, 0
	br i1 %23 , label %then_0, label %endif_0
then_0:
	%24 = load i16, i16* %17
	%25 = or i16 61440, %24
	store i16 %25, i16* %17
	br label %endif_0
endif_0:
	%26 = load i16, i16* %17
	%27 = bitcast i16 %26 to i16
	%28 = icmp eq i8 %1, 0
	br i1 %28 , label %then_1, label %else_1
then_1:
	;beq
	;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%29 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%30 = getelementptr inbounds [32 x i32], [32 x i32]* %29, i32 0, i8 %4
	%31 = load i32, i32* %30
	%32 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%33 = getelementptr inbounds [32 x i32], [32 x i32]* %32, i32 0, i8 %5
	%34 = load i32, i32* %33
	%35 = icmp eq i32 %31, %34
	br i1 %35 , label %then_2, label %endif_2
then_2:
	%36 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%37 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%38 = load i32, i32* %37
	%39 = bitcast i32 %38 to i32
	%40 = sext i16 %27 to i32
	%41 = add i32 %39, %40
	%42 = bitcast i32 %41 to i32
	store i32 %42, i32* %36
	%43 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %43
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	%44 = icmp eq i8 %1, 1
	br i1 %44 , label %then_3, label %else_3
then_3:
	;bne
	;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%45 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%46 = getelementptr inbounds [32 x i32], [32 x i32]* %45, i32 0, i8 %4
	%47 = load i32, i32* %46
	%48 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%49 = getelementptr inbounds [32 x i32], [32 x i32]* %48, i32 0, i8 %5
	%50 = load i32, i32* %49
	%51 = icmp ne i32 %47, %50
	br i1 %51 , label %then_4, label %endif_4
then_4:
	%52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%53 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%54 = load i32, i32* %53
	%55 = bitcast i32 %54 to i32
	%56 = sext i16 %27 to i32
	%57 = add i32 %55, %56
	%58 = bitcast i32 %57 to i32
	store i32 %58, i32* %52
	%59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %59
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
	%60 = icmp eq i8 %1, 4
	br i1 %60 , label %then_5, label %else_5
then_5:
	;blt
	;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%61 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%62 = getelementptr inbounds [32 x i32], [32 x i32]* %61, i32 0, i8 %4
	%63 = load i32, i32* %62
	%64 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%65 = getelementptr inbounds [32 x i32], [32 x i32]* %64, i32 0, i8 %5
	%66 = load i32, i32* %65
	%67 = icmp slt i32 %63, %66
	br i1 %67 , label %then_6, label %endif_6
then_6:
	%68 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%69 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%70 = load i32, i32* %69
	%71 = bitcast i32 %70 to i32
	%72 = sext i16 %27 to i32
	%73 = add i32 %71, %72
	%74 = bitcast i32 %73 to i32
	store i32 %74, i32* %68
	%75 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %75
	br label %endif_6
endif_6:
	br label %endif_5
else_5:
	%76 = icmp eq i8 %1, 5
	br i1 %76 , label %then_7, label %else_7
then_7:
	;bge
	;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%77 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%78 = getelementptr inbounds [32 x i32], [32 x i32]* %77, i32 0, i8 %4
	%79 = load i32, i32* %78
	%80 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%81 = getelementptr inbounds [32 x i32], [32 x i32]* %80, i32 0, i8 %5
	%82 = load i32, i32* %81
	%83 = icmp sge i32 %79, %82
	br i1 %83 , label %then_8, label %endif_8
then_8:
	%84 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%85 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%86 = load i32, i32* %85
	%87 = bitcast i32 %86 to i32
	%88 = sext i16 %27 to i32
	%89 = add i32 %87, %88
	%90 = bitcast i32 %89 to i32
	store i32 %90, i32* %84
	%91 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %91
	br label %endif_8
endif_8:
	br label %endif_7
else_7:
	%92 = icmp eq i8 %1, 6
	br i1 %92 , label %then_9, label %else_9
then_9:
	;bltu
	;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%93 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%94 = getelementptr inbounds [32 x i32], [32 x i32]* %93, i32 0, i8 %4
	%95 = load i32, i32* %94
	%96 = bitcast i32 %95 to i32
	%97 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%98 = getelementptr inbounds [32 x i32], [32 x i32]* %97, i32 0, i8 %5
	%99 = load i32, i32* %98
	%100 = bitcast i32 %99 to i32
	%101 = icmp ult i32 %96, %100
	br i1 %101 , label %then_10, label %endif_10
then_10:
	%102 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%103 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%104 = load i32, i32* %103
	%105 = bitcast i32 %104 to i32
	%106 = sext i16 %27 to i32
	%107 = add i32 %105, %106
	%108 = bitcast i32 %107 to i32
	store i32 %108, i32* %102
	%109 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %109
	br label %endif_10
endif_10:
	br label %endif_9
else_9:
	%110 = icmp eq i8 %1, 7
	br i1 %110 , label %then_11, label %endif_11
then_11:
	;bgeu
	;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
	%111 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%112 = getelementptr inbounds [32 x i32], [32 x i32]* %111, i32 0, i8 %4
	%113 = load i32, i32* %112
	%114 = bitcast i32 %113 to i32
	%115 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%116 = getelementptr inbounds [32 x i32], [32 x i32]* %115, i32 0, i8 %5
	%117 = load i32, i32* %116
	%118 = bitcast i32 %117 to i32
	%119 = icmp uge i32 %114, %118
	br i1 %119 , label %then_12, label %else_12
then_12:
	%120 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%121 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
	%122 = load i32, i32* %121
	%123 = bitcast i32 %122 to i32
	%124 = sext i16 %27 to i32
	%125 = add i32 %123, %124
	%126 = bitcast i32 %125 to i32
	store i32 %126, i32* %120
	%127 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
	store i1 0, i1* %127
	br label %endif_12
else_12:
	br label %endif_12
endif_12:
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

define void @do_opl(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	;let imm = expand12(imm12)
	%4 = call i8 (i32) @extract_rd(i32 %instr)
	%5 = call i8 (i32) @extract_rs1(i32 %instr)
	%6 = call i8 (i32) @extract_rs2(i32 %instr)
	%7 = call i32 (i32) @extract_imm12(i32 %instr)
	%8 = call i32 (i32) @expand12(i32 %7)
	%9 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%10 = getelementptr inbounds [32 x i32], [32 x i32]* %9, i32 0, i8 %5
	%11 = load i32, i32* %10
	%12 = add i32 %11, %8
	%13 = bitcast i32 %12 to i32
	%14 = icmp eq i8 %1, 0
	br i1 %14 , label %then_0, label %else_0
then_0:
	; lb
	;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
	%15 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%16 = load %MemoryInterface*, %MemoryInterface** %15
	%17 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %16, i32 0, i32 0
	%18 = load i8 (i32)*, i8 (i32)** %17
	%19 = call i8 (i32) %18(i32 %13)
	%20 = icmp ne i8 %4, 0
	br i1 %20 , label %then_1, label %endif_1
then_1:
	%21 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%22 = getelementptr inbounds [32 x i32], [32 x i32]* %21, i32 0, i8 %4
	%23 = sext i8 %19 to i32
	store i32 %23, i32* %22
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
	%24 = icmp eq i8 %1, 1
	br i1 %24 , label %then_2, label %else_2
then_2:
	; lh
	;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
	%25 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%26 = load %MemoryInterface*, %MemoryInterface** %25
	%27 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %26, i32 0, i32 1
	%28 = load i16 (i32)*, i16 (i32)** %27
	%29 = call i16 (i32) %28(i32 %13)
	%30 = icmp ne i8 %4, 0
	br i1 %30 , label %then_3, label %endif_3
then_3:
	%31 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%32 = getelementptr inbounds [32 x i32], [32 x i32]* %31, i32 0, i8 %4
	%33 = sext i16 %29 to i32
	store i32 %33, i32* %32
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
	%34 = icmp eq i8 %1, 2
	br i1 %34 , label %then_4, label %else_4
then_4:
	; lw
	;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
	%35 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%36 = load %MemoryInterface*, %MemoryInterface** %35
	%37 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %36, i32 0, i32 2
	%38 = load i32 (i32)*, i32 (i32)** %37
	%39 = call i32 (i32) %38(i32 %13)
	;printf("LW [0x%x] (0x%x)\n", adr, val)
	%40 = icmp ne i8 %4, 0
	br i1 %40 , label %then_5, label %endif_5
then_5:
	%41 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%42 = getelementptr inbounds [32 x i32], [32 x i32]* %41, i32 0, i8 %4
	%43 = bitcast i32 %39 to i32
	store i32 %43, i32* %42
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
	%44 = icmp eq i8 %1, 4
	br i1 %44 , label %then_6, label %else_6
then_6:
	; lbu
	;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
	%45 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%46 = load %MemoryInterface*, %MemoryInterface** %45
	%47 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %46, i32 0, i32 0
	%48 = load i8 (i32)*, i8 (i32)** %47
	%49 = call i8 (i32) %48(i32 %13)
	%50 = zext i8 %49 to i32
	;printf("LBU[0x%x] (0x%x)\n", adr, val)
	%51 = icmp ne i8 %4, 0
	br i1 %51 , label %then_7, label %endif_7
then_7:
	%52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%53 = getelementptr inbounds [32 x i32], [32 x i32]* %52, i32 0, i8 %4
	%54 = bitcast i32 %50 to i32
	store i32 %54, i32* %53
	br label %endif_7
endif_7:
	br label %endif_6
else_6:
	%55 = icmp eq i8 %1, 5
	br i1 %55 , label %then_8, label %endif_8
then_8:
	; lhu
	;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
	%56 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%57 = load %MemoryInterface*, %MemoryInterface** %56
	%58 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %57, i32 0, i32 1
	%59 = load i16 (i32)*, i16 (i32)** %58
	%60 = call i16 (i32) %59(i32 %13)
	%61 = zext i16 %60 to i32
	%62 = icmp ne i8 %4, 0
	br i1 %62 , label %then_9, label %endif_9
then_9:
	%63 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%64 = getelementptr inbounds [32 x i32], [32 x i32]* %63, i32 0, i8 %4
	%65 = bitcast i32 %61 to i32
	store i32 %65, i32* %64
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_6
endif_6:
	br label %endif_4
endif_4:
	br label %endif_2
endif_2:
	br label %endif_0
endif_0:
	ret void
}

define void @do_ops(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	;let imm = expand12(imm12)
	%4 = call i8 (i32) @extract_rd(i32 %instr)
	%5 = call i8 (i32) @extract_rs1(i32 %instr)
	%6 = call i8 (i32) @extract_rs2(i32 %instr)
	%7 = call i8 (i32) @extract_funct7(i32 %instr)
	%8 = zext i8 %7 to i32
	%9 = shl i32 %8, 5
	%10 = zext i8 %4 to i32
	%11 = or i32 %9, %10
	%12 = call i32 (i32) @expand12(i32 %11)
	%13 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%14 = getelementptr inbounds [32 x i32], [32 x i32]* %13, i32 0, i8 %5
	%15 = load i32, i32* %14
	%16 = add i32 %15, %12
	%17 = bitcast i32 %16 to i32
	%18 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%19 = getelementptr inbounds [32 x i32], [32 x i32]* %18, i32 0, i8 %6
	%20 = load i32, i32* %19
	%21 = icmp eq i8 %1, 0
	br i1 %21 , label %then_0, label %else_0
then_0:
	; sb
	;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
	%22 = trunc i32 %20 to i8
	%23 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%24 = load %MemoryInterface*, %MemoryInterface** %23
	%25 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %24, i32 0, i32 3
	%26 = load void (i32, i8)*, void (i32, i8)** %25
	call void (i32, i8) %26(i32 %17, i8 %22)
	br label %endif_0
else_0:
	%27 = icmp eq i8 %1, 1
	br i1 %27 , label %then_1, label %else_1
then_1:
	; sh
	;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
	%28 = trunc i32 %20 to i16
	%29 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%30 = load %MemoryInterface*, %MemoryInterface** %29
	%31 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %30, i32 0, i32 4
	%32 = load void (i32, i16)*, void (i32, i16)** %31
	call void (i32, i16) %32(i32 %17, i16 %28)
	br label %endif_1
else_1:
	%33 = icmp eq i8 %1, 2
	br i1 %33 , label %then_2, label %endif_2
then_2:
	; sw
	;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
	%34 = bitcast i32 %20 to i32
	%35 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
	%36 = load %MemoryInterface*, %MemoryInterface** %35
	%37 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %36, i32 0, i32 5
	%38 = load void (i32, i32)*, void (i32, i32)** %37
	call void (i32, i32) %38(i32 %17, i32 %34)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define void @do_system(%Core* %core, i32 %instr) {
	%1 = call i8 (i32) @extract_funct3(i32 %instr)
	%2 = call i8 (i32) @extract_funct7(i32 %instr)
	%3 = call i32 (i32) @extract_imm12(i32 %instr)
	%4 = call i32 (i32) @expand12(i32 %3)
	%5 = call i8 (i32) @extract_rd(i32 %instr)
	%6 = call i8 (i32) @extract_rs1(i32 %instr)
	%7 = trunc i32 %3 to i16
	%8 = icmp eq i32 %instr, 115
	br i1 %8 , label %then_0, label %else_0
then_0:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str2 to [0 x i8]*))
	call void (%Core*, i32) @core_irq(%Core* %core, i32 8)
	br label %endif_0
else_0:
	%10 = icmp eq i32 %instr, 1048691
	br i1 %10 , label %then_1, label %else_1
then_1:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str3 to [0 x i8]*))
	%12 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
	store i1 1, i1* %12
	; CSR instructions
	br label %endif_1
else_1:
	%13 = icmp eq i8 %1, 1
	br i1 %13 , label %then_2, label %else_2
then_2:
	call void (%Core*, i16, i8, i8) @csr_rw(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_2
else_2:
	%14 = icmp eq i8 %1, 2
	br i1 %14 , label %then_3, label %else_3
then_3:
	call void (%Core*, i16, i8, i8) @csr_rs(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_3
else_3:
	%15 = icmp eq i8 %1, 3
	br i1 %15 , label %then_4, label %else_4
then_4:
	call void (%Core*, i16, i8, i8) @csr_rc(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_4
else_4:
	%16 = icmp eq i8 %1, 4
	br i1 %16 , label %then_5, label %else_5
then_5:
	call void (%Core*, i16, i8, i8) @csr_rwi(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_5
else_5:
	%17 = icmp eq i8 %1, 5
	br i1 %17 , label %then_6, label %else_6
then_6:
	call void (%Core*, i16, i8, i8) @csr_rsi(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_6
else_6:
	%18 = icmp eq i8 %1, 6
	br i1 %18 , label %then_7, label %else_7
then_7:
	call void (%Core*, i16, i8, i8) @csr_rci(%Core* %core, i16 %7, i8 %5, i8 %6)
	br label %endif_7
else_7:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str4 to [0 x i8]*), i32 %instr)
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), i8 %1)
	%21 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
	store i1 1, i1* %21
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
	br label %endif_0
endif_0:
	ret void
}

define void @do_fence(%Core* %core, i32 %instr) {
	%1 = icmp eq i32 %instr, 16777231
	br i1 %1 , label %then_0, label %endif_0
then_0:
	;printf("PAUSE\n")
	br label %endif_0
endif_0:
	ret void
}


