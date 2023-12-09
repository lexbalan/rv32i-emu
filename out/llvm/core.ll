
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

define i32 @expand12(i32 %val_12bit) {
    %v = alloca i32
    store i32 %val_12bit, i32* %v
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
    ; instruction fetch
    %12 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %13 = load i32, i32* %12
    %14 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %15 = load %MemoryInterface*, %MemoryInterface** %14
    %16 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %15, i32 0, i32 2
    %17 = load i32(i32)*, i32(i32)** %16
    %18 = call i32(i32) %17 (i32 %13)
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %19 = call i8(i32) @extract_op (i32 %18)
    %20 = call i8(i32) @extract_rd (i32 %18)
    %21 = call i8(i32) @extract_rs1 (i32 %18)
    %22 = call i8(i32) @extract_rs2 (i32 %18)
    %23 = call i8(i32) @extract_funct3 (i32 %18)
    br i1 0 , label %then_1, label %endif_1
then_1:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_1
endif_1:
    %24 = icmp eq i8 %19, 19
    br i1 %24 , label %then_2, label %else_2
then_2:
    %25 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %25, i32 %18)
    br label %endif_2
else_2:
    %26 = icmp eq i8 %19, 51
    br i1 %26 , label %then_3, label %else_3
then_3:
    %27 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %27, i32 %18)
    br label %endif_3
else_3:
    %28 = icmp eq i8 %19, 55
    br i1 %28 , label %then_4, label %else_4
then_4:
    ; U-type
    %29 = call i32(i32) @extract_imm31_12 (i32 %18)
    %30 = call i32(i32) @expand12 (i32 %29)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %31 = shl i32 %30, 12
    %32 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %33 = getelementptr inbounds [32 x i32], [32 x i32]* %32, i32 0, i8 %20
    store i32 %31, i32* %33
    br label %endif_4
else_4:
    %34 = icmp eq i8 %19, 23
    br i1 %34 , label %then_5, label %else_5
then_5:
    ; U-type
    %35 = call i32(i32) @extract_imm31_12 (i32 %18)
    %36 = call i32(i32) @expand12 (i32 %35)
    %37 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %38 = load i32, i32* %37
    %39 = bitcast i32 %38 to i32
    %40 = shl i32 %36, 12
    %41 = add i32 %39, %40
    %42 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %43 = getelementptr inbounds [32 x i32], [32 x i32]* %42, i32 0, i8 %20
    store i32 %41, i32* %43
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_5
else_5:
    %44 = icmp eq i8 %19, 111
    br i1 %44 , label %then_6, label %else_6
then_6:
    ; U-type
    %45 = call i32(i32) @extract_jal_imm (i32 %18)
    %46 = call i32(i32) @expand20 (i32 %45)
    ;printf("jal x%d, %d\n", rd, imm)
    %47 = icmp ne i8 %20, 0
    br i1 %47 , label %then_7, label %endif_7
then_7:
    %48 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %49 = load i32, i32* %48
    %50 = add i32 %49, 4
    %51 = bitcast i32 %50 to i32
    %52 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %53 = getelementptr inbounds [32 x i32], [32 x i32]* %52, i32 0, i8 %20
    store i32 %51, i32* %53
    br label %endif_7
endif_7:
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %55 = load i32, i32* %54
    %56 = bitcast i32 %55 to i32
    %57 = add i32 %56, %46
    %58 = bitcast i32 %57 to i32
    %59 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %58, i32* %59
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %60
    br label %endif_6
else_6:
    %61 = icmp eq i8 %19, 103
    %62 = icmp eq i8 %23, 0
    %63 = and i1 %61, %62
    br i1 %63 , label %then_8, label %else_8
then_8:
    %64 = call i32(i32) @extract_imm12 (i32 %18)
    %65 = call i32(i32) @expand12 (i32 %64)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %66 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %67 = load i32, i32* %66
    %68 = add i32 %67, 4
    %69 = bitcast i32 %68 to i32
    %70 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %71 = getelementptr inbounds [32 x i32], [32 x i32]* %70, i32 0, i8 %21
    %72 = load i32, i32* %71
    %73 = add i32 %72, %65
    %74 = bitcast i32 %73 to i32
    %75 = and i32 %74, 4294967294
    %76 = icmp ne i8 %20, 0
    br i1 %76 , label %then_9, label %endif_9
then_9:
    %77 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %78 = getelementptr inbounds [32 x i32], [32 x i32]* %77, i32 0, i8 %20
    store i32 %69, i32* %78
    br label %endif_9
endif_9:
    %79 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %75, i32* %79
    %80 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %80
    br label %endif_8
