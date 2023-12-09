
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
	i32,
	%MemoryInterface*
}













; -- SOURCE: src/core.cm

@str1 = private constant [12 x i8] [i8 10, i8 73, i8 78, i8 84, i8 32, i8 35, i8 37, i8 48, i8 50, i8 88, i8 10, i8 0]
@str2 = private constant [14 x i8] [i8 82, i8 85, i8 78, i8 32, i8 70, i8 82, i8 79, i8 77, i8 58, i8 32, i8 37, i8 120, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl) {
    %1 = bitcast %Core* %core to i8*
    %2 = call i8*(i8*, i32, i64) @memset (i8* %1, i32 0, i64 152)
    %3 = bitcast %MemoryInterface* %memctl to %MemoryInterface*
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    store %MemoryInterface* %3, %MemoryInterface** %4
    %5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %5
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

define i32 @expand12(i16 %val12bit) {
    %1 = zext i16 %val12bit to i32
    %v = alloca i32
    store i32 %1, i32* %v
    %2 = load i32, i32* %v
    %3 = and i32 %2, 2048
    %4 = icmp ne i32 %3, 0
    br i1 %4 , label %then_0, label %endif_0
then_0:
    %5 = load i32, i32* %v
    %6 = or i32 %5, 4294963200
    store i32 %6, i32* %v
    br label %endif_0
endif_0:
    %7 = load i32, i32* %v
    %8 = bitcast i32 %7 to i32
    ret i32 %8
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
    %4 = load i16, i16* %imm
    %5 = call i32(i16) @expand12 (i16 %4)
    ret i32 %5
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

define i32 @extract_jal_imm(i32 %instr) {
    %1 = call i32(i32) @extract_imm31_12 (i32 %instr)
    %2 = bitcast i32 %1 to i32
    %3 = lshr i32 %2, 0
    %4 = and i32 %3, 255
    %5 = shl i32 %4, 12
    %6 = lshr i32 %2, 8
    %7 = and i32 %6, 1
    %8 = shl i32 %7, 11
    %9 = lshr i32 %2, 9
    %10 = and i32 %9, 1023
    %11 = shl i32 %10, 1
    %12 = lshr i32 %2, 20
    %13 = and i32 %12, 1
    %14 = shl i32 %13, 20
    %15 = or i32 %8, %11
    %16 = or i32 %5, %15
    %17 = or i32 %14, %16
    ret i32 %17
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
    ;printf("addi x%d, x%d, %d\n", rd, rs1, imm)
    %9 = icmp ne i8 %4, 0
    br i1 %9 , label %then_2, label %endif_2
then_2:
    %10 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %11 = getelementptr inbounds [32 x i32], [32 x i32]* %10, i32 0, i8 %5
    %12 = load i32, i32* %11
    %13 = add i32 %12, %3
    %14 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %15 = getelementptr inbounds [32 x i32], [32 x i32]* %14, i32 0, i8 %4
    store i32 %13, i32* %15
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    %16 = icmp eq i8 %1, 1
    %17 = icmp eq i8 %2, 0
    %18 = and i1 %16, %17
    br i1 %18 , label %then_3, label %else_3
then_3:

    ;printf("slli x%d, x%d, %d\n", rd, rs1, imm)
    %19 = icmp ne i8 %4, 0
    br i1 %19 , label %then_4, label %endif_4
then_4:
    %20 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %21 = getelementptr inbounds [32 x i32], [32 x i32]* %20, i32 0, i8 %5
    %22 = load i32, i32* %21
    %23 = bitcast i32 %22 to i32
    %24 = shl i32 %23, %3
    %25 = bitcast i32 %24 to i32
    %26 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %27 = getelementptr inbounds [32 x i32], [32 x i32]* %26, i32 0, i8 %4
    store i32 %25, i32* %27
    br label %endif_4
endif_4:
    br label %endif_3
else_3:
    %28 = icmp eq i8 %1, 2
    br i1 %28 , label %then_5, label %else_5
then_5:
    ; SLTI - set [1 to rd if rs1] less than immediate
    ;printf("slti x%d, x%d, %d\n", rd, rs1, imm)
    %29 = icmp ne i8 %4, 0
    br i1 %29 , label %then_6, label %endif_6
then_6:
    %30 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %31 = getelementptr inbounds [32 x i32], [32 x i32]* %30, i32 0, i8 %5
    %32 = load i32, i32* %31
    %33 = icmp slt i32 %32, %3
    %34 = sext i1 %33 to i32
    %35 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %36 = getelementptr inbounds [32 x i32], [32 x i32]* %35, i32 0, i8 %4
    store i32 %34, i32* %36
    br label %endif_6
endif_6:
    br label %endif_5
else_5:
    %37 = icmp eq i8 %1, 3
    br i1 %37 , label %then_7, label %else_7
then_7:
    ;printf("sltiu x%d, x%d, %d\n", rd, rs1, imm)
    %38 = icmp ne i8 %4, 0
    br i1 %38 , label %then_8, label %endif_8
then_8:
    %39 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %40 = getelementptr inbounds [32 x i32], [32 x i32]* %39, i32 0, i8 %5
    %41 = load i32, i32* %40
    %42 = bitcast i32 %41 to i32
    %43 = bitcast i32 %3 to i32
    %44 = icmp ult i32 %42, %43
    %45 = sext i1 %44 to i32
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %4
    store i32 %45, i32* %47
    br label %endif_8
endif_8:
    br label %endif_7
else_7:
    %48 = icmp eq i8 %1, 4
    br i1 %48 , label %then_9, label %else_9
then_9:
    ;printf("xori x%d, x%d, %d\n", rd, rs1, imm)
    %49 = icmp ne i8 %4, 0
    br i1 %49 , label %then_10, label %endif_10
then_10:
    %50 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %51 = getelementptr inbounds [32 x i32], [32 x i32]* %50, i32 0, i8 %5
    %52 = load i32, i32* %51
    %53 = xor i32 %52, %3
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %55 = getelementptr inbounds [32 x i32], [32 x i32]* %54, i32 0, i8 %4
    store i32 %53, i32* %55
    br label %endif_10
endif_10:
    br label %endif_9
else_9:
    %56 = icmp eq i8 %1, 5
    %57 = icmp eq i8 %2, 0
    %58 = and i1 %56, %57
    br i1 %58 , label %then_11, label %else_11
then_11:
    ;printf("srli x%d, x%d, %d\n", rd, rs1, imm)
    %59 = icmp ne i8 %4, 0
    br i1 %59 , label %then_12, label %endif_12
then_12:
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %61 = getelementptr inbounds [32 x i32], [32 x i32]* %60, i32 0, i8 %5
    %62 = load i32, i32* %61
    %63 = bitcast i32 %62 to i32
    %64 = lshr i32 %63, %3
    %65 = bitcast i32 %64 to i32
    %66 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %67 = getelementptr inbounds [32 x i32], [32 x i32]* %66, i32 0, i8 %4
    store i32 %65, i32* %67
    br label %endif_12
endif_12:
    br label %endif_11
else_11:
    %68 = icmp eq i8 %1, 5
    %69 = icmp eq i8 %2, 32
    %70 = and i1 %68, %69
    br i1 %70 , label %then_13, label %else_13
then_13:
    ;printf("srai x%d, x%d, %d\n", rd, rs1, imm)
    %71 = icmp ne i8 %4, 0
    br i1 %71 , label %then_14, label %endif_14
then_14:
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %5
    %74 = load i32, i32* %73
    %75 = ashr i32 %74, %3
    %76 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %77 = getelementptr inbounds [32 x i32], [32 x i32]* %76, i32 0, i8 %4
    store i32 %75, i32* %77
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %78 = icmp eq i8 %1, 6
    br i1 %78 , label %then_15, label %else_15
then_15:
    ;printf("ori x%d, x%d, %d\n", rd, rs1, imm)
    %79 = icmp ne i8 %4, 0
    br i1 %79 , label %then_16, label %endif_16
then_16:
    %80 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %81 = getelementptr inbounds [32 x i32], [32 x i32]* %80, i32 0, i8 %5
    %82 = load i32, i32* %81
    %83 = or i32 %82, %3
    %84 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %85 = getelementptr inbounds [32 x i32], [32 x i32]* %84, i32 0, i8 %4
    store i32 %83, i32* %85
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %86 = icmp eq i8 %1, 7
    br i1 %86 , label %then_17, label %endif_17
then_17:
    ;printf("andi x%d, x%d, %d\n", rd, rs1, imm)
    %87 = icmp ne i8 %4, 0
    br i1 %87 , label %then_18, label %endif_18
then_18:
    %88 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %89 = getelementptr inbounds [32 x i32], [32 x i32]* %88, i32 0, i8 %5
    %90 = load i32, i32* %89
    %91 = and i32 %90, %3
    %92 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %93 = getelementptr inbounds [32 x i32], [32 x i32]* %92, i32 0, i8 %4
    store i32 %91, i32* %93
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
    ;printf("add x%d, x%d, x%d\n", rd, rs1, rs2)
    %18 = add i32 %11, %14
    %19 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %20 = getelementptr inbounds [32 x i32], [32 x i32]* %19, i32 0, i8 %4
    store i32 %18, i32* %20
    br label %endif_1
else_1:
    %21 = icmp eq i8 %1, 0
    %22 = icmp eq i8 %2, 32
    %23 = and i1 %21, %22
    br i1 %23 , label %then_2, label %else_2
then_2:
    ;printf("sub x%d, x%d, x%d\n", rd, rs1, rs2)
    %24 = sub i32 %11, %14
    %25 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %26 = getelementptr inbounds [32 x i32], [32 x i32]* %25, i32 0, i8 %4
    store i32 %24, i32* %26
    br label %endif_2
else_2:
    %27 = icmp eq i8 %1, 1
    br i1 %27 , label %then_3, label %else_3
then_3:
    ; shift left logical
    ;printf("sll x%d, x%d, x%d\n", rd, rs1, rs2)
    %28 = shl i32 %11, %14
    %29 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %30 = getelementptr inbounds [32 x i32], [32 x i32]* %29, i32 0, i8 %4
    store i32 %28, i32* %30
    br label %endif_3
else_3:
    %31 = icmp eq i8 %1, 2
    br i1 %31 , label %then_4, label %else_4
then_4:
    ; set less than
    ;printf("slt x%d, x%d, x%d\n", rd, rs1, rs2)
    %32 = icmp slt i32 %11, %14
    %33 = sext i1 %32 to i32
    %34 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %35 = getelementptr inbounds [32 x i32], [32 x i32]* %34, i32 0, i8 %4
    store i32 %33, i32* %35
    br label %endif_4
else_4:
    %36 = icmp eq i8 %1, 3
    br i1 %36 , label %then_5, label %else_5
then_5:
    ; set less than unsigned
    ;printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2)
    %37 = bitcast i32 %11 to i32
    %38 = bitcast i32 %14 to i32
    %39 = icmp ult i32 %37, %38
    %40 = sext i1 %39 to i32
    %41 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %42 = getelementptr inbounds [32 x i32], [32 x i32]* %41, i32 0, i8 %4
    store i32 %40, i32* %42
    br label %endif_5
else_5:
    %43 = icmp eq i8 %1, 4
    br i1 %43 , label %then_6, label %else_6
then_6:
    ;printf("xor x%d, x%d, x%d\n", rd, rs1, rs2)
    %44 = xor i32 %11, %14
    %45 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %46 = getelementptr inbounds [32 x i32], [32 x i32]* %45, i32 0, i8 %4
    store i32 %44, i32* %46
    br label %endif_6
else_6:
    %47 = icmp eq i8 %1, 5
    %48 = icmp eq i8 %2, 0
    %49 = and i1 %47, %48
    br i1 %49 , label %then_7, label %else_7
then_7:
    ; shift right logical
    ;printf("srl x%d, x%d, x%d\n", rd, rs1, rs2)
    %50 = bitcast i32 %11 to i32
    %51 = lshr i32 %50, %14
    %52 = bitcast i32 %51 to i32
    %53 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %54 = getelementptr inbounds [32 x i32], [32 x i32]* %53, i32 0, i8 %4
    store i32 %52, i32* %54
    br label %endif_7
else_7:
    %55 = icmp eq i8 %1, 5
    %56 = icmp eq i8 %2, 32
    %57 = and i1 %55, %56
    br i1 %57 , label %then_8, label %else_8
then_8:
    ; shift right arithmetical
    ;printf("sra x%d, x%d, x%d\n", rd, rs1, rs2)
    %58 = ashr i32 %11, %14
    %59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %60 = getelementptr inbounds [32 x i32], [32 x i32]* %59, i32 0, i8 %4
    store i32 %58, i32* %60
    br label %endif_8
else_8:
    %61 = icmp eq i8 %1, 6
    br i1 %61 , label %then_9, label %else_9
then_9:
    ;printf("or x%d, x%d, x%d\n", rd, rs1, rs2)
    %62 = or i32 %11, %14
    %63 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %64 = getelementptr inbounds [32 x i32], [32 x i32]* %63, i32 0, i8 %4
    store i32 %62, i32* %64
    br label %endif_9
else_9:
    %65 = icmp eq i8 %1, 7
    br i1 %65 , label %then_10, label %endif_10
then_10:
    ;printf("and x%d, x%d, x%d\n", rd, rs1, rs2)
    %66 = and i32 %11, %14
    %67 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %68 = getelementptr inbounds [32 x i32], [32 x i32]* %67, i32 0, i8 %4
    store i32 %66, i32* %68
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

define i32 @fetch(%Core* %core) {
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %4 = load %MemoryInterface*, %MemoryInterface** %3
    %5 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %4, i32 0, i32 2
    %6 = load i32(i32)*, i32(i32)** %5
    %7 = call i32(i32) %6 (i32 %2)
    ret i32 %7
}

define i1 @core_tick(%Core* %core) {
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %2 = load i32, i32* %1
    %3 = icmp ugt i32 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %5 = load i32, i32* %4
    %6 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*), i32 %5)
    %7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %8 = load i32, i32* %7
    %9 = mul i32 %8, 4
    %10 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*), i32 %9)
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %9, i32* %11
    %12 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i32 0, i32* %12
    br label %endif_0
