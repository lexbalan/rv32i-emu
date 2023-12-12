
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
	i32,
	i1,
	i32,
	%MemoryInterface*
}













; -- SOURCE: src/core.cm

@str1 = private constant [17 x i8] [i8 70, i8 65, i8 84, i8 65, i8 76, i8 58, i8 32, i8 120, i8 48, i8 32, i8 33, i8 61, i8 32, i8 48, i8 33, i8 10, i8 0]


define void @core_init(%Core* %core, %MemoryInterface* %memctl) {
    %1 = bitcast %Core* %core to i8*
    %2 = call i8*(i8*, i32, i64) @memset (i8* %1, i32 0, i64 160)
    %3 = bitcast %MemoryInterface* %memctl to %MemoryInterface*
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    store %MemoryInterface* %3, %MemoryInterface** %4
    %5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 1, i1* %5
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
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %12 = load %MemoryInterface*, %MemoryInterface** %11
    %13 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %12, i32 0, i32 2
    %14 = load i32(i32)*, i32(i32)** %13
    %15 = call i32(i32) %14 (i32 %10)
    %16 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %17 = load i32, i32* %16
    %18 = add i32 %17, 1
    %19 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i32 %18, i32* %19
    ; assert
    %20 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %21 = getelementptr inbounds [32 x i32], [32 x i32]* %20, i32 0, i32 0
    %22 = load i32, i32* %21
    %23 = icmp ne i32 %22, 0
    br i1 %23 , label %then_1, label %endif_1
then_1:
    %24 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str1 to [0 x i8]*))
    call void(i32) @exit (i32 1)
    br label %endif_1
endif_1:
    ;printf("X8 = %x\n", core.reg[8]);
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;    //printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %25 = call i8(i32) @extract_op (i32 %15)
    %26 = call i8(i32) @extract_rd (i32 %15)
    %27 = call i8(i32) @extract_rs1 (i32 %15)
    %28 = call i8(i32) @extract_rs2 (i32 %15)
    %29 = call i8(i32) @extract_funct3 (i32 %15)
    br i1 0 , label %then_2, label %endif_2
then_2:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_2
endif_2:
    %30 = icmp eq i8 %25, 19
    br i1 %30 , label %then_3, label %else_3
then_3:
    %31 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %31, i32 %15)
    br label %endif_3
else_3:
    %32 = icmp eq i8 %25, 51
    br i1 %32 , label %then_4, label %else_4
then_4:
    %33 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %33, i32 %15)
    br label %endif_4
else_4:
    %34 = icmp eq i8 %25, 55
    br i1 %34 , label %then_5, label %else_5
then_5:
    ; U-type
    %35 = call i32(i32) @extract_imm31_12 (i32 %15)
    %36 = call i32(i32) @expand12 (i32 %35)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %37 = shl i32 %36, 12
    %38 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %39 = getelementptr inbounds [32 x i32], [32 x i32]* %38, i32 0, i8 %26
    store i32 %37, i32* %39
    br label %endif_5
else_5:
    %40 = icmp eq i8 %25, 23
    br i1 %40 , label %then_6, label %else_6
then_6:
    ; U-type
    %41 = call i32(i32) @extract_imm31_12 (i32 %15)
    %42 = call i32(i32) @expand12 (i32 %41)
    %43 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %44 = load i32, i32* %43
    %45 = bitcast i32 %44 to i32
    %46 = shl i32 %42, 12
    %47 = add i32 %45, %46
    %48 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %49 = getelementptr inbounds [32 x i32], [32 x i32]* %48, i32 0, i8 %26
    store i32 %47, i32* %49
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_6
else_6:
    %50 = icmp eq i8 %25, 111
    br i1 %50 , label %then_7, label %else_7
then_7:
    ; U-type
    %51 = call i32(i32) @extract_jal_imm (i32 %15)
    %52 = call i32(i32) @expand20 (i32 %51)
    ;printf("jal x%d, %d\n", rd, imm)
    %53 = icmp ne i8 %26, 0
    br i1 %53 , label %then_8, label %endif_8
