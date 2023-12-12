
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

@str1 = private constant [17 x i8] [i8 70, i8 65, i8 84, i8 65, i8 76, i8 58, i8 32, i8 120, i8 48, i8 32, i8 33, i8 61, i8 32, i8 48, i8 33, i8 10, i8 0]


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
    %11 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %12 = load %MemoryInterface*, %MemoryInterface** %11
    %13 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %12, i32 0, i32 2
    %14 = load i32(i32)*, i32(i32)** %13
    %15 = call i32(i32) %14 (i32 %10)
    ; assert
    %16 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %17 = getelementptr inbounds [32 x i32], [32 x i32]* %16, i32 0, i32 0
    %18 = load i32, i32* %17
    %19 = icmp ne i32 %18, 0
    br i1 %19 , label %then_1, label %endif_1
then_1:
    %20 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([17 x i8]* @str1 to [0 x i8]*))
    call void(i32) @exit (i32 1)
    br label %endif_1
endif_1:
    ;printf("X8 = %x\n", core.reg[8]);
    ;let b3 = ((instr >> 24) to Nat8) and 0xFF
    ;let b2 = ((instr >> 16) to Nat8) and 0xFF
    ;let b1 = ((instr >> 8) to Nat8) and 0xFF
    ;let b0 = ((instr >> 0) to Nat8) and 0xFF
    ;    //printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %21 = call i8(i32) @extract_op (i32 %15)
    %22 = call i8(i32) @extract_rd (i32 %15)
    %23 = call i8(i32) @extract_rs1 (i32 %15)
    %24 = call i8(i32) @extract_rs2 (i32 %15)
    %25 = call i8(i32) @extract_funct3 (i32 %15)
    br i1 0 , label %then_2, label %endif_2
then_2:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_2
endif_2:
    %26 = icmp eq i8 %21, 19
    br i1 %26 , label %then_3, label %else_3
then_3:
    %27 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %27, i32 %15)
    br label %endif_3
else_3:
    %28 = icmp eq i8 %21, 51
    br i1 %28 , label %then_4, label %else_4
then_4:
    %29 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %29, i32 %15)
    br label %endif_4
else_4:
    %30 = icmp eq i8 %21, 55
    br i1 %30 , label %then_5, label %else_5
then_5:
    ; U-type
    %31 = call i32(i32) @extract_imm31_12 (i32 %15)
    %32 = call i32(i32) @expand12 (i32 %31)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %33 = shl i32 %32, 12
    %34 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %35 = getelementptr inbounds [32 x i32], [32 x i32]* %34, i32 0, i8 %22
    store i32 %33, i32* %35
    br label %endif_5
else_5:
    %36 = icmp eq i8 %21, 23
    br i1 %36 , label %then_6, label %else_6
then_6:
    ; U-type
    %37 = call i32(i32) @extract_imm31_12 (i32 %15)
    %38 = call i32(i32) @expand12 (i32 %37)
    %39 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %40 = load i32, i32* %39
    %41 = bitcast i32 %40 to i32
    %42 = shl i32 %38, 12
    %43 = add i32 %41, %42
    %44 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %45 = getelementptr inbounds [32 x i32], [32 x i32]* %44, i32 0, i8 %22
    store i32 %43, i32* %45
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_6
else_6:
    %46 = icmp eq i8 %21, 111
    br i1 %46 , label %then_7, label %else_7
then_7:
    ; U-type
    %47 = call i32(i32) @extract_jal_imm (i32 %15)
    %48 = call i32(i32) @expand20 (i32 %47)
    ;printf("jal x%d, %d\n", rd, imm)
    %49 = icmp ne i8 %22, 0
    br i1 %49 , label %then_8, label %endif_8
then_8:
    %50 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %51 = load i32, i32* %50
    %52 = add i32 %51, 4
    %53 = bitcast i32 %52 to i32
    %54 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %55 = getelementptr inbounds [32 x i32], [32 x i32]* %54, i32 0, i8 %22
    store i32 %53, i32* %55
    br label %endif_8