endif_0:
    %13 = bitcast %Core* %core to %Core*
    %14 = call i32(%Core*) @fetch (%Core* %13)
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %15 = call i8(i32) @extract_op (i32 %14)
    %16 = call i8(i32) @extract_rd (i32 %14)
    %17 = call i8(i32) @extract_rs1 (i32 %14)
    %18 = call i8(i32) @extract_rs2 (i32 %14)
    %19 = call i8(i32) @extract_funct3 (i32 %14)
    br i1 0 , label %then_1, label %endif_1
then_1:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_1
endif_1:
    %20 = icmp eq i8 %15, 19
    br i1 %20 , label %then_2, label %else_2
then_2:
    %21 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %21, i32 %14)
    br label %endif_2
else_2:
    %22 = icmp eq i8 %15, 51
    br i1 %22 , label %then_3, label %else_3
then_3:
    %23 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %23, i32 %14)
    br label %endif_3
else_3:
    %24 = icmp eq i8 %15, 55
    br i1 %24 , label %then_4, label %else_4
then_4:
    ; U-type
    %25 = call i32(i32) @extract_imm31_12 (i32 %14)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %26 = shl i32 %25, 12
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %16
    store i32 %26, i32* %28
    br label %endif_4
else_4:
    %29 = icmp eq i8 %15, 23
    br i1 %29 , label %then_5, label %else_5
