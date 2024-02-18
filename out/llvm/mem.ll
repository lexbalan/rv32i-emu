
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


; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/mem.hm





; -- SOURCE: src/mem.cm

@str1 = private constant [30 x i8] [i8 77, i8 69, i8 77, i8 79, i8 82, i8 89, i8 32, i8 86, i8 73, i8 79, i8 76, i8 65, i8 84, i8 73, i8 79, i8 78, i8 32, i8 39, i8 37, i8 99, i8 39, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str2 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str3 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str4 = private constant [3 x i8] [i8 37, i8 117, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 120, i8 0]
@str6 = private constant [3 x i8] [i8 37, i8 120, i8 0]



@rom = global [65536 x i8] zeroinitializer
@ram = global [4096 x i8] zeroinitializer

define [0 x i8]* @get_ram_ptr() {
    %1 = bitcast [4096 x i8]* @ram to [0 x i8]*
    ret [0 x i8]* %1
}

define [0 x i8]* @get_rom_ptr() {
    %1 = bitcast [65536 x i8]* @rom to [0 x i8]*
    ret [0 x i8]* %1
}


declare void @exit(i32 %code)
declare void @mem_violation_event(i32 %reason)

define void @mem_violation(i8 %rw, i32 %adr) {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str1 to [0 x i8]*), i8 %rw, i32 %adr)
    call void (i32) @mem_violation_event(i32 85)
    ret void
}

define i8 @vm_mem_read8(i32 %adr) {
    %1 = alloca i8
    store i8 0, i8* %1
    %2 = icmp uge i32 %adr, 268435456
    %3 = icmp ule i32 %adr, 268439552
    %4 = and i1 %2, %3
    br i1 %4 , label %then_0, label %else_0
then_0:
    %5 = sub i32 %adr, 268435456
    %6 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %5
    %7 = bitcast i8* %6 to i8*
    %8 = bitcast i8* %7 to i8*
    %9 = load i8, i8* %8
    store i8 %9, i8* %1
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 4027318272
    %11 = icmp ule i32 %adr, 4027383807
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    store i8 0, i8* %1
    br label %endif_1
else_1:
    %13 = icmp uge i32 %adr, 0
    %14 = icmp ule i32 %adr, 65536
    %15 = and i1 %13, %14
    br i1 %15 , label %then_2, label %else_2
then_2:
    %16 = sub i32 %adr, 0
    %17 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %16
    %18 = bitcast i8* %17 to i8*
    %19 = bitcast i8* %18 to i8*
    %20 = load i8, i8* %19
    store i8 %20, i8* %1
    br label %endif_2
else_2:
    call void (i8, i32) @mem_violation(i8 114, i32 %adr)
    store i8 0, i8* %1
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;	printf("MEM_READ_8[%x] = 0x%x\n", adr, x to Nat32)
    %21 = load i8, i8* %1
    ret i8 %21
}

define i16 @vm_mem_read16(i32 %adr) {
    %1 = alloca i16
    store i16 0, i16* %1
    %2 = icmp uge i32 %adr, 268435456
    %3 = icmp ule i32 %adr, 268439552
    %4 = and i1 %2, %3
    br i1 %4 , label %then_0, label %else_0
then_0:
    %5 = sub i32 %adr, 268435456
    %6 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %5
    %7 = bitcast i8* %6 to i8*
    %8 = bitcast i8* %7 to i16*
    %9 = load i16, i16* %8
    store i16 %9, i16* %1
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 4027318272
    %11 = icmp ule i32 %adr, 4027383807
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    store i16 0, i16* %1
    br label %endif_1
else_1:
    %13 = icmp uge i32 %adr, 0
    %14 = icmp ule i32 %adr, 65536
    %15 = and i1 %13, %14
    br i1 %15 , label %then_2, label %else_2
then_2:
    %16 = sub i32 %adr, 0
    %17 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %16
    %18 = bitcast i8* %17 to i8*
    %19 = bitcast i8* %18 to i16*
    %20 = load i16, i16* %19
    store i16 %20, i16* %1
    br label %endif_2
else_2:
    call void (i8, i32) @mem_violation(i8 114, i32 %adr)
    store i16 0, i16* %1
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_READ_16[%x] = 0x%x\n", adr, x to Nat32)
    %21 = load i16, i16* %1
    ret i16 %21
}

define i32 @vm_mem_read32(i32 %adr) {
    %1 = alloca i32
    store i32 0, i32* %1
    %2 = icmp uge i32 %adr, 0
    %3 = icmp ule i32 %adr, 65536
    %4 = and i1 %2, %3
    br i1 %4 , label %then_0, label %else_0
then_0:
    %5 = sub i32 %adr, 0
    %6 = getelementptr inbounds [65536 x i8], [65536 x i8]* @rom, i32 0, i32 %5
    %7 = bitcast i8* %6 to i8*
    %8 = bitcast i8* %7 to i32*
    %9 = load i32, i32* %8
    store i32 %9, i32* %1
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 268435456
    %11 = icmp ule i32 %adr, 268439552
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    %13 = sub i32 %adr, 268435456
    %14 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %13
    %15 = bitcast i8* %14 to i8*
    %16 = bitcast i8* %15 to i32*
    %17 = load i32, i32* %16
    store i32 %17, i32* %1
    br label %endif_1
else_1:
    %18 = icmp uge i32 %adr, 4027318272
    %19 = icmp ule i32 %adr, 4027383807
    %20 = and i1 %18, %19
    br i1 %20 , label %then_2, label %else_2
then_2:
    store i32 0, i32* %1
    br label %endif_2
else_2:
    call void (i8, i32) @mem_violation(i8 114, i32 %adr)
    br label %endif_2
endif_2:
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_READ_32[%x] = 0x%x\n", adr, x)
    %21 = load i32, i32* %1
    ret i32 %21
}

define void @vm_mem_write8(i32 %adr, i8 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268439552
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %4
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
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str2 to [0 x i8]*), i8 %12)ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    call void (i8, i32) @mem_violation(i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write16(i32 %adr, i16 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268439552
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %4
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
    %12 = sext i16 %value to %Int
    %13 = call %Int (%Int) @putchar(%Int %12)ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    call void (i8, i32) @mem_violation(i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write32(i32 %adr, i32 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268439552
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [4096 x i8], [4096 x i8]* @ram, i32 0, i32 %4
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
    br i1 %11 , label %then_2, label %else_2
then_2:
    %12 = bitcast i32 %value to %Int
    %13 = call %Int (%Int) @putchar(%Int %12)ret void
    br label %endif_2
else_2:
    %15 = icmp eq i32 %adr, 4027318304
    br i1 %15 , label %then_3, label %else_3
then_3:
    %16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*), i32 %value)ret void
    br label %endif_3
else_3:
    %18 = icmp eq i32 %adr, 4027318308
    br i1 %18 , label %then_4, label %else_4
then_4:
    %19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*), i32 %value)ret void
    br label %endif_4
else_4:
    %21 = icmp eq i32 %adr, 4027318312
    br i1 %21 , label %then_5, label %else_5
then_5:
    %22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32 %value)ret void
    br label %endif_5
else_5:
    %24 = icmp eq i32 %adr, 4027318316
    br i1 %24 , label %then_6, label %endif_6
then_6:
    %25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str6 to [0 x i8]*), i32 %value)ret void
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
else_1:
    call void (i8, i32) @mem_violation(i8 119, i32 %adr)
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ;printf("MEM_WRITE_32[%x] = 0x%x\n", adr, value)
    ret void
}