endif_8:
    %56 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %57 = load i32, i32* %56
    %58 = bitcast i32 %57 to i32
    %59 = add i32 %58, %48
    %60 = bitcast i32 %59 to i32
    %61 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %60, i32* %61
    %62 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %62
    br label %endif_7
else_7:
    %63 = icmp eq i8 %21, 103
    %64 = icmp eq i8 %25, 0
    %65 = and i1 %63, %64
    br i1 %65 , label %then_9, label %else_9
then_9:
    %66 = call i32(i32) @extract_imm12 (i32 %15)
    %67 = call i32(i32) @expand12 (i32 %66)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; rd <- pc + 4
    ; pc <- (rs1 + imm) & ~1
    %68 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %69 = load i32, i32* %68
    %70 = add i32 %69, 4
    %71 = bitcast i32 %70 to i32
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %23
    %74 = load i32, i32* %73
    %75 = add i32 %74, %67
    %76 = bitcast i32 %75 to i32
    %77 = and i32 %76, 4294967294
    %78 = icmp ne i8 %22, 0
    br i1 %78 , label %then_10, label %endif_10
then_10:
    %79 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %80 = getelementptr inbounds [32 x i32], [32 x i32]* %79, i32 0, i8 %22
    store i32 %71, i32* %80
    br label %endif_10
endif_10:
    %81 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %77, i32* %81
    %82 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %82
    br label %endif_9
else_9:
    %83 = icmp eq i8 %21, 99
    br i1 %83 , label %then_11, label %else_11
then_11:
    %84 = call i8(i32) @extract_funct7 (i32 %15)
    %85 = call i8(i32) @extract_rd (i32 %15)
    %86 = and i8 %85, 30
    %87 = zext i8 %86 to i16
    %88 = and i8 %84, 63
    %89 = zext i8 %88 to i16
    %90 = shl i16 %89, 5
    %91 = and i8 %85, 1
    %92 = zext i8 %91 to i16
    %93 = shl i16 %92, 11
    %94 = and i8 %84, 64
    %95 = zext i8 %94 to i16
    %96 = shl i16 %95, 6
    %97 = or i16 %90, %87
    %98 = or i16 %93, %97
    %99 = or i16 %96, %98
    %bits = alloca i16
    store i16 %99, i16* %bits
    ; распространяем знак, если он есть
    %100 = load i16, i16* %bits
    %101 = and i16 %100, 4096
    %102 = icmp ne i16 %101, 0
    br i1 %102 , label %then_12, label %endif_12
then_12:
    %103 = load i16, i16* %bits
    %104 = or i16 61440, %103
    store i16 %104, i16* %bits
    br label %endif_12
endif_12:
    %105 = load i16, i16* %bits
    %106 = bitcast i16 %105 to i16
    %107 = icmp eq i8 %25, 0
    br i1 %107 , label %then_13, label %else_13
then_13:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %108 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %109 = getelementptr inbounds [32 x i32], [32 x i32]* %108, i32 0, i8 %23
    %110 = load i32, i32* %109
    %111 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %112 = getelementptr inbounds [32 x i32], [32 x i32]* %111, i32 0, i8 %24
    %113 = load i32, i32* %112
    %114 = icmp eq i32 %110, %113
    br i1 %114 , label %then_14, label %endif_14
then_14:
    %115 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %116 = load i32, i32* %115
    %117 = bitcast i32 %116 to i32
    %118 = sext i16 %106 to i32
    %119 = add i32 %117, %118
    %120 = bitcast i32 %119 to i32
    %121 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %120, i32* %121
    %122 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %122
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %123 = icmp eq i8 %25, 1
    br i1 %123 , label %then_15, label %else_15