then_5:
    ; U-type
    %30 = call i32(i32) @extract_imm31_12 (i32 %14)
    %31 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %32 = load i32, i32* %31
    %33 = bitcast i32 %32 to i32
    %34 = shl i32 %30, 12
    %35 = add i32 %33, %34
    %36 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %37 = getelementptr inbounds [32 x i32], [32 x i32]* %36, i32 0, i8 %16
    store i32 %35, i32* %37
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_5
else_5:
    %38 = icmp eq i8 %15, 111
    br i1 %38 , label %then_6, label %else_6
then_6:
    ; U-type
    %39 = call i32(i32) @extract_jal_imm (i32 %14)
    %40 = call i32(i32) @expand20 (i32 %39)
    ;printf("jal x%d, %d\n", rd, imm)
    %41 = icmp ne i8 %16, 0
    br i1 %41 , label %then_7, label %endif_7
then_7:
    %42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %43 = load i32, i32* %42
    %44 = add i32 %43, 4
    %45 = bitcast i32 %44 to i32
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %16
    store i32 %45, i32* %47
    br label %endif_7
endif_7:
    %48 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %49 = load i32, i32* %48
    %50 = bitcast i32 %49 to i32
    %51 = add i32 %50, %40
    %52 = bitcast i32 %51 to i32
    %53 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %52, i32* %53
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %54
    br label %endif_6
