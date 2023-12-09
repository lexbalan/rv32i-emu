
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

define i32 @expand12(i32 %val12bit) {
    %v = alloca i32
    store i32 %val12bit, i32* %v
    %1 = load i32, i32* %v
    %2 = and i32 %1, 2048
    %3 = icmp ne i32 %2, 0
    br i1 %3 , label %then_0, label %endif_0
then_0:
    %4 = load i32, i32* %v
    %5 = or i32 %4, 4294963200
    store i32 %5, i32* %v
    br label %endif_0
endif_0:
    %6 = load i32, i32* %v
    %7 = bitcast i32 %6 to i32
    ret i32 %7
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
    ret i32 %2
}

define i32 @extract_imm31_12(i32 %instr) {
    %1 = lshr i32 %instr, 12
    %2 = and i32 %1, 1048575
    ret i32 %2
}

define i32 @extract_jal_imm(i32 %instr) {
    %1 = call i32(i32) @extract_imm31_12 (i32 %instr)
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
    %1 = call i8(i32) @extract_funct3 (i32 %instr)
    %2 = call i8(i32) @extract_funct7 (i32 %instr)
    %3 = call i32(i32) @extract_imm12 (i32 %instr)
    %4 = call i32(i32) @expand12 (i32 %3)
    %5 = call i8(i32) @extract_rd (i32 %instr)
    %6 = call i8(i32) @extract_rs1 (i32 %instr)
    %7 = icmp eq i8 %5, 0
    br i1 %7 , label %then_0, label %endif_0
then_0:
    ret void
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
    %12 = getelementptr inbounds [32 x i32], [32 x i32]* %11, i32 0, i8 %6
    %13 = load i32, i32* %12
    %14 = add i32 %13, %4
    %15 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %16 = getelementptr inbounds [32 x i32], [32 x i32]* %15, i32 0, i8 %5
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

    ;printf("slli x%d, x%d, %d\n", rd, rs1, imm)
    %20 = icmp ne i8 %5, 0
    br i1 %20 , label %then_4, label %endif_4
then_4:
    %21 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %22 = getelementptr inbounds [32 x i32], [32 x i32]* %21, i32 0, i8 %6
    %23 = load i32, i32* %22
    %24 = bitcast i32 %23 to i32
    %25 = shl i32 %24, %4
    %26 = bitcast i32 %25 to i32
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %5
    store i32 %26, i32* %28
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
    %32 = getelementptr inbounds [32 x i32], [32 x i32]* %31, i32 0, i8 %6
    %33 = load i32, i32* %32
    %34 = icmp slt i32 %33, %4
    %35 = sext i1 %34 to i32
    %36 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %37 = getelementptr inbounds [32 x i32], [32 x i32]* %36, i32 0, i8 %5
    store i32 %35, i32* %37
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
    %41 = getelementptr inbounds [32 x i32], [32 x i32]* %40, i32 0, i8 %6
    %42 = load i32, i32* %41
    %43 = bitcast i32 %42 to i32
    %44 = bitcast i32 %4 to i32
    %45 = icmp ult i32 %43, %44
    %46 = sext i1 %45 to i32
    %47 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %48 = getelementptr inbounds [32 x i32], [32 x i32]* %47, i32 0, i8 %5
    store i32 %46, i32* %48
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
    %52 = getelementptr inbounds [32 x i32], [32 x i32]* %51, i32 0, i8 %6
    %53 = load i32, i32* %52
    %54 = xor i32 %53, %4
    %55 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %56 = getelementptr inbounds [32 x i32], [32 x i32]* %55, i32 0, i8 %5
    store i32 %54, i32* %56
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
    %62 = getelementptr inbounds [32 x i32], [32 x i32]* %61, i32 0, i8 %6
    %63 = load i32, i32* %62
    %64 = bitcast i32 %63 to i32
    %65 = lshr i32 %64, %4
    %66 = bitcast i32 %65 to i32
    %67 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %68 = getelementptr inbounds [32 x i32], [32 x i32]* %67, i32 0, i8 %5
    store i32 %66, i32* %68
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
    %74 = getelementptr inbounds [32 x i32], [32 x i32]* %73, i32 0, i8 %6
    %75 = load i32, i32* %74
    %76 = ashr i32 %75, %4
    %77 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %78 = getelementptr inbounds [32 x i32], [32 x i32]* %77, i32 0, i8 %5
    store i32 %76, i32* %78
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
    %82 = getelementptr inbounds [32 x i32], [32 x i32]* %81, i32 0, i8 %6
    %83 = load i32, i32* %82
    %84 = or i32 %83, %4
    %85 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %86 = getelementptr inbounds [32 x i32], [32 x i32]* %85, i32 0, i8 %5
    store i32 %84, i32* %86
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
    %90 = getelementptr inbounds [32 x i32], [32 x i32]* %89, i32 0, i8 %6
    %91 = load i32, i32* %90
    %92 = and i32 %91, %4
    %93 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %94 = getelementptr inbounds [32 x i32], [32 x i32]* %93, i32 0, i8 %5
    store i32 %92, i32* %94
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
    %4 = call i32(i32) @expand12 (i32 %3)
    %5 = call i8(i32) @extract_rd (i32 %instr)
    %6 = call i8(i32) @extract_rs1 (i32 %instr)
    %7 = call i8(i32) @extract_rs2 (i32 %instr)
    %8 = icmp eq i8 %5, 0
    br i1 %8 , label %then_0, label %endif_0
then_0:
    ret void
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
    %19 = add i32 %12, %15
    %20 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %21 = getelementptr inbounds [32 x i32], [32 x i32]* %20, i32 0, i8 %5
    store i32 %19, i32* %21
    br label %endif_1
else_1:
    %22 = icmp eq i8 %1, 0
    %23 = icmp eq i8 %2, 32
    %24 = and i1 %22, %23
    br i1 %24 , label %then_2, label %else_2
then_2:
    ;printf("sub x%d, x%d, x%d\n", rd, rs1, rs2)
    %25 = sub i32 %12, %15
    %26 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %27 = getelementptr inbounds [32 x i32], [32 x i32]* %26, i32 0, i8 %5
    store i32 %25, i32* %27
    br label %endif_2
else_2:
    %28 = icmp eq i8 %1, 1
    br i1 %28 , label %then_3, label %else_3
then_3:
    ; shift left logical
    ;printf("sll x%d, x%d, x%d\n", rd, rs1, rs2)
    %29 = shl i32 %12, %15
    %30 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %31 = getelementptr inbounds [32 x i32], [32 x i32]* %30, i32 0, i8 %5
    store i32 %29, i32* %31
    br label %endif_3
else_3:
    %32 = icmp eq i8 %1, 2
    br i1 %32 , label %then_4, label %else_4
then_4:
    ; set less than
    ;printf("slt x%d, x%d, x%d\n", rd, rs1, rs2)
    %33 = icmp slt i32 %12, %15
    %34 = sext i1 %33 to i32
    %35 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %36 = getelementptr inbounds [32 x i32], [32 x i32]* %35, i32 0, i8 %5
    store i32 %34, i32* %36
    br label %endif_4
else_4:
    %37 = icmp eq i8 %1, 3
    br i1 %37 , label %then_5, label %else_5
then_5:
    ; set less than unsigned
    ;printf("sltu x%d, x%d, x%d\n", rd, rs1, rs2)
    %38 = bitcast i32 %12 to i32
    %39 = bitcast i32 %15 to i32
    %40 = icmp ult i32 %38, %39
    %41 = sext i1 %40 to i32
    %42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %43 = getelementptr inbounds [32 x i32], [32 x i32]* %42, i32 0, i8 %5
    store i32 %41, i32* %43
    br label %endif_5
else_5:
    %44 = icmp eq i8 %1, 4
    br i1 %44 , label %then_6, label %else_6
then_6:
    ;printf("xor x%d, x%d, x%d\n", rd, rs1, rs2)
    %45 = xor i32 %12, %15
    %46 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %47 = getelementptr inbounds [32 x i32], [32 x i32]* %46, i32 0, i8 %5
    store i32 %45, i32* %47
    br label %endif_6
else_6:
    %48 = icmp eq i8 %1, 5
    %49 = icmp eq i8 %2, 0
    %50 = and i1 %48, %49
    br i1 %50 , label %then_7, label %else_7
then_7:
    ; shift right logical
    ;printf("srl x%d, x%d, x%d\n", rd, rs1, rs2)
    %51 = bitcast i32 %12 to i32
    %52 = lshr i32 %51, %15
    %53 = bitcast i32 %52 to i32
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %55 = getelementptr inbounds [32 x i32], [32 x i32]* %54, i32 0, i8 %5
    store i32 %53, i32* %55
    br label %endif_7
else_7:
    %56 = icmp eq i8 %1, 5
    %57 = icmp eq i8 %2, 32
    %58 = and i1 %56, %57
    br i1 %58 , label %then_8, label %else_8
then_8:
    ; shift right arithmetical
    ;printf("sra x%d, x%d, x%d\n", rd, rs1, rs2)
    %59 = ashr i32 %12, %15
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %61 = getelementptr inbounds [32 x i32], [32 x i32]* %60, i32 0, i8 %5
    store i32 %59, i32* %61
    br label %endif_8
else_8:
    %62 = icmp eq i8 %1, 6
    br i1 %62 , label %then_9, label %else_9
then_9:
    ;printf("or x%d, x%d, x%d\n", rd, rs1, rs2)
    %63 = or i32 %12, %15
    %64 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %65 = getelementptr inbounds [32 x i32], [32 x i32]* %64, i32 0, i8 %5
    store i32 %63, i32* %65
    br label %endif_9
else_9:
    %66 = icmp eq i8 %1, 7
    br i1 %66 , label %then_10, label %endif_10
then_10:
    ;printf("and x%d, x%d, x%d\n", rd, rs1, rs2)
    %67 = and i32 %12, %15
    %68 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %69 = getelementptr inbounds [32 x i32], [32 x i32]* %68, i32 0, i8 %5
    store i32 %67, i32* %69
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
    %10 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %9, i32* %10
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i32 0, i32* %11
    br label %endif_0
endif_0:
    %12 = bitcast %Core* %core to %Core*
    %13 = call i32(%Core*) @fetch (%Core* %12)
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %14 = call i8(i32) @extract_op (i32 %13)
    %15 = call i8(i32) @extract_rd (i32 %13)
    %16 = call i8(i32) @extract_rs1 (i32 %13)
    %17 = call i8(i32) @extract_rs2 (i32 %13)
    %18 = call i8(i32) @extract_funct3 (i32 %13)
    br i1 0 , label %then_1, label %endif_1
then_1:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_1
endif_1:
    %19 = icmp eq i8 %14, 19
    br i1 %19 , label %then_2, label %else_2
then_2:
    %20 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %20, i32 %13)
    br label %endif_2
