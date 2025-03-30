
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

; MODULE: hart

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
; -- print imports 'hart' --
; -- 0
; -- end print imports 'hart' --
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
@str55 = private constant [8 x i8] [i8 91, i8 37, i8 48, i8 56, i8 88, i8 93, i8 32, i8 0]
@str56 = private constant [33 x i8] [i8 10, i8 10, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 95, i8 78, i8 79, i8 84, i8 95, i8 73, i8 77, i8 80, i8 76, i8 69, i8 77, i8 69, i8 78, i8 84, i8 69, i8 68, i8 58, i8 32, i8 34, i8 0]
@str57 = private constant [3 x i8] [i8 34, i8 10, i8 0]
@str58 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str59 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str60 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
; -- endstrings --;
;
%hart_Hart = type {
	[32 x %Word32],
	%Int32,
	%Int32,
	%hart_BusInterface*,
	%Word32,
	%Int32,
	%Bool
};

%hart_BusInterface = type {
	%Word8 (%Int32)*,
	%Word16 (%Int32)*,
	%Word32 (%Int32)*,
	void (%Int32, %Word8)*,
	void (%Int32, %Word16)*,
	void (%Int32, %Word32)*
};
; load; immediate; store; reg; branch; load upper immediate; add upper immediate to PC; jump and link; jump and link by register;;


; funct3 for CSR
define void @hart_init(%hart_Hart* %hart, %hart_BusInterface* %bus) {
	%1 = insertvalue %hart_Hart zeroinitializer, %hart_BusInterface* %bus, 3
	store %hart_Hart %1, %hart_Hart* %hart
	ret void
}

define internal %Word32 @fetch(%hart_Hart* %hart) {
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%4 = load %hart_BusInterface*, %hart_BusInterface** %3
	%5 = getelementptr %hart_BusInterface, %hart_BusInterface* %4, %Int32 0, %Int32 2
	%6 = load %Word32 (%Int32)*, %Word32 (%Int32)** %5
	%7 = call %Word32 %6(%Int32 %2)
	ret %Word32 %7
}

define void @hart_tick(%hart_Hart* %hart) {
; if_0
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	%2 = zext i8 0 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = icmp ne %Word32 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	%8 = load %Word32, %Word32* %7
	call void (%Int32, %Str8*, ...) @trace(%Int32 %6, %Str8* bitcast ([12 x i8]* @str1 to [0 x i8]*), %Word32 %8)
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	%10 = load %Word32, %Word32* %9
	%11 = bitcast %Word32 %10 to %Int32
	%12 = mul %Int32 %11, 4
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	store %Int32 %12, %Int32* %13
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	%15 = zext i8 0 to %Word32
	store %Word32 %15, %Word32* %14
	br label %endif_0
endif_0:
	%16 = call %Word32 @fetch(%hart_Hart* %hart)
	%17 = call %Word8 @decode_extract_op(%Word32 %16)
	%18 = call %Word8 @decode_extract_funct3(%Word32 %16)
; if_1
	%19 = icmp eq %Word8 %17, 19
	br %Bool %19 , label %then_1, label %else_1
then_1:
	call void @doOpI(%hart_Hart* %hart, %Word32 %16)
	br label %endif_1
else_1:
; if_2
	%20 = icmp eq %Word8 %17, 51
	br %Bool %20 , label %then_2, label %else_2
then_2:
	call void @doOpR(%hart_Hart* %hart, %Word32 %16)
	br label %endif_2
else_2:
; if_3
	%21 = icmp eq %Word8 %17, 55
	br %Bool %21 , label %then_3, label %else_3
then_3:
	call void @doOpLUI(%hart_Hart* %hart, %Word32 %16)
	br label %endif_3
else_3:
; if_4
	%22 = icmp eq %Word8 %17, 23
	br %Bool %22 , label %then_4, label %else_4
then_4:
	call void @doOpAUIPC(%hart_Hart* %hart, %Word32 %16)
	br label %endif_4
else_4:
; if_5
	%23 = icmp eq %Word8 %17, 111
	br %Bool %23 , label %then_5, label %else_5
then_5:
	call void @doOpJAL(%hart_Hart* %hart, %Word32 %16)
	br label %endif_5
else_5:
; if_6
	%24 = icmp eq %Word8 %17, 103
	%25 = bitcast i8 0 to %Word8
	%26 = icmp eq %Word8 %18, %25
	%27 = and %Bool %24, %26
	br %Bool %27 , label %then_6, label %else_6
then_6:
	call void @doOpJALR(%hart_Hart* %hart, %Word32 %16)
	br label %endif_6
else_6:
; if_7
	%28 = icmp eq %Word8 %17, 99
	br %Bool %28 , label %then_7, label %else_7
then_7:
	call void @doOpB(%hart_Hart* %hart, %Word32 %16)
	br label %endif_7
else_7:
; if_8
	%29 = icmp eq %Word8 %17, 3
	br %Bool %29 , label %then_8, label %else_8
then_8:
	call void @doOpL(%hart_Hart* %hart, %Word32 %16)
	br label %endif_8
else_8:
; if_9
	%30 = icmp eq %Word8 %17, 35
	br %Bool %30 , label %then_9, label %else_9
then_9:
	call void @doOpS(%hart_Hart* %hart, %Word32 %16)
	br label %endif_9
else_9:
; if_10
	%31 = icmp eq %Word8 %17, 115
	br %Bool %31 , label %then_10, label %else_10
then_10:
	call void @doOpSystem(%hart_Hart* %hart, %Word32 %16)
	br label %endif_10
else_10:
; if_11
	%32 = icmp eq %Word8 %17, 15
	br %Bool %32 , label %then_11, label %else_11
then_11:
	call void @doOpFence(%hart_Hart* %hart, %Word32 %16)
	br label %endif_11
else_11:
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%34 = load %Int32, %Int32* %33
	call void (%Int32, %Str8*, ...) @trace(%Int32 %34, %Str8* bitcast ([22 x i8]* @str2 to [0 x i8]*), %Word8 %17)
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
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%36 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%37 = load %Int32, %Int32* %36
	store %Int32 %37, %Int32* %35
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%39 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%40 = load %Int32, %Int32* %39
	%41 = add %Int32 %40, 4
	store %Int32 %41, %Int32* %38
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%43 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%44 = load %Int32, %Int32* %43
	%45 = add %Int32 %44, 1
	store %Int32 %45, %Int32* %42
	ret void
}