else_6:
    %55 = icmp eq i8 %15, 103
    %56 = icmp eq i8 %19, 0
    %57 = and i1 %55, %56
    br i1 %57 , label %then_8, label %else_8
then_8:
    %58 = call i32(i32) @extract_imm12 (i32 %14)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %60 = load i32, i32* %59
    %61 = add i32 %60, 4
    %62 = bitcast i32 %61 to i32
    %63 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %64 = getelementptr inbounds [32 x i32], [32 x i32]* %63, i32 0, i8 %17
    %65 = load i32, i32* %64
    %66 = add i32 %65, %58
    %67 = bitcast i32 %66 to i32
    %68 = and i32 %67, 4294967294
    %69 = icmp ne i8 %16, 0
    br i1 %69 , label %then_9, label %endif_9
then_9:
    %70 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %71 = getelementptr inbounds [32 x i32], [32 x i32]* %70, i32 0, i8 %16
    store i32 %62, i32* %71
    br label %endif_9
endif_9:
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %68, i32* %72
    %73 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %73
    br label %endif_8
else_8:
    %74 = icmp eq i8 %15, 99
    br i1 %74 , label %then_10, label %else_10
then_10:
    %75 = call i8(i32) @extract_funct7 (i32 %14)
    %76 = call i8(i32) @extract_rd (i32 %14)
    %77 = and i8 %76, 30
    %78 = zext i8 %77 to i16
    %79 = and i8 %75, 63
    %80 = zext i8 %79 to i16
    %81 = shl i16 %80, 5
    %82 = and i8 %76, 1
    %83 = zext i8 %82 to i16
    %84 = shl i16 %83, 11
    %85 = and i8 %75, 64
    %86 = zext i8 %85 to i16
    %87 = shl i16 %86, 6
    %88 = or i16 %81, %78
    %89 = or i16 %84, %88
    %90 = or i16 %87, %89
    %bits = alloca i16
    store i16 %90, i16* %bits
    ; распространяем знак, если он есть
    %91 = load i16, i16* %bits
    %92 = and i16 %91, 4096
    %93 = icmp ne i16 %92, 0
    br i1 %93 , label %then_11, label %endif_11
