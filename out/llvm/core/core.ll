
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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
%__VA_List = type i8*
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

; MODULE: core

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included ctypes
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; from included unistd
declare %Int @access([0 x %ConstChar]* %path, %Int %amode)
declare %UnsignedInt @alarm(%UnsignedInt %seconds)
declare %Int @brk(i8* %end_data_segment)
declare %Int @chdir([0 x %ConstChar]* %path)
declare %Int @chroot([0 x %ConstChar]* %path)
declare %Int @chown([0 x %ConstChar]* %pathname, %UIDT %owner, %GIDT %group)
declare %Int @close(%Int %fildes)
declare %SizeT @confstr(%Int %name, [0 x %Char]* %buf, %SizeT %len)
declare [0 x %Char]* @crypt([0 x %ConstChar]* %key, [0 x %ConstChar]* %salt)
declare [0 x %Char]* @ctermid([0 x %Char]* %s)
declare [0 x %Char]* @cuserid([0 x %Char]* %s)
declare %Int @dup(%Int %fildes)
declare %Int @dup2(%Int %fildes, %Int %fildes2)
declare void @encrypt([64 x %Char]* %block, %Int %edflag)
declare %Int @execl([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execle([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execlp([0 x %ConstChar]* %file, [0 x %ConstChar]* %arg0, ...)
declare %Int @execv([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv)
declare %Int @execve([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %envp)
declare %Int @execvp([0 x %ConstChar]* %file, [0 x %ConstChar]* %argv)
declare void @_exit(%Int %status)
declare %Int @fchown(%Int %fildes, %UIDT %owner, %GIDT %group)
declare %Int @fchdir(%Int %fildes)
declare %Int @fdatasync(%Int %fildes)
declare %PIDT @fork()
declare %LongInt @fpathconf(%Int %fildes, %Int %name)
declare %Int @fsync(%Int %fildes)
declare %Int @ftruncate(%Int %fildes, %OffT %length)
declare [0 x %Char]* @getcwd([0 x %Char]* %buf, %SizeT %size)
declare %Int @getdtablesize()
declare %GIDT @getegid()
declare %UIDT @geteuid()
declare %GIDT @getgid()
declare %Int @getgroups(%Int %gidsetsize, [0 x %GIDT]* %grouplist)
declare %Long @gethostid()
declare [0 x %Char]* @getlogin()
declare %Int @getlogin_r([0 x %Char]* %name, %SizeT %namesize)
declare %Int @getopt(%Int %argc, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %optstring)
declare %Int @getpagesize()
declare [0 x %Char]* @getpass([0 x %ConstChar]* %prompt)
declare %PIDT @getpgid(%PIDT %pid)
declare %PIDT @getpgrp()
declare %PIDT @getpid()
declare %PIDT @getppid()
declare %PIDT @getsid(%PIDT %pid)
declare %UIDT @getuid()
declare [0 x %Char]* @getwd([0 x %Char]* %path_name)
declare %Int @isatty(%Int %fildes)
declare %Int @lchown([0 x %ConstChar]* %path, %UIDT %owner, %GIDT %group)
declare %Int @link([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare %Int @lockf(%Int %fildes, %Int %function, %OffT %size)
declare %OffT @lseek(%Int %fildes, %OffT %offset, %Int %whence)
declare %Int @nice(%Int %incr)
declare %LongInt @pathconf([0 x %ConstChar]* %path, %Int %name)
declare %Int @pause()
declare %Int @pipe([2 x %Int]* %fildes)
declare %SSizeT @pread(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %Int @pthread_atfork(void ()* %prepare, void ()* %parent, void ()* %child)
declare %SSizeT @pwrite(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @read(%Int %fildes, i8* %buf, %SizeT %nbyte)
declare %Int @readlink([0 x %ConstChar]* %path, [0 x %Char]* %buf, %SizeT %bufsize)
declare %Int @rmdir([0 x %ConstChar]* %path)
declare i8* @sbrk(%IntPtrT %incr)
declare %Int @setgid(%GIDT %gid)
declare %Int @setpgid(%PIDT %pid, %PIDT %pgid)
declare %PIDT @setpgrp()
declare %Int @setregid(%GIDT %rgid, %GIDT %egid)
declare %Int @setreuid(%UIDT %ruid, %UIDT %euid)
declare %PIDT @setsid()
declare %Int @setuid(%UIDT %uid)
declare %UnsignedInt @sleep(%UnsignedInt %seconds)
declare void @swab(i8* %src, i8* %dst, %SSizeT %nbytes)
declare %Int @symlink([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare void @sync()
declare %LongInt @sysconf(%Int %name)
declare %PIDT @tcgetpgrp(%Int %fildes)
declare %Int @tcsetpgrp(%Int %fildes, %PIDT %pgid_id)
declare %Int @truncate([0 x %ConstChar]* %path, %OffT %length)
declare [0 x %Char]* @ttyname(%Int %fildes)
declare %Int @ttyname_r(%Int %fildes, [0 x %Char]* %name, %SizeT %namesize)
declare %USecondsT @ualarm(%USecondsT %useconds, %USecondsT %interval)
declare %Int @unlink([0 x %ConstChar]* %path)
declare %Int @usleep(%USecondsT %useconds)
declare %PIDT @vfork()
declare %SSizeT @write(%Int %fildes, i8* %buf, %SizeT %nbyte)
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; from included decode
declare %Word8 @decode_extract_op(%Word32 %instr)
declare %Word8 @decode_extract_funct2(%Word32 %instr)
declare %Word8 @decode_extract_funct3(%Word32 %instr)
declare %Word8 @decode_extract_funct5(%Word32 %instr)
declare %Int8 @decode_extract_rd(%Word32 %instr)
declare %Int8 @decode_extract_rs1(%Word32 %instr)
declare %Int8 @decode_extract_rs2(%Word32 %instr)
declare %Word8 @decode_extract_funct7(%Word32 %instr)
declare %Word32 @decode_extract_imm12(%Word32 %instr)
declare %Word32 @decode_extract_imm31_12(%Word32 %instr)
declare %Word32 @decode_extract_jal_imm(%Word32 %instr)
declare %Int32 @decode_expand12(%Word32 %val_12bit)
declare %Int32 @decode_expand20(%Word32 %val_20bit)
; -- end print includes --
; -- print imports 'core' --
; -- 0
; -- end print imports 'core' --
; -- strings --
@str1 = private constant [12 x i8] [i8 10, i8 73, i8 78, i8 84, i8 32, i8 35, i8 37, i8 48, i8 50, i8 88, i8 10, i8 0]
@str2 = private constant [22 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 79, i8 80, i8 67, i8 79, i8 68, i8 69, i8 58, i8 32, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 105, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [18 x i8] [i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [19 x i8] [i8 109, i8 117, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [20 x i8] [i8 109, i8 117, i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str14 = private constant [22 x i8] [i8 109, i8 117, i8 108, i8 104, i8 115, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str15 = private constant [21 x i8] [i8 109, i8 117, i8 108, i8 104, i8 115, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 0]
@str16 = private constant [21 x i8] [i8 109, i8 117, i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str17 = private constant [22 x i8] [i8 109, i8 117, i8 108, i8 104, i8 115, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str18 = private constant [19 x i8] [i8 100, i8 105, i8 118, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str19 = private constant [20 x i8] [i8 100, i8 105, i8 118, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str20 = private constant [19 x i8] [i8 114, i8 101, i8 109, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str21 = private constant [20 x i8] [i8 114, i8 101, i8 109, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str22 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str23 = private constant [19 x i8] [i8 115, i8 117, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str24 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str25 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str26 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str27 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str28 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str29 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str30 = private constant [18 x i8] [i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str31 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str32 = private constant [15 x i8] [i8 108, i8 117, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str33 = private constant [17 x i8] [i8 97, i8 117, i8 105, i8 112, i8 99, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str34 = private constant [13 x i8] [i8 106, i8 97, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str35 = private constant [14 x i8] [i8 106, i8 97, i8 108, i8 114, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str36 = private constant [18 x i8] [i8 98, i8 101, i8 113, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str37 = private constant [18 x i8] [i8 98, i8 110, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str38 = private constant [18 x i8] [i8 98, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str39 = private constant [18 x i8] [i8 98, i8 103, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str40 = private constant [19 x i8] [i8 98, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str41 = private constant [19 x i8] [i8 98, i8 103, i8 101, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str42 = private constant [17 x i8] [i8 108, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str43 = private constant [17 x i8] [i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str44 = private constant [17 x i8] [i8 108, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str45 = private constant [18 x i8] [i8 108, i8 98, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str46 = private constant [18 x i8] [i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str47 = private constant [17 x i8] [i8 115, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str48 = private constant [17 x i8] [i8 115, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str49 = private constant [17 x i8] [i8 115, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str50 = private constant [7 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 10, i8 0]
@str51 = private constant [8 x i8] [i8 69, i8 66, i8 82, i8 69, i8 65, i8 75, i8 10, i8 0]
@str52 = private constant [6 x i8] [i8 69, i8 78, i8 68, i8 46, i8 10, i8 0]
@str53 = private constant [34 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str54 = private constant [7 x i8] [i8 80, i8 65, i8 85, i8 83, i8 69, i8 10, i8 0]
@str55 = private constant [33 x i8] [i8 10, i8 10, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 95, i8 78, i8 79, i8 84, i8 95, i8 73, i8 77, i8 80, i8 76, i8 69, i8 77, i8 69, i8 78, i8 84, i8 69, i8 68, i8 58, i8 32, i8 34, i8 0]
@str56 = private constant [3 x i8] [i8 34, i8 10, i8 0]
@str57 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str58 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str59 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
; -- endstrings --
%core_Core = type {
	[32 x %Word32],
	%Int32,
	%Int32,
	%core_BusInterface*,
	%Int32,
	%Int32,
	%Bool
};

%core_BusInterface = type {
	%Word8 (%Int32)*,
	%Word16 (%Int32)*,
	%Word32 (%Int32)*,
	void (%Int32, %Word8)*,
	void (%Int32, %Word16)*,
	void (%Int32, %Word32)*
};
; load; immediate; store; reg; branch; load upper immediate; add upper immediate to PC; jump and link; jump and link by register;;


; funct3 for CSR
define void @core_init(%core_Core* %core, %core_BusInterface* %bus) {
	%1 = insertvalue %core_Core zeroinitializer, %core_BusInterface* %bus, 3
	store %core_Core %1, %core_Core* %core
	ret void
}

define internal %Word32 @core_fetch(%core_Core* %core) {
	%1 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%4 = load %core_BusInterface*, %core_BusInterface** %3
	%5 = getelementptr %core_BusInterface, %core_BusInterface* %4, %Int32 0, %Int32 2
	%6 = load %Word32 (%Int32)*, %Word32 (%Int32)** %5
	%7 = call %Word32 %6(%Int32 %2)
	ret %Word32 %7
}

define void @core_tick(%core_Core* %core) {
	%1 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	%2 = load %Int32, %Int32* %1
	%3 = icmp ugt %Int32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	%5 = load %Int32, %Int32* %4
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([12 x i8]* @str1 to [0 x i8]*), %Int32 %5)
	%6 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	%7 = load %Int32, %Int32* %6
	%8 = mul %Int32 %7, 4
	%9 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	store %Int32 %8, %Int32* %9
	%10 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	store %Int32 0, %Int32* %10
	br label %endif_0
endif_0:
	%11 = call %Word32 @core_fetch(%core_Core* %core)
	%12 = call %Word8 @decode_extract_op(%Word32 %11)
	%13 = call %Word8 @decode_extract_funct3(%Word32 %11)
	%14 = icmp eq %Word8 %12, 19
	br %Bool %14 , label %then_1, label %else_1
then_1:
	call void @core_doOpI(%core_Core* %core, %Word32 %11)
	br label %endif_1
else_1:
	%15 = icmp eq %Word8 %12, 51
	br %Bool %15 , label %then_2, label %else_2
then_2:
	call void @core_doOpR(%core_Core* %core, %Word32 %11)
	br label %endif_2
else_2:
	%16 = icmp eq %Word8 %12, 55
	br %Bool %16 , label %then_3, label %else_3
then_3:
	call void @core_doOpLUI(%core_Core* %core, %Word32 %11)
	br label %endif_3
else_3:
	%17 = icmp eq %Word8 %12, 23
	br %Bool %17 , label %then_4, label %else_4
then_4:
	call void @core_doOpAUIPC(%core_Core* %core, %Word32 %11)
	br label %endif_4
else_4:
	%18 = icmp eq %Word8 %12, 111
	br %Bool %18 , label %then_5, label %else_5
then_5:
	call void @core_doOpJAL(%core_Core* %core, %Word32 %11)
	br label %endif_5
else_5:
	%19 = icmp eq %Word8 %12, 103
	%20 = icmp eq %Word8 %13, 0
	%21 = and %Bool %19, %20
	br %Bool %21 , label %then_6, label %else_6
then_6:
	call void @core_doOpJALR(%core_Core* %core, %Word32 %11)
	br label %endif_6
else_6:
	%22 = icmp eq %Word8 %12, 99
	br %Bool %22 , label %then_7, label %else_7
then_7:
	call void @core_doOpB(%core_Core* %core, %Word32 %11)
	br label %endif_7
else_7:
	%23 = icmp eq %Word8 %12, 3
	br %Bool %23 , label %then_8, label %else_8
then_8:
	call void @core_doOpL(%core_Core* %core, %Word32 %11)
	br label %endif_8
else_8:
	%24 = icmp eq %Word8 %12, 35
	br %Bool %24 , label %then_9, label %else_9
then_9:
	call void @core_doOpS(%core_Core* %core, %Word32 %11)
	br label %endif_9
else_9:
	%25 = icmp eq %Word8 %12, 115
	br %Bool %25 , label %then_10, label %else_10
then_10:
	call void @core_doOpSystem(%core_Core* %core, %Word32 %11)
	br label %endif_10
else_10:
	%26 = icmp eq %Word8 %12, 15
	br %Bool %26 , label %then_11, label %else_11
then_11:
	call void @core_doOpFence(%core_Core* %core, %Word32 %11)
	br label %endif_11
else_11:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([22 x i8]* @str2 to [0 x i8]*), %Word8 %12)
	br label %endif_11
endif_11:
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
	%27 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%28 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%29 = load %Int32, %Int32* %28
	store %Int32 %29, %Int32* %27
	%30 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%31 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%32 = load %Int32, %Int32* %31
	%33 = add %Int32 %32, 4
	store %Int32 %33, %Int32* %30
	%34 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 5
	%35 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 5
	%36 = load %Int32, %Int32* %35
	%37 = add %Int32 %36, 1
	store %Int32 %37, %Int32* %34
	ret void
}

define internal void @core_doOpI(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = icmp eq %Int8 %5, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
	%9 = icmp eq %Word8 %1, 0
	br %Bool %9 , label %then_1, label %else_1
then_1:
	; Add immediate
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str3 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%10 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%11 = getelementptr [32 x %Word32], [32 x %Word32]* %10, %Int32 0, %Int8 %5
	%12 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%13 = getelementptr [32 x %Word32], [32 x %Word32]* %12, %Int32 0, %Int8 %6
	%14 = load %Word32, %Word32* %13
	%15 = bitcast %Word32 %14 to %Int32
	%16 = add %Int32 %15, %4
	%17 = bitcast %Int32 %16 to %Word32
	store %Word32 %17, %Word32* %11
	br label %endif_1
else_1:
	%18 = icmp eq %Word8 %1, 1
	%19 = icmp eq %Word8 %2, 0
	%20 = and %Bool %18, %19
	br %Bool %20 , label %then_2, label %else_2
then_2:
; SLLI is a logical left shift (zeros are shifted
;		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
;		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). 
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str4 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%21 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%22 = getelementptr [32 x %Word32], [32 x %Word32]* %21, %Int32 0, %Int8 %5
	%23 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%24 = getelementptr [32 x %Word32], [32 x %Word32]* %23, %Int32 0, %Int8 %6
	%25 = load %Word32, %Word32* %24
	%26 = trunc %Int32 %4 to %Int8
	%27 = zext %Int8 %26 to %Word32
	%28 = shl %Word32 %25, %27
	store %Word32 %28, %Word32* %22
	br label %endif_2
else_2:
	%29 = icmp eq %Word8 %1, 2
	br %Bool %29 , label %then_3, label %else_3
then_3:
	; SLTI - set [1 to rd if rs1] less than immediate
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%30 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%31 = getelementptr [32 x %Word32], [32 x %Word32]* %30, %Int32 0, %Int8 %5
	%32 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%33 = getelementptr [32 x %Word32], [32 x %Word32]* %32, %Int32 0, %Int8 %6
	%34 = load %Word32, %Word32* %33
	%35 = bitcast %Word32 %34 to %Int32
	%36 = icmp slt %Int32 %35, %4
	%37 = zext %Bool %36 to %Word32
	store %Word32 %37, %Word32* %31
	br label %endif_3
else_3:
	%38 = icmp eq %Word8 %1, 3
	br %Bool %38 , label %then_4, label %else_4
then_4:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([20 x i8]* @str6 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%39 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%40 = getelementptr [32 x %Word32], [32 x %Word32]* %39, %Int32 0, %Int8 %5
	%41 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%42 = getelementptr [32 x %Word32], [32 x %Word32]* %41, %Int32 0, %Int8 %6
	%43 = load %Word32, %Word32* %42
	%44 = bitcast %Word32 %43 to %Int32
	%45 = bitcast %Int32 %4 to %Int32
	%46 = icmp ult %Int32 %44, %45
	%47 = zext %Bool %46 to %Word32
	store %Word32 %47, %Word32* %40
	br label %endif_4
else_4:
	%48 = icmp eq %Word8 %1, 4
	br %Bool %48 , label %then_5, label %else_5
then_5:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%49 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%50 = getelementptr [32 x %Word32], [32 x %Word32]* %49, %Int32 0, %Int8 %5
	%51 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%52 = getelementptr [32 x %Word32], [32 x %Word32]* %51, %Int32 0, %Int8 %6
	%53 = bitcast %Int32 %4 to %Word32
	%54 = load %Word32, %Word32* %52
	%55 = xor %Word32 %54, %53
	store %Word32 %55, %Word32* %50
	br label %endif_5
else_5:
	%56 = icmp eq %Word8 %1, 5
	%57 = icmp eq %Word8 %2, 0
	%58 = and %Bool %56, %57
	br %Bool %58 , label %then_6, label %else_6
then_6:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str8 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%59 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%60 = getelementptr [32 x %Word32], [32 x %Word32]* %59, %Int32 0, %Int8 %5
	%61 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%62 = getelementptr [32 x %Word32], [32 x %Word32]* %61, %Int32 0, %Int8 %6
	%63 = load %Word32, %Word32* %62
	%64 = trunc %Int32 %4 to %Int8
	%65 = zext %Int8 %64 to %Word32
	%66 = lshr %Word32 %63, %65
	store %Word32 %66, %Word32* %60
	br label %endif_6
else_6:
	%67 = icmp eq %Word8 %1, 5
	%68 = icmp eq %Word8 %2, 32
	%69 = and %Bool %67, %68
	br %Bool %69 , label %then_7, label %else_7
then_7:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str9 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%70 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%71 = getelementptr [32 x %Word32], [32 x %Word32]* %70, %Int32 0, %Int8 %5
	%72 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%73 = getelementptr [32 x %Word32], [32 x %Word32]* %72, %Int32 0, %Int8 %6
	%74 = load %Word32, %Word32* %73
	%75 = trunc %Int32 %4 to %Int8
	%76 = zext %Int8 %75 to %Word32
	%77 = lshr %Word32 %74, %76
	store %Word32 %77, %Word32* %71
	br label %endif_7
else_7:
	%78 = icmp eq %Word8 %1, 6
	br %Bool %78 , label %then_8, label %else_8
then_8:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str10 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%79 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%80 = getelementptr [32 x %Word32], [32 x %Word32]* %79, %Int32 0, %Int8 %5
	%81 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%82 = getelementptr [32 x %Word32], [32 x %Word32]* %81, %Int32 0, %Int8 %6
	%83 = bitcast %Int32 %4 to %Word32
	%84 = load %Word32, %Word32* %82
	%85 = or %Word32 %84, %83
	store %Word32 %85, %Word32* %80
	br label %endif_8
else_8:
	%86 = icmp eq %Word8 %1, 7
	br %Bool %86 , label %then_9, label %endif_9
then_9:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str11 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%87 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%88 = getelementptr [32 x %Word32], [32 x %Word32]* %87, %Int32 0, %Int8 %5
	%89 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%90 = getelementptr [32 x %Word32], [32 x %Word32]* %89, %Int32 0, %Int8 %6
	%91 = bitcast %Int32 %4 to %Word32
	%92 = load %Word32, %Word32* %90
	%93 = and %Word32 %92, %91
	store %Word32 %93, %Word32* %88
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

define internal void @core_doOpR(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = call %Int8 @decode_extract_rs2(%Word32 %instr)
	%8 = icmp eq %Int8 %5, 0
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
	%10 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%11 = getelementptr [32 x %Word32], [32 x %Word32]* %10, %Int32 0, %Int8 %6
	%12 = load %Word32, %Word32* %11
	%13 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%14 = getelementptr [32 x %Word32], [32 x %Word32]* %13, %Int32 0, %Int8 %7
	%15 = load %Word32, %Word32* %14
	%16 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	;let f5 = extract_funct5(instr)
	;let f2 = extract_funct2(instr)
	;if f5 == 0 and f2 == 1 {
	%17 = icmp eq %Word8 %16, 1
	br %Bool %17 , label %then_1, label %endif_1
then_1:
	;printf("MUL(%i)\n", Int32 funct3)

	;
	; "M" extension
	;
	%18 = icmp eq %Word8 %1, 0
	br %Bool %18 , label %then_2, label %else_2
then_2:
	; MUL rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str12 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%19 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%20 = getelementptr [32 x %Word32], [32 x %Word32]* %19, %Int32 0, %Int8 %5
	%21 = bitcast %Word32 %12 to %Int32
	%22 = bitcast %Word32 %15 to %Int32
	%23 = mul %Int32 %21, %22
	%24 = bitcast %Int32 %23 to %Word32
	store %Word32 %24, %Word32* %20
	br label %endif_2
else_2:
	%25 = icmp eq %Word8 %1, 1
	br %Bool %25 , label %then_3, label %else_3
then_3:
	; MULH rd, rs1, rs2
	; Записывает в целевой регистр старшие биты
	; которые бы не поместились в него при обычном умножении
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([20 x i8]* @str13 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%26 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%27 = getelementptr [32 x %Word32], [32 x %Word32]* %26, %Int32 0, %Int8 %5
	%28 = sext %Word32 %12 to %Int64
	%29 = sext %Word32 %15 to %Int64
	%30 = mul %Int64 %28, %29
	%31 = bitcast %Int64 %30 to %Word64
	%32 = zext i8 32 to %Word64
	%33 = lshr %Word64 %31, %32
	%34 = trunc %Word64 %33 to %Word32
	store %Word32 %34, %Word32* %27
	br label %endif_3
else_3:
	%35 = icmp eq %Word8 %1, 2
	br %Bool %35 , label %then_4, label %else_4
then_4:
	; MULHSU rd, rs1, rs2
	; mul high signed unsigned
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([22 x i8]* @str14 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; NOT IMPLEMENTED!
	call void (%Str8*, ...) @core_notImplemented(%Str8* bitcast ([21 x i8]* @str15 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	br label %endif_4
else_4:
	%36 = icmp eq %Word8 %1, 3
	br %Bool %36 , label %then_5, label %else_5
then_5:
	; MULHU rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([21 x i8]* @str16 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; NOT IMPLEMENTED!
	call void (%Str8*, ...) @core_notImplemented(%Str8* bitcast ([22 x i8]* @str17 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	br label %endif_5
else_5:
	%37 = icmp eq %Word8 %1, 4
	br %Bool %37 , label %then_6, label %else_6
then_6:
	; DIV rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str18 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%38 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%39 = getelementptr [32 x %Word32], [32 x %Word32]* %38, %Int32 0, %Int8 %5
	%40 = bitcast %Word32 %12 to %Int32
	%41 = bitcast %Word32 %15 to %Int32
	%42 = sdiv %Int32 %40, %41
	%43 = bitcast %Int32 %42 to %Word32
	store %Word32 %43, %Word32* %39
	br label %endif_6
else_6:
	%44 = icmp eq %Word8 %1, 5
	br %Bool %44 , label %then_7, label %else_7
then_7:
	; DIVU rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([20 x i8]* @str19 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%45 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%46 = getelementptr [32 x %Word32], [32 x %Word32]* %45, %Int32 0, %Int8 %5
	%47 = bitcast %Word32 %12 to %Int32
	%48 = bitcast %Word32 %15 to %Int32
	%49 = udiv %Int32 %47, %48
	%50 = bitcast %Int32 %49 to %Word32
	store %Word32 %50, %Word32* %46
	br label %endif_7
else_7:
	%51 = icmp eq %Word8 %1, 6
	br %Bool %51 , label %then_8, label %else_8
then_8:
	; REM rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str20 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%52 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%53 = getelementptr [32 x %Word32], [32 x %Word32]* %52, %Int32 0, %Int8 %5
	%54 = bitcast %Word32 %12 to %Int32
	%55 = bitcast %Word32 %15 to %Int32
	%56 = srem %Int32 %54, %55
	%57 = bitcast %Int32 %56 to %Word32
	store %Word32 %57, %Word32* %53
	br label %endif_8
else_8:
	%58 = icmp eq %Word8 %1, 7
	br %Bool %58 , label %then_9, label %endif_9
then_9:
	; REMU rd, rs1, rs2
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([20 x i8]* @str21 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%59 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%60 = getelementptr [32 x %Word32], [32 x %Word32]* %59, %Int32 0, %Int8 %5
	%61 = bitcast %Word32 %12 to %Int32
	%62 = bitcast %Word32 %15 to %Int32
	%63 = urem %Int32 %61, %62
	%64 = bitcast %Int32 %63 to %Word32
	store %Word32 %64, %Word32* %60
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
	ret void
	br label %endif_1
endif_1:
	%66 = icmp eq %Word8 %1, 0
	%67 = icmp eq %Word8 %2, 0
	%68 = and %Bool %66, %67
	br %Bool %68 , label %then_10, label %else_10
then_10:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str22 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%69 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%70 = getelementptr [32 x %Word32], [32 x %Word32]* %69, %Int32 0, %Int8 %5
	%71 = bitcast %Word32 %12 to %Int32
	%72 = bitcast %Word32 %15 to %Int32
	%73 = add %Int32 %71, %72
	%74 = bitcast %Int32 %73 to %Word32
	store %Word32 %74, %Word32* %70
	br label %endif_10
else_10:
	%75 = icmp eq %Word8 %1, 0
	%76 = icmp eq %Word8 %2, 32
	%77 = and %Bool %75, %76
	br %Bool %77 , label %then_11, label %else_11
then_11:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str23 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%78 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%79 = getelementptr [32 x %Word32], [32 x %Word32]* %78, %Int32 0, %Int8 %5
	%80 = bitcast %Word32 %12 to %Int32
	%81 = bitcast %Word32 %15 to %Int32
	%82 = sub %Int32 %80, %81
	%83 = bitcast %Int32 %82 to %Word32
	store %Word32 %83, %Word32* %79
	br label %endif_11
else_11:
	%84 = icmp eq %Word8 %1, 1
	br %Bool %84 , label %then_12, label %else_12
then_12:
	; shift left logical
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str24 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%85 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%86 = getelementptr [32 x %Word32], [32 x %Word32]* %85, %Int32 0, %Int8 %5
	%87 = trunc %Word32 %15 to %Int8
	%88 = zext %Int8 %87 to %Word32
	%89 = shl %Word32 %12, %88
	store %Word32 %89, %Word32* %86
	br label %endif_12
else_12:
	%90 = icmp eq %Word8 %1, 2
	br %Bool %90 , label %then_13, label %else_13
then_13:
	; set less than
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str25 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%91 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%92 = getelementptr [32 x %Word32], [32 x %Word32]* %91, %Int32 0, %Int8 %5
	%93 = bitcast %Word32 %12 to %Int32
	%94 = bitcast %Word32 %15 to %Int32
	%95 = icmp slt %Int32 %93, %94
	%96 = zext %Bool %95 to %Word32
	store %Word32 %96, %Word32* %92
	br label %endif_13
else_13:
	%97 = icmp eq %Word8 %1, 3
	br %Bool %97 , label %then_14, label %else_14
then_14:
	; set less than unsigned
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([20 x i8]* @str26 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%98 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%99 = getelementptr [32 x %Word32], [32 x %Word32]* %98, %Int32 0, %Int8 %5
	%100 = bitcast %Word32 %12 to %Int32
	%101 = bitcast %Word32 %15 to %Int32
	%102 = icmp ult %Int32 %100, %101
	%103 = zext %Bool %102 to %Word32
	store %Word32 %103, %Word32* %99
	br label %endif_14
else_14:
	%104 = icmp eq %Word8 %1, 4
	br %Bool %104 , label %then_15, label %else_15
then_15:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str27 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%105 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%106 = getelementptr [32 x %Word32], [32 x %Word32]* %105, %Int32 0, %Int8 %5
	%107 = xor %Word32 %12, %15
	store %Word32 %107, %Word32* %106
	br label %endif_15
else_15:
	%108 = icmp eq %Word8 %1, 5
	%109 = icmp eq %Word8 %2, 0
	%110 = and %Bool %108, %109
	br %Bool %110 , label %then_16, label %else_16
then_16:
	; shift right logical
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str28 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%111 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%112 = getelementptr [32 x %Word32], [32 x %Word32]* %111, %Int32 0, %Int8 %5
	%113 = trunc %Word32 %15 to %Int8
	%114 = zext %Int8 %113 to %Word32
	%115 = lshr %Word32 %12, %114
	store %Word32 %115, %Word32* %112
	br label %endif_16
else_16:
	%116 = icmp eq %Word8 %1, 5
	%117 = icmp eq %Word8 %2, 32
	%118 = and %Bool %116, %117
	br %Bool %118 , label %then_17, label %else_17
then_17:
	; shift right arithmetical
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str29 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; ERROR: не реализован арифм сдвиг!
	;core.reg[rd] = v0 >> Int32 v1
	br label %endif_17
else_17:
	%119 = icmp eq %Word8 %1, 6
	br %Bool %119 , label %then_18, label %else_18
then_18:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str30 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%120 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%121 = getelementptr [32 x %Word32], [32 x %Word32]* %120, %Int32 0, %Int8 %5
	%122 = or %Word32 %12, %15
	store %Word32 %122, %Word32* %121
	br label %endif_18
else_18:
	%123 = icmp eq %Word8 %1, 7
	br %Bool %123 , label %then_19, label %endif_19
then_19:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str31 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%124 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%125 = getelementptr [32 x %Word32], [32 x %Word32]* %124, %Int32 0, %Int8 %5
	%126 = and %Word32 %12, %15
	store %Word32 %126, %Word32* %125
	br label %endif_19
endif_19:
	br label %endif_18
endif_18:
	br label %endif_17
endif_17:
	br label %endif_16
endif_16:
	br label %endif_15
endif_15:
	br label %endif_14
endif_14:
	br label %endif_13
endif_13:
	br label %endif_12
endif_12:
	br label %endif_11
endif_11:
	br label %endif_10
endif_10:
	ret void
}

define internal void @core_doOpLUI(%core_Core* %core, %Word32 %instr) {
	; load upper immediate
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Int32 @decode_expand12(%Word32 %1)
	%3 = call %Int8 @decode_extract_rd(%Word32 %instr)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([15 x i8]* @str32 to [0 x i8]*), %Int8 %3, %Int32 %2)
	%4 = icmp ne %Int8 %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%6 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Int8 %3
	%7 = bitcast %Int32 %2 to %Word32
	%8 = zext i8 12 to %Word32
	%9 = shl %Word32 %7, %8
	store %Word32 %9, %Word32* %6
	br label %endif_0
endif_0:
	ret void
}

define internal void @core_doOpAUIPC(%core_Core* %core, %Word32 %instr) {
	; Add upper immediate to PC
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Int32 @decode_expand12(%Word32 %1)
	%3 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%4 = bitcast %Int32 %2 to %Word32
	%5 = zext i8 12 to %Word32
	%6 = shl %Word32 %4, %5
	%7 = bitcast %Word32 %6 to %Int32
	%8 = load %Int32, %Int32* %3
	%9 = add %Int32 %8, %7
	%10 = call %Int8 @decode_extract_rd(%Word32 %instr)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str33 to [0 x i8]*), %Int8 %10, %Int32 %2)
	%11 = icmp ne %Int8 %10, 0
	br %Bool %11 , label %then_0, label %endif_0
then_0:
	%12 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%13 = getelementptr [32 x %Word32], [32 x %Word32]* %12, %Int32 0, %Int8 %10
	%14 = bitcast %Int32 %9 to %Word32
	store %Word32 %14, %Word32* %13
	br label %endif_0
endif_0:
	ret void
}

define internal void @core_doOpJAL(%core_Core* %core, %Word32 %instr) {
	; Jump and link
	%1 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%2 = call %Word32 @decode_extract_jal_imm(%Word32 %instr)
	%3 = call %Int32 @decode_expand20(%Word32 %2)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([13 x i8]* @str34 to [0 x i8]*), %Int8 %1, %Int32 %3)
	%4 = icmp ne %Int8 %1, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%6 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Int8 %1
	%7 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = add %Int32 %8, 4
	%10 = bitcast %Int32 %9 to %Word32
	store %Word32 %10, %Word32* %6
	br label %endif_0
endif_0:
	%11 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%12 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%13 = load %Int32, %Int32* %12
	%14 = bitcast %Int32 %13 to %Int32
	%15 = add %Int32 %14, %3
	%16 = bitcast %Int32 %15 to %Int32
	store %Int32 %16, %Int32* %11
	ret void
}

define internal void @core_doOpJALR(%core_Core* %core, %Word32 %instr) {
	; Jump and link (by register)
	%1 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%2 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([14 x i8]* @str35 to [0 x i8]*), %Int32 %4, %Int8 %1)

	; rd <- pc + 4
	; pc <- (rs1 + imm) & ~1
	%5 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = add %Int32 %6, 4
	%8 = bitcast %Int32 %7 to %Int32
	%9 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%10 = getelementptr [32 x %Word32], [32 x %Word32]* %9, %Int32 0, %Int8 %1
	%11 = load %Word32, %Word32* %10
	%12 = bitcast %Word32 %11 to %Int32
	%13 = add %Int32 %12, %4
	%14 = bitcast %Int32 %13 to %Word32
	%15 = and %Word32 %14, 4294967294
	%16 = icmp ne %Int8 %2, 0
	br %Bool %16 , label %then_0, label %endif_0
then_0:
	%17 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%18 = getelementptr [32 x %Word32], [32 x %Word32]* %17, %Int32 0, %Int8 %2
	%19 = bitcast %Int32 %8 to %Word32
	store %Word32 %19, %Word32* %18
	br label %endif_0
endif_0:
	%20 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%21 = bitcast %Word32 %15 to %Int32
	store %Int32 %21, %Int32* %20
	ret void
}

define internal void @core_doOpB(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%4 = zext %Int8 %3 to %Word16
	%5 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs2(%Word32 %instr)
	%7 = and %Word16 %4, 30
	%8 = and %Word8 %2, 63
	%9 = zext %Word8 %8 to %Word16
	%10 = zext i8 5 to %Word16
	%11 = shl %Word16 %9, %10
	%12 = and %Word16 %4, 1
	%13 = zext i8 11 to %Word16
	%14 = shl %Word16 %12, %13
	%15 = and %Word8 %2, 64
	%16 = zext %Word8 %15 to %Word16
	%17 = zext i8 6 to %Word16
	%18 = shl %Word16 %16, %17
	%19 = alloca %Word16, align 2
	%20 = or %Word16 %11, %7
	%21 = or %Word16 %14, %20
	%22 = or %Word16 %18, %21
	store %Word16 %22, %Word16* %19

	; распространяем знак, если он есть
	%23 = load %Word16, %Word16* %19
	%24 = and %Word16 %23, 4096
	%25 = icmp ne %Word16 %24, 0
	br %Bool %25 , label %then_0, label %endif_0
then_0:
	%26 = load %Word16, %Word16* %19
	%27 = or %Word16 61440, %26
	store %Word16 %27, %Word16* %19
	br label %endif_0
endif_0:
	%28 = load %Word16, %Word16* %19
	%29 = bitcast %Word16 %28 to %Int16
	%30 = icmp eq %Word8 %1, 0
	br %Bool %30 , label %then_1, label %else_1
then_1:
	; BEQ - Branch if equal
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str36 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	; Branch if two registers are equal
	%31 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%32 = getelementptr [32 x %Word32], [32 x %Word32]* %31, %Int32 0, %Int8 %5
	%33 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%34 = getelementptr [32 x %Word32], [32 x %Word32]* %33, %Int32 0, %Int8 %6
	%35 = load %Word32, %Word32* %32
	%36 = load %Word32, %Word32* %34
	%37 = icmp eq %Word32 %35, %36
	br %Bool %37 , label %then_2, label %endif_2
then_2:
	%38 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%39 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%40 = load %Int32, %Int32* %39
	%41 = bitcast %Int32 %40 to %Int32
	%42 = sext %Int16 %29 to %Int32
	%43 = add %Int32 %41, %42
	%44 = bitcast %Int32 %43 to %Int32
	store %Int32 %44, %Int32* %38
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
	%45 = icmp eq %Word8 %1, 1
	br %Bool %45 , label %then_3, label %else_3
then_3:
	; BNE - Branch if not equal
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str37 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	;
	%46 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%47 = getelementptr [32 x %Word32], [32 x %Word32]* %46, %Int32 0, %Int8 %5
	%48 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%49 = getelementptr [32 x %Word32], [32 x %Word32]* %48, %Int32 0, %Int8 %6
	%50 = load %Word32, %Word32* %47
	%51 = load %Word32, %Word32* %49
	%52 = icmp ne %Word32 %50, %51
	br %Bool %52 , label %then_4, label %endif_4
then_4:
	%53 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%54 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%55 = load %Int32, %Int32* %54
	%56 = bitcast %Int32 %55 to %Int32
	%57 = sext %Int16 %29 to %Int32
	%58 = add %Int32 %56, %57
	%59 = bitcast %Int32 %58 to %Int32
	store %Int32 %59, %Int32* %53
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
	%60 = icmp eq %Word8 %1, 4
	br %Bool %60 , label %then_5, label %else_5
then_5:
	; BLT - Branch if less than (signed)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str38 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	;
	%61 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%62 = getelementptr [32 x %Word32], [32 x %Word32]* %61, %Int32 0, %Int8 %5
	%63 = load %Word32, %Word32* %62
	%64 = bitcast %Word32 %63 to %Int32
	%65 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%66 = getelementptr [32 x %Word32], [32 x %Word32]* %65, %Int32 0, %Int8 %6
	%67 = load %Word32, %Word32* %66
	%68 = bitcast %Word32 %67 to %Int32
	%69 = icmp slt %Int32 %64, %68
	br %Bool %69 , label %then_6, label %endif_6
then_6:
	%70 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%71 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%72 = load %Int32, %Int32* %71
	%73 = bitcast %Int32 %72 to %Int32
	%74 = sext %Int16 %29 to %Int32
	%75 = add %Int32 %73, %74
	%76 = bitcast %Int32 %75 to %Int32
	store %Int32 %76, %Int32* %70
	br label %endif_6
endif_6:
	br label %endif_5
else_5:
	%77 = icmp eq %Word8 %1, 5
	br %Bool %77 , label %then_7, label %else_7
then_7:
	; BGE - Branch if greater or equal (signed)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str39 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	;
	%78 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%79 = getelementptr [32 x %Word32], [32 x %Word32]* %78, %Int32 0, %Int8 %5
	%80 = load %Word32, %Word32* %79
	%81 = bitcast %Word32 %80 to %Int32
	%82 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%83 = getelementptr [32 x %Word32], [32 x %Word32]* %82, %Int32 0, %Int8 %6
	%84 = load %Word32, %Word32* %83
	%85 = bitcast %Word32 %84 to %Int32
	%86 = icmp sge %Int32 %81, %85
	br %Bool %86 , label %then_8, label %endif_8
then_8:
	%87 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%88 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%89 = load %Int32, %Int32* %88
	%90 = bitcast %Int32 %89 to %Int32
	%91 = sext %Int16 %29 to %Int32
	%92 = add %Int32 %90, %91
	%93 = bitcast %Int32 %92 to %Int32
	store %Int32 %93, %Int32* %87
	br label %endif_8
endif_8:
	br label %endif_7
else_7:
	%94 = icmp eq %Word8 %1, 6
	br %Bool %94 , label %then_9, label %else_9
then_9:
	; BLTU - Branch if less than (unsigned)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str40 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	;
	%95 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%96 = getelementptr [32 x %Word32], [32 x %Word32]* %95, %Int32 0, %Int8 %5
	%97 = load %Word32, %Word32* %96
	%98 = bitcast %Word32 %97 to %Int32
	%99 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%100 = getelementptr [32 x %Word32], [32 x %Word32]* %99, %Int32 0, %Int8 %6
	%101 = load %Word32, %Word32* %100
	%102 = bitcast %Word32 %101 to %Int32
	%103 = icmp ult %Int32 %98, %102
	br %Bool %103 , label %then_10, label %endif_10
then_10:
	%104 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%105 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%106 = load %Int32, %Int32* %105
	%107 = bitcast %Int32 %106 to %Int32
	%108 = sext %Int16 %29 to %Int32
	%109 = add %Int32 %107, %108
	%110 = bitcast %Int32 %109 to %Int32
	store %Int32 %110, %Int32* %104
	br label %endif_10
endif_10:
	br label %endif_9
else_9:
	%111 = icmp eq %Word8 %1, 7
	br %Bool %111 , label %then_11, label %endif_11
then_11:
	; BGEU - Branch if greater or equal (unsigned)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([19 x i8]* @str41 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %29)

	;
	%112 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%113 = getelementptr [32 x %Word32], [32 x %Word32]* %112, %Int32 0, %Int8 %5
	%114 = load %Word32, %Word32* %113
	%115 = bitcast %Word32 %114 to %Int32
	%116 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%117 = getelementptr [32 x %Word32], [32 x %Word32]* %116, %Int32 0, %Int8 %6
	%118 = load %Word32, %Word32* %117
	%119 = bitcast %Word32 %118 to %Int32
	%120 = icmp uge %Int32 %115, %119
	br %Bool %120 , label %then_12, label %endif_12
then_12:
	%121 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 2
	%122 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 1
	%123 = load %Int32, %Int32* %122
	%124 = bitcast %Int32 %123 to %Int32
	%125 = sext %Int16 %29 to %Int32
	%126 = add %Int32 %124, %125
	%127 = bitcast %Int32 %126 to %Int32
	store %Int32 %127, %Int32* %121
	br label %endif_12
endif_12:
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

define internal void @core_doOpL(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = call %Int8 @decode_extract_rs2(%Word32 %instr)
	%8 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%9 = getelementptr [32 x %Word32], [32 x %Word32]* %8, %Int32 0, %Int8 %6
	%10 = load %Word32, %Word32* %9
	%11 = bitcast %Word32 %10 to %Int32
	%12 = add %Int32 %11, %4
	%13 = bitcast %Int32 %12 to %Int32
	%14 = icmp eq %Word8 %1, 0
	br %Bool %14 , label %then_0, label %else_0
then_0:
	; LB (Load 8-bit signed integer value)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str42 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%15 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%16 = load %core_BusInterface*, %core_BusInterface** %15
	%17 = getelementptr %core_BusInterface, %core_BusInterface* %16, %Int32 0, %Int32 0
	%18 = load %Word8 (%Int32)*, %Word8 (%Int32)** %17
	%19 = call %Word8 %18(%Int32 %13)
	%20 = sext %Word8 %19 to %Int32
	%21 = icmp ne %Int8 %5, 0
	br %Bool %21 , label %then_1, label %endif_1
then_1:
	%22 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%23 = getelementptr [32 x %Word32], [32 x %Word32]* %22, %Int32 0, %Int8 %5
	%24 = bitcast %Int32 %20 to %Word32
	store %Word32 %24, %Word32* %23
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
	%25 = icmp eq %Word8 %1, 1
	br %Bool %25 , label %then_2, label %else_2
then_2:
	; LH (Load 16-bit signed integer value)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str43 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%26 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%27 = load %core_BusInterface*, %core_BusInterface** %26
	%28 = getelementptr %core_BusInterface, %core_BusInterface* %27, %Int32 0, %Int32 1
	%29 = load %Word16 (%Int32)*, %Word16 (%Int32)** %28
	%30 = call %Word16 %29(%Int32 %13)
	%31 = sext %Word16 %30 to %Int32
	%32 = icmp ne %Int8 %5, 0
	br %Bool %32 , label %then_3, label %endif_3
then_3:
	%33 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%34 = getelementptr [32 x %Word32], [32 x %Word32]* %33, %Int32 0, %Int8 %5
	%35 = bitcast %Int32 %31 to %Word32
	store %Word32 %35, %Word32* %34
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
	%36 = icmp eq %Word8 %1, 2
	br %Bool %36 , label %then_4, label %else_4
then_4:
	; LW (Load 32-bit signed integer value)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str44 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%37 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%38 = load %core_BusInterface*, %core_BusInterface** %37
	%39 = getelementptr %core_BusInterface, %core_BusInterface* %38, %Int32 0, %Int32 2
	%40 = load %Word32 (%Int32)*, %Word32 (%Int32)** %39
	%41 = call %Word32 %40(%Int32 %13)
	%42 = icmp ne %Int8 %5, 0
	br %Bool %42 , label %then_5, label %endif_5
then_5:
	%43 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%44 = getelementptr [32 x %Word32], [32 x %Word32]* %43, %Int32 0, %Int8 %5
	store %Word32 %41, %Word32* %44
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
	%45 = icmp eq %Word8 %1, 4
	br %Bool %45 , label %then_6, label %else_6
then_6:
	; LBU (Load 8-bit unsigned integer value)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str45 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%46 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%47 = load %core_BusInterface*, %core_BusInterface** %46
	%48 = getelementptr %core_BusInterface, %core_BusInterface* %47, %Int32 0, %Int32 0
	%49 = load %Word8 (%Int32)*, %Word8 (%Int32)** %48
	%50 = call %Word8 %49(%Int32 %13)
	%51 = zext %Word8 %50 to %Int32
	%52 = icmp ne %Int8 %5, 0
	br %Bool %52 , label %then_7, label %endif_7
then_7:
	%53 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%54 = getelementptr [32 x %Word32], [32 x %Word32]* %53, %Int32 0, %Int8 %5
	%55 = bitcast %Int32 %51 to %Word32
	store %Word32 %55, %Word32* %54
	br label %endif_7
endif_7:
	br label %endif_6
else_6:
	%56 = icmp eq %Word8 %1, 5
	br %Bool %56 , label %then_8, label %endif_8
then_8:
	; LHU (Load 16-bit unsigned integer value)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([18 x i8]* @str46 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%57 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%58 = load %core_BusInterface*, %core_BusInterface** %57
	%59 = getelementptr %core_BusInterface, %core_BusInterface* %58, %Int32 0, %Int32 1
	%60 = load %Word16 (%Int32)*, %Word16 (%Int32)** %59
	%61 = call %Word16 %60(%Int32 %13)
	%62 = zext %Word16 %61 to %Int32
	%63 = icmp ne %Int8 %5, 0
	br %Bool %63 , label %then_9, label %endif_9
then_9:
	%64 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%65 = getelementptr [32 x %Word32], [32 x %Word32]* %64, %Int32 0, %Int8 %5
	%66 = bitcast %Int32 %62 to %Word32
	store %Word32 %66, %Word32* %65
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_6
endif_6:
	br label %endif_4
endif_4:
	br label %endif_2
endif_2:
	br label %endif_0
endif_0:
	ret void
}

define internal void @core_doOpS(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%4 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%5 = call %Int8 @decode_extract_rs2(%Word32 %instr)
	%6 = zext %Int8 %3 to %Int32
	%7 = zext %Word8 %2 to %Int32
	%8 = bitcast %Int32 %7 to %Word32
	%9 = zext i8 5 to %Word32
	%10 = shl %Word32 %8, %9
	%11 = bitcast %Int32 %6 to %Word32
	%12 = or %Word32 %10, %11
	%13 = call %Int32 @decode_expand12(%Word32 %12)
	%14 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%15 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Int8 %4
	%16 = load %Word32, %Word32* %15
	%17 = bitcast %Word32 %16 to %Int32
	%18 = add %Int32 %17, %13
	%19 = bitcast %Int32 %18 to %Int32
	%20 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%21 = getelementptr [32 x %Word32], [32 x %Word32]* %20, %Int32 0, %Int8 %5
	%22 = load %Word32, %Word32* %21
	%23 = icmp eq %Word8 %1, 0
	br %Bool %23 , label %then_0, label %else_0
then_0:
	; SB (save 8-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str47 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%24 = trunc %Word32 %22 to %Word8
	%25 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%26 = load %core_BusInterface*, %core_BusInterface** %25
	%27 = getelementptr %core_BusInterface, %core_BusInterface* %26, %Int32 0, %Int32 3
	%28 = load void (%Int32, %Word8)*, void (%Int32, %Word8)** %27
	call void %28(%Int32 %19, %Word8 %24)
	br label %endif_0
else_0:
	%29 = icmp eq %Word8 %1, 1
	br %Bool %29 , label %then_1, label %else_1
then_1:
	; SH (save 16-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str48 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%30 = trunc %Word32 %22 to %Word16
	%31 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%32 = load %core_BusInterface*, %core_BusInterface** %31
	%33 = getelementptr %core_BusInterface, %core_BusInterface* %32, %Int32 0, %Int32 4
	%34 = load void (%Int32, %Word16)*, void (%Int32, %Word16)** %33
	call void %34(%Int32 %19, %Word16 %30)
	br label %endif_1
else_1:
	%35 = icmp eq %Word8 %1, 2
	br %Bool %35 , label %then_2, label %endif_2
then_2:
	; SW (save 32-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([17 x i8]* @str49 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%36 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 3
	%37 = load %core_BusInterface*, %core_BusInterface** %36
	%38 = getelementptr %core_BusInterface, %core_BusInterface* %37, %Int32 0, %Int32 5
	%39 = load void (%Int32, %Word32)*, void (%Int32, %Word32)** %38
	call void %39(%Int32 %19, %Word32 %22)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @core_doOpSystem(%core_Core* %core, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = trunc %Word32 %3 to %Int16
	%8 = icmp eq %Word32 %instr, 115
	br %Bool %8 , label %then_0, label %else_0
then_0:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([7 x i8]* @str50 to [0 x i8]*))

	;
	call void @core_irq(%core_Core* %core, %Int32 8)
	br label %endif_0
else_0:
	%9 = icmp eq %Word32 %instr, 1048691
	br %Bool %9 , label %then_1, label %else_1
then_1:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([8 x i8]* @str51 to [0 x i8]*))

	;
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str52 to [0 x i8]*))
	%11 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 6
	store %Bool 1, %Bool* %11

	; CSR instructions
	br label %endif_1
else_1:
	%12 = icmp eq %Word8 %1, 1
	br %Bool %12 , label %then_2, label %else_2
then_2:
	; CSR read & write
	call void @core_csr_rw(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_2
else_2:
	%13 = icmp eq %Word8 %1, 2
	br %Bool %13 , label %then_3, label %else_3
then_3:
	; CSR read & set bit
	call void @core_csr_rs(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_3
else_3:
	%14 = icmp eq %Word8 %1, 3
	br %Bool %14 , label %then_4, label %else_4
then_4:
	; CSR read & clear bit
	call void @core_csr_rc(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_4
else_4:
	%15 = icmp eq %Word8 %1, 4
	br %Bool %15 , label %then_5, label %else_5
then_5:
	call void @core_csr_rwi(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_5
else_5:
	%16 = icmp eq %Word8 %1, 5
	br %Bool %16 , label %then_6, label %else_6
then_6:
	call void @core_csr_rsi(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_6
else_6:
	%17 = icmp eq %Word8 %1, 6
	br %Bool %17 , label %then_7, label %else_7
then_7:
	call void @core_csr_rci(%core_Core* %core, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_7
else_7:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([34 x i8]* @str53 to [0 x i8]*), %Word32 %instr)
	%18 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 6
	store %Bool 1, %Bool* %18
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
	br label %endif_0
endif_0:
	ret void
}

define internal void @core_doOpFence(%core_Core* %core, %Word32 %instr) {
	%1 = icmp eq %Word32 %instr, 16777231
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	call void (%Str8*, ...) @core_debug(%Str8* bitcast ([7 x i8]* @str54 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret void
}

define void @core_irq(%core_Core* %core, %Int32 %irq) {
	%1 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	%2 = load %Int32, %Int32* %1
	%3 = icmp eq %Int32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 4
	store %Int32 %irq, %Int32* %4
	br label %endif_0
endif_0:
	ret void
}






;
; CSR's
;https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
;


;
;The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
;
define internal void @core_csr_rw(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	%1 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%2 = getelementptr [32 x %Word32], [32 x %Word32]* %1, %Int32 0, %Int8 %rs1
	%3 = load %Word32, %Word32* %2
	%4 = icmp eq %Int16 %csr, 832
	br %Bool %4 , label %then_0, label %else_0
then_0:
	; mscratch
	br label %endif_0
else_0:
	%5 = icmp eq %Int16 %csr, 833
	br %Bool %5 , label %then_1, label %else_1
then_1:
	; mepc
	br label %endif_1
else_1:
	%6 = icmp eq %Int16 %csr, 834
	br %Bool %6 , label %then_2, label %else_2
then_2:
	; mcause
	br label %endif_2
else_2:
	%7 = icmp eq %Int16 %csr, 835
	br %Bool %7 , label %then_3, label %else_3
then_3:
	; mbadaddr
	br label %endif_3
else_3:
	%8 = icmp eq %Int16 %csr, 836
	br %Bool %8 , label %then_4, label %endif_4
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



;
;The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
;
define internal void @core_csr_rs(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	;TODO
	ret void
}


;
;The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
;
define internal void @core_csr_rc(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	;TODO
	ret void
}



; -
define internal void @core_csr_rwi(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}



; read+clear immediate(5-bit)
define internal void @core_csr_rsi(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}



; read+clear immediate(5-bit)
define internal void @core_csr_rci(%core_Core* %core, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}

define internal void @core_debug(%Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%3 = load i8*, i8** %1
	%4 = call %Int @vprintf(%Str8* %form, i8* %3)
	br label %endif_0
endif_0:
	%5 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %5)
	ret void
}

define internal void @core_notImplemented(%Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str55 to [0 x i8]*))
	%4 = load i8*, i8** %1
	%5 = call %Int @vprintf(%Str8* %form, i8* %4)
	%6 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %6)
	%7 = call %Int @puts(%ConstCharStr* bitcast ([3 x i8]* @str56 to [0 x i8]*))
	call void @exit(%Int -1)
	ret void
}

define void @core_show_regs(%core_Core* %core) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp slt %Int32 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %1
	%5 = load %Int32, %Int32* %1
	%6 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Int32 %5
	%8 = load %Word32, %Word32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str57 to [0 x i8]*), %Int32 %4, %Word32 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str58 to [0 x i8]*))
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 16
	%13 = load %Int32, %Int32* %1
	%14 = add %Int32 %13, 16
	%15 = getelementptr %core_Core, %core_Core* %core, %Int32 0, %Int32 0
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %15, %Int32 0, %Int32 %14
	%17 = load %Word32, %Word32* %16
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str59 to [0 x i8]*), %Int32 %12, %Word32 %17)
	%19 = load %Int32, %Int32* %1
	%20 = add %Int32 %19, 1
	store %Int32 %20, %Int32* %1
	br label %again_1
break_1:
	ret void
}