else_2:
    %21 = icmp eq i8 %14, 51
    br i1 %21 , label %then_3, label %else_3
then_3:
    %22 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %22, i32 %13)
    br label %endif_3
else_3:
    %23 = icmp eq i8 %14, 55
    br i1 %23 , label %then_4, label %else_4
then_4:
    ; U-type
    %24 = call i32(i32) @extract_imm31_12 (i32 %13)
    %25 = call i32(i32) @expand12 (i32 %24)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %26 = shl i32 %25, 12
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %15
    store i32 %26, i32* %28
    br label %endif_4
else_4:
    %29 = icmp eq i8 %14, 23
    br i1 %29 , label %then_5, label %else_5
then_5:
    ; U-type
    %30 = call i32(i32) @extract_imm31_12 (i32 %13)
    %31 = call i32(i32) @expand12 (i32 %30)
    %32 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %33 = load i32, i32* %32
    %34 = bitcast i32 %33 to i32
    %35 = shl i32 %31, 12
    %36 = add i32 %34, %35
    %37 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %38 = getelementptr inbounds [32 x i32], [32 x i32]* %37, i32 0, i8 %15
    store i32 %36, i32* %38
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_5
else_5:
    %39 = icmp eq i8 %14, 111
    br i1 %39 , label %then_6, label %else_6