then_11:
    %94 = load i16, i16* %bits
    %95 = or i16 61440, %94
    store i16 %95, i16* %bits
    br label %endif_11
endif_11:
    %96 = load i16, i16* %bits
    %97 = bitcast i16 %96 to i16
    %98 = icmp eq i8 %19, 0
    br i1 %98 , label %then_12, label %else_12
then_12:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %99 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %100 = getelementptr inbounds [32 x i32], [32 x i32]* %99, i32 0, i8 %17
    %101 = load i32, i32* %100
    %102 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %103 = getelementptr inbounds [32 x i32], [32 x i32]* %102, i32 0, i8 %18
    %104 = load i32, i32* %103
    %105 = icmp eq i32 %101, %104
    br i1 %105 , label %then_13, label %endif_13
then_13:
    %106 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %107 = load i32, i32* %106
    %108 = bitcast i32 %107 to i32
    %109 = sext i16 %97 to i32
    %110 = add i32 %108, %109
    %111 = bitcast i32 %110 to i32
    %112 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %111, i32* %112
    %113 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %113
    br label %endif_13
endif_13:
    br label %endif_12
else_12:
    %114 = icmp eq i8 %19, 1
    br i1 %114 , label %then_14, label %else_14
then_14:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %115 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %116 = getelementptr inbounds [32 x i32], [32 x i32]* %115, i32 0, i8 %17
    %117 = load i32, i32* %116
    %118 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %119 = getelementptr inbounds [32 x i32], [32 x i32]* %118, i32 0, i8 %18
    %120 = load i32, i32* %119
    %121 = icmp ne i32 %117, %120
    br i1 %121 , label %then_15, label %endif_15