define internal void @doOpI(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
; if_0
	%7 = icmp eq %Int8 %5, 0
	br %Bool %7 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
; if_1
	%9 = bitcast i8 0 to %Word8
	%10 = icmp eq %Word8 %1, %9
	br %Bool %10 , label %then_1, label %else_1
then_1:
	; Add immediate
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%12 = load %Int32, %Int32* %11
	call void (%Int32, %Str8*, ...) @trace(%Int32 %12, %Str8* bitcast ([19 x i8]* @str3 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%14 = zext %Int8 %5 to %Int32
	%15 = getelementptr [32 x %Word32], [32 x %Word32]* %13, %Int32 0, %Int32 %14
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%17 = zext %Int8 %6 to %Int32
	%18 = getelementptr [32 x %Word32], [32 x %Word32]* %16, %Int32 0, %Int32 %17
	%19 = load %Word32, %Word32* %18
	%20 = bitcast %Word32 %19 to %Int32
	%21 = add %Int32 %20, %4
	%22 = bitcast %Int32 %21 to %Word32
	store %Word32 %22, %Word32* %15
	br label %endif_1
else_1:
; if_2
	%23 = bitcast i8 1 to %Word8
	%24 = icmp eq %Word8 %1, %23
	%25 = bitcast i8 0 to %Word8
	%26 = icmp eq %Word8 %2, %25
	%27 = and %Bool %24, %26
	br %Bool %27 , label %then_2, label %else_2
then_2:
; SLLI is a logical left shift (zeros are shifted
;		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
;		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). 
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Int32, %Int32* %28
	call void (%Int32, %Str8*, ...) @trace(%Int32 %29, %Str8* bitcast ([19 x i8]* @str4 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%31 = zext %Int8 %5 to %Int32
	%32 = getelementptr [32 x %Word32], [32 x %Word32]* %30, %Int32 0, %Int32 %31
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%34 = zext %Int8 %6 to %Int32
	%35 = getelementptr [32 x %Word32], [32 x %Word32]* %33, %Int32 0, %Int32 %34
	%36 = load %Word32, %Word32* %35
	%37 = trunc %Int32 %4 to %Int8
	%38 = zext %Int8 %37 to %Word32
	%39 = shl %Word32 %36, %38
	store %Word32 %39, %Word32* %32
	br label %endif_2
else_2:
; if_3
	%40 = bitcast i8 2 to %Word8
	%41 = icmp eq %Word8 %1, %40
	br %Bool %41 , label %then_3, label %else_3
then_3:
	; SLTI - set [1 to rd if rs1] less than immediate
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%43 = load %Int32, %Int32* %42
	call void (%Int32, %Str8*, ...) @trace(%Int32 %43, %Str8* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%45 = zext %Int8 %5 to %Int32
	%46 = getelementptr [32 x %Word32], [32 x %Word32]* %44, %Int32 0, %Int32 %45
	%47 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%48 = zext %Int8 %6 to %Int32
	%49 = getelementptr [32 x %Word32], [32 x %Word32]* %47, %Int32 0, %Int32 %48
	%50 = load %Word32, %Word32* %49
	%51 = bitcast %Word32 %50 to %Int32
	%52 = icmp slt %Int32 %51, %4
	%53 = zext %Bool %52 to %Word32
	store %Word32 %53, %Word32* %46
	br label %endif_3
else_3:
; if_4
	%54 = bitcast i8 3 to %Word8
	%55 = icmp eq %Word8 %1, %54
	br %Bool %55 , label %then_4, label %else_4
then_4:
	%56 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%57 = load %Int32, %Int32* %56
	call void (%Int32, %Str8*, ...) @trace(%Int32 %57, %Str8* bitcast ([20 x i8]* @str6 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%58 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%59 = zext %Int8 %5 to %Int32
	%60 = getelementptr [32 x %Word32], [32 x %Word32]* %58, %Int32 0, %Int32 %59
	%61 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%62 = zext %Int8 %6 to %Int32
	%63 = getelementptr [32 x %Word32], [32 x %Word32]* %61, %Int32 0, %Int32 %62
	%64 = load %Word32, %Word32* %63
	%65 = bitcast %Word32 %64 to %Int32
	%66 = bitcast %Int32 %4 to %Int32
	%67 = icmp ult %Int32 %65, %66
	%68 = zext %Bool %67 to %Word32
	store %Word32 %68, %Word32* %60
	br label %endif_4
else_4:
; if_5
	%69 = bitcast i8 4 to %Word8
	%70 = icmp eq %Word8 %1, %69
	br %Bool %70 , label %then_5, label %else_5
then_5:
	%71 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%72 = load %Int32, %Int32* %71
	call void (%Int32, %Str8*, ...) @trace(%Int32 %72, %Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%73 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%74 = zext %Int8 %5 to %Int32
	%75 = getelementptr [32 x %Word32], [32 x %Word32]* %73, %Int32 0, %Int32 %74
	%76 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%77 = zext %Int8 %6 to %Int32
	%78 = getelementptr [32 x %Word32], [32 x %Word32]* %76, %Int32 0, %Int32 %77
	%79 = bitcast %Int32 %4 to %Word32
	%80 = load %Word32, %Word32* %78
	%81 = xor %Word32 %80, %79
	store %Word32 %81, %Word32* %75
	br label %endif_5
else_5:
; if_6
	%82 = bitcast i8 5 to %Word8
	%83 = icmp eq %Word8 %1, %82
	%84 = bitcast i8 0 to %Word8
	%85 = icmp eq %Word8 %2, %84
	%86 = and %Bool %83, %85
	br %Bool %86 , label %then_6, label %else_6
then_6:
	%87 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%88 = load %Int32, %Int32* %87
	call void (%Int32, %Str8*, ...) @trace(%Int32 %88, %Str8* bitcast ([19 x i8]* @str8 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%89 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%90 = zext %Int8 %5 to %Int32
	%91 = getelementptr [32 x %Word32], [32 x %Word32]* %89, %Int32 0, %Int32 %90
	%92 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%93 = zext %Int8 %6 to %Int32
	%94 = getelementptr [32 x %Word32], [32 x %Word32]* %92, %Int32 0, %Int32 %93
	%95 = load %Word32, %Word32* %94
	%96 = trunc %Int32 %4 to %Int8
	%97 = zext %Int8 %96 to %Word32
	%98 = lshr %Word32 %95, %97
	store %Word32 %98, %Word32* %91
	br label %endif_6
else_6:
; if_7
	%99 = bitcast i8 5 to %Word8
	%100 = icmp eq %Word8 %1, %99
	%101 = icmp eq %Word8 %2, 32
	%102 = and %Bool %100, %101
	br %Bool %102 , label %then_7, label %else_7
then_7:
	%103 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%104 = load %Int32, %Int32* %103
	call void (%Int32, %Str8*, ...) @trace(%Int32 %104, %Str8* bitcast ([19 x i8]* @str9 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%105 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%106 = zext %Int8 %5 to %Int32
	%107 = getelementptr [32 x %Word32], [32 x %Word32]* %105, %Int32 0, %Int32 %106
	%108 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%109 = zext %Int8 %6 to %Int32
	%110 = getelementptr [32 x %Word32], [32 x %Word32]* %108, %Int32 0, %Int32 %109
	%111 = load %Word32, %Word32* %110
	%112 = trunc %Int32 %4 to %Int8
	%113 = zext %Int8 %112 to %Word32
	%114 = lshr %Word32 %111, %113
	store %Word32 %114, %Word32* %107
	br label %endif_7
else_7:
; if_8
	%115 = bitcast i8 6 to %Word8
	%116 = icmp eq %Word8 %1, %115
	br %Bool %116 , label %then_8, label %else_8
then_8:
	%117 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%118 = load %Int32, %Int32* %117
	call void (%Int32, %Str8*, ...) @trace(%Int32 %118, %Str8* bitcast ([18 x i8]* @str10 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%119 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%120 = zext %Int8 %5 to %Int32
	%121 = getelementptr [32 x %Word32], [32 x %Word32]* %119, %Int32 0, %Int32 %120
	%122 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%123 = zext %Int8 %6 to %Int32
	%124 = getelementptr [32 x %Word32], [32 x %Word32]* %122, %Int32 0, %Int32 %123
	%125 = bitcast %Int32 %4 to %Word32
	%126 = load %Word32, %Word32* %124
	%127 = or %Word32 %126, %125
	store %Word32 %127, %Word32* %121
	br label %endif_8
else_8:
; if_9
	%128 = bitcast i8 7 to %Word8
	%129 = icmp eq %Word8 %1, %128
	br %Bool %129 , label %then_9, label %endif_9
then_9:
	%130 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%131 = load %Int32, %Int32* %130
	call void (%Int32, %Str8*, ...) @trace(%Int32 %131, %Str8* bitcast ([19 x i8]* @str11 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int32 %4)

	;
	%132 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%133 = zext %Int8 %5 to %Int32
	%134 = getelementptr [32 x %Word32], [32 x %Word32]* %132, %Int32 0, %Int32 %133
	%135 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%136 = zext %Int8 %6 to %Int32
	%137 = getelementptr [32 x %Word32], [32 x %Word32]* %135, %Int32 0, %Int32 %136
	%138 = bitcast %Int32 %4 to %Word32
	%139 = load %Word32, %Word32* %137
	%140 = and %Word32 %139, %138
	store %Word32 %140, %Word32* %134
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

define internal void @doOpR(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = call %Int8 @decode_extract_rs2(%Word32 %instr)
; if_0
	%8 = icmp eq %Int8 %5, 0
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%11 = zext %Int8 %6 to %Int32
	%12 = getelementptr [32 x %Word32], [32 x %Word32]* %10, %Int32 0, %Int32 %11
	%13 = load %Word32, %Word32* %12
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%15 = zext %Int8 %7 to %Int32
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Int32 %15
	%17 = load %Word32, %Word32* %16
	%18 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	;let f5 = extract_funct5(instr)
	;let f2 = extract_funct2(instr)
	;if f5 == 0 and f2 == 1 {
; if_1
	%19 = bitcast i8 1 to %Word8
	%20 = icmp eq %Word8 %18, %19
	br %Bool %20 , label %then_1, label %endif_1
then_1:
	;printf("MUL(%i)\n", Int32 funct3)

	;
	; "M" extension
	;
; if_2
	%21 = bitcast i8 0 to %Word8
	%22 = icmp eq %Word8 %1, %21
	br %Bool %22 , label %then_2, label %else_2
then_2:
	; MUL rd, rs1, rs2
	%23 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%24 = load %Int32, %Int32* %23
	call void (%Int32, %Str8*, ...) @trace(%Int32 %24, %Str8* bitcast ([19 x i8]* @str12 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%25 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%26 = zext %Int8 %5 to %Int32
	%27 = getelementptr [32 x %Word32], [32 x %Word32]* %25, %Int32 0, %Int32 %26
	%28 = bitcast %Word32 %13 to %Int32
	%29 = bitcast %Word32 %17 to %Int32
	%30 = mul %Int32 %28, %29
	%31 = bitcast %Int32 %30 to %Word32
	store %Word32 %31, %Word32* %27
	br label %endif_2
else_2:
; if_3
	%32 = bitcast i8 1 to %Word8
	%33 = icmp eq %Word8 %1, %32
	br %Bool %33 , label %then_3, label %else_3
then_3:
	; MULH rd, rs1, rs2
	; Записывает в целевой регистр старшие биты
	; которые бы не поместились в него при обычном умножении
	%34 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%35 = load %Int32, %Int32* %34
	call void (%Int32, %Str8*, ...) @trace(%Int32 %35, %Str8* bitcast ([20 x i8]* @str13 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%36 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%37 = zext %Int8 %5 to %Int32
	%38 = getelementptr [32 x %Word32], [32 x %Word32]* %36, %Int32 0, %Int32 %37
	%39 = sext %Word32 %13 to %Int64
	%40 = sext %Word32 %17 to %Int64
	%41 = mul %Int64 %39, %40
	%42 = bitcast %Int64 %41 to %Word64
	%43 = zext i8 32 to %Word64
	%44 = lshr %Word64 %42, %43
	%45 = trunc %Word64 %44 to %Word32
	store %Word32 %45, %Word32* %38
	br label %endif_3
else_3:
; if_4
	%46 = bitcast i8 2 to %Word8
	%47 = icmp eq %Word8 %1, %46
	br %Bool %47 , label %then_4, label %else_4
then_4:
	; MULHSU rd, rs1, rs2
	; mul high signed unsigned
	%48 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%49 = load %Int32, %Int32* %48
	call void (%Int32, %Str8*, ...) @trace(%Int32 %49, %Str8* bitcast ([22 x i8]* @str14 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; NOT IMPLEMENTED!
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str15 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	br label %endif_4
else_4:
; if_5
	%50 = bitcast i8 3 to %Word8
	%51 = icmp eq %Word8 %1, %50
	br %Bool %51 , label %then_5, label %else_5
then_5:
	; MULHU rd, rs1, rs2
	%52 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%53 = load %Int32, %Int32* %52
	call void (%Int32, %Str8*, ...) @trace(%Int32 %53, %Str8* bitcast ([21 x i8]* @str16 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; NOT IMPLEMENTED!
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([22 x i8]* @str17 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	br label %endif_5
else_5:
; if_6
	%54 = bitcast i8 4 to %Word8
	%55 = icmp eq %Word8 %1, %54
	br %Bool %55 , label %then_6, label %else_6
then_6:
	; DIV rd, rs1, rs2
	%56 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%57 = load %Int32, %Int32* %56
	call void (%Int32, %Str8*, ...) @trace(%Int32 %57, %Str8* bitcast ([19 x i8]* @str18 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%58 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%59 = zext %Int8 %5 to %Int32
	%60 = getelementptr [32 x %Word32], [32 x %Word32]* %58, %Int32 0, %Int32 %59
	%61 = bitcast %Word32 %13 to %Int32
	%62 = bitcast %Word32 %17 to %Int32
	%63 = sdiv %Int32 %61, %62
	%64 = bitcast %Int32 %63 to %Word32
	store %Word32 %64, %Word32* %60
	br label %endif_6
else_6:
; if_7
	%65 = bitcast i8 5 to %Word8
	%66 = icmp eq %Word8 %1, %65
	br %Bool %66 , label %then_7, label %else_7
then_7:
	; DIVU rd, rs1, rs2
	%67 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%68 = load %Int32, %Int32* %67
	call void (%Int32, %Str8*, ...) @trace(%Int32 %68, %Str8* bitcast ([20 x i8]* @str19 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%69 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%70 = zext %Int8 %5 to %Int32
	%71 = getelementptr [32 x %Word32], [32 x %Word32]* %69, %Int32 0, %Int32 %70
	%72 = bitcast %Word32 %13 to %Int32
	%73 = bitcast %Word32 %17 to %Int32
	%74 = udiv %Int32 %72, %73
	%75 = bitcast %Int32 %74 to %Word32
	store %Word32 %75, %Word32* %71
	br label %endif_7
else_7:
; if_8
	%76 = bitcast i8 6 to %Word8
	%77 = icmp eq %Word8 %1, %76
	br %Bool %77 , label %then_8, label %else_8
then_8:
	; REM rd, rs1, rs2
	%78 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%79 = load %Int32, %Int32* %78
	call void (%Int32, %Str8*, ...) @trace(%Int32 %79, %Str8* bitcast ([19 x i8]* @str20 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%80 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%81 = zext %Int8 %5 to %Int32
	%82 = getelementptr [32 x %Word32], [32 x %Word32]* %80, %Int32 0, %Int32 %81
	%83 = bitcast %Word32 %13 to %Int32
	%84 = bitcast %Word32 %17 to %Int32
	%85 = srem %Int32 %83, %84
	%86 = bitcast %Int32 %85 to %Word32
	store %Word32 %86, %Word32* %82
	br label %endif_8
else_8:
; if_9
	%87 = bitcast i8 7 to %Word8
	%88 = icmp eq %Word8 %1, %87
	br %Bool %88 , label %then_9, label %endif_9
then_9:
	; REMU rd, rs1, rs2
	%89 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%90 = load %Int32, %Int32* %89
	call void (%Int32, %Str8*, ...) @trace(%Int32 %90, %Str8* bitcast ([20 x i8]* @str21 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%91 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%92 = zext %Int8 %5 to %Int32
	%93 = getelementptr [32 x %Word32], [32 x %Word32]* %91, %Int32 0, %Int32 %92
	%94 = bitcast %Word32 %13 to %Int32
	%95 = bitcast %Word32 %17 to %Int32
	%96 = urem %Int32 %94, %95
	%97 = bitcast %Int32 %96 to %Word32
	store %Word32 %97, %Word32* %93
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
; if_10
	%99 = bitcast i8 0 to %Word8
	%100 = icmp eq %Word8 %1, %99
	%101 = icmp eq %Word8 %2, 0
	%102 = and %Bool %100, %101
	br %Bool %102 , label %then_10, label %else_10
then_10:
	%103 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%104 = load %Int32, %Int32* %103
	call void (%Int32, %Str8*, ...) @trace(%Int32 %104, %Str8* bitcast ([19 x i8]* @str22 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%105 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%106 = zext %Int8 %5 to %Int32
	%107 = getelementptr [32 x %Word32], [32 x %Word32]* %105, %Int32 0, %Int32 %106
	%108 = bitcast %Word32 %13 to %Int32
	%109 = bitcast %Word32 %17 to %Int32
	%110 = add %Int32 %108, %109
	%111 = bitcast %Int32 %110 to %Word32
	store %Word32 %111, %Word32* %107
	br label %endif_10
else_10:
; if_11
	%112 = bitcast i8 0 to %Word8
	%113 = icmp eq %Word8 %1, %112
	%114 = icmp eq %Word8 %2, 32
	%115 = and %Bool %113, %114
	br %Bool %115 , label %then_11, label %else_11
then_11:
	%116 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%117 = load %Int32, %Int32* %116
	call void (%Int32, %Str8*, ...) @trace(%Int32 %117, %Str8* bitcast ([19 x i8]* @str23 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%118 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%119 = zext %Int8 %5 to %Int32
	%120 = getelementptr [32 x %Word32], [32 x %Word32]* %118, %Int32 0, %Int32 %119
	%121 = bitcast %Word32 %13 to %Int32
	%122 = bitcast %Word32 %17 to %Int32
	%123 = sub %Int32 %121, %122
	%124 = bitcast %Int32 %123 to %Word32
	store %Word32 %124, %Word32* %120
	br label %endif_11
else_11:
; if_12
	%125 = bitcast i8 1 to %Word8
	%126 = icmp eq %Word8 %1, %125
	br %Bool %126 , label %then_12, label %else_12
then_12:
	; shift left logical
	%127 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%128 = load %Int32, %Int32* %127
	call void (%Int32, %Str8*, ...) @trace(%Int32 %128, %Str8* bitcast ([19 x i8]* @str24 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%129 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%130 = zext %Int8 %5 to %Int32
	%131 = getelementptr [32 x %Word32], [32 x %Word32]* %129, %Int32 0, %Int32 %130
	%132 = trunc %Word32 %17 to %Int8
	%133 = zext %Int8 %132 to %Word32
	%134 = shl %Word32 %13, %133
	store %Word32 %134, %Word32* %131
	br label %endif_12
else_12:
; if_13
	%135 = bitcast i8 2 to %Word8
	%136 = icmp eq %Word8 %1, %135
	br %Bool %136 , label %then_13, label %else_13
then_13:
	; set less than
	%137 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%138 = load %Int32, %Int32* %137
	call void (%Int32, %Str8*, ...) @trace(%Int32 %138, %Str8* bitcast ([19 x i8]* @str25 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%139 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%140 = zext %Int8 %5 to %Int32
	%141 = getelementptr [32 x %Word32], [32 x %Word32]* %139, %Int32 0, %Int32 %140
	%142 = bitcast %Word32 %13 to %Int32
	%143 = bitcast %Word32 %17 to %Int32
	%144 = icmp slt %Int32 %142, %143
	%145 = zext %Bool %144 to %Word32
	store %Word32 %145, %Word32* %141
	br label %endif_13
else_13:
; if_14
	%146 = bitcast i8 3 to %Word8
	%147 = icmp eq %Word8 %1, %146
	br %Bool %147 , label %then_14, label %else_14
then_14:
	; set less than unsigned
	%148 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%149 = load %Int32, %Int32* %148
	call void (%Int32, %Str8*, ...) @trace(%Int32 %149, %Str8* bitcast ([20 x i8]* @str26 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%150 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%151 = zext %Int8 %5 to %Int32
	%152 = getelementptr [32 x %Word32], [32 x %Word32]* %150, %Int32 0, %Int32 %151
	%153 = bitcast %Word32 %13 to %Int32
	%154 = bitcast %Word32 %17 to %Int32
	%155 = icmp ult %Int32 %153, %154
	%156 = zext %Bool %155 to %Word32
	store %Word32 %156, %Word32* %152
	br label %endif_14
else_14:
; if_15
	%157 = bitcast i8 4 to %Word8
	%158 = icmp eq %Word8 %1, %157
	br %Bool %158 , label %then_15, label %else_15
then_15:
	%159 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%160 = load %Int32, %Int32* %159
	call void (%Int32, %Str8*, ...) @trace(%Int32 %160, %Str8* bitcast ([19 x i8]* @str27 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%161 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%162 = zext %Int8 %5 to %Int32
	%163 = getelementptr [32 x %Word32], [32 x %Word32]* %161, %Int32 0, %Int32 %162
	%164 = xor %Word32 %13, %17
	store %Word32 %164, %Word32* %163
	br label %endif_15
else_15:
; if_16
	%165 = bitcast i8 5 to %Word8
	%166 = icmp eq %Word8 %1, %165
	%167 = bitcast i8 0 to %Word8
	%168 = icmp eq %Word8 %2, %167
	%169 = and %Bool %166, %168
	br %Bool %169 , label %then_16, label %else_16
then_16:
	; shift right logical
	%170 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%171 = load %Int32, %Int32* %170
	call void (%Int32, %Str8*, ...) @trace(%Int32 %171, %Str8* bitcast ([19 x i8]* @str28 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)
	%172 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%173 = zext %Int8 %5 to %Int32
	%174 = getelementptr [32 x %Word32], [32 x %Word32]* %172, %Int32 0, %Int32 %173
	%175 = trunc %Word32 %17 to %Int8
	%176 = zext %Int8 %175 to %Word32
	%177 = lshr %Word32 %13, %176
	store %Word32 %177, %Word32* %174
	br label %endif_16
else_16:
; if_17
	%178 = bitcast i8 5 to %Word8
	%179 = icmp eq %Word8 %1, %178
	%180 = icmp eq %Word8 %2, 32
	%181 = and %Bool %179, %180
	br %Bool %181 , label %then_17, label %else_17
then_17:
	; shift right arithmetical
	%182 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%183 = load %Int32, %Int32* %182
	call void (%Int32, %Str8*, ...) @trace(%Int32 %183, %Str8* bitcast ([19 x i8]* @str29 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	; ERROR: не реализован арифм сдвиг!
	;hart.reg[rd] = v0 >> Int32 v1
	br label %endif_17
else_17:
; if_18
	%184 = bitcast i8 6 to %Word8
	%185 = icmp eq %Word8 %1, %184
	br %Bool %185 , label %then_18, label %else_18
then_18:
	%186 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%187 = load %Int32, %Int32* %186
	call void (%Int32, %Str8*, ...) @trace(%Int32 %187, %Str8* bitcast ([18 x i8]* @str30 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%188 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%189 = zext %Int8 %5 to %Int32
	%190 = getelementptr [32 x %Word32], [32 x %Word32]* %188, %Int32 0, %Int32 %189
	%191 = or %Word32 %13, %17
	store %Word32 %191, %Word32* %190
	br label %endif_18
else_18:
; if_19
	%192 = bitcast i8 7 to %Word8
	%193 = icmp eq %Word8 %1, %192
	br %Bool %193 , label %then_19, label %endif_19
then_19:
	%194 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%195 = load %Int32, %Int32* %194
	call void (%Int32, %Str8*, ...) @trace(%Int32 %195, %Str8* bitcast ([19 x i8]* @str31 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int8 %7)

	;
	%196 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%197 = zext %Int8 %5 to %Int32
	%198 = getelementptr [32 x %Word32], [32 x %Word32]* %196, %Int32 0, %Int32 %197
	%199 = and %Word32 %13, %17
	store %Word32 %199, %Word32* %198
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

define internal void @doOpLUI(%hart_Hart* %hart, %Word32 %instr) {
	; load upper immediate
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Int32 @decode_expand12(%Word32 %1)
	%3 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%4 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	call void (%Int32, %Str8*, ...) @trace(%Int32 %5, %Str8* bitcast ([15 x i8]* @str32 to [0 x i8]*), %Int8 %3, %Int32 %2)
; if_0
	%6 = icmp ne %Int8 %3, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%8 = zext %Int8 %3 to %Int32
	%9 = getelementptr [32 x %Word32], [32 x %Word32]* %7, %Int32 0, %Int32 %8
	%10 = bitcast %Int32 %2 to %Word32
	%11 = zext i8 12 to %Word32
	%12 = shl %Word32 %10, %11
	store %Word32 %12, %Word32* %9
	br label %endif_0
endif_0:
	ret void
}

define internal void @doOpAUIPC(%hart_Hart* %hart, %Word32 %instr) {
	; Add upper immediate to PC
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Int32 @decode_expand12(%Word32 %1)
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%4 = bitcast %Int32 %2 to %Word32
	%5 = zext i8 12 to %Word32
	%6 = shl %Word32 %4, %5
	%7 = bitcast %Word32 %6 to %Int32
	%8 = load %Int32, %Int32* %3
	%9 = add %Int32 %8, %7
	%10 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%12 = load %Int32, %Int32* %11
	call void (%Int32, %Str8*, ...) @trace(%Int32 %12, %Str8* bitcast ([17 x i8]* @str33 to [0 x i8]*), %Int8 %10, %Int32 %2)
; if_0
	%13 = icmp ne %Int8 %10, 0
	br %Bool %13 , label %then_0, label %endif_0
then_0:
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%15 = zext %Int8 %10 to %Int32
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Int32 %15
	%17 = bitcast %Int32 %9 to %Word32
	store %Word32 %17, %Word32* %16
	br label %endif_0
endif_0:
	ret void
}

define internal void @doOpJAL(%hart_Hart* %hart, %Word32 %instr) {
	; Jump and link
	%1 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%2 = call %Word32 @decode_extract_jal_imm(%Word32 %instr)
	%3 = call %Int32 @decode_expand20(%Word32 %2)
	%4 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%5 = load %Int32, %Int32* %4
	call void (%Int32, %Str8*, ...) @trace(%Int32 %5, %Str8* bitcast ([13 x i8]* @str34 to [0 x i8]*), %Int8 %1, %Int32 %3)
; if_0
	%6 = icmp ne %Int8 %1, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%8 = zext %Int8 %1 to %Int32
	%9 = getelementptr [32 x %Word32], [32 x %Word32]* %7, %Int32 0, %Int32 %8
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = add %Int32 %11, 4
	%13 = bitcast %Int32 %12 to %Word32
	store %Word32 %13, %Word32* %9
	br label %endif_0
endif_0:
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%16 = load %Int32, %Int32* %15
	%17 = bitcast %Int32 %16 to %Int32
	%18 = add %Int32 %17, %3
	%19 = bitcast %Int32 %18 to %Int32
	store %Int32 %19, %Int32* %14
	ret void
}

define internal void @doOpJALR(%hart_Hart* %hart, %Word32 %instr) {
	; Jump and link (by register)
	%1 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%2 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	call void (%Int32, %Str8*, ...) @trace(%Int32 %6, %Str8* bitcast ([14 x i8]* @str35 to [0 x i8]*), %Int32 %4, %Int8 %1)

	; rd <- pc + 4
	; pc <- (rs1 + imm) & ~1
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = add %Int32 %8, 4
	%10 = bitcast %Int32 %9 to %Int32
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%12 = zext %Int8 %1 to %Int32
	%13 = getelementptr [32 x %Word32], [32 x %Word32]* %11, %Int32 0, %Int32 %12
	%14 = load %Word32, %Word32* %13
	%15 = bitcast %Word32 %14 to %Int32
	%16 = add %Int32 %15, %4
	%17 = bitcast %Int32 %16 to %Word32
	%18 = and %Word32 %17, 4294967294
; if_0
	%19 = icmp ne %Int8 %2, 0
	br %Bool %19 , label %then_0, label %endif_0
then_0:
	%20 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%21 = zext %Int8 %2 to %Int32
	%22 = getelementptr [32 x %Word32], [32 x %Word32]* %20, %Int32 0, %Int32 %21
	%23 = bitcast %Int32 %10 to %Word32
	store %Word32 %23, %Word32* %22
	br label %endif_0
endif_0:
	%24 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%25 = bitcast %Word32 %18 to %Int32
	store %Int32 %25, %Int32* %24
	ret void
}

define internal void @doOpB(%hart_Hart* %hart, %Word32 %instr) {
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
; if_0
	%23 = load %Word16, %Word16* %19
	%24 = and %Word16 %23, 4096
	%25 = zext i8 0 to %Word16
	%26 = icmp ne %Word16 %24, %25
	br %Bool %26 , label %then_0, label %endif_0
then_0:
	%27 = load %Word16, %Word16* %19
	%28 = or %Word16 61440, %27
	store %Word16 %28, %Word16* %19
	br label %endif_0
endif_0:
	%29 = load %Word16, %Word16* %19
	%30 = bitcast %Word16 %29 to %Int16
; if_1
	%31 = bitcast i8 0 to %Word8
	%32 = icmp eq %Word8 %1, %31
	br %Bool %32 , label %then_1, label %else_1
then_1:
	; BEQ - Branch if equal
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%34 = load %Int32, %Int32* %33
	call void (%Int32, %Str8*, ...) @trace(%Int32 %34, %Str8* bitcast ([18 x i8]* @str36 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	; Branch if two registers are equal
; if_2
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%36 = zext %Int8 %5 to %Int32
	%37 = getelementptr [32 x %Word32], [32 x %Word32]* %35, %Int32 0, %Int32 %36
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%39 = zext %Int8 %6 to %Int32
	%40 = getelementptr [32 x %Word32], [32 x %Word32]* %38, %Int32 0, %Int32 %39
	%41 = load %Word32, %Word32* %37
	%42 = load %Word32, %Word32* %40
	%43 = icmp eq %Word32 %41, %42
	br %Bool %43 , label %then_2, label %endif_2
then_2:
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%45 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%46 = load %Int32, %Int32* %45
	%47 = bitcast %Int32 %46 to %Int32
	%48 = sext %Int16 %30 to %Int32
	%49 = add %Int32 %47, %48
	%50 = bitcast %Int32 %49 to %Int32
	store %Int32 %50, %Int32* %44
	br label %endif_2
endif_2:
	br label %endif_1
else_1:
; if_3
	%51 = bitcast i8 1 to %Word8
	%52 = icmp eq %Word8 %1, %51
	br %Bool %52 , label %then_3, label %else_3
then_3:
	; BNE - Branch if not equal
	%53 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%54 = load %Int32, %Int32* %53
	call void (%Int32, %Str8*, ...) @trace(%Int32 %54, %Str8* bitcast ([18 x i8]* @str37 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	;
; if_4
	%55 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%56 = zext %Int8 %5 to %Int32
	%57 = getelementptr [32 x %Word32], [32 x %Word32]* %55, %Int32 0, %Int32 %56
	%58 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%59 = zext %Int8 %6 to %Int32
	%60 = getelementptr [32 x %Word32], [32 x %Word32]* %58, %Int32 0, %Int32 %59
	%61 = load %Word32, %Word32* %57
	%62 = load %Word32, %Word32* %60
	%63 = icmp ne %Word32 %61, %62
	br %Bool %63 , label %then_4, label %endif_4
then_4:
	%64 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%65 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%66 = load %Int32, %Int32* %65
	%67 = bitcast %Int32 %66 to %Int32
	%68 = sext %Int16 %30 to %Int32
	%69 = add %Int32 %67, %68
	%70 = bitcast %Int32 %69 to %Int32
	store %Int32 %70, %Int32* %64
	br label %endif_4
endif_4:
	br label %endif_3
else_3:
; if_5
	%71 = bitcast i8 4 to %Word8
	%72 = icmp eq %Word8 %1, %71
	br %Bool %72 , label %then_5, label %else_5
then_5:
	; BLT - Branch if less than (signed)
	%73 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%74 = load %Int32, %Int32* %73
	call void (%Int32, %Str8*, ...) @trace(%Int32 %74, %Str8* bitcast ([18 x i8]* @str38 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	;
; if_6
	%75 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%76 = zext %Int8 %5 to %Int32
	%77 = getelementptr [32 x %Word32], [32 x %Word32]* %75, %Int32 0, %Int32 %76
	%78 = load %Word32, %Word32* %77
	%79 = bitcast %Word32 %78 to %Int32
	%80 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%81 = zext %Int8 %6 to %Int32
	%82 = getelementptr [32 x %Word32], [32 x %Word32]* %80, %Int32 0, %Int32 %81
	%83 = load %Word32, %Word32* %82
	%84 = bitcast %Word32 %83 to %Int32
	%85 = icmp slt %Int32 %79, %84
	br %Bool %85 , label %then_6, label %endif_6
then_6:
	%86 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%87 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%88 = load %Int32, %Int32* %87
	%89 = bitcast %Int32 %88 to %Int32
	%90 = sext %Int16 %30 to %Int32
	%91 = add %Int32 %89, %90
	%92 = bitcast %Int32 %91 to %Int32
	store %Int32 %92, %Int32* %86
	br label %endif_6
endif_6:
	br label %endif_5
else_5:
; if_7
	%93 = bitcast i8 5 to %Word8
	%94 = icmp eq %Word8 %1, %93
	br %Bool %94 , label %then_7, label %else_7
then_7:
	; BGE - Branch if greater or equal (signed)
	%95 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%96 = load %Int32, %Int32* %95
	call void (%Int32, %Str8*, ...) @trace(%Int32 %96, %Str8* bitcast ([18 x i8]* @str39 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	;
; if_8
	%97 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%98 = zext %Int8 %5 to %Int32
	%99 = getelementptr [32 x %Word32], [32 x %Word32]* %97, %Int32 0, %Int32 %98
	%100 = load %Word32, %Word32* %99
	%101 = bitcast %Word32 %100 to %Int32
	%102 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%103 = zext %Int8 %6 to %Int32
	%104 = getelementptr [32 x %Word32], [32 x %Word32]* %102, %Int32 0, %Int32 %103
	%105 = load %Word32, %Word32* %104
	%106 = bitcast %Word32 %105 to %Int32
	%107 = icmp sge %Int32 %101, %106
	br %Bool %107 , label %then_8, label %endif_8
then_8:
	%108 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%109 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%110 = load %Int32, %Int32* %109
	%111 = bitcast %Int32 %110 to %Int32
	%112 = sext %Int16 %30 to %Int32
	%113 = add %Int32 %111, %112
	%114 = bitcast %Int32 %113 to %Int32
	store %Int32 %114, %Int32* %108
	br label %endif_8
endif_8:
	br label %endif_7
else_7:
; if_9
	%115 = bitcast i8 6 to %Word8
	%116 = icmp eq %Word8 %1, %115
	br %Bool %116 , label %then_9, label %else_9
then_9:
	; BLTU - Branch if less than (unsigned)
	%117 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%118 = load %Int32, %Int32* %117
	call void (%Int32, %Str8*, ...) @trace(%Int32 %118, %Str8* bitcast ([19 x i8]* @str40 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	;
; if_10
	%119 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%120 = zext %Int8 %5 to %Int32
	%121 = getelementptr [32 x %Word32], [32 x %Word32]* %119, %Int32 0, %Int32 %120
	%122 = load %Word32, %Word32* %121
	%123 = bitcast %Word32 %122 to %Int32
	%124 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%125 = zext %Int8 %6 to %Int32
	%126 = getelementptr [32 x %Word32], [32 x %Word32]* %124, %Int32 0, %Int32 %125
	%127 = load %Word32, %Word32* %126
	%128 = bitcast %Word32 %127 to %Int32
	%129 = icmp ult %Int32 %123, %128
	br %Bool %129 , label %then_10, label %endif_10
then_10:
	%130 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%131 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%132 = load %Int32, %Int32* %131
	%133 = bitcast %Int32 %132 to %Int32
	%134 = sext %Int16 %30 to %Int32
	%135 = add %Int32 %133, %134
	%136 = bitcast %Int32 %135 to %Int32
	store %Int32 %136, %Int32* %130
	br label %endif_10
endif_10:
	br label %endif_9
else_9:
; if_11
	%137 = bitcast i8 7 to %Word8
	%138 = icmp eq %Word8 %1, %137
	br %Bool %138 , label %then_11, label %endif_11
then_11:
	; BGEU - Branch if greater or equal (unsigned)
	%139 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%140 = load %Int32, %Int32* %139
	call void (%Int32, %Str8*, ...) @trace(%Int32 %140, %Str8* bitcast ([19 x i8]* @str41 to [0 x i8]*), %Int8 %5, %Int8 %6, %Int16 %30)

	;
; if_12
	%141 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%142 = zext %Int8 %5 to %Int32
	%143 = getelementptr [32 x %Word32], [32 x %Word32]* %141, %Int32 0, %Int32 %142
	%144 = load %Word32, %Word32* %143
	%145 = bitcast %Word32 %144 to %Int32
	%146 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%147 = zext %Int8 %6 to %Int32
	%148 = getelementptr [32 x %Word32], [32 x %Word32]* %146, %Int32 0, %Int32 %147
	%149 = load %Word32, %Word32* %148
	%150 = bitcast %Word32 %149 to %Int32
	%151 = icmp uge %Int32 %145, %150
	br %Bool %151 , label %then_12, label %endif_12
then_12:
	%152 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%153 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%154 = load %Int32, %Int32* %153
	%155 = bitcast %Int32 %154 to %Int32
	%156 = sext %Int16 %30 to %Int32
	%157 = add %Int32 %155, %156
	%158 = bitcast %Int32 %157 to %Int32
	store %Int32 %158, %Int32* %152
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

define internal void @doOpL(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = call %Int8 @decode_extract_rs2(%Word32 %instr)
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%9 = zext %Int8 %6 to %Int32
	%10 = getelementptr [32 x %Word32], [32 x %Word32]* %8, %Int32 0, %Int32 %9
	%11 = load %Word32, %Word32* %10
	%12 = bitcast %Word32 %11 to %Int32
	%13 = add %Int32 %12, %4
	%14 = bitcast %Int32 %13 to %Int32
; if_0
	%15 = bitcast i8 0 to %Word8
	%16 = icmp eq %Word8 %1, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:
	; LB (Load 8-bit signed integer value)
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%18 = load %Int32, %Int32* %17
	call void (%Int32, %Str8*, ...) @trace(%Int32 %18, %Str8* bitcast ([17 x i8]* @str42 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%20 = load %hart_BusInterface*, %hart_BusInterface** %19
	%21 = getelementptr %hart_BusInterface, %hart_BusInterface* %20, %Int32 0, %Int32 0
	%22 = load %Word8 (%Int32)*, %Word8 (%Int32)** %21
	%23 = call %Word8 %22(%Int32 %14)
	%24 = sext %Word8 %23 to %Int32
; if_1
	%25 = icmp ne %Int8 %5, 0
	br %Bool %25 , label %then_1, label %endif_1
then_1:
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%27 = zext %Int8 %5 to %Int32
	%28 = getelementptr [32 x %Word32], [32 x %Word32]* %26, %Int32 0, %Int32 %27
	%29 = bitcast %Int32 %24 to %Word32
	store %Word32 %29, %Word32* %28
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_2
	%30 = bitcast i8 1 to %Word8
	%31 = icmp eq %Word8 %1, %30
	br %Bool %31 , label %then_2, label %else_2
then_2:
	; LH (Load 16-bit signed integer value)
	%32 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%33 = load %Int32, %Int32* %32
	call void (%Int32, %Str8*, ...) @trace(%Int32 %33, %Str8* bitcast ([17 x i8]* @str43 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%34 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%35 = load %hart_BusInterface*, %hart_BusInterface** %34
	%36 = getelementptr %hart_BusInterface, %hart_BusInterface* %35, %Int32 0, %Int32 1
	%37 = load %Word16 (%Int32)*, %Word16 (%Int32)** %36
	%38 = call %Word16 %37(%Int32 %14)
	%39 = sext %Word16 %38 to %Int32
; if_3
	%40 = icmp ne %Int8 %5, 0
	br %Bool %40 , label %then_3, label %endif_3
then_3:
	%41 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%42 = zext %Int8 %5 to %Int32
	%43 = getelementptr [32 x %Word32], [32 x %Word32]* %41, %Int32 0, %Int32 %42
	%44 = bitcast %Int32 %39 to %Word32
	store %Word32 %44, %Word32* %43
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
; if_4
	%45 = bitcast i8 2 to %Word8
	%46 = icmp eq %Word8 %1, %45
	br %Bool %46 , label %then_4, label %else_4
then_4:
	; LW (Load 32-bit signed integer value)
	%47 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%48 = load %Int32, %Int32* %47
	call void (%Int32, %Str8*, ...) @trace(%Int32 %48, %Str8* bitcast ([17 x i8]* @str44 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%49 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%50 = load %hart_BusInterface*, %hart_BusInterface** %49
	%51 = getelementptr %hart_BusInterface, %hart_BusInterface* %50, %Int32 0, %Int32 2
	%52 = load %Word32 (%Int32)*, %Word32 (%Int32)** %51
	%53 = call %Word32 %52(%Int32 %14)
; if_5
	%54 = icmp ne %Int8 %5, 0
	br %Bool %54 , label %then_5, label %endif_5
then_5:
	%55 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%56 = zext %Int8 %5 to %Int32
	%57 = getelementptr [32 x %Word32], [32 x %Word32]* %55, %Int32 0, %Int32 %56
	store %Word32 %53, %Word32* %57
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
; if_6
	%58 = bitcast i8 4 to %Word8
	%59 = icmp eq %Word8 %1, %58
	br %Bool %59 , label %then_6, label %else_6
then_6:
	; LBU (Load 8-bit unsigned integer value)
	%60 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%61 = load %Int32, %Int32* %60
	call void (%Int32, %Str8*, ...) @trace(%Int32 %61, %Str8* bitcast ([18 x i8]* @str45 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%62 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%63 = load %hart_BusInterface*, %hart_BusInterface** %62
	%64 = getelementptr %hart_BusInterface, %hart_BusInterface* %63, %Int32 0, %Int32 0
	%65 = load %Word8 (%Int32)*, %Word8 (%Int32)** %64
	%66 = call %Word8 %65(%Int32 %14)
	%67 = zext %Word8 %66 to %Int32
; if_7
	%68 = icmp ne %Int8 %5, 0
	br %Bool %68 , label %then_7, label %endif_7
then_7:
	%69 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%70 = zext %Int8 %5 to %Int32
	%71 = getelementptr [32 x %Word32], [32 x %Word32]* %69, %Int32 0, %Int32 %70
	%72 = bitcast %Int32 %67 to %Word32
	store %Word32 %72, %Word32* %71
	br label %endif_7
endif_7:
	br label %endif_6
else_6:
; if_8
	%73 = bitcast i8 5 to %Word8
	%74 = icmp eq %Word8 %1, %73
	br %Bool %74 , label %then_8, label %endif_8
then_8:
	; LHU (Load 16-bit unsigned integer value)
	%75 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%76 = load %Int32, %Int32* %75
	call void (%Int32, %Str8*, ...) @trace(%Int32 %76, %Str8* bitcast ([18 x i8]* @str46 to [0 x i8]*), %Int8 %5, %Int32 %4, %Int8 %6)
	%77 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%78 = load %hart_BusInterface*, %hart_BusInterface** %77
	%79 = getelementptr %hart_BusInterface, %hart_BusInterface* %78, %Int32 0, %Int32 1
	%80 = load %Word16 (%Int32)*, %Word16 (%Int32)** %79
	%81 = call %Word16 %80(%Int32 %14)
	%82 = zext %Word16 %81 to %Int32
; if_9
	%83 = icmp ne %Int8 %5, 0
	br %Bool %83 , label %then_9, label %endif_9
then_9:
	%84 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%85 = zext %Int8 %5 to %Int32
	%86 = getelementptr [32 x %Word32], [32 x %Word32]* %84, %Int32 0, %Int32 %85
	%87 = bitcast %Int32 %82 to %Word32
	store %Word32 %87, %Word32* %86
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

define internal void @doOpS(%hart_Hart* %hart, %Word32 %instr) {
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
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%15 = zext %Int8 %4 to %Int32
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Int32 %15
	%17 = load %Word32, %Word32* %16
	%18 = bitcast %Word32 %17 to %Int32
	%19 = add %Int32 %18, %13
	%20 = bitcast %Int32 %19 to %Word32
	%21 = bitcast %Word32 %20 to %Int32
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%23 = zext %Int8 %5 to %Int32
	%24 = getelementptr [32 x %Word32], [32 x %Word32]* %22, %Int32 0, %Int32 %23
	%25 = load %Word32, %Word32* %24
; if_0
	%26 = bitcast i8 0 to %Word8
	%27 = icmp eq %Word8 %1, %26
	br %Bool %27 , label %then_0, label %else_0
then_0:
	; SB (save 8-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Int32, %Int32* %28
	call void (%Int32, %Str8*, ...) @trace(%Int32 %29, %Str8* bitcast ([17 x i8]* @str47 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%30 = trunc %Word32 %25 to %Word8
	%31 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%32 = load %hart_BusInterface*, %hart_BusInterface** %31
	%33 = getelementptr %hart_BusInterface, %hart_BusInterface* %32, %Int32 0, %Int32 3
	%34 = load void (%Int32, %Word8)*, void (%Int32, %Word8)** %33
	call void %34(%Int32 %21, %Word8 %30)
	br label %endif_0
else_0:
; if_1
	%35 = bitcast i8 1 to %Word8
	%36 = icmp eq %Word8 %1, %35
	br %Bool %36 , label %then_1, label %else_1
then_1:
	; SH (save 16-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%38 = load %Int32, %Int32* %37
	call void (%Int32, %Str8*, ...) @trace(%Int32 %38, %Str8* bitcast ([17 x i8]* @str48 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%39 = trunc %Word32 %25 to %Word16
	%40 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%41 = load %hart_BusInterface*, %hart_BusInterface** %40
	%42 = getelementptr %hart_BusInterface, %hart_BusInterface* %41, %Int32 0, %Int32 4
	%43 = load void (%Int32, %Word16)*, void (%Int32, %Word16)** %42
	call void %43(%Int32 %21, %Word16 %39)
	br label %endif_1
else_1:
; if_2
	%44 = bitcast i8 2 to %Word8
	%45 = icmp eq %Word8 %1, %44
	br %Bool %45 , label %then_2, label %endif_2
then_2:
	; SW (save 32-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Int32, %Int32* %46
	call void (%Int32, %Str8*, ...) @trace(%Int32 %47, %Str8* bitcast ([17 x i8]* @str49 to [0 x i8]*), %Int8 %5, %Int32 %13, %Int8 %4)

	;
	%48 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%49 = load %hart_BusInterface*, %hart_BusInterface** %48
	%50 = getelementptr %hart_BusInterface, %hart_BusInterface* %49, %Int32 0, %Int32 5
	%51 = load void (%Int32, %Word32)*, void (%Int32, %Word32)** %50
	call void %51(%Int32 %21, %Word32 %25)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @doOpSystem(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Int8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Int8 @decode_extract_rs1(%Word32 %instr)
	%7 = trunc %Word32 %3 to %Int16
; if_0
	%8 = icmp eq %Word32 %instr, 115
	br %Bool %8 , label %then_0, label %else_0
then_0:
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%10 = load %Int32, %Int32* %9
	call void (%Int32, %Str8*, ...) @trace(%Int32 %10, %Str8* bitcast ([7 x i8]* @str50 to [0 x i8]*))

	;
	call void @hart_irq(%hart_Hart* %hart, %Word32 8)
	br label %endif_0
else_0:
; if_1
	%11 = icmp eq %Word32 %instr, 1048691
	br %Bool %11 , label %then_1, label %else_1
then_1:
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%13 = load %Int32, %Int32* %12
	call void (%Int32, %Str8*, ...) @trace(%Int32 %13, %Str8* bitcast ([8 x i8]* @str51 to [0 x i8]*))

	;
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str52 to [0 x i8]*))
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 6
	store %Bool 1, %Bool* %15

	; CSR instructions
	br label %endif_1
else_1:
; if_2
	%16 = bitcast i8 1 to %Word8
	%17 = icmp eq %Word8 %1, %16
	br %Bool %17 , label %then_2, label %else_2
then_2:
	; CSR read & write
	call void @csr_rw(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_2
else_2:
; if_3
	%18 = bitcast i8 2 to %Word8
	%19 = icmp eq %Word8 %1, %18
	br %Bool %19 , label %then_3, label %else_3
then_3:
	; CSR read & set bit
	call void @csr_rs(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_3
else_3:
; if_4
	%20 = bitcast i8 3 to %Word8
	%21 = icmp eq %Word8 %1, %20
	br %Bool %21 , label %then_4, label %else_4
then_4:
	; CSR read & clear bit
	call void @csr_rc(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_4
else_4:
; if_5
	%22 = bitcast i8 4 to %Word8
	%23 = icmp eq %Word8 %1, %22
	br %Bool %23 , label %then_5, label %else_5
then_5:
	call void @csr_rwi(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_5
else_5:
; if_6
	%24 = bitcast i8 5 to %Word8
	%25 = icmp eq %Word8 %1, %24
	br %Bool %25 , label %then_6, label %else_6
then_6:
	call void @csr_rsi(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_6
else_6:
; if_7
	%26 = bitcast i8 6 to %Word8
	%27 = icmp eq %Word8 %1, %26
	br %Bool %27 , label %then_7, label %else_7
then_7:
	call void @csr_rci(%hart_Hart* %hart, %Int16 %7, %Int8 %5, %Int8 %6)
	br label %endif_7
else_7:
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Int32, %Int32* %28
	call void (%Int32, %Str8*, ...) @trace(%Int32 %29, %Str8* bitcast ([34 x i8]* @str53 to [0 x i8]*), %Word32 %instr)
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 6
	store %Bool 1, %Bool* %30
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

define internal void @doOpFence(%hart_Hart* %hart, %Word32 %instr) {
; if_0
	%1 = icmp eq %Word32 %instr, 16777231
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%3 = load %Int32, %Int32* %2
	call void (%Int32, %Str8*, ...) @trace(%Int32 %3, %Str8* bitcast ([7 x i8]* @str54 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret void
}

define void @hart_irq(%hart_Hart* %hart, %Word32 %irq) {
; if_0
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	%2 = zext i8 0 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = icmp eq %Word32 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Word32 %irq, %Word32* %5
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
define internal void @csr_rw(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%2 = zext %Int8 %rs1 to %Int32
	%3 = getelementptr [32 x %Word32], [32 x %Word32]* %1, %Int32 0, %Int32 %2
	%4 = load %Word32, %Word32* %3
; if_0
	%5 = icmp eq %Int16 %csr, 832
	br %Bool %5 , label %then_0, label %else_0
then_0:
	; mscratch
	br label %endif_0
else_0:
; if_1
	%6 = icmp eq %Int16 %csr, 833
	br %Bool %6 , label %then_1, label %else_1
then_1:
	; mepc
	br label %endif_1
else_1:
; if_2
	%7 = icmp eq %Int16 %csr, 834
	br %Bool %7 , label %then_2, label %else_2
then_2:
	; mcause
	br label %endif_2
else_2:
; if_3
	%8 = icmp eq %Int16 %csr, 835
	br %Bool %8 , label %then_3, label %else_3
then_3:
	; mbadaddr
	br label %endif_3
else_3:
; if_4
	%9 = icmp eq %Int16 %csr, 836
	br %Bool %9 , label %then_4, label %endif_4
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
define internal void @csr_rs(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	;TODO
	ret void
}


;
;The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
;
define internal void @csr_rc(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %rs1) {
	;TODO
	ret void
}



; -
define internal void @csr_rwi(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}



; read+clear immediate(5-bit)
define internal void @csr_rsi(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}



; read+clear immediate(5-bit)
define internal void @csr_rci(%hart_Hart* %hart, %Int16 %csr, %Int8 %rd, %Int8 %imm) {
	;TODO
	ret void
}

define internal void @trace(%Int32 %pc, %Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
; if_0
	br %Bool 0 , label %then_0, label %endif_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str55 to [0 x i8]*), %Int32 %pc)
	%4 = load i8*, i8** %1
	%5 = call %Int @vprintf(%Str8* %form, i8* %4)
	br label %endif_0
endif_0:
	%6 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %6)
	ret void
}

define internal void @notImplemented(%Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str56 to [0 x i8]*))
	%4 = load i8*, i8** %1
	%5 = call %Int @vprintf(%Str8* %form, i8* %4)
	%6 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %6)
	%7 = call %Int @puts(%ConstCharStr* bitcast ([3 x i8]* @str57 to [0 x i8]*))
	call void @exit(%Int -1)
	ret void
}

define void @hart_show_regs(%hart_Hart* %hart) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp slt %Int32 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %1
	%5 = load %Int32, %Int32* %1
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Int32 %5
	%8 = load %Word32, %Word32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str58 to [0 x i8]*), %Int32 %4, %Word32 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str59 to [0 x i8]*))
	%11 = load %Int32, %Int32* %1
	%12 = add %Int32 %11, 16
	%13 = load %Int32, %Int32* %1
	%14 = add %Int32 %13, 16
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %15, %Int32 0, %Int32 %14
	%17 = load %Word32, %Word32* %16
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str60 to [0 x i8]*), %Int32 %12, %Word32 %17)
	%19 = load %Int32, %Int32* %1
	%20 = add %Int32 %19, 1
	store %Int32 %20, %Int32* %1
	br label %again_1
break_1:
	ret void
}