then_6:
    ; U-type
    %40 = call i32(i32) @extract_jal_imm (i32 %13)
    %41 = call i32(i32) @expand20 (i32 %40)
    ;printf("jal x%d, %d\n", rd, imm)
    %42 = icmp ne i8 %15, 0
    br i1 %42 , label %then_7, label %endif_7
then_7:
    %43 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %44 = load i32, i32* %43
    %45 = add i32 %44, 4
    %46 = bitcast i32 %45 to i32
    %47 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %48 = getelementptr inbounds [32 x i32], [32 x i32]* %47, i32 0, i8 %15
    store i32 %46, i32* %48
    br label %endif_7
endif_7:
    %49 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %50 = load i32, i32* %49
    %51 = bitcast i32 %50 to i32
    %52 = add i32 %51, %41
    %53 = bitcast i32 %52 to i32
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %53, i32* %54
    %55 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %55
    br label %endif_6
else_6:
    %56 = icmp eq i8 %14, 103
    %57 = icmp eq i8 %18, 0
    %58 = and i1 %56, %57
    br i1 %58 , label %then_8, label %else_8
then_8:
    %59 = call i32(i32) @extract_imm12 (i32 %13)
    %60 = call i32(i32) @expand12 (i32 %59)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %61 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %62 = load i32, i32* %61
    %63 = add i32 %62, 4
    %64 = bitcast i32 %63 to i32
    %65 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %66 = getelementptr inbounds [32 x i32], [32 x i32]* %65, i32 0, i8 %16
    %67 = load i32, i32* %66
    %68 = add i32 %67, %60
    %69 = bitcast i32 %68 to i32
    %70 = and i32 %69, 4294967294
    %71 = icmp ne i8 %15, 0
    br i1 %71 , label %then_9, label %endif_9