then_15:
    %122 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %123 = load i32, i32* %122
    %124 = bitcast i32 %123 to i32
    %125 = sext i16 %97 to i32
    %126 = add i32 %124, %125
    %127 = bitcast i32 %126 to i32
    %128 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %127, i32* %128
    %129 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %129
    br label %endif_15
endif_15:
    br label %endif_14
else_14:
    %130 = icmp eq i8 %19, 4
    br i1 %130 , label %then_16, label %else_16
then_16:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %131 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %132 = getelementptr inbounds [32 x i32], [32 x i32]* %131, i32 0, i8 %17
    %133 = load i32, i32* %132
    %134 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %135 = getelementptr inbounds [32 x i32], [32 x i32]* %134, i32 0, i8 %18
    %136 = load i32, i32* %135
    %137 = icmp slt i32 %133, %136
    br i1 %137 , label %then_17, label %endif_17
then_17:
    %138 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %139 = load i32, i32* %138
    %140 = bitcast i32 %139 to i32
    %141 = sext i16 %97 to i32
    %142 = add i32 %140, %141
    %143 = bitcast i32 %142 to i32
    %144 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %143, i32* %144
    %145 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %145
    br label %endif_17
endif_17:
    br label %endif_16
else_16:
    %146 = icmp eq i8 %19, 5
    br i1 %146 , label %then_18, label %else_18
then_18:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %148 = getelementptr inbounds [32 x i32], [32 x i32]* %147, i32 0, i8 %17
    %149 = load i32, i32* %148
    %150 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %151 = getelementptr inbounds [32 x i32], [32 x i32]* %150, i32 0, i8 %18
    %152 = load i32, i32* %151
    %153 = icmp sge i32 %149, %152
    br i1 %153 , label %then_19, label %endif_19
then_19:
    %154 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %155 = load i32, i32* %154
    %156 = bitcast i32 %155 to i32
    %157 = sext i16 %97 to i32
    %158 = add i32 %156, %157
    %159 = bitcast i32 %158 to i32
    %160 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %159, i32* %160
    %161 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %161
    br label %endif_19
endif_19:
    br label %endif_18
else_18:
    %162 = icmp eq i8 %19, 6
    br i1 %162 , label %then_20, label %else_20
then_20:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %163 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %164 = getelementptr inbounds [32 x i32], [32 x i32]* %163, i32 0, i8 %17
    %165 = load i32, i32* %164
    %166 = bitcast i32 %165 to i32
    %167 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %168 = getelementptr inbounds [32 x i32], [32 x i32]* %167, i32 0, i8 %18
    %169 = load i32, i32* %168
    %170 = bitcast i32 %169 to i32
    %171 = icmp ult i32 %166, %170
    br i1 %171 , label %then_21, label %endif_21
then_21:
    %172 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %173 = load i32, i32* %172
    %174 = bitcast i32 %173 to i32
    %175 = sext i16 %97 to i32
    %176 = add i32 %174, %175
    %177 = bitcast i32 %176 to i32
    %178 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %177, i32* %178
    %179 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %179
    br label %endif_21
endif_21:
    br label %endif_20
else_20:
    %180 = icmp eq i8 %19, 7
    br i1 %180 , label %then_22, label %endif_22
then_22:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %181 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %182 = getelementptr inbounds [32 x i32], [32 x i32]* %181, i32 0, i8 %17
    %183 = load i32, i32* %182
    %184 = bitcast i32 %183 to i32
    %185 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %186 = getelementptr inbounds [32 x i32], [32 x i32]* %185, i32 0, i8 %18
    %187 = load i32, i32* %186
    %188 = bitcast i32 %187 to i32
    %189 = icmp uge i32 %184, %188
    br i1 %189 , label %then_23, label %else_23
