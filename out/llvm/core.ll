
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




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
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
	i32,
	i32
}














; -- SOURCE: src/core.cm

@str1 = private constant [17 x i8] [i8 70, i8 65, i8 84, i8 65, i8 76, i8 58, i8 32, i8 120, i8 48, i8 32, i8 33, i8 61, i8 32, i8 48, i8 33, i8 10, i8 0]
@str2 = private constant [7 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 10, i8 0]
@str3 = private constant [8 x i8] [i8 69, i8 66, i8 82, i8 69, i8 65, i8 75, i8 10, i8 0]
@str4 = private constant [34 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str5 = private constant [13 x i8] [i8 102, i8 117, i8 110, i8 99, i8 116, i8 51, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl) {
    ;memset(core, 0, sizeof(Core))
    store %Core zeroinitializer, %Core* %core
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    store %MemoryInterface* %memctl, %MemoryInterface** %1
    %2 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %2
    ret void
}

define void @core_irq(%Core* %core, i32 %irq) {
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %2 = load i32, i32* %1
    %3 = icmp eq i32 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
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

define void @i_type_op(%Core* %core, i32 %instr) {
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

define void @r_type_op(%Core* %core, i32 %instr) {
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

define void @riscv_csr_rw(%Core* %core, i16 %csr, i8 %rd, i8 %rs1) {
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %2 = getelementptr inbounds [32 x i32], [32 x i32]* %1, i32 0, i8 %rs1
    %3 = load i32, i32* %2
    %4 = icmp eq i16 %csr, 832
    br i1 %4 , label %then_0, label %else_0
then_0:
    ; mscratch
    br label %endif_0
else_0:
    %5 = icmp eq i16 %csr, 833
    br i1 %5 , label %then_1, label %else_1
then_1:
    ; mepc
    br label %endif_1
else_1:
    %6 = icmp eq i16 %csr, 834
    br i1 %6 , label %then_2, label %else_2
then_2:
    ; mcause
    br label %endif_2
else_2:
    %7 = icmp eq i16 %csr, 835
    br i1 %7 , label %then_3, label %else_3
then_3:
    ; mbadaddr
    br label %endif_3
else_3:
    %8 = icmp eq i16 %csr, 836
    br i1 %8 , label %then_4, label %endif_4
then_4:
    ; mip (machine interrupt pending)
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

define void @riscv_csr_rs(%Core* %core, i8 %csr, i8 %rd, i8 %rs1) {
    ret void
}

define void @riscv_csr_rc(%Core* %core, i8 %csr, i8 %rd, i8 %rs1) {
    ret void
}

define i1 @core_tick(%Core* %core) {
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %2 = load i32, i32* %1
    %3 = icmp ugt i32 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    ;printf("\nINT #%02X\n", core.interrupt)
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %5 = load i32, i32* %4
    %6 = mul i32 %5, 4
    %7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %6, i32* %7
    %8 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
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
    %16 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %17 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
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
    ;printf("X8 = %x\n", core.reg[8]);
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;    //printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %25 = call i8 (i32) @extract_op(i32 %15)
    %26 = call i8 (i32) @extract_rd(i32 %15)
    %27 = call i8 (i32) @extract_rs1(i32 %15)
    %28 = call i8 (i32) @extract_rs2(i32 %15)
    %29 = call i8 (i32) @extract_funct3(i32 %15)
    br i1 0 , label %then_2, label %endif_2
then_2:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_2
endif_2:
    %30 = icmp eq i8 %25, 19
    br i1 %30 , label %then_3, label %else_3
then_3:
    call void (%Core*, i32) @i_type_op(%Core* %core, i32 %15)
    br label %endif_3
else_3:
    %31 = icmp eq i8 %25, 51
    br i1 %31 , label %then_4, label %else_4
then_4:
    call void (%Core*, i32) @r_type_op(%Core* %core, i32 %15)
    br label %endif_4
else_4:
    %32 = icmp eq i8 %25, 55
    br i1 %32 , label %then_5, label %else_5
then_5:
    ; U-type
    %33 = call i32 (i32) @extract_imm31_12(i32 %15)
    %34 = call i32 (i32) @expand12(i32 %33)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %35 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %36 = getelementptr inbounds [32 x i32], [32 x i32]* %35, i32 0, i8 %26
    %37 = shl i32 %34, 12
    store i32 %37, i32* %36
    br label %endif_5
else_5:
    %38 = icmp eq i8 %25, 23
    br i1 %38 , label %then_6, label %else_6
then_6:
    ; U-type
    %39 = call i32 (i32) @extract_imm31_12(i32 %15)
    %40 = call i32 (i32) @expand12(i32 %39)
    %41 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %42 = load i32, i32* %41
    %43 = bitcast i32 %42 to i32
    %44 = shl i32 %40, 12
    %45 = add i32 %43, %44
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %26
    store i32 %45, i32* %47
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_6
else_6:
    %48 = icmp eq i8 %25, 111
    br i1 %48 , label %then_7, label %else_7
then_7:
    ; U-type
    %49 = call i32 (i32) @extract_jal_imm(i32 %15)
    %50 = call i32 (i32) @expand20(i32 %49)
    ;printf("jal x%d, %d\n", rd, imm)
    %51 = icmp ne i8 %26, 0
    br i1 %51 , label %then_8, label %endif_8
then_8:
    %52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %53 = getelementptr inbounds [32 x i32], [32 x i32]* %52, i32 0, i8 %26
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %55 = load i32, i32* %54
    %56 = add i32 %55, 4
    %57 = bitcast i32 %56 to i32
    store i32 %57, i32* %53
    br label %endif_8
endif_8:
    %58 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %60 = load i32, i32* %59
    %61 = bitcast i32 %60 to i32
    %62 = add i32 %61, %50
    %63 = bitcast i32 %62 to i32
    store i32 %63, i32* %58
    %64 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %64
    br label %endif_7
else_7:
    %65 = icmp eq i8 %25, 103
    %66 = icmp eq i8 %29, 0
    %67 = and i1 %65, %66
    br i1 %67 , label %then_9, label %else_9
then_9:
    %68 = call i32 (i32) @extract_imm12(i32 %15)
    %69 = call i32 (i32) @expand12(i32 %68)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %70 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %71 = load i32, i32* %70
    %72 = add i32 %71, 4
    %73 = bitcast i32 %72 to i32
    %74 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %75 = getelementptr inbounds [32 x i32], [32 x i32]* %74, i32 0, i8 %27
    %76 = load i32, i32* %75
    %77 = add i32 %76, %69
    %78 = bitcast i32 %77 to i32
    %79 = and i32 %78, 4294967294
    %80 = icmp ne i8 %26, 0
    br i1 %80 , label %then_10, label %endif_10
then_10:
    %81 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %82 = getelementptr inbounds [32 x i32], [32 x i32]* %81, i32 0, i8 %26
    store i32 %73, i32* %82
    br label %endif_10
endif_10:
    %83 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %79, i32* %83
    %84 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %84
    br label %endif_9
else_9:
    %85 = icmp eq i8 %25, 99
    br i1 %85 , label %then_11, label %else_11
then_11:
    %86 = call i8 (i32) @extract_funct7(i32 %15)
    %87 = call i8 (i32) @extract_rd(i32 %15)
    %88 = and i8 %87, 30
    %89 = zext i8 %88 to i16
    %90 = and i8 %86, 63
    %91 = zext i8 %90 to i16
    %92 = shl i16 %91, 5
    %93 = and i8 %87, 1
    %94 = zext i8 %93 to i16
    %95 = shl i16 %94, 11
    %96 = and i8 %86, 64
    %97 = zext i8 %96 to i16
    %98 = shl i16 %97, 6
    %99 = alloca i16
    %100 = or i16 %92, %89
    %101 = or i16 %95, %100
    %102 = or i16 %98, %101
    store i16 %102, i16* %99
    ; распространяем знак, если он есть
    %103 = load i16, i16* %99
    %104 = and i16 %103, 4096
    %105 = icmp ne i16 %104, 0
    br i1 %105 , label %then_12, label %endif_12
then_12:
    %106 = load i16, i16* %99
    %107 = or i16 61440, %106
    store i16 %107, i16* %99
    br label %endif_12
endif_12:
    %108 = load i16, i16* %99
    %109 = bitcast i16 %108 to i16
    %110 = icmp eq i8 %29, 0
    br i1 %110 , label %then_13, label %else_13
then_13:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %111 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %112 = getelementptr inbounds [32 x i32], [32 x i32]* %111, i32 0, i8 %27
    %113 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %114 = getelementptr inbounds [32 x i32], [32 x i32]* %113, i32 0, i8 %28
    %115 = load i32, i32* %112
    %116 = load i32, i32* %114
    %117 = icmp eq i32 %115, %116
    br i1 %117 , label %then_14, label %endif_14
then_14:
    %118 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %119 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %120 = load i32, i32* %119
    %121 = bitcast i32 %120 to i32
    %122 = sext i16 %109 to i32
    %123 = add i32 %121, %122
    %124 = bitcast i32 %123 to i32
    store i32 %124, i32* %118
    %125 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %125
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %126 = icmp eq i8 %29, 1
    br i1 %126 , label %then_15, label %else_15
then_15:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %127 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %128 = getelementptr inbounds [32 x i32], [32 x i32]* %127, i32 0, i8 %27
    %129 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %130 = getelementptr inbounds [32 x i32], [32 x i32]* %129, i32 0, i8 %28
    %131 = load i32, i32* %128
    %132 = load i32, i32* %130
    %133 = icmp ne i32 %131, %132
    br i1 %133 , label %then_16, label %endif_16
then_16:
    %134 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %135 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %136 = load i32, i32* %135
    %137 = bitcast i32 %136 to i32
    %138 = sext i16 %109 to i32
    %139 = add i32 %137, %138
    %140 = bitcast i32 %139 to i32
    store i32 %140, i32* %134
    %141 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %141
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %142 = icmp eq i8 %29, 4
    br i1 %142 , label %then_17, label %else_17
then_17:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %143 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %144 = getelementptr inbounds [32 x i32], [32 x i32]* %143, i32 0, i8 %27
    %145 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %146 = getelementptr inbounds [32 x i32], [32 x i32]* %145, i32 0, i8 %28
    %147 = load i32, i32* %144
    %148 = load i32, i32* %146
    %149 = icmp slt i32 %147, %148
    br i1 %149 , label %then_18, label %endif_18
then_18:
    %150 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %151 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %152 = load i32, i32* %151
    %153 = bitcast i32 %152 to i32
    %154 = sext i16 %109 to i32
    %155 = add i32 %153, %154
    %156 = bitcast i32 %155 to i32
    store i32 %156, i32* %150
    %157 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %157
    br label %endif_18
endif_18:
    br label %endif_17
else_17:
    %158 = icmp eq i8 %29, 5
    br i1 %158 , label %then_19, label %else_19
then_19:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %159 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %160 = getelementptr inbounds [32 x i32], [32 x i32]* %159, i32 0, i8 %27
    %161 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %162 = getelementptr inbounds [32 x i32], [32 x i32]* %161, i32 0, i8 %28
    %163 = load i32, i32* %160
    %164 = load i32, i32* %162
    %165 = icmp sge i32 %163, %164
    br i1 %165 , label %then_20, label %endif_20
then_20:
    %166 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %167 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %168 = load i32, i32* %167
    %169 = bitcast i32 %168 to i32
    %170 = sext i16 %109 to i32
    %171 = add i32 %169, %170
    %172 = bitcast i32 %171 to i32
    store i32 %172, i32* %166
    %173 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %173
    br label %endif_20
endif_20:
    br label %endif_19
else_19:
    %174 = icmp eq i8 %29, 6
    br i1 %174 , label %then_21, label %else_21
then_21:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %175 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %176 = getelementptr inbounds [32 x i32], [32 x i32]* %175, i32 0, i8 %27
    %177 = load i32, i32* %176
    %178 = bitcast i32 %177 to i32
    %179 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %180 = getelementptr inbounds [32 x i32], [32 x i32]* %179, i32 0, i8 %28
    %181 = load i32, i32* %180
    %182 = bitcast i32 %181 to i32
    %183 = icmp ult i32 %178, %182
    br i1 %183 , label %then_22, label %endif_22
then_22:
    %184 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %185 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %186 = load i32, i32* %185
    %187 = bitcast i32 %186 to i32
    %188 = sext i16 %109 to i32
    %189 = add i32 %187, %188
    %190 = bitcast i32 %189 to i32
    store i32 %190, i32* %184
    %191 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %191
    br label %endif_22
endif_22:
    br label %endif_21
else_21:
    %192 = icmp eq i8 %29, 7
    br i1 %192 , label %then_23, label %endif_23
then_23:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %193 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %194 = getelementptr inbounds [32 x i32], [32 x i32]* %193, i32 0, i8 %27
    %195 = load i32, i32* %194
    %196 = bitcast i32 %195 to i32
    %197 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %198 = getelementptr inbounds [32 x i32], [32 x i32]* %197, i32 0, i8 %28
    %199 = load i32, i32* %198
    %200 = bitcast i32 %199 to i32
    %201 = icmp uge i32 %196, %200
    br i1 %201 , label %then_24, label %else_24
then_24:
    %202 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %203 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %204 = load i32, i32* %203
    %205 = bitcast i32 %204 to i32
    %206 = sext i16 %109 to i32
    %207 = add i32 %205, %206
    %208 = bitcast i32 %207 to i32
    store i32 %208, i32* %202
    %209 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %209
    br label %endif_24
else_24:
    br label %endif_24
endif_24:
    br label %endif_23
endif_23:
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
else_11:
    %210 = icmp eq i8 %25, 3
    br i1 %210 , label %then_25, label %else_25
then_25:
    %211 = call i32 (i32) @extract_imm12(i32 %15)
    %212 = call i32 (i32) @expand12(i32 %211)
    %213 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %214 = getelementptr inbounds [32 x i32], [32 x i32]* %213, i32 0, i8 %27
    %215 = load i32, i32* %214
    %216 = add i32 %215, %212
    %217 = bitcast i32 %216 to i32
    %218 = icmp eq i8 %29, 0
    br i1 %218 , label %then_26, label %else_26
then_26:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %219 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %220 = load %MemoryInterface*, %MemoryInterface** %219
    %221 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %220, i32 0, i32 0
    %222 = load i8 (i32)*, i8 (i32)** %221
    %223 = call i8 (i32) %222(i32 %217)
    %224 = sext i8 %223 to i32
    %225 = icmp ne i8 %26, 0
    br i1 %225 , label %then_27, label %endif_27
then_27:
    %226 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %227 = getelementptr inbounds [32 x i32], [32 x i32]* %226, i32 0, i8 %26
    store i32 %224, i32* %227
    br label %endif_27
endif_27:
    br label %endif_26
else_26:
    %228 = icmp eq i8 %29, 1
    br i1 %228 , label %then_28, label %else_28
then_28:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %229 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %230 = load %MemoryInterface*, %MemoryInterface** %229
    %231 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %230, i32 0, i32 1
    %232 = load i16 (i32)*, i16 (i32)** %231
    %233 = call i16 (i32) %232(i32 %217)
    %234 = sext i16 %233 to i32
    %235 = icmp ne i8 %26, 0
    br i1 %235 , label %then_29, label %endif_29
then_29:
    %236 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %237 = getelementptr inbounds [32 x i32], [32 x i32]* %236, i32 0, i8 %26
    store i32 %234, i32* %237
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %238 = icmp eq i8 %29, 2
    br i1 %238 , label %then_30, label %else_30
then_30:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %239 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %240 = load %MemoryInterface*, %MemoryInterface** %239
    %241 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %240, i32 0, i32 2
    %242 = load i32 (i32)*, i32 (i32)** %241
    %243 = call i32 (i32) %242(i32 %217)
    %244 = bitcast i32 %243 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %245 = icmp ne i8 %26, 0
    br i1 %245 , label %then_31, label %endif_31
then_31:
    %246 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %247 = getelementptr inbounds [32 x i32], [32 x i32]* %246, i32 0, i8 %26
    store i32 %244, i32* %247
    br label %endif_31
endif_31:
    br label %endif_30
else_30:
    %248 = icmp eq i8 %29, 4
    br i1 %248 , label %then_32, label %else_32
then_32:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %249 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %250 = load %MemoryInterface*, %MemoryInterface** %249
    %251 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %250, i32 0, i32 0
    %252 = load i8 (i32)*, i8 (i32)** %251
    %253 = call i8 (i32) %252(i32 %217)
    %254 = zext i8 %253 to i32
    %255 = bitcast i32 %254 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %256 = icmp ne i8 %26, 0
    br i1 %256 , label %then_33, label %endif_33
then_33:
    %257 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %258 = getelementptr inbounds [32 x i32], [32 x i32]* %257, i32 0, i8 %26
    store i32 %255, i32* %258
    br label %endif_33
endif_33:
    br label %endif_32
else_32:
    %259 = icmp eq i8 %29, 5
    br i1 %259 , label %then_34, label %endif_34
then_34:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %260 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %261 = load %MemoryInterface*, %MemoryInterface** %260
    %262 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %261, i32 0, i32 1
    %263 = load i16 (i32)*, i16 (i32)** %262
    %264 = call i16 (i32) %263(i32 %217)
    %265 = zext i16 %264 to i32
    %266 = bitcast i32 %265 to i32
    %267 = icmp ne i8 %26, 0
    br i1 %267 , label %then_35, label %endif_35
then_35:
    %268 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %269 = getelementptr inbounds [32 x i32], [32 x i32]* %268, i32 0, i8 %26
    store i32 %266, i32* %269
    br label %endif_35
endif_35:
    br label %endif_34
endif_34:
    br label %endif_32
endif_32:
    br label %endif_30
endif_30:
    br label %endif_28
endif_28:
    br label %endif_26
endif_26:
    br label %endif_25
else_25:
    %270 = icmp eq i8 %25, 35
    br i1 %270 , label %then_36, label %else_36
then_36:
    %271 = call i8 (i32) @extract_funct7(i32 %15)
    %272 = zext i8 %271 to i32
    %273 = shl i32 %272, 5
    %274 = zext i8 %26 to i32
    %275 = or i32 %273, %274
    %276 = call i32 (i32) @expand12(i32 %275)
    %277 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %278 = getelementptr inbounds [32 x i32], [32 x i32]* %277, i32 0, i8 %27
    %279 = load i32, i32* %278
    %280 = add i32 %279, %276
    %281 = bitcast i32 %280 to i32
    %282 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %283 = getelementptr inbounds [32 x i32], [32 x i32]* %282, i32 0, i8 %28
    %284 = load i32, i32* %283
    %285 = icmp eq i8 %29, 0
    br i1 %285 , label %then_37, label %else_37
then_37:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %286 = trunc i32 %284 to i8
    %287 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %288 = load %MemoryInterface*, %MemoryInterface** %287
    %289 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %288, i32 0, i32 3
    %290 = load void (i32, i8)*, void (i32, i8)** %289
    call void (i32, i8) %290(i32 %281, i8 %286)
    br label %endif_37
else_37:
    %291 = icmp eq i8 %29, 1
    br i1 %291 , label %then_38, label %else_38
then_38:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %292 = trunc i32 %284 to i16
    %293 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %294 = load %MemoryInterface*, %MemoryInterface** %293
    %295 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %294, i32 0, i32 4
    %296 = load void (i32, i16)*, void (i32, i16)** %295
    call void (i32, i16) %296(i32 %281, i16 %292)
    br label %endif_38
else_38:
    %297 = icmp eq i8 %29, 2
    br i1 %297 , label %then_39, label %endif_39
then_39:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %298 = bitcast i32 %284 to i32
    %299 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 2
    %300 = load %MemoryInterface*, %MemoryInterface** %299
    %301 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %300, i32 0, i32 5
    %302 = load void (i32, i32)*, void (i32, i32)** %301
    call void (i32, i32) %302(i32 %281, i32 %298)
    br label %endif_39
endif_39:
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
else_36:
    %303 = icmp eq i8 %25, 115
    br i1 %303 , label %then_40, label %else_40
then_40:
    %304 = icmp eq i32 %15, 115
    br i1 %304 , label %then_41, label %else_41
then_41:
    %305 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str2 to [0 x i8]*))
    call void (%Core*, i32) @core_irq(%Core* %core, i32 8)
    br label %endif_41
else_41:
    %306 = icmp eq i32 %15, 1048691
    br i1 %306 , label %then_42, label %else_42
then_42:
    %307 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str3 to [0 x i8]*))
    ret i1 0
    ; CSR instructions
    br label %endif_42
else_42:
    %309 = icmp eq i8 %29, 1
    br i1 %309 , label %then_43, label %else_43
then_43:
    ;riscv_csr_rw(core, csr, rd, rs1)
    br label %endif_43
else_43:
    %310 = icmp eq i8 %29, 2
    br i1 %310 , label %then_44, label %else_44
then_44:
    ;riscv_csr_rs(core, csr, rd, rs1)
    br label %endif_44
else_44:
    %311 = icmp eq i8 %29, 3
    br i1 %311 , label %then_45, label %else_45
then_45:
    ;riscv_csr_rc(core, csr, rd, rs1)
    br label %endif_45
else_45:
    %312 = icmp eq i8 %29, 4
    br i1 %312 , label %then_46, label %else_46
then_46:
    br label %endif_46
else_46:
    %313 = icmp eq i8 %29, 5
    br i1 %313 , label %then_47, label %else_47
then_47:
    br label %endif_47
else_47:
    %314 = icmp eq i8 %29, 6
    br i1 %314 , label %then_48, label %else_48
then_48:
    br label %endif_48
else_48:
    %315 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str4 to [0 x i8]*), i32 %15)
    %316 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str5 to [0 x i8]*), i8 %29)
    ret i1 0
    br label %endif_48
