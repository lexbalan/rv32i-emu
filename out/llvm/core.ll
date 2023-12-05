
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



define void @core_init(%Core* %core, %MemoryInterface* %memctl, i32 %sp) {
    %1 = bitcast %Core* %core to i8*
    %2 = call i8*(i8*, i32, i64) @memset (i8* %1, i32 0, i64 168)
    %3 = bitcast %MemoryInterface* %memctl to %MemoryInterface*
    %4 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    store %MemoryInterface* %3, %MemoryInterface** %4
    %5 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %5
    %6 = bitcast i32 %sp to i32
    %7 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %8 = getelementptr inbounds [32 x i32], [32 x i32]* %7, i32 0, i32 2
    store i32 %6, i32* %8
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

define i32 @extract_imm12(i32 %instr) {
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
    %10 = sext i16 %9 to i32
    ret i32 %10
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
    ;let instr_adr = core.ip / 4
    ;let instr = core.text[instr_adr]
    %1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %2 = load i32, i32* %1
    %3 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %4 = load %MemoryInterface*, %MemoryInterface** %3
    %5 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %4, i32 0, i32 2
    %6 = load i32(i32)*, i32(i32)** %5
    %7 = call i32(i32) %6 (i32 %2)
    ret i32 %7
}


@cnt = global i32 zeroinitializer

define i1 @core_tick(%Core* %core) {
    %1 = bitcast %Core* %core to %Core*
    %2 = call i32(%Core*) @fetch (%Core* %1)
    %3 = lshr i32 %2, 24
    %4 = trunc i32 %3 to i8
    %5 = and i8 %4, 255
    %6 = lshr i32 %2, 16
    %7 = trunc i32 %6 to i8
    %8 = and i8 %7, 255
    %9 = lshr i32 %2, 8
    %10 = trunc i32 %9 to i8
    %11 = and i8 %10, 255
    %12 = lshr i32 %2, 0
    %13 = trunc i32 %12 to i8
    %14 = and i8 %13, 255
    ;printf("[%04x] %02x%02x%02x%02x ", core.ip, b0 to Nat32, b1 to Nat32, b2 to Nat32, b3 to Nat32)
    %15 = call i8(i32) @extract_op (i32 %2)
    %16 = call i8(i32) @extract_rd (i32 %2)
    %17 = call i8(i32) @extract_rs1 (i32 %2)
    %18 = call i8(i32) @extract_rs2 (i32 %2)
    %19 = call i8(i32) @extract_funct3 (i32 %2)
    br i1 0 , label %then_0, label %endif_0
then_0:
    ;printf("INSTR = 0x%x\n", instr)
    ;printf("OP = 0x%x\n", op)
    br label %endif_0
endif_0:
    %20 = icmp eq i8 %15, 19
    br i1 %20 , label %then_1, label %else_1
then_1:
    %21 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @i_type_op (%Core* %21, i32 %2)
    br label %endif_1
else_1:
    %22 = icmp eq i8 %15, 51
    br i1 %22 , label %then_2, label %else_2
then_2:
    %23 = bitcast %Core* %core to %Core*
    call void(%Core*, i32) @r_type_op (%Core* %23, i32 %2)
    br label %endif_2
else_2:
    %24 = icmp eq i8 %15, 55
    br i1 %24 , label %then_3, label %else_3
then_3:
    ; U-type
    %25 = call i32(i32) @extract_imm31_12 (i32 %2)
    ;printf("lui x%d, 0x%X\n", rd, imm)
    %26 = shl i32 %25, 12
    %27 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %28 = getelementptr inbounds [32 x i32], [32 x i32]* %27, i32 0, i8 %16
    store i32 %26, i32* %28
    br label %endif_3
else_3:
    %29 = icmp eq i8 %15, 23
    br i1 %29 , label %then_4, label %else_4
then_4:
    ; U-type
    %30 = call i32(i32) @extract_imm31_12 (i32 %2)
    %31 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %32 = load i32, i32* %31
    %33 = bitcast i32 %32 to i32
    %34 = shl i32 %30, 12
    %35 = add i32 %33, %34
    %36 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %37 = getelementptr inbounds [32 x i32], [32 x i32]* %36, i32 0, i8 %16
    store i32 %35, i32* %37
    ;printf("auipc x%d, 0x%X\n", rd, imm)
    br label %endif_4
else_4:
    %38 = icmp eq i8 %15, 111
    br i1 %38 , label %then_5, label %else_5
then_5:
    ; U-type
    %39 = call i32(i32) @extract_imm31_12 (i32 %2)
    %40 = bitcast i32 %39 to i32
    %41 = call i32(i32) @jal_imm_recode (i32 %40)
    %42 = call i32(i32) @expand20 (i32 %41)
    ;printf("jal x%d, %d\n", rd, imm)
    %43 = icmp ne i8 %16, 0
    br i1 %43 , label %then_6, label %endif_6
then_6:
    %44 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %45 = load i32, i32* %44
    %46 = add i32 %45, 4
    %47 = bitcast i32 %46 to i32
    %48 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %49 = getelementptr inbounds [32 x i32], [32 x i32]* %48, i32 0, i8 %16
    store i32 %47, i32* %49
    br label %endif_6
endif_6:
    %50 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %51 = load i32, i32* %50
    %52 = bitcast i32 %51 to i32
    %53 = add i32 %52, %42
    %54 = bitcast i32 %53 to i32
    %55 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %54, i32* %55
    %56 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %56
    br label %endif_5
else_5:
    %57 = icmp eq i8 %15, 103
    %58 = icmp eq i8 %19, 0
    %59 = and i1 %57, %58
    br i1 %59 , label %then_7, label %else_7
then_7:
    %60 = call i32(i32) @extract_imm12 (i32 %2)
    ;printf("jalr %d(x%d)\n", imm, rs1)
    ; pc <- (rs1 + imm) & ~1
    ; rd <- pc + 4
    %61 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %62 = load i32, i32* %61
    %63 = add i32 %62, 4
    %64 = bitcast i32 %63 to i32
    %65 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %66 = getelementptr inbounds [32 x i32], [32 x i32]* %65, i32 0, i8 %17
    %67 = load i32, i32* %66
    %68 = add i32 %67, %60
    %69 = bitcast i32 %68 to i32
    %70 = and i32 %69, 4294967294
    %71 = icmp ne i8 %16, 0
    br i1 %71 , label %then_8, label %endif_8
then_8:
    %72 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %73 = getelementptr inbounds [32 x i32], [32 x i32]* %72, i32 0, i8 %16
    store i32 %64, i32* %73
    br label %endif_8
endif_8:
    %74 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %70, i32* %74
    %75 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 0, i1* %75
    br label %endif_7
else_7:
    %76 = icmp eq i8 %15, 99
    br i1 %76 , label %then_9, label %else_9
then_9:
    %77 = call i8(i32) @extract_funct7 (i32 %2)
    %78 = call i8(i32) @extract_rd (i32 %2)
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
    br i1 %95 , label %then_10, label %endif_10
then_10:
    %96 = load i16, i16* %bits
    %97 = or i16 61440, %96
    store i16 %97, i16* %bits
    br label %endif_10
endif_10:
    %98 = load i16, i16* %bits
    %99 = bitcast i16 %98 to i16
    %100 = icmp eq i8 %19, 0
    br i1 %100 , label %then_11, label %else_11
then_11:
    ;beq
    ;printf("beq x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %101 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %102 = getelementptr inbounds [32 x i32], [32 x i32]* %101, i32 0, i8 %17
    %103 = load i32, i32* %102
    %104 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %105 = getelementptr inbounds [32 x i32], [32 x i32]* %104, i32 0, i8 %18
    %106 = load i32, i32* %105
    %107 = icmp eq i32 %103, %106
    br i1 %107 , label %then_12, label %endif_12
then_12:
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
    br label %endif_12
endif_12:
    br label %endif_11
else_11:
    %116 = icmp eq i8 %19, 1
    br i1 %116 , label %then_13, label %else_13
then_13:
    ;bne
    ;printf("bne x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %117 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %118 = getelementptr inbounds [32 x i32], [32 x i32]* %117, i32 0, i8 %17
    %119 = load i32, i32* %118
    %120 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %121 = getelementptr inbounds [32 x i32], [32 x i32]* %120, i32 0, i8 %18
    %122 = load i32, i32* %121
    %123 = icmp ne i32 %119, %122
    br i1 %123 , label %then_14, label %endif_14
then_14:
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
    br label %endif_14
endif_14:
    br label %endif_13
else_13:
    %132 = icmp eq i8 %19, 4
    br i1 %132 , label %then_15, label %else_15
then_15:
    ;blt
    ;printf("blt x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %133 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %134 = getelementptr inbounds [32 x i32], [32 x i32]* %133, i32 0, i8 %17
    %135 = load i32, i32* %134
    %136 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %137 = getelementptr inbounds [32 x i32], [32 x i32]* %136, i32 0, i8 %18
    %138 = load i32, i32* %137
    %139 = icmp slt i32 %135, %138
    br i1 %139 , label %then_16, label %endif_16
then_16:
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
    br label %endif_16
endif_16:
    br label %endif_15
else_15:
    %148 = icmp eq i8 %19, 5
    br i1 %148 , label %then_17, label %else_17
then_17:
    ;bge
    ;printf("bge x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %149 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %150 = getelementptr inbounds [32 x i32], [32 x i32]* %149, i32 0, i8 %17
    %151 = load i32, i32* %150
    %152 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %153 = getelementptr inbounds [32 x i32], [32 x i32]* %152, i32 0, i8 %18
    %154 = load i32, i32* %153
    %155 = icmp sge i32 %151, %154
    br i1 %155 , label %then_18, label %endif_18
then_18:
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
    br label %endif_18
endif_18:
    br label %endif_17
else_17:
    %164 = icmp eq i8 %19, 6
    br i1 %164 , label %then_19, label %else_19
then_19:
    ;bltu
    ;printf("bltu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %165 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %166 = getelementptr inbounds [32 x i32], [32 x i32]* %165, i32 0, i8 %17
    %167 = load i32, i32* %166
    %168 = bitcast i32 %167 to i32
    %169 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %170 = getelementptr inbounds [32 x i32], [32 x i32]* %169, i32 0, i8 %18
    %171 = load i32, i32* %170
    %172 = bitcast i32 %171 to i32
    %173 = icmp ult i32 %168, %172
    br i1 %173 , label %then_20, label %endif_20
then_20:
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
    br label %endif_20
endif_20:
    br label %endif_19
else_19:
    %182 = icmp eq i8 %19, 7
    br i1 %182 , label %then_21, label %endif_21
then_21:
    ;bgeu
    ;printf("bgeu x%d, x%d, %d\n", rs1, rs2, imm to Int32)
    %183 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %184 = getelementptr inbounds [32 x i32], [32 x i32]* %183, i32 0, i8 %17
    %185 = load i32, i32* %184
    %186 = bitcast i32 %185 to i32
    %187 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %188 = getelementptr inbounds [32 x i32], [32 x i32]* %187, i32 0, i8 %18
    %189 = load i32, i32* %188
    %190 = bitcast i32 %189 to i32
    %191 = icmp uge i32 %186, %190
    br i1 %191 , label %then_22, label %else_22
then_22:
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
    br label %endif_22
else_22:
    br label %endif_22
endif_22:
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
endif_11:
    br label %endif_9
else_9:
    %200 = icmp eq i8 %15, 3
    br i1 %200 , label %then_23, label %else_23
then_23:
    %201 = call i32(i32) @extract_imm12 (i32 %2)
    %202 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %203 = getelementptr inbounds [32 x i32], [32 x i32]* %202, i32 0, i8 %17
    %204 = load i32, i32* %203
    %205 = add i32 %204, %201
    %206 = bitcast i32 %205 to i32
    %207 = icmp eq i8 %19, 0
    br i1 %207 , label %then_24, label %else_24
then_24:
    ; lb
    ;printf("lb x%d, %d(x%d)\n", rd, imm, rs1)
    %208 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %209 = load %MemoryInterface*, %MemoryInterface** %208
    %210 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %209, i32 0, i32 0
    %211 = load i8(i32)*, i8(i32)** %210
    %212 = call i8(i32) %211 (i32 %206)
    %213 = sext i8 %212 to i32
    %214 = icmp ne i8 %16, 0
    br i1 %214 , label %then_25, label %endif_25
then_25:
    %215 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %216 = getelementptr inbounds [32 x i32], [32 x i32]* %215, i32 0, i8 %16
    store i32 %213, i32* %216
    br label %endif_25
endif_25:
    br label %endif_24
else_24:
    %217 = icmp eq i8 %19, 1
    br i1 %217 , label %then_26, label %else_26
then_26:
    ; lh
    ;printf("lh x%d, %d(x%d)\n", rd, imm, rs1)
    %218 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %219 = load %MemoryInterface*, %MemoryInterface** %218
    %220 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %219, i32 0, i32 1
    %221 = load i16(i32)*, i16(i32)** %220
    %222 = call i16(i32) %221 (i32 %206)
    %223 = sext i16 %222 to i32
    %224 = icmp ne i8 %16, 0
    br i1 %224 , label %then_27, label %endif_27
then_27:
    %225 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %226 = getelementptr inbounds [32 x i32], [32 x i32]* %225, i32 0, i8 %16
    store i32 %223, i32* %226
    br label %endif_27
endif_27:
    br label %endif_26
else_26:
    %227 = icmp eq i8 %19, 2
    br i1 %227 , label %then_28, label %else_28
then_28:
    ; lw
    ;printf("lw x%d, %d(x%d)\n", rd, imm, rs1)
    %228 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %229 = load %MemoryInterface*, %MemoryInterface** %228
    %230 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %229, i32 0, i32 2
    %231 = load i32(i32)*, i32(i32)** %230
    %232 = call i32(i32) %231 (i32 %206)
    %233 = bitcast i32 %232 to i32
    ;printf("LW [0x%x] (0x%x)\n", adr, val)
    %234 = icmp ne i8 %16, 0
    br i1 %234 , label %then_29, label %endif_29
then_29:
    %235 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %236 = getelementptr inbounds [32 x i32], [32 x i32]* %235, i32 0, i8 %16
    store i32 %233, i32* %236
    br label %endif_29
endif_29:
    br label %endif_28
else_28:
    %237 = icmp eq i8 %19, 4
    br i1 %237 , label %then_30, label %else_30
then_30:
    ; lbu
    ;printf("lbu x%d, %d(x%d)\n", rd, imm, rs1)
    %238 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %239 = load %MemoryInterface*, %MemoryInterface** %238
    %240 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %239, i32 0, i32 0
    %241 = load i8(i32)*, i8(i32)** %240
    %242 = call i8(i32) %241 (i32 %206)
    %243 = zext i8 %242 to i32
    %244 = bitcast i32 %243 to i32
    ;printf("LBU[0x%x] (0x%x)\n", adr, val)
    %245 = icmp ne i8 %16, 0
    br i1 %245 , label %then_31, label %endif_31
then_31:
    %246 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %247 = getelementptr inbounds [32 x i32], [32 x i32]* %246, i32 0, i8 %16
    store i32 %244, i32* %247
    br label %endif_31
endif_31:
    br label %endif_30
else_30:
    %248 = icmp eq i8 %19, 5
    br i1 %248 , label %then_32, label %endif_32
then_32:
    ; lhu
    ;printf("lhu x%d, %d(x%d)\n", rd, imm, rs1)
    %249 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %250 = load %MemoryInterface*, %MemoryInterface** %249
    %251 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %250, i32 0, i32 1
    %252 = load i16(i32)*, i16(i32)** %251
    %253 = call i16(i32) %252 (i32 %206)
    %254 = zext i16 %253 to i32
    %255 = bitcast i32 %254 to i32
    %256 = icmp ne i8 %16, 0
    br i1 %256 , label %then_33, label %endif_33
then_33:
    %257 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %258 = getelementptr inbounds [32 x i32], [32 x i32]* %257, i32 0, i8 %16
    store i32 %255, i32* %258
    br label %endif_33
endif_33:
    br label %endif_32
endif_32:
    br label %endif_30
endif_30:
    br label %endif_28
endif_28:
    br label %endif_26
endif_26:
    br label %endif_24
endif_24:
    br label %endif_23
else_23:
    %259 = icmp eq i8 %15, 35
    br i1 %259 , label %then_34, label %else_34
then_34:
    %260 = call i8(i32) @extract_funct7 (i32 %2)
    %261 = zext i8 %260 to i16
    %262 = shl i16 %261, 5
    %263 = zext i8 %16 to i16
    %264 = or i16 %262, %263
    %265 = call i16(i16) @expand12 (i16 %264)
    %266 = sext i16 %265 to i32
    %267 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %268 = getelementptr inbounds [32 x i32], [32 x i32]* %267, i32 0, i8 %17
    %269 = load i32, i32* %268
    %270 = add i32 %269, %266
    %271 = bitcast i32 %270 to i32
    %272 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
    %273 = getelementptr inbounds [32 x i32], [32 x i32]* %272, i32 0, i8 %18
    %274 = load i32, i32* %273
    %275 = icmp eq i8 %19, 0
    br i1 %275 , label %then_35, label %else_35
then_35:
    ; sb
    ;printf("sb x%d, %d(x%d)\n", rs2, imm, rs1)
    %276 = trunc i32 %274 to i8
    %277 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %278 = load %MemoryInterface*, %MemoryInterface** %277
    %279 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %278, i32 0, i32 3
    %280 = load void(i32, i8)*, void(i32, i8)** %279
    call void(i32, i8) %280 (i32 %271, i8 %276)
    br label %endif_35
else_35:
    %281 = icmp eq i8 %19, 1
    br i1 %281 , label %then_36, label %else_36
then_36:
    ; sh
    ;printf("sh x%d, %d(x%d)\n", rs2, imm, rs1)
    %282 = trunc i32 %274 to i16
    %283 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %284 = load %MemoryInterface*, %MemoryInterface** %283
    %285 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %284, i32 0, i32 4
    %286 = load void(i32, i16)*, void(i32, i16)** %285
    call void(i32, i16) %286 (i32 %271, i16 %282)
    br label %endif_36
else_36:
    %287 = icmp eq i8 %19, 2
    br i1 %287 , label %then_37, label %endif_37
then_37:
    ; sw
    ;printf("sw x%d, %d(x%d)\n", rs2, imm, rs1)
    %288 = bitcast i32 %274 to i32
    %289 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 4
    %290 = load %MemoryInterface*, %MemoryInterface** %289
    %291 = getelementptr inbounds %MemoryInterface, %MemoryInterface* %290, i32 0, i32 5
    %292 = load void(i32, i32)*, void(i32, i32)** %291
    call void(i32, i32) %292 (i32 %271, i32 %288)
    br label %endif_37
endif_37:
    br label %endif_36
endif_36:
    br label %endif_35
endif_35:
    br label %endif_34
else_34:
    %293 = icmp eq i32 %2, 115
    br i1 %293 , label %then_38, label %else_38
then_38:
    ;printf("ECALL\n")
    br label %endif_38
else_38:
    %294 = icmp eq i32 %2, 1048691
    br i1 %294 , label %then_39, label %else_39
then_39:
    ;printf("EBREAK\n")
    ret i1 0
    br label %endif_39
else_39:
    %296 = icmp eq i32 %2, 16777231
    br i1 %296 , label %then_40, label %else_40
then_40:
    ;printf("PAUSE\n")
    br label %endif_40
else_40:
    %297 = icmp eq i32 %2, 0
    br i1 %297 , label %then_41, label %else_41
then_41:
    ;printf("\n\n* * * STOP\n")
    ret i1 0
    br label %endif_41
else_41:
    ;printf("UNKNOWN OPCODE: %08X\n", op)
    br label %endif_41
endif_41:
    br label %endif_40
endif_40:
    br label %endif_39
endif_39:
    br label %endif_38
endif_38:
    br label %endif_34
endif_34:
    br label %endif_23
endif_23:
    br label %endif_9
endif_9:
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
    %299 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    %300 = load i1, i1* %299
    br i1 %300 , label %then_42, label %else_42
then_42:
    %301 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    %302 = load i32, i32* %301
    %303 = add i32 %302, 4
    %304 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 1
    store i32 %303, i32* %304
    br label %endif_42
else_42:
    %305 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 3
    store i1 1, i1* %305
    br label %endif_42
endif_42:
    ret i1 1
}