then_23:
    %190 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %191 = load i32, i32* %190
    %192 = bitcast i32 %191 to i32
    %193 = sext i16 %97 to i32
    %194 = add i32 %192, %193
    %195 = bitcast i32 %194 to i32
    %196 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %195, i32* %196
    %197 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %197
    br label %endif_23
else_23:
    br label %endif_23
endif_23:
    br label %endif_22
endif_22:
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
else_10:
    %198 = icmp eq i8 %15, 3
    br i1 %198 , label %then_24, label %else_24
then_24:
    %199 = call i32(i32) @extract_imm12 (i32 %14)
    %200 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %201 = getelementptr inbounds [32 x i32], [32 x i32]* %200, i32 0, i8 %17
    %202 = load i32, i32* %201
    %203 = add i32 %202, %199
    %204 = bitcast i32 %203 to i32
    %205 = icmp eq i8 %19, 0
    br i1 %205 , label %then_25, label %else_25
then_25:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %206 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %207 = load %MemoryInterface*, %MemoryInterface** %206
    %208 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %207, i32 0, i32 0
    %209 = load i8(i32)*, i8(i32)** %208
    %210 = call i8(i32) %209 (i32 %204)
    %211 = sext i8 %210 to i32
    %212 = icmp ne i8 %16, 0
    br i1 %212 , label %then_26, label %endif_26
then_26:
    %213 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %214 = getelementptr inbounds [32 x i32], [32 x i32]* %213, i32 0, i8 %16
    store i32 %211, i32* %214
    br label %endif_26
endif_26:
    br label %endif_25
else_25:
    %215 = icmp eq i8 %19, 1
    br i1 %215 , label %then_27, label %else_27
then_27:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %216 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %217 = load %MemoryInterface*, %MemoryInterface** %216
    %218 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %217, i32 0, i32 1
    %219 = load i16(i32)*, i16(i32)** %218
    %220 = call i16(i32) %219 (i32 %204)
    %221 = sext i16 %220 to i32
    %222 = icmp ne i8 %16, 0
    br i1 %222 , label %then_28, label %endif_28
then_28:
    %223 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %224 = getelementptr inbounds [32 x i32], [32 x i32]* %223, i32 0, i8 %16
    store i32 %221, i32* %224
    br label %endif_28
endif_28:
    br label %endif_27
else_27:
    %225 = icmp eq i8 %19, 2
    br i1 %225 , label %then_29, label %else_29
then_29:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %226 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %227 = load %MemoryInterface*, %MemoryInterface** %226
    %228 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %227, i32 0, i32 2
    %229 = load i32(i32)*, i32(i32)** %228
    %230 = call i32(i32) %229 (i32 %204)
    %231 = bitcast i32 %230 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %232 = icmp ne i8 %16, 0
    br i1 %232 , label %then_30, label %endif_30
then_30:
    %233 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %234 = getelementptr inbounds [32 x i32], [32 x i32]* %233, i32 0, i8 %16
    store i32 %231, i32* %234
    br label %endif_30
endif_30:
    br label %endif_29
else_29:
    %235 = icmp eq i8 %19, 4
    br i1 %235 , label %then_31, label %else_31
then_31:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %236 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %237 = load %MemoryInterface*, %MemoryInterface** %236
    %238 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %237, i32 0, i32 0
    %239 = load i8(i32)*, i8(i32)** %238
    %240 = call i8(i32) %239 (i32 %204)
    %241 = zext i8 %240 to i32
    %242 = bitcast i32 %241 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %243 = icmp ne i8 %16, 0
    br i1 %243 , label %then_32, label %endif_32
then_32:
    %244 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %245 = getelementptr inbounds [32 x i32], [32 x i32]* %244, i32 0, i8 %16
    store i32 %242, i32* %245
    br label %endif_32
endif_32:
    br label %endif_31
else_31:
    %246 = icmp eq i8 %19, 5
    br i1 %246 , label %then_33, label %endif_33