then_9:
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %15
    store i32 %64, i32* %73
    br label %endif_9
endif_9:
    %74 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %70, i32* %74
    %75 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %75
    br label %endif_8
else_8:
    %76 = icmp eq i8 %14, 99
    br i1 %76 , label %then_10, label %else_10
then_10:
    %77 = call i8(i32) @extract_funct7 (i32 %13)
    %78 = call i8(i32) @extract_rd (i32 %13)
    %79 = and i8 %78, 30
    %80 = zext i8 %79 to i16
    %81 = and i8 %77, 63
    %82 = zext i8 %81 to i16
    %83 = shl i16 %82, 5
    %84 = and i8 %78, 1
    %85 = zext i8 %84 to i16
    %86 = shl i16 %85, 11
    %87 = and i8 %77, 64
    %88 = zext i8 %87 to i16
    %89 = shl i16 %88, 6
    %90 = or i16 %83, %80
    %91 = or i16 %86, %90
    %92 = or i16 %89, %91
    %bits = alloca i16
    store i16 %92, i16* %bits
    ; распространяем знак, если он есть
    %93 = load i16, i16* %bits
    %94 = and i16 %93, 4096
    %95 = icmp ne i16 %94, 0
    br i1 %95 , label %then_11, label %endif_11
then_11:
    %96 = load i16, i16* %bits
    %97 = or i16 61440, %96
    store i16 %97, i16* %bits
    br label %endif_11
endif_11:
    %98 = load i16, i16* %bits
    %99 = bitcast i16 %98 to i16
    %100 = icmp eq i8 %18, 0
    br i1 %100 , label %then_12, label %else_12
then_12:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %101 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %102 = getelementptr inbounds [32 x i32], [32 x i32]* %101, i32 0, i8 %16
    %103 = load i32, i32* %102
    %104 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %105 = getelementptr inbounds [32 x i32], [32 x i32]* %104, i32 0, i8 %17
    %106 = load i32, i32* %105
    %107 = icmp eq i32 %103, %106
    br i1 %107 , label %then_13, label %endif_13
