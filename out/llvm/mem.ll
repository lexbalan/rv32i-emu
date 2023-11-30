
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




@ram = global [32768 x i8] zeroinitializer

define [0 x i8]* @get_ram_ptr() {
    %1 = bitcast [32768 x i8]* @ram to [0 x i8]*
    ret [0 x i8]* %1
}

define i8 @vm_mem_read8(i32 %adr) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i8*
    %8 = load i8, i8* %7
    ret i8 %8
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 4027318272
    %11 = icmp ule i32 %adr, 4027383807
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    ret i8 0
    br label %endif_1
else_1:
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i8 0
}

define i16 @vm_mem_read16(i32 %adr) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i16*
    %8 = load i16, i16* %7
    ret i16 %8
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 4027318272
    %11 = icmp ule i32 %adr, 4027383807
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    ret i16 0
    br label %endif_1
else_1:
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i16 0
}

define i32 @vm_mem_read32(i32 %adr) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
    %6 = bitcast i8* %5 to i8*
    %7 = bitcast i8* %6 to i32*
    %8 = load i32, i32* %7
    ret i32 %8
    br label %endif_0
else_0:
    %10 = icmp uge i32 %adr, 4027318272
    %11 = icmp ule i32 %adr, 4027383807
    %12 = and i1 %10, %11
    br i1 %12 , label %then_1, label %else_1
then_1:
    ret i32 0
    br label %endif_1
else_1:
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret i32 0
}

define void @vm_mem_write8(i32 %adr, i8 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
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
    %12 = sext i8 %value to i32
    %13 = call i32(i32) @putchar (i32 %12)
    ret void
    br label %endif_2
endif_2:
    br label %endif_1
else_1:
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write16(i32 %adr, i16 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
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
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}

define void @vm_mem_write32(i32 %adr, i32 %value) {
    %1 = icmp uge i32 %adr, 268435456
    %2 = icmp ule i32 %adr, 268468224
    %3 = and i1 %1, %2
    br i1 %3 , label %then_0, label %else_0
then_0:
    %4 = sub i32 %adr, 268435456
    %5 = getelementptr inbounds [32768 x i8], [32768 x i8]* @ram, i32 0, i32 %4
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
    ; memory voilation
    br label %endif_1
endif_1:
    br label %endif_0
endif_0:
    ret void
}