else_8:
    %81 = icmp eq i8 %19, 99
    br i1 %81 , label %then_10, label %else_10
then_10:
    %82 = call i8(i32) @extract_funct7 (i32 %18)
    %83 = call i8(i32) @extract_rd (i32 %18)
    %84 = and i8 %83, 30
    %85 = zext i8 %84 to i16
    %86 = and i8 %82, 63
    %87 = zext i8 %86 to i16
    %88 = shl i16 %87, 5
    %89 = and i8 %83, 1
    %90 = zext i8 %89 to i16
    %91 = shl i16 %90, 11
    %92 = and i8 %82, 64
    %93 = zext i8 %92 to i16
    %94 = shl i16 %93, 6
    %95 = or i16 %88, %85
    %96 = or i16 %91, %95
    %97 = or i16 %94, %96
    %bits = alloca i16
    store i16 %97, i16* %bits
    ; распространяем знак, если он есть
    %98 = load i16, i16* %bits
    %99 = and i16 %98, 4096
    %100 = icmp ne i16 %99, 0
    br i1 %100 , label %then_11, label %endif_11
then_11:
    %101 = load i16, i16* %bits
    %102 = or i16 61440, %101
    store i16 %102, i16* %bits
    br label %endif_11
endif_11:
    %103 = load i16, i16* %bits
    %104 = bitcast i16 %103 to i16
    %105 = icmp eq i8 %23, 0
    br i1 %105 , label %then_12, label %else_12
then_12:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %106 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %107 = getelementptr inbounds [32 x i32], [32 x i32]* %106, i32 0, i8 %21
    %108 = load i32, i32* %107
    %109 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %110 = getelementptr inbounds [32 x i32], [32 x i32]* %109, i32 0, i8 %22
    %111 = load i32, i32* %110
    %112 = icmp eq i32 %108, %111
    br i1 %112 , label %then_13, label %endif_13
then_13:
    %113 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %114 = load i32, i32* %113
    %115 = bitcast i32 %114 to i32
    %116 = sext i16 %104 to i32
    %117 = add i32 %115, %116
    %118 = bitcast i32 %117 to i32
    %119 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %118, i32* %119
    %120 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %120
    br label %endif_13
endif_13:
    br label %endif_12
else_12:
    %121 = icmp eq i8 %23, 1
    br i1 %121 , label %then_14, label %else_14
then_14:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %122 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %123 = getelementptr inbounds [32 x i32], [32 x i32]* %122, i32 0, i8 %21
    %124 = load i32, i32* %123
    %125 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %126 = getelementptr inbounds [32 x i32], [32 x i32]* %125, i32 0, i8 %22
    %127 = load i32, i32* %126
    %128 = icmp ne i32 %124, %127
    br i1 %128 , label %then_15, label %endif_15
then_15:
    %129 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %130 = load i32, i32* %129
    %131 = bitcast i32 %130 to i32
    %132 = sext i16 %104 to i32
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
    %137 = icmp eq i8 %23, 4
    br i1 %137 , label %then_16, label %else_16
then_16:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %138 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %139 = getelementptr inbounds [32 x i32], [32 x i32]* %138, i32 0, i8 %21
    %140 = load i32, i32* %139
    %141 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %142 = getelementptr inbounds [32 x i32], [32 x i32]* %141, i32 0, i8 %22
    %143 = load i32, i32* %142
    %144 = icmp slt i32 %140, %143
    br i1 %144 , label %then_17, label %endif_17
then_17:
    %145 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %146 = load i32, i32* %145
    %147 = bitcast i32 %146 to i32
    %148 = sext i16 %104 to i32
    %149 = add i32 %147, %148
    %150 = bitcast i32 %149 to i32
    %151 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %150, i32* %151
    %152 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %152
    br label %endif_17
endif_17:
    br label %endif_16
else_16:
    %153 = icmp eq i8 %23, 5
    br i1 %153 , label %then_18, label %else_18
then_18:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %154 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %155 = getelementptr inbounds [32 x i32], [32 x i32]* %154, i32 0, i8 %21
    %156 = load i32, i32* %155
    %157 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %158 = getelementptr inbounds [32 x i32], [32 x i32]* %157, i32 0, i8 %22
    %159 = load i32, i32* %158
    %160 = icmp sge i32 %156, %159
    br i1 %160 , label %then_19, label %endif_19
then_19:
    %161 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %162 = load i32, i32* %161
    %163 = bitcast i32 %162 to i32
    %164 = sext i16 %104 to i32
    %165 = add i32 %163, %164
    %166 = bitcast i32 %165 to i32
    %167 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %166, i32* %167
    %168 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %168
    br label %endif_19