then_13:
    %108 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %109 = load i32, i32* %108
    %110 = bitcast i32 %109 to i32
    %111 = sext i16 %99 to i32
    %112 = add i32 %110, %111
    %113 = bitcast i32 %112 to i32
    %114 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %113, i32* %114
    %115 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %115
    br label %endif_13
endif_13:
    br label %endif_12
else_12:
    %116 = icmp eq i8 %18, 1
    br i1 %116 , label %then_14, label %else_14
then_14:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %117 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %118 = getelementptr inbounds [32 x i32], [32 x i32]* %117, i32 0, i8 %16
    %119 = load i32, i32* %118
    %120 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %121 = getelementptr inbounds [32 x i32], [32 x i32]* %120, i32 0, i8 %17
    %122 = load i32, i32* %121
    %123 = icmp ne i32 %119, %122
    br i1 %123 , label %then_15, label %endif_15
then_15:
    %124 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %125 = load i32, i32* %124
    %126 = bitcast i32 %125 to i32
    %127 = sext i16 %99 to i32
    %128 = add i32 %126, %127
    %129 = bitcast i32 %128 to i32
    %130 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %129, i32* %130
    %131 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %131
    br label %endif_15
endif_15:
    br label %endif_14
else_14:
    %132 = icmp eq i8 %18, 4
    br i1 %132 , label %then_16, label %else_16
then_16:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %133 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %134 = getelementptr inbounds [32 x i32], [32 x i32]* %133, i32 0, i8 %16
    %135 = load i32, i32* %134
    %136 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %137 = getelementptr inbounds [32 x i32], [32 x i32]* %136, i32 0, i8 %17
    %138 = load i32, i32* %137
    %139 = icmp slt i32 %135, %138
    br i1 %139 , label %then_17, label %endif_17
then_17:
    %140 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %141 = load i32, i32* %140
    %142 = bitcast i32 %141 to i32
    %143 = sext i16 %99 to i32
    %144 = add i32 %142, %143
    %145 = bitcast i32 %144 to i32
    %146 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %145, i32* %146
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %147
    br label %endif_17
endif_17:
    br label %endif_16
else_16:
    %148 = icmp eq i8 %18, 5
    br i1 %148 , label %then_18, label %else_18
then_18:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %149 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %150 = getelementptr inbounds [32 x i32], [32 x i32]* %149, i32 0, i8 %16
    %151 = load i32, i32* %150
    %152 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %153 = getelementptr inbounds [32 x i32], [32 x i32]* %152, i32 0, i8 %17
    %154 = load i32, i32* %153
    %155 = icmp sge i32 %151, %154
    br i1 %155 , label %then_19, label %endif_19
then_19:
    %156 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %157 = load i32, i32* %156
    %158 = bitcast i32 %157 to i32
    %159 = sext i16 %99 to i32
    %160 = add i32 %158, %159
    %161 = bitcast i32 %160 to i32
    %162 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %161, i32* %162
    %163 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %163
    br label %endif_19
endif_19:
    br label %endif_18
else_18:
    %164 = icmp eq i8 %18, 6
    br i1 %164 , label %then_20, label %else_20
then_20:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %165 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %166 = getelementptr inbounds [32 x i32], [32 x i32]* %165, i32 0, i8 %16
    %167 = load i32, i32* %166
    %168 = bitcast i32 %167 to i32
    %169 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %170 = getelementptr inbounds [32 x i32], [32 x i32]* %169, i32 0, i8 %17
    %171 = load i32, i32* %170
    %172 = bitcast i32 %171 to i32
    %173 = icmp ult i32 %168, %172
    br i1 %173 , label %then_21, label %endif_21
then_21:
    %174 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %175 = load i32, i32* %174
    %176 = bitcast i32 %175 to i32
    %177 = sext i16 %99 to i32
    %178 = add i32 %176, %177
    %179 = bitcast i32 %178 to i32
    %180 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %179, i32* %180
    %181 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %181
    br label %endif_21
endif_21:
    br label %endif_20
else_20:
    %182 = icmp eq i8 %18, 7
    br i1 %182 , label %then_22, label %endif_22