then_33:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %247 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %248 = load %MemoryInterface*, %MemoryInterface** %247
    %249 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %248, i32 0, i32 1
    %250 = load i16(i32)*, i16(i32)** %249
    %251 = call i16(i32) %250 (i32 %204)
    %252 = zext i16 %251 to i32
    %253 = bitcast i32 %252 to i32
    %254 = icmp ne i8 %16, 0
    br i1 %254 , label %then_34, label %endif_34
then_34:
    %255 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %256 = getelementptr inbounds [32 x i32], [32 x i32]* %255, i32 0, i8 %16
    store i32 %253, i32* %256
    br label %endif_34
endif_34:
    br label %endif_33
endif_33:
    br label %endif_31
endif_31:
    br label %endif_29
endif_29:
    br label %endif_27
endif_27:
    br label %endif_25
endif_25:
    br label %endif_24
else_24:
    %257 = icmp eq i8 %15, 35
    br i1 %257 , label %then_35, label %else_35
then_35:
    %258 = call i8(i32) @extract_funct7 (i32 %14)
    %259 = zext i8 %258 to i16
    %260 = shl i16 %259, 5
    %261 = zext i8 %16 to i16
    %262 = or i16 %260, %261
    %263 = call i32(i16) @expand12 (i16 %262)
    %264 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %265 = getelementptr inbounds [32 x i32], [32 x i32]* %264, i32 0, i8 %17
    %266 = load i32, i32* %265
    %267 = add i32 %266, %263
    %268 = bitcast i32 %267 to i32
    %269 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %270 = getelementptr inbounds [32 x i32], [32 x i32]* %269, i32 0, i8 %18
    %271 = load i32, i32* %270
    %272 = icmp eq i8 %19, 0
    br i1 %272 , label %then_36, label %else_36
then_36:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %273 = trunc i32 %271 to i8
    %274 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %275 = load %MemoryInterface*, %MemoryInterface** %274
    %276 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %275, i32 0, i32 3
    %277 = load void(i32, i8)*, void(i32, i8)** %276
    call void(i32, i8) %277 (i32 %268, i8 %273)
    br label %endif_36
else_36:
    %278 = icmp eq i8 %19, 1
    br i1 %278 , label %then_37, label %else_37
then_37:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %279 = trunc i32 %271 to i16
    %280 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %281 = load %MemoryInterface*, %MemoryInterface** %280
    %282 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %281, i32 0, i32 4
    %283 = load void(i32, i16)*, void(i32, i16)** %282
    call void(i32, i16) %283 (i32 %268, i16 %279)
    br label %endif_37
else_37:
    %284 = icmp eq i8 %19, 2
    br i1 %284 , label %then_38, label %endif_38
then_38:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %285 = bitcast i32 %271 to i32
    %286 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %287 = load %MemoryInterface*, %MemoryInterface** %286
    %288 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %287, i32 0, i32 5
    %289 = load void(i32, i32)*, void(i32, i32)** %288
    call void(i32, i32) %289 (i32 %268, i32 %285)
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
endif_36:
    br label %endif_35
else_35:
    %290 = icmp eq i32 %14, 115
    br i1 %290 , label %then_39, label %else_39
then_39:
    ;printf("ECALL\n")
    %291 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @core_irq (%Core* %291, i32 8)
    br label %endif_39
else_39:
    %292 = icmp eq i32 %14, 1048691
    br i1 %292 , label %then_40, label %else_40
then_40:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_40
else_40:
    %294 = icmp eq i32 %14, 16777231
    br i1 %294 , label %then_41, label %else_41
then_41:
    ;printf("PAUSE\n")
    br label %endif_41
else_41:
    ;printf("UNKNOWN OPCODE: %08X\n", op)
    br label %endif_41
endif_41:
    br label %endif_40
endif_40:
    br label %endif_39
endif_39:
    br label %endif_35
endif_35:
    br label %endif_24
endif_24:
    br label %endif_10
endif_10:
    br label %endif_8
endif_8:
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
    %295 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %296 = load i1, i1* %295
    br i1 %296 , label %then_42, label %else_42
then_42:
    %297 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %298 = load i32, i32* %297
    %299 = add i32 %298, 4
    %300 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %299, i32* %300
    br label %endif_42
else_42:
    %301 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %301
    br label %endif_42
endif_42:
    ret i1 1
}