then_15:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %124 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %125 = getelementptr inbounds [32 x i32], [32 x i32]* %124, i32 0, i8 %23
    %126 = load i32, i32* %125
    %127 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %128 = getelementptr inbounds [32 x i32], [32 x i32]* %127, i32 0, i8 %24
    %129 = load i32, i32* %128
    %130 = icmp ne i32 %126, %129
    br i1 %130 , label %then_16, label %endif_16
then_16:
    %131 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %132 = load i32, i32* %131
    %133 = bitcast i32 %132 to i32
    %134 = sext i16 %106 to i32
    %135 = add i32 %133, %134
    %136 = bitcast i32 %135 to i32
    %137 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %136, i32* %137
    %138 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %138
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %139 = icmp eq i8 %25, 4
    br i1 %139 , label %then_17, label %else_17
then_17:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %140 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %141 = getelementptr inbounds [32 x i32], [32 x i32]* %140, i32 0, i8 %23
    %142 = load i32, i32* %141
    %143 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %144 = getelementptr inbounds [32 x i32], [32 x i32]* %143, i32 0, i8 %24
    %145 = load i32, i32* %144
    %146 = icmp slt i32 %142, %145
    br i1 %146 , label %then_18, label %endif_18
then_18:
    %147 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %148 = load i32, i32* %147
    %149 = bitcast i32 %148 to i32
    %150 = sext i16 %106 to i32
    %151 = add i32 %149, %150
    %152 = bitcast i32 %151 to i32
    %153 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %152, i32* %153
    %154 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %154
    br label %endif_18
endif_18:
    br label %endif_17
else_17:
    %155 = icmp eq i8 %25, 5
    br i1 %155 , label %then_19, label %else_19
then_19:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %156 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %157 = getelementptr inbounds [32 x i32], [32 x i32]* %156, i32 0, i8 %23
    %158 = load i32, i32* %157
    %159 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %160 = getelementptr inbounds [32 x i32], [32 x i32]* %159, i32 0, i8 %24
    %161 = load i32, i32* %160
    %162 = icmp sge i32 %158, %161
    br i1 %162 , label %then_20, label %endif_20
then_20:
    %163 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %164 = load i32, i32* %163
    %165 = bitcast i32 %164 to i32
    %166 = sext i16 %106 to i32
    %167 = add i32 %165, %166
    %168 = bitcast i32 %167 to i32
    %169 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %168, i32* %169
    %170 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %170
    br label %endif_20
endif_20:
    br label %endif_19
else_19:
    %171 = icmp eq i8 %25, 6
    br i1 %171 , label %then_21, label %else_21
then_21:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %172 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %173 = getelementptr inbounds [32 x i32], [32 x i32]* %172, i32 0, i8 %23
    %174 = load i32, i32* %173
    %175 = bitcast i32 %174 to i32
    %176 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %177 = getelementptr inbounds [32 x i32], [32 x i32]* %176, i32 0, i8 %24
    %178 = load i32, i32* %177
    %179 = bitcast i32 %178 to i32
    %180 = icmp ult i32 %175, %179
    br i1 %180 , label %then_22, label %endif_22
then_22:
    %181 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %182 = load i32, i32* %181
    %183 = bitcast i32 %182 to i32
    %184 = sext i16 %106 to i32
    %185 = add i32 %183, %184
    %186 = bitcast i32 %185 to i32
    %187 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %186, i32* %187
    %188 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %188
    br label %endif_22
endif_22:
    br label %endif_21
else_21:
    %189 = icmp eq i8 %25, 7
    br i1 %189 , label %then_23, label %endif_23
then_23:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %190 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %191 = getelementptr inbounds [32 x i32], [32 x i32]* %190, i32 0, i8 %23
    %192 = load i32, i32* %191
    %193 = bitcast i32 %192 to i32
    %194 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %195 = getelementptr inbounds [32 x i32], [32 x i32]* %194, i32 0, i8 %24
    %196 = load i32, i32* %195
    %197 = bitcast i32 %196 to i32
    %198 = icmp uge i32 %193, %197
    br i1 %198 , label %then_24, label %else_24