then_8:
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %55 = load i32, i32* %54
    %56 = add i32 %55, 4
    %57 = bitcast i32 %56 to i32
    %58 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %59 = getelementptr inbounds [32 x i32], [32 x i32]* %58, i32 0, i8 %26
    store i32 %57, i32* %59
    br label %endif_8
endif_8:
    %60 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %61 = load i32, i32* %60
    %62 = bitcast i32 %61 to i32
    %63 = add i32 %62, %52
    %64 = bitcast i32 %63 to i32
    %65 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %64, i32* %65
    %66 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %66
    br label %endif_7
else_7:
    %67 = icmp eq i8 %25, 103
    %68 = icmp eq i8 %29, 0
    %69 = and i1 %67, %68
    br i1 %69 , label %then_9, label %else_9
then_9:
    %70 = call i32(i32) @extract_imm12 (i32 %15)
    %71 = call i32(i32) @expand12 (i32 %70)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %73 = load i32, i32* %72
    %74 = add i32 %73, 4
    %75 = bitcast i32 %74 to i32
    %76 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %77 = getelementptr inbounds [32 x i32], [32 x i32]* %76, i32 0, i8 %27
    %78 = load i32, i32* %77
    %79 = add i32 %78, %71
    %80 = bitcast i32 %79 to i32
    %81 = and i32 %80, 4294967294
    %82 = icmp ne i8 %26, 0
    br i1 %82 , label %then_10, label %endif_10
then_10:
    %83 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %84 = getelementptr inbounds [32 x i32], [32 x i32]* %83, i32 0, i8 %26
    store i32 %75, i32* %84
    br label %endif_10
endif_10:
    %85 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %81, i32* %85
    %86 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %86
    br label %endif_9
else_9:
    %87 = icmp eq i8 %25, 99
    br i1 %87 , label %then_11, label %else_11
then_11:
    %88 = call i8(i32) @extract_funct7 (i32 %15)
    %89 = call i8(i32) @extract_rd (i32 %15)
    %90 = and i8 %89, 30
    %91 = zext i8 %90 to i16
    %92 = and i8 %88, 63
    %93 = zext i8 %92 to i16
    %94 = shl i16 %93, 5
    %95 = and i8 %89, 1
    %96 = zext i8 %95 to i16
    %97 = shl i16 %96, 11
    %98 = and i8 %88, 64
    %99 = zext i8 %98 to i16
    %100 = shl i16 %99, 6
    %101 = or i16 %94, %91
    %102 = or i16 %97, %101
    %103 = or i16 %100, %102
    %bits = alloca i16
    store i16 %103, i16* %bits
    ; распространяем знак, если он есть
    %104 = load i16, i16* %bits
    %105 = and i16 %104, 4096
    %106 = icmp ne i16 %105, 0
    br i1 %106 , label %then_12, label %endif_12
then_12:
    %107 = load i16, i16* %bits
    %108 = or i16 61440, %107
    store i16 %108, i16* %bits
    br label %endif_12
endif_12:
    %109 = load i16, i16* %bits
    %110 = bitcast i16 %109 to i16
    %111 = icmp eq i8 %29, 0
    br i1 %111 , label %then_13, label %else_13
then_13:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %112 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %113 = getelementptr inbounds [32 x i32], [32 x i32]* %112, i32 0, i8 %27
    %114 = load i32, i32* %113
    %115 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %116 = getelementptr inbounds [32 x i32], [32 x i32]* %115, i32 0, i8 %28
    %117 = load i32, i32* %116
    %118 = icmp eq i32 %114, %117
    br i1 %118 , label %then_14, label %endif_14
then_14:
    %119 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %120 = load i32, i32* %119
    %121 = bitcast i32 %120 to i32
    %122 = sext i16 %110 to i32
    %123 = add i32 %121, %122
    %124 = bitcast i32 %123 to i32
    %125 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %124, i32* %125
    %126 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %126
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %127 = icmp eq i8 %29, 1
    br i1 %127 , label %then_15, label %else_15