endif_19:
    br label %endif_18
else_18:
    %169 = icmp eq i8 %23, 6
    br i1 %169 , label %then_20, label %else_20
then_20:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %170 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %171 = getelementptr inbounds [32 x i32], [32 x i32]* %170, i32 0, i8 %21
    %172 = load i32, i32* %171
    %173 = bitcast i32 %172 to i32
    %174 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %175 = getelementptr inbounds [32 x i32], [32 x i32]* %174, i32 0, i8 %22
    %176 = load i32, i32* %175
    %177 = bitcast i32 %176 to i32
    %178 = icmp ult i32 %173, %177
    br i1 %178 , label %then_21, label %endif_21
then_21:
    %179 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %180 = load i32, i32* %179
    %181 = bitcast i32 %180 to i32
    %182 = sext i16 %104 to i32
    %183 = add i32 %181, %182
    %184 = bitcast i32 %183 to i32
    %185 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %184, i32* %185
    %186 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %186
    br label %endif_21
endif_21:
    br label %endif_20
else_20:
    %187 = icmp eq i8 %23, 7
    br i1 %187 , label %then_22, label %endif_22
then_22:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %188 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %189 = getelementptr inbounds [32 x i32], [32 x i32]* %188, i32 0, i8 %21
    %190 = load i32, i32* %189
    %191 = bitcast i32 %190 to i32
    %192 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %193 = getelementptr inbounds [32 x i32], [32 x i32]* %192, i32 0, i8 %22
    %194 = load i32, i32* %193
    %195 = bitcast i32 %194 to i32
    %196 = icmp uge i32 %191, %195
    br i1 %196 , label %then_23, label %else_23
then_23:
    %197 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %198 = load i32, i32* %197
    %199 = bitcast i32 %198 to i32
    %200 = sext i16 %104 to i32
    %201 = add i32 %199, %200
    %202 = bitcast i32 %201 to i32
    %203 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %202, i32* %203
    %204 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %204
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
    %205 = icmp eq i8 %19, 3
    br i1 %205 , label %then_24, label %else_24
then_24:
    %206 = call i32(i32) @extract_imm12 (i32 %18)
    %207 = call i32(i32) @expand12 (i32 %206)
    %208 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %209 = getelementptr inbounds [32 x i32], [32 x i32]* %208, i32 0, i8 %21
    %210 = load i32, i32* %209
    %211 = add i32 %210, %207
    %212 = bitcast i32 %211 to i32
    %213 = icmp eq i8 %23, 0
    br i1 %213 , label %then_25, label %else_25
then_25:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %214 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %215 = load %MemoryInterface*, %MemoryInterface** %214
    %216 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %215, i32 0, i32 0
    %217 = load i8(i32)*, i8(i32)** %216
    %218 = call i8(i32) %217 (i32 %212)
    %219 = sext i8 %218 to i32
    %220 = icmp ne i8 %20, 0
    br i1 %220 , label %then_26, label %endif_26
then_26:
    %221 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %222 = getelementptr inbounds [32 x i32], [32 x i32]* %221, i32 0, i8 %20
    store i32 %219, i32* %222
    br label %endif_26
endif_26:
    br label %endif_25
else_25:
    %223 = icmp eq i8 %23, 1
    br i1 %223 , label %then_27, label %else_27
then_27:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %224 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %225 = load %MemoryInterface*, %MemoryInterface** %224
    %226 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %225, i32 0, i32 1
    %227 = load i16(i32)*, i16(i32)** %226
    %228 = call i16(i32) %227 (i32 %212)
    %229 = sext i16 %228 to i32
    %230 = icmp ne i8 %20, 0
    br i1 %230 , label %then_28, label %endif_28
then_28:
    %231 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %232 = getelementptr inbounds [32 x i32], [32 x i32]* %231, i32 0, i8 %20
    store i32 %229, i32* %232
    br label %endif_28
endif_28:
    br label %endif_27
else_27:
    %233 = icmp eq i8 %23, 2
    br i1 %233 , label %then_29, label %else_29
then_29:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %234 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %235 = load %MemoryInterface*, %MemoryInterface** %234
    %236 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %235, i32 0, i32 2
    %237 = load i32(i32)*, i32(i32)** %236
    %238 = call i32(i32) %237 (i32 %212)
    %239 = bitcast i32 %238 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %240 = icmp ne i8 %20, 0
    br i1 %240 , label %then_30, label %endif_30
then_30:
    %241 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %242 = getelementptr inbounds [32 x i32], [32 x i32]* %241, i32 0, i8 %20
    store i32 %239, i32* %242
    br label %endif_30