endif_48:
    br label %endif_47
endif_47:
    br label %endif_46
endif_46:
    br label %endif_45
endif_45:
    br label %endif_44
endif_44:
    br label %endif_43
endif_43:
    br label %endif_42
endif_42:
    br label %endif_41
endif_41:
    br label %endif_40
else_40:
    %318 = icmp eq i8 %25, 15
    br i1 %318 , label %then_49, label %else_49
then_49:
    %319 = icmp eq i32 %15, 16777231
    br i1 %319 , label %then_50, label %endif_50
then_50:
    ;printf("PAUSE\n")
    br label %endif_50
endif_50:
    br label %endif_49
else_49:
    ;printf("UNKNOWN OPCODE: %08X\n", op)
    br label %endif_49
endif_49:
    br label %endif_40
endif_40:
    br label %endif_36
endif_36:
    br label %endif_25
endif_25:
    br label %endif_11
endif_11:
    br label %endif_9
endif_9:
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
    %320 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %321 = load i1, i1* %320
    br i1 %321 , label %then_51, label %else_51
then_51:
    %322 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %323 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %324 = load i32, i32* %323
    %325 = add i32 %324, 4
    store i32 %325, i32* %322
    br label %endif_51
else_51:
    %326 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %326
    br label %endif_51
endif_51:
    ret i1 1
}