then_15:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %128 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %129 = getelementptr inbounds [32 x i32], [32 x i32]* %128, i32 0, i8 %27
    %130 = load i32, i32* %129
    %131 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %132 = getelementptr inbounds [32 x i32], [32 x i32]* %131, i32 0, i8 %28
    %133 = load i32, i32* %132
    %134 = icmp ne i32 %130, %133
    br i1 %134 , label %then_16, label %endif_16
then_16:
    %135 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %136 = load i32, i32* %135
    %137 = bitcast i32 %136 to i32
    %138 = sext i16 %110 to i32
    %139 = add i32 %137, %138
    %140 = bitcast i32 %139 to i32
    %141 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %140, i32* %141
    %142 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %142
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %143 = icmp eq i8 %29, 4
    br i1 %143 , label %then_17, label %else_17
then_17:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %144 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %145 = getelementptr inbounds [32 x i32], [32 x i32]* %144, i32 0, i8 %27
    %146 = load i32, i32* %145
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %148 = getelementptr inbounds [32 x i32], [32 x i32]* %147, i32 0, i8 %28
    %149 = load i32, i32* %148
    %150 = icmp slt i32 %146, %149
    br i1 %150 , label %then_18, label %endif_18
then_18:
    %151 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %152 = load i32, i32* %151
    %153 = bitcast i32 %152 to i32
    %154 = sext i16 %110 to i32
    %155 = add i32 %153, %154
    %156 = bitcast i32 %155 to i32
    %157 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %156, i32* %157
    %158 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %158
    br label %endif_18
endif_18:
    br label %endif_17
else_17:
    %159 = icmp eq i8 %29, 5
    br i1 %159 , label %then_19, label %else_19
then_19:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %160 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %161 = getelementptr inbounds [32 x i32], [32 x i32]* %160, i32 0, i8 %27
    %162 = load i32, i32* %161
    %163 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %164 = getelementptr inbounds [32 x i32], [32 x i32]* %163, i32 0, i8 %28
    %165 = load i32, i32* %164
    %166 = icmp sge i32 %162, %165
    br i1 %166 , label %then_20, label %endif_20
then_20:
    %167 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %168 = load i32, i32* %167
    %169 = bitcast i32 %168 to i32
    %170 = sext i16 %110 to i32
    %171 = add i32 %169, %170
    %172 = bitcast i32 %171 to i32
    %173 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %172, i32* %173
    %174 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %174
    br label %endif_20
endif_20:
    br label %endif_19
else_19:
    %175 = icmp eq i8 %29, 6
    br i1 %175 , label %then_21, label %else_21
then_21:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %176 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %177 = getelementptr inbounds [32 x i32], [32 x i32]* %176, i32 0, i8 %27
    %178 = load i32, i32* %177
    %179 = bitcast i32 %178 to i32
    %180 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %181 = getelementptr inbounds [32 x i32], [32 x i32]* %180, i32 0, i8 %28
    %182 = load i32, i32* %181
    %183 = bitcast i32 %182 to i32
    %184 = icmp ult i32 %179, %183
    br i1 %184 , label %then_22, label %endif_22
then_22:
    %185 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %186 = load i32, i32* %185
    %187 = bitcast i32 %186 to i32
    %188 = sext i16 %110 to i32
    %189 = add i32 %187, %188
    %190 = bitcast i32 %189 to i32
    %191 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %190, i32* %191
    %192 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %192
    br label %endif_22
endif_22:
    br label %endif_21
else_21:
    %193 = icmp eq i8 %29, 7
    br i1 %193 , label %then_23, label %endif_23
then_23:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %194 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %195 = getelementptr inbounds [32 x i32], [32 x i32]* %194, i32 0, i8 %27
    %196 = load i32, i32* %195
    %197 = bitcast i32 %196 to i32
    %198 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %199 = getelementptr inbounds [32 x i32], [32 x i32]* %198, i32 0, i8 %28
    %200 = load i32, i32* %199
    %201 = bitcast i32 %200 to i32
    %202 = icmp uge i32 %197, %201
    br i1 %202 , label %then_24, label %else_24
