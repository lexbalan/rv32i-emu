
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
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


; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/core/core.hm




%BusInterface = type {
	i8 (i32)*, 
	i16 (i32)*, 
	i32 (i32)*, 
	void (i32, i8)*, 
	void (i32, i16)*, 
	void (i32, i32)*
};

%Core = type {
	[32 x i32], 
	i32, 
	%BusInterface*, 
	i1, 
	i1, 
	i32, 
	i32
};























declare void @core_init(%Core* %core, %BusInterface* %bus)
declare void @core_tick(%Core* %core)
declare void @core_irq(%Core* %core, i32 %irq)


; -- SOURCE: /Users/alexbalan/p/riscv-emu/src/core/csr.hm





; -- SOURCE: src/core/csr.cm





define void @csr_rw(%Core* %core, i16 %csr, i8 %rd, i8 %rs1) {
	%1 = getelementptr inbounds %Core, %Core* %core, i32 0, i32 0
	%2 = getelementptr inbounds [32 x i32], [32 x i32]* %1, i32 0, i8 %rs1
	%3 = load i32, i32* %2
	%4 = icmp eq i16 %csr, 832
	br i1 %4 , label %then_0, label %else_0
then_0:
	; mscratch
	br label %endif_0
else_0:
	%5 = icmp eq i16 %csr, 833
	br i1 %5 , label %then_1, label %else_1
then_1:
	; mepc
	br label %endif_1
else_1:
	%6 = icmp eq i16 %csr, 834
	br i1 %6 , label %then_2, label %else_2
then_2:
	; mcause
	br label %endif_2
else_2:
	%7 = icmp eq i16 %csr, 835
	br i1 %7 , label %then_3, label %else_3
then_3:
	; mbadaddr
	br label %endif_3
else_3:
	%8 = icmp eq i16 %csr, 836
	br i1 %8 , label %then_4, label %endif_4
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



define void @csr_rs(%Core* %core, i16 %csr, i8 %rd, i8 %rs1) {
	;TODO
	ret void
}



define void @csr_rc(%Core* %core, i16 %csr, i8 %rd, i8 %rs1) {
	;TODO
	ret void
}



define void @csr_rwi(%Core* %core, i16 %csr, i8 %rd, i8 %imm) {
	;TODO
	ret void
}



define void @csr_rsi(%Core* %core, i16 %csr, i8 %rd, i8 %imm) {
	;TODO
	ret void
}



define void @csr_rci(%Core* %core, i16 %csr, i8 %rd, i8 %imm) {
	;TODO
	ret void
}


