
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




; -- SOURCE: src/mem.cm

@str1 = private constant [30 x i8] [i8 77, i8 69, i8 77, i8 79, i8 82, i8 89, i8 32, i8 86, i8 73, i8 79, i8 76, i8 65, i8 84, i8 73, i8 79, i8 78, i8 32, i8 39, i8 37, i8 99, i8 39, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str2 = private constant [3 x i8] [i8 37, i8 99, i8 0]



@rom = global [65536 x i8] zeroinitializer
@ram = global [256 x i8] zeroinitializer

define [0 x i8]* @get_ram_ptr() {
    %1 = bitcast [256 x i8]* @ram to [0 x i8]*
    ret [0 x i8]* %1
}

define [0 x i8]* @get_rom_ptr() {
    %1 = bitcast [65536 x i8]* @rom to [0 x i8]*
    ret [0 x i8]* %1
}


declare void @exit(i32)

define void @mem_violation(i8 %rw, i32 %adr) {
    %1 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([30 x i8]* @str1 to [0 x i8]*), i8 %rw, i32 %adr)
    call void(i32) @exit (i32 1)
    ret void
}

define i8 @vm_mem_read8(i32 %adr) {
    %x = alloca i8
    store i8 0, i8* %x
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268435712
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i8*
    %8 = load i8, i8* %7
    store i8 %8, i8* %x
    br label %endif_0
else_0:
    %9 = icmp uge i32 %adr, 4027318272
    %10 = icmp ule i32 %adr, 4027383807
    %11 = and i1 %9, %10
    br i1 %11 , label %then_1, label %else_1
then_1:
    store i8 0, i8* %x
    br label %endif_1
else_1:
    %12 = icmp uge i32 %adr, 0
    %13 = icmp ule i32 %adr, 65536
    %14 = and i1 %12, %13
    br i1 %14 , label %then_2, label %else_2
then_2:
    %15 = sub i32 %adr, 0
    %16 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %15
    %17 = bitcast i8* %16 to i8*
    %18 = bitcast i8* %17 to i8*
    %19 = load i8, i8* %18
    store i8 %19, i8* %x
    br label %endif_2
else_2:
    call void(i8, i32) @mem_violation (i8 114, i32 %adr)
    store i8 0, i8* %x
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;	printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)
    %20 = load i8, i8* %x
    ret i8 %20
}

define i16 @vm_mem_read16(i32 %adr) {
    %x = alloca i16
    store i16 0, i16* %x
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268435712
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i16*
    %8 = load i16, i16* %7
    store i16 %8, i16* %x
    br label %endif_0
else_0:
    %9 = icmp uge i32 %adr, 4027318272
    %10 = icmp ule i32 %adr, 4027383807
    %11 = and i1 %9, %10
    br i1 %11 , label %then_1, label %else_1
then_1:
    store i16 0, i16* %x
    br label %endif_1
else_1:
    %12 = icmp uge i32 %adr, 0
    %13 = icmp ule i32 %adr, 65536
    %14 = and i1 %12, %13
    br i1 %14 , label %then_2, label %else_2
then_2:
    %15 = sub i32 %adr, 0
    %16 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %15
    %17 = bitcast i8* %16 to i8*
    %18 = bitcast i8* %17 to i16*
    %19 = load i16, i16* %18
    store i16 %19, i16* %x
    br label %endif_2
else_2:
    call void(i8, i32) @mem_violation (i8 114, i32 %adr)
    store i16 0, i16* %x
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
    %20 = load i16, i16* %x
    ret i16 %20
}

define i32 @vm_mem_read32(i32 %adr) {
    %x = alloca i32
    store i32 0, i32* %x
    %1 = icmp uge i32 %adr, 0
    %2 = icmp ule i32 %adr, 65536
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 0
    %5 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i32*
    %8 = load i32, i32* %7
    store i32 %8, i32* %x
    br label %endif_0
else_0:
    %9 = icmp uge i32 %adr, 268435456
    %10 = icmp ule i32 %adr, 268435712
    %11 = and i1 %9, %10
    br i1 %11 , label %then_1, label %else_1
then_1:
    %12 = sub i32 %adr, 268435456
    %13 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %12
    %14 = bitcast i8* %13 to i8*
    %15 = bitcast i8* %14 to i32*
    %16 = load i32, i32* %15
    store i32 %16, i32* %x
    br label %endif_1
else_1:
    %17 = icmp uge i32 %adr, 4027318272
    %18 = icmp ule i32 %adr, 4027383807
    %19 = and i1 %17, %18
    br i1 %19 , label %then_2, label %else_2
then_2:
    store i32 0, i32* %x
    br label %endif_2
else_2:
    call void(i8, i32) @mem_violation (i8 114, i32 %adr)
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_READ_32[%x] = 0x%x\n", adr, x)
    %20 = load i32, i32* %x
    ret i32 %20
}

define void @vm_mem_write8(i32 %adr, i8 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268435712
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i8*
    store i8 %value, i8* %7
    br label %endif_0
else_0:
    %8 = icmp uge i32 %adr, 4027318272
    %9 = icmp ule i32 %adr, 4027383807
    %10 = and i1 %8, %9
    br i1 %10 , label %then_1, label %else_1
then_1:
    %11 = icmp eq i32 %adr, 4027318288
    br i1 %11 , label %then_2, label %endif_2
then_2:
    %12 = bitcast i8 %value to i8
    %13 = call i32(%ConstCharStr*, ...) @printf (%ConstCharStr* bitcast ([3 x i8]* @str2 to [0 x i8]*), i8 %12)
    ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    call void(i8, i32) @mem_violation (i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write16(i32 %adr, i16 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268435712
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i16*
    store i16 %value, i16* %7
    br label %endif_0
else_0:
    %8 = icmp uge i32 %adr, 4027318272
    %9 = icmp ule i32 %adr, 4027383807
    %10 = and i1 %8, %9
    br i1 %10 , label %then_1, label %else_1
then_1:
    %11 = icmp eq i32 %adr, 4027318288
    br i1 %11 , label %then_2, label %endif_2
then_2:
    %12 = sext i16 %value to i32
    %13 = call i32(i32) @putchar (i32 %12)
    ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    call void(i8, i32) @mem_violation (i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write32(i32 %adr, i32 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268435712
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [256 x i8], [256 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i32*
    store i32 %value, i32* %7
    br label %endif_0
else_0:
    %8 = icmp uge i32 %adr, 4027318272
    %9 = icmp ule i32 %adr, 4027383807
    %10 = and i1 %8, %9
    br i1 %10 , label %then_1, label %else_1
then_1:
    %11 = icmp eq i32 %adr, 4027318288
    br i1 %11 , label %then_2, label %endif_2
then_2:
    %12 = bitcast i32 %value to i32
    %13 = call i32(i32) @putchar (i32 %12)
    ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    call void(i8, i32) @mem_violation (i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
    ret void
}