then_24:
    %203 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %204 = load i32, i32* %203
    %205 = bitcast i32 %204 to i32
    %206 = sext i16 %110 to i32
    %207 = add i32 %205, %206
    %208 = bitcast i32 %207 to i32
    %209 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %208, i32* %209
    %210 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 0, i1* %210
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
    %211 = icmp eq i8 %25, 3
    br i1 %211 , label %then_25, label %else_25
then_25:
    %212 = call i32(i32) @extract_imm12 (i32 %15)
    %213 = call i32(i32) @expand12 (i32 %212)
    %214 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %215 = getelementptr inbounds [32 x i32], [32 x i32]* %214, i32 0, i8 %27
    %216 = load i32, i32* %215
    %217 = add i32 %216, %213
    %218 = bitcast i32 %217 to i32
    %219 = icmp eq i8 %29, 0
    br i1 %219 , label %then_26, label %else_26
then_26:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %220 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %221 = load %MemoryInterface*, %MemoryInterface** %220
    %222 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %221, i32 0, i32 0
    %223 = load i8(i32)*, i8(i32)** %222
    %224 = call i8(i32) %223 (i32 %218)
    %225 = sext i8 %224 to i32
    %226 = icmp ne i8 %26, 0
    br i1 %226 , label %then_27, label %endif_27
then_27:
    %227 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %228 = getelementptr inbounds [32 x i32], [32 x i32]* %227, i32 0, i8 %26
    store i32 %225, i32* %228
    br label %endif_27
endif_27:
    br label %endif_26
else_26:
    %229 = icmp eq i8 %29, 1
    br i1 %229 , label %then_28, label %else_28
then_28:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %230 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %231 = load %MemoryInterface*, %MemoryInterface** %230
    %232 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %231, i32 0, i32 1
    %233 = load i16(i32)*, i16(i32)** %232
    %234 = call i16(i32) %233 (i32 %218)
    %235 = sext i16 %234 to i32
    %236 = icmp ne i8 %26, 0
    br i1 %236 , label %then_29, label %endif_29
then_29:
    %237 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %238 = getelementptr inbounds [32 x i32], [32 x i32]* %237, i32 0, i8 %26
    store i32 %235, i32* %238
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %239 = icmp eq i8 %29, 2
    br i1 %239 , label %then_30, label %else_30
then_30:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %240 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %241 = load %MemoryInterface*, %MemoryInterface** %240
    %242 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %241, i32 0, i32 2
    %243 = load i32(i32)*, i32(i32)** %242
    %244 = call i32(i32) %243 (i32 %218)
    %245 = bitcast i32 %244 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %246 = icmp ne i8 %26, 0
    br i1 %246 , label %then_31, label %endif_31
then_31:
    %247 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %248 = getelementptr inbounds [32 x i32], [32 x i32]* %247, i32 0, i8 %26
    store i32 %245, i32* %248
    br label %endif_31
endif_31:
    br label %endif_30
else_30:
    %249 = icmp eq i8 %29, 4
    br i1 %249 , label %then_32, label %else_32
then_32:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %250 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %251 = load %MemoryInterface*, %MemoryInterface** %250
    %252 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %251, i32 0, i32 0
    %253 = load i8(i32)*, i8(i32)** %252
    %254 = call i8(i32) %253 (i32 %218)
    %255 = zext i8 %254 to i32
    %256 = bitcast i32 %255 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %257 = icmp ne i8 %26, 0
    br i1 %257 , label %then_33, label %endif_33
then_33:
    %258 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %259 = getelementptr inbounds [32 x i32], [32 x i32]* %258, i32 0, i8 %26
    store i32 %256, i32* %259
    br label %endif_33
endif_33:
    br label %endif_32
else_32:
    %260 = icmp eq i8 %29, 5
    br i1 %260 , label %then_34, label %endif_34