endif_30:
    br label %endif_29
else_29:
    %243 = icmp eq i8 %23, 4
    br i1 %243 , label %then_31, label %else_31
then_31:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %244 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %245 = load %MemoryInterface*, %MemoryInterface** %244
    %246 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %245, i32 0, i32 0
    %247 = load i8(i32)*, i8(i32)** %246
    %248 = call i8(i32) %247 (i32 %212)
    %249 = zext i8 %248 to i32
    %250 = bitcast i32 %249 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %251 = icmp ne i8 %20, 0
    br i1 %251 , label %then_32, label %endif_32
then_32:
    %252 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %253 = getelementptr inbounds [32 x i32], [32 x i32]* %252, i32 0, i8 %20
    store i32 %250, i32* %253
    br label %endif_32
endif_32:
    br label %endif_31
else_31:
    %254 = icmp eq i8 %23, 5
    br i1 %254 , label %then_33, label %endif_33
then_33:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %255 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %256 = load %MemoryInterface*, %MemoryInterface** %255
    %257 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %256, i32 0, i32 1
    %258 = load i16(i32)*, i16(i32)** %257
    %259 = call i16(i32) %258 (i32 %212)
    %260 = zext i16 %259 to i32
    %261 = bitcast i32 %260 to i32
    %262 = icmp ne i8 %20, 0
    br i1 %262 , label %then_34, label %endif_34
then_34:
    %263 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %264 = getelementptr inbounds [32 x i32], [32 x i32]* %263, i32 0, i8 %20
    store i32 %261, i32* %264
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
    %265 = icmp eq i8 %19, 35
    br i1 %265 , label %then_35, label %else_35
then_35:
    %266 = call i8(i32) @extract_funct7 (i32 %18)
    %267 = zext i8 %266 to i32
    %268 = shl i32 %267, 5
    %269 = zext i8 %20 to i32
    %270 = or i32 %268, %269
    %271 = call i32(i32) @expand12 (i32 %270)
    %272 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %273 = getelementptr inbounds [32 x i32], [32 x i32]* %272, i32 0, i8 %21
    %274 = load i32, i32* %273
    %275 = add i32 %274, %271
    %276 = bitcast i32 %275 to i32
    %277 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %278 = getelementptr inbounds [32 x i32], [32 x i32]* %277, i32 0, i8 %22
    %279 = load i32, i32* %278
    %280 = icmp eq i8 %23, 0
    br i1 %280 , label %then_36, label %else_36
then_36:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %281 = trunc i32 %279 to i8
    %282 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %283 = load %MemoryInterface*, %MemoryInterface** %282
    %284 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %283, i32 0, i32 3
    %285 = load void(i32, i8)*, void(i32, i8)** %284
    call void(i32, i8) %285 (i32 %276, i8 %281)
    br label %endif_36
else_36:
    %286 = icmp eq i8 %23, 1
    br i1 %286 , label %then_37, label %else_37
then_37:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %287 = trunc i32 %279 to i16
    %288 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %289 = load %MemoryInterface*, %MemoryInterface** %288
    %290 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %289, i32 0, i32 4
    %291 = load void(i32, i16)*, void(i32, i16)** %290
    call void(i32, i16) %291 (i32 %276, i16 %287)
    br label %endif_37
else_37:
    %292 = icmp eq i8 %23, 2
    br i1 %292 , label %then_38, label %endif_38
then_38:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %293 = bitcast i32 %279 to i32
    %294 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %295 = load %MemoryInterface*, %MemoryInterface** %294
    %296 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %295, i32 0, i32 5
    %297 = load void(i32, i32)*, void(i32, i32)** %296
    call void(i32, i32) %297 (i32 %276, i32 %293)
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
endif_36:
    br label %endif_35
else_35:
    %298 = icmp eq i32 %18, 115
    br i1 %298 , label %then_39, label %else_39
then_39:
    ;printf("ECALL\n")
    %299 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @core_irq (%Core* %299, i32 8)
    br label %endif_39
else_39:
    %300 = icmp eq i32 %18, 1048691
    br i1 %300 , label %then_40, label %else_40
then_40:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_40
else_40:
    %302 = icmp eq i32 %18, 16777231
    br i1 %302 , label %then_41, label %else_41
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
    %303 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %304 = load i1, i1* %303
    br i1 %304 , label %then_42, label %else_42
then_42:
    %305 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %306 = load i32, i32* %305
    %307 = add i32 %306, 4
    %308 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %307, i32* %308
    br label %endif_42
else_42:
    %309 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %309
    br label %endif_42
endif_42:
    ret i1 1
}


