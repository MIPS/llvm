; ModuleID = 'cttz_zero_return_test.c'
; RUN: llc -mtriple=riscv64 -mattr=+zbb -verify-machineinstrs < %s | FileCheck %s -check-prefix=RV64ZBB

source_filename = "cttz_zero_return_test.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64-unknown-linux-elf-unknown"

@global_x = dso_local local_unnamed_addr global i32 0, align 4

define dso_local signext i32 @ctz_dereferencing_pointer(i64* nocapture noundef readonly %b) {
; RV64ZBB-LABEL: ctz_dereferencing_pointer:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	     ld	a0, 0(a0)
; RV64ZBB-NEXT:	     ctz a0, a0
; RV64ZBB-NEXT:	     andi a0, a0, 63
; RV64ZBB-NEXT:	     ret
entry:
  %0 = load i64, i64* %b, align 8
  %1 = tail call i64 @llvm.cttz.i64(i64 %0, i1 true)
  %2 = icmp eq i64 %0, 0
  %3 = trunc i64 %1 to i32
  %4 = select i1 %2, i32 0, i32 %3
  ret i32 %4
}

define dso_local signext i32 @ctz1(i32 noundef signext %x) {
; RV64ZBB-LABEL: ctz1:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	   ctzw	a0, a0
; RV64ZBB-NEXT:	   ret
entry:
  %0 = tail call i32 @llvm.cttz.i32(i32 %x, i1 true)
  %1 = icmp eq i32 %x, 0
  %conv = select i1 %1, i32 0, i32 %0
  ret i32 %conv
}

define dso_local signext i32 @ctz2(i32 noundef signext %x) {
; RV64ZBB-LABEL: ctz2:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	   ctzw	a0, a0
; RV64ZBB-NEXT:	   ret
entry:
  %0 = tail call i32 @llvm.cttz.i32(i32 %x, i1 false)
  ret i32 %0
}

define dso_local signext i32 @ctz3(i32 noundef signext %x) {
; RV64ZBB-LABEL: ctz3:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	   ctzw	a0, a0
; RV64ZBB-NEXT:	   ret
entry:
  %0 = tail call i32 @llvm.cttz.i32(i32 %x, i1 false)
  ret i32 %0
}

define dso_local signext i32 @ctz4(i64 noundef %b) {
; RV64ZBB-LABEL:  ctz4:
; RV64ZBB:        # %bb.0:
; RV64ZBB-NEXT:	    ctz	a0, a0
; RV64ZBB-NEXT:	    andi a0, a0, 63
; RV64ZBB-NEXT:	    ret
entry:
  %0 = tail call i64 @llvm.cttz.i64(i64 %b, i1 true)
  %1 = icmp eq i64 %b, 0
  %2 = trunc i64 %0 to i32
  %3 = select i1 %1, i32 0, i32 %2
  ret i32 %3
}

define dso_local signext i32 @ctz5(i32 noundef signext %x) {
; RV64ZBB-LABEL: ctz5:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	   ctzw	a0, a0
; RV64ZBB-NEXT:	   ret
entry:
  %0 = tail call i32 @llvm.cttz.i32(i32 %x, i1 true)
  %1 = icmp eq i32 %x, 0
  %conv = select i1 %1, i32 0, i32 %0
  ret i32 %conv
}

define dso_local signext i32 @ctz6(i32 noundef signext %x) {
; RV64ZBB-LABEL: ctz6:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:	   ctzw	a0, a0
; RV64ZBB-NEXT:	   ret
entry:
  %0 = tail call i32 @llvm.cttz.i32(i32 %x, i1 true)
  %1 = icmp eq i32 %x, 0
  %conv = select i1 %1, i32 0, i32 %0
  ret i32 %conv
}

define dso_local signext i32 @globalVar() {
; RV64ZBB-LABEL:  globalVar:
; RV64ZBB:        # %bb.0:
; RV64ZBB-NEXT:	    lui	a0, %hi(global_x)
; RV64ZBB-NEXT:	    lw a0, %lo(global_x)(a0)
; RV64ZBB-NEXT:	    ctzw a0, a0
; RV64ZBB-NEXT:	    ret
entry:
  %0 = load i32, i32* @global_x, align 4
  %1 = tail call i32 @llvm.cttz.i32(i32 %0, i1 true)
  %2 = icmp eq i32 %0, 0
  %conv = select i1 %2, i32 0, i32 %1
  ret i32 %conv
}

declare i64 @llvm.cttz.i64(i64, i1 immarg)
declare i32 @llvm.cttz.i32(i32, i1 immarg)

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64"}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 1, !"SmallDataLimit", i32 8}
!5 = !{!"clang version 15.0.0"}