then_34:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %261 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %262 = load %MemoryInterface*, %MemoryInterface** %261
    %263 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %262, i32 0, i32 1
    %264 = load i16(i32)*, i16(i32)** %263
    %265 = call i16(i32) %264 (i32 %218)
    %266 = zext i16 %265 to i32
    %267 = bitcast i32 %266 to i32
    %268 = icmp ne i8 %26, 0
    br i1 %268 , label %then_35, label %endif_35
then_35:
    %269 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %270 = getelementptr inbounds [32 x i32], [32 x i32]* %269, i32 0, i8 %26
    store i32 %267, i32* %270
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
    %271 = icmp eq i8 %25, 35
    br i1 %271 , label %then_36, label %else_36
then_36:
    %272 = call i8(i32) @extract_funct7 (i32 %15)
    %273 = zext i8 %272 to i32
    %274 = shl i32 %273, 5
    %275 = zext i8 %26 to i32
    %276 = or i32 %274, %275
    %277 = call i32(i32) @expand12 (i32 %276)
    %278 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %279 = getelementptr inbounds [32 x i32], [32 x i32]* %278, i32 0, i8 %27
    %280 = load i32, i32* %279
    %281 = add i32 %280, %277
    %282 = bitcast i32 %281 to i32
    %283 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %284 = getelementptr inbounds [32 x i32], [32 x i32]* %283, i32 0, i8 %28
    %285 = load i32, i32* %284
    %286 = icmp eq i8 %29, 0
    br i1 %286 , label %then_37, label %else_37
then_37:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %287 = trunc i32 %285 to i8
    %288 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %289 = load %MemoryInterface*, %MemoryInterface** %288
    %290 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %289, i32 0, i32 3
    %291 = load void(i32, i8)*, void(i32, i8)** %290
    call void(i32, i8) %291 (i32 %282, i8 %287)
    br label %endif_37
else_37:
    %292 = icmp eq i8 %29, 1
    br i1 %292 , label %then_38, label %else_38
then_38:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %293 = trunc i32 %285 to i16
    %294 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %295 = load %MemoryInterface*, %MemoryInterface** %294
    %296 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %295, i32 0, i32 4
    %297 = load void(i32, i16)*, void(i32, i16)** %296
    call void(i32, i16) %297 (i32 %282, i16 %293)
    br label %endif_38
else_38:
    %298 = icmp eq i8 %29, 2
    br i1 %298 , label %then_39, label %endif_39
then_39:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %299 = bitcast i32 %285 to i32
    %300 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 6
    %301 = load %MemoryInterface*, %MemoryInterface** %300
    %302 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %301, i32 0, i32 5
    %303 = load void(i32, i32)*, void(i32, i32)** %302
    call void(i32, i32) %303 (i32 %282, i32 %299)
    br label %endif_39
endif_39:
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
else_36:
    %304 = icmp eq i32 %15, 115
    br i1 %304 , label %then_40, label %else_40
then_40:
    ;printf("ECALL\n")
    %305 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @core_irq (%Core* %305, i32 8)
    br label %endif_40
else_40:
    %306 = icmp eq i32 %15, 1048691
    br i1 %306 , label %then_41, label %else_41
then_41:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_41
else_41:
    %308 = icmp eq i32 %15, 16777231
    br i1 %308 , label %then_42, label %else_42
then_42:
    ;printf("PAUSE\n")
    br label %endif_42
else_42:
    ;printf("UNKNOWN OPCODE: %08X\n", op)
    br label %endif_42
endif_42:
    br label %endif_41
endif_41:
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
    %309 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %310 = load i1, i1* %309
    br i1 %310 , label %then_43, label %else_43
then_43:
    %311 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %312 = load i32, i32* %311
    %313 = add i32 %312, 4
    %314 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %313, i32* %314
    br label %endif_43
else_43:
    %315 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store i1 1, i1* %315
    br label %endif_43
endif_43:
    ret i1 1
}