then_24:
    %199 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %200 = load i32, i32* %199
    %201 = bitcast i32 %200 to i32
    %202 = sext i16 %106 to i32
    %203 = add i32 %201, %202
    %204 = bitcast i32 %203 to i32
    %205 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %204, i32* %205
    %206 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %206
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
    %207 = icmp eq i8 %21, 3
    br i1 %207 , label %then_25, label %else_25
then_25:
    %208 = call i32(i32) @extract_imm12 (i32 %15)
    %209 = call i32(i32) @expand12 (i32 %208)
    %210 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %211 = getelementptr inbounds [32 x i32], [32 x i32]* %210, i32 0, i8 %23
    %212 = load i32, i32* %211
    %213 = add i32 %212, %209
    %214 = bitcast i32 %213 to i32
    %215 = icmp eq i8 %25, 0
    br i1 %215 , label %then_26, label %else_26
then_26:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %216 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %217 = load %MemoryInterface*, %MemoryInterface** %216
    %218 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %217, i32 0, i32 0
    %219 = load i8(i32)*, i8(i32)** %218
    %220 = call i8(i32) %219 (i32 %214)
    %221 = sext i8 %220 to i32
    %222 = icmp ne i8 %22, 0
    br i1 %222 , label %then_27, label %endif_27
then_27:
    %223 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %224 = getelementptr inbounds [32 x i32], [32 x i32]* %223, i32 0, i8 %22
    store i32 %221, i32* %224
    br label %endif_27
endif_27:
    br label %endif_26
else_26:
    %225 = icmp eq i8 %25, 1
    br i1 %225 , label %then_28, label %else_28
then_28:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %226 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %227 = load %MemoryInterface*, %MemoryInterface** %226
    %228 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %227, i32 0, i32 1
    %229 = load i16(i32)*, i16(i32)** %228
    %230 = call i16(i32) %229 (i32 %214)
    %231 = sext i16 %230 to i32
    %232 = icmp ne i8 %22, 0
    br i1 %232 , label %then_29, label %endif_29
then_29:
    %233 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %234 = getelementptr inbounds [32 x i32], [32 x i32]* %233, i32 0, i8 %22
    store i32 %231, i32* %234
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %235 = icmp eq i8 %25, 2
    br i1 %235 , label %then_30, label %else_30
then_30:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %236 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %237 = load %MemoryInterface*, %MemoryInterface** %236
    %238 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %237, i32 0, i32 2
    %239 = load i32(i32)*, i32(i32)** %238
    %240 = call i32(i32) %239 (i32 %214)
    %241 = bitcast i32 %240 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %242 = icmp ne i8 %22, 0
    br i1 %242 , label %then_31, label %endif_31
then_31:
    %243 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %244 = getelementptr inbounds [32 x i32], [32 x i32]* %243, i32 0, i8 %22
    store i32 %241, i32* %244
    br label %endif_31
endif_31:
    br label %endif_30
else_30:
    %245 = icmp eq i8 %25, 4
    br i1 %245 , label %then_32, label %else_32
then_32:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %246 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %247 = load %MemoryInterface*, %MemoryInterface** %246
    %248 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %247, i32 0, i32 0
    %249 = load i8(i32)*, i8(i32)** %248
    %250 = call i8(i32) %249 (i32 %214)
    %251 = zext i8 %250 to i32
    %252 = bitcast i32 %251 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %253 = icmp ne i8 %22, 0
    br i1 %253 , label %then_33, label %endif_33
then_33:
    %254 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %255 = getelementptr inbounds [32 x i32], [32 x i32]* %254, i32 0, i8 %22
    store i32 %252, i32* %255
    br label %endif_33
endif_33:
    br label %endif_32