then_22:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %183 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %184 = getelementptr inbounds [32 x i32], [32 x i32]* %183, i32 0, i8 %16
    %185 = load i32, i32* %184
    %186 = bitcast i32 %185 to i32
    %187 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %188 = getelementptr inbounds [32 x i32], [32 x i32]* %187, i32 0, i8 %17
    %189 = load i32, i32* %188
    %190 = bitcast i32 %189 to i32
    %191 = icmp uge i32 %186, %190
    br i1 %191 , label %then_23, label %else_23
then_23:
    %192 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %193 = load i32, i32* %192
    %194 = bitcast i32 %193 to i32
    %195 = sext i16 %99 to i32
    %196 = add i32 %194, %195
    %197 = bitcast i32 %196 to i32
    %198 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %197, i32* %198
    %199 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %199
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
    %200 = icmp eq i8 %14, 3
    br i1 %200 , label %then_24, label %else_24
then_24:
    %201 = call i32(i32) @extract_imm12 (i32 %13)
    %202 = call i32(i32) @expand12 (i32 %201)
    %203 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %204 = getelementptr inbounds [32 x i32], [32 x i32]* %203, i32 0, i8 %16
    %205 = load i32, i32* %204
    %206 = add i32 %205, %202
    %207 = bitcast i32 %206 to i32
    %208 = icmp eq i8 %18, 0
    br i1 %208 , label %then_25, label %else_25
then_25:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %209 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %210 = load %MemoryInterface*, %MemoryInterface** %209
    %211 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %210, i32 0, i32 0
    %212 = load i8(i32)*, i8(i32)** %211
    %213 = call i8(i32) %212 (i32 %207)
    %214 = sext i8 %213 to i32
    %215 = icmp ne i8 %15, 0
    br i1 %215 , label %then_26, label %endif_26
then_26:
    %216 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %217 = getelementptr inbounds [32 x i32], [32 x i32]* %216, i32 0, i8 %15
    store i32 %214, i32* %217
    br label %endif_26
endif_26:
    br label %endif_25
else_25:
    %218 = icmp eq i8 %18, 1
    br i1 %218 , label %then_27, label %else_27
then_27:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %219 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %220 = load %MemoryInterface*, %MemoryInterface** %219
    %221 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %220, i32 0, i32 1
    %222 = load i16(i32)*, i16(i32)** %221
    %223 = call i16(i32) %222 (i32 %207)
    %224 = sext i16 %223 to i32
    %225 = icmp ne i8 %15, 0
    br i1 %225 , label %then_28, label %endif_28
then_28:
    %226 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %227 = getelementptr inbounds [32 x i32], [32 x i32]* %226, i32 0, i8 %15
    store i32 %224, i32* %227
    br label %endif_28
endif_28:
    br label %endif_27
else_27:
    %228 = icmp eq i8 %18, 2
    br i1 %228 , label %then_29, label %else_29
then_29:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %229 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %230 = load %MemoryInterface*, %MemoryInterface** %229
    %231 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %230, i32 0, i32 2
    %232 = load i32(i32)*, i32(i32)** %231
    %233 = call i32(i32) %232 (i32 %207)
    %234 = bitcast i32 %233 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %235 = icmp ne i8 %15, 0
    br i1 %235 , label %then_30, label %endif_30
then_30:
    %236 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %237 = getelementptr inbounds [32 x i32], [32 x i32]* %236, i32 0, i8 %15
    store i32 %234, i32* %237
    br label %endif_30
endif_30:
    br label %endif_29
else_29:
    %238 = icmp eq i8 %18, 4
    br i1 %238 , label %then_31, label %else_31
then_31:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %239 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %240 = load %MemoryInterface*, %MemoryInterface** %239
    %241 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %240, i32 0, i32 0
    %242 = load i8(i32)*, i8(i32)** %241
    %243 = call i8(i32) %242 (i32 %207)
    %244 = zext i8 %243 to i32
    %245 = bitcast i32 %244 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %246 = icmp ne i8 %15, 0
    br i1 %246 , label %then_32, label %endif_32
then_32:
    %247 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %248 = getelementptr inbounds [32 x i32], [32 x i32]* %247, i32 0, i8 %15
    store i32 %245, i32* %248
    br label %endif_32
endif_32:
    br label %endif_31
else_31:
    %249 = icmp eq i8 %18, 5
    br i1 %249 , label %then_33, label %endif_33
then_33:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %250 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %251 = load %MemoryInterface*, %MemoryInterface** %250
    %252 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %251, i32 0, i32 1
    %253 = load i16(i32)*, i16(i32)** %252
    %254 = call i16(i32) %253 (i32 %207)
    %255 = zext i16 %254 to i32
    %256 = bitcast i32 %255 to i32
    %257 = icmp ne i8 %15, 0
    br i1 %257 , label %then_34, label %endif_34
then_34:
    %258 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %259 = getelementptr inbounds [32 x i32], [32 x i32]* %258, i32 0, i8 %15
    store i32 %256, i32* %259
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
    %260 = icmp eq i8 %14, 35
    br i1 %260 , label %then_35, label %else_35
then_35:
    %261 = call i8(i32) @extract_funct7 (i32 %13)
    %262 = zext i8 %261 to i32
    %263 = shl i32 %262, 5
    %264 = zext i8 %15 to i32
    %265 = or i32 %263, %264
    %266 = call i32(i32) @expand12 (i32 %265)
    %267 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %268 = getelementptr inbounds [32 x i32], [32 x i32]* %267, i32 0, i8 %16
    %269 = load i32, i32* %268
    %270 = add i32 %269, %266
    %271 = bitcast i32 %270 to i32
    %272 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %273 = getelementptr inbounds [32 x i32], [32 x i32]* %272, i32 0, i8 %17
    %274 = load i32, i32* %273
    %275 = icmp eq i8 %18, 0
    br i1 %275 , label %then_36, label %else_36
then_36:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %276 = trunc i32 %274 to i8
    %277 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %278 = load %MemoryInterface*, %MemoryInterface** %277
    %279 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %278, i32 0, i32 3
    %280 = load void(i32, i8)*, void(i32, i8)** %279
    call void(i32, i8) %280 (i32 %271, i8 %276)
    br label %endif_36
else_36:
    %281 = icmp eq i8 %18, 1
    br i1 %281 , label %then_37, label %else_37
then_37:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %282 = trunc i32 %274 to i16
    %283 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %284 = load %MemoryInterface*, %MemoryInterface** %283
    %285 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %284, i32 0, i32 4
    %286 = load void(i32, i16)*, void(i32, i16)** %285
    call void(i32, i16) %286 (i32 %271, i16 %282)
    br label %endif_37
else_37:
    %287 = icmp eq i8 %18, 2
    br i1 %287 , label %then_38, label %endif_38
then_38:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %288 = bitcast i32 %274 to i32
    %289 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %290 = load %MemoryInterface*, %MemoryInterface** %289
    %291 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %290, i32 0, i32 5
    %292 = load void(i32, i32)*, void(i32, i32)** %291
    call void(i32, i32) %292 (i32 %271, i32 %288)
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
endif_36:
    br label %endif_35
else_35:
    %293 = icmp eq i32 %13, 115
    br i1 %293 , label %then_39, label %else_39
then_39:
    ;printf("ECALL\n")
    %294 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @core_irq (%Core* %294, i32 8)
    br label %endif_39
else_39:
    %295 = icmp eq i32 %13, 1048691
    br i1 %295 , label %then_40, label %else_40
then_40:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_40
else_40:
    %297 = icmp eq i32 %13, 16777231
    br i1 %297 , label %then_41, label %else_41
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
    %298 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %299 = load i1, i1* %298
    br i1 %299 , label %then_42, label %else_42
then_42:
    %300 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %301 = load i32, i32* %300
    %302 = add i32 %301, 4
    %303 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %302, i32* %303
    br label %endif_42
else_42:
    %304 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %304
    br label %endif_42
endif_42:
    ret i1 1
}