else_32:
    %256 = icmp eq i8 %25, 5
    br i1 %256 , label %then_34, label %endif_34
then_34:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %257 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %258 = load %MemoryInterface*, %MemoryInterface** %257
    %259 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %258, i32 0, i32 1
    %260 = load i16(i32)*, i16(i32)** %259
    %261 = call i16(i32) %260 (i32 %214)
    %262 = zext i16 %261 to i32
    %263 = bitcast i32 %262 to i32
    %264 = icmp ne i8 %22, 0
    br i1 %264 , label %then_35, label %endif_35
then_35:
    %265 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %266 = getelementptr inbounds [32 x i32], [32 x i32]* %265, i32 0, i8 %22
    store i32 %263, i32* %266
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
    %267 = icmp eq i8 %21, 35
    br i1 %267 , label %then_36, label %else_36
then_36:
    %268 = call i8(i32) @extract_funct7 (i32 %15)
    %269 = zext i8 %268 to i32
    %270 = shl i32 %269, 5
    %271 = zext i8 %22 to i32
    %272 = or i32 %270, %271
    %273 = call i32(i32) @expand12 (i32 %272)
    %274 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %275 = getelementptr inbounds [32 x i32], [32 x i32]* %274, i32 0, i8 %23
    %276 = load i32, i32* %275
    %277 = add i32 %276, %273
    %278 = bitcast i32 %277 to i32
    %279 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %280 = getelementptr inbounds [32 x i32], [32 x i32]* %279, i32 0, i8 %24
    %281 = load i32, i32* %280
    %282 = icmp eq i8 %25, 0
    br i1 %282 , label %then_37, label %else_37
then_37:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %283 = trunc i32 %281 to i8
    %284 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %285 = load %MemoryInterface*, %MemoryInterface** %284
    %286 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %285, i32 0, i32 3
    %287 = load void(i32, i8)*, void(i32, i8)** %286
    call void(i32, i8) %287 (i32 %278, i8 %283)
    br label %endif_37
else_37:
    %288 = icmp eq i8 %25, 1
    br i1 %288 , label %then_38, label %else_38
then_38:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %289 = trunc i32 %281 to i16
    %290 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %291 = load %MemoryInterface*, %MemoryInterface** %290
    %292 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %291, i32 0, i32 4
    %293 = load void(i32, i16)*, void(i32, i16)** %292
    call void(i32, i16) %293 (i32 %278, i16 %289)
    br label %endif_38
else_38:
    %294 = icmp eq i8 %25, 2
    br i1 %294 , label %then_39, label %endif_39
then_39:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %295 = bitcast i32 %281 to i32
    %296 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 5
    %297 = load %MemoryInterface*, %MemoryInterface** %296
    %298 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %297, i32 0, i32 5
    %299 = load void(i32, i32)*, void(i32, i32)** %298
    call void(i32, i32) %299 (i32 %278, i32 %295)
    br label %endif_39
endif_39:
    br label %endif_38
endif_38:
    br label %endif_37
endif_37:
    br label %endif_36
else_36:
    %300 = icmp eq i32 %15, 115
    br i1 %300 , label %then_40, label %else_40
then_40:
    ;printf("ECALL\n")
    %301 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @core_irq (%Core* %301, i32 8)
    br label %endif_40
else_40:
    %302 = icmp eq i32 %15, 1048691
    br i1 %302 , label %then_41, label %else_41
then_41:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_41
else_41:
    %304 = icmp eq i32 %15, 16777231
    br i1 %304 , label %then_42, label %else_42
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
    %305 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %306 = load i1, i1* %305
    br i1 %306 , label %then_43, label %else_43
then_43:
    %307 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %308 = load i32, i32* %307
    %309 = add i32 %308, 4
    %310 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %309, i32* %310
    br label %endif_43
else_43:
    %311 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %311
    br label %endif_43
endif_43:
    ret i1 1
}


