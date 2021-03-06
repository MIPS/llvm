; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -csky-no-aliases -mattr=+2e3 < %s -mtriple=csky | FileCheck %s

define signext i1 @load_I_bits(i1* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_bits:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.b a0, (a0, 3)
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 3
  %0 = load i1, i1* %arrayidx, align 1
  ret i1 %0
}

define zeroext i1 @load_I_bit_(i1* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_bit_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.b a0, (a0, 3)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 3
  %0 = load i1, i1* %arrayidx, align 1
  ret i1 %0
}

define signext i8 @load_I_bs(i8* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_bs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld32.bs a0, (a0, 3)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 3
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define zeroext i8 @load_I_b_(i8* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_b_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.b a0, (a0, 3)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 3
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define signext i16 @load_I_hs(i16* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_hs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld32.hs a0, (a0, 6)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 3
  %0 = load i16, i16* %arrayidx, align 2
  ret i16 %0
}

define zeroext i16 @load_I_h_(i16* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_h_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.h a0, (a0, 6)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 3
  %0 = load i16, i16* %arrayidx, align 2
  ret i16 %0
}

define i32 @load_I_w(i32* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.w a0, (a0, 12)
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 3
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0
}

define i64 @load_I_d(i64* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-LABEL: load_I_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.w a2, (a0, 24)
; CHECK-NEXT:    ld16.w a1, (a0, 28)
; CHECK-NEXT:    mov16 a0, a2
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i64, i64* %a, i64 3
  %0 = load i64, i64* %arrayidx, align 4
  ret i64 %0
}

define i8 @load_I_i8_anyext(i8* %p) {
; CHECK-LABEL: load_I_i8_anyext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld16.b a0, (a0, 0)
; CHECK-NEXT:    rts16
entry:
  %ret = load i8, i8* %p, align 1
  ret i8 %ret
}

define signext i1 @load_R_bits(i1* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_bits:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.bs a0, (a0, a1 << 0)
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 %idxprom
  %0 = load i1, i1* %arrayidx, align 1
  ret i1 %0
}

define zeroext i1 @load_R_bit_(i1* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_bit_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.b a0, (a0, a1 << 0)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 %idxprom
  %0 = load i1, i1* %arrayidx, align 1
  ret i1 %0
}


define signext i8 @load_R_bs(i8* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_bs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.bs a0, (a0, a1 << 0)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 %idxprom
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define zeroext i8 @load_R_b_(i8* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_b_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.b a0, (a0, a1 << 0)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 %idxprom
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define signext i16 @load_R_hs(i16* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_hs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.hs a0, (a0, a1 << 1)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 %idxprom
  %0 = load i16, i16* %arrayidx, align 2
  ret i16 %0
}

define zeroext i16 @load_R_h_(i16* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_h_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.h a0, (a0, a1 << 1)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 %idxprom
  %0 = load i16, i16* %arrayidx, align 2
  ret i16 %0
}

define i32 @load_R_w(i32* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.w a0, (a0, a1 << 2)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0
}

define i64 @load_R_d(i64* nocapture readonly %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: load_R_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ixd32 a2, a0, a1
; CHECK-NEXT:    ldr32.w a0, (a0, a1 << 3)
; CHECK-NEXT:    ld16.w a1, (a2, 4)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i64, i64* %a, i64 %idxprom
  %0 = load i64, i64* %arrayidx, align 4
  ret i64 %0
}

define i8 @loadR_i8_anyext(i8* %c, i32 %a) {
; CHECK-LABEL: loadR_i8_anyext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ldr32.bs a0, (a0, a1 << 0)
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %a to i64
  %arrayidx = getelementptr inbounds i8, i8* %c, i64 %idxprom
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define signext i1 @store_I_bits(i1*  %a, i1 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_bits:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a1, a1, 1
; CHECK-NEXT:    st16.b a1, (a0, 3)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 3
  store i1 %b,  i1* %arrayidx, align 1
  ret i1 0
}

define zeroext i1 @store_I_bit_(i1*  %a, i1 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_bit_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a1, a1, 1
; CHECK-NEXT:    st16.b a1, (a0, 3)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 3
  store i1 %b, i1* %arrayidx, align 1
  ret i1 0
}

define signext i8 @store_I_bs(i8*  %a, i8 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_bs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.b a1, (a0, 3)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 3
  store i8 %b, i8* %arrayidx, align 1
  ret i8 0
}

define zeroext i8 @store_I_b_(i8*  %a, i8 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_b_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.b a1, (a0, 3)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 3
  store i8 %b, i8* %arrayidx, align 1
  ret i8 0
}

define signext i16 @store_I_hs(i16*  %a, i16 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_hs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.h a1, (a0, 6)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 3
  store i16 %b, i16* %arrayidx, align 2
  ret i16 0
}

define zeroext i16 @store_I_h_(i16*  %a, i16 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_h_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.h a1, (a0, 6)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 3
  store i16 %b, i16* %arrayidx, align 2
  ret i16 0
}

define i32 @store_I_w(i32*  %a, i32 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.w a1, (a0, 12)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 3
  store i32 %b, i32* %arrayidx, align 4
  ret i32 0
}

define i64 @store_I_d(i64*  %a, i64 %b) local_unnamed_addr #0 {
; CHECK-LABEL: store_I_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.w a2, (a0, 28)
; CHECK-NEXT:    st16.w a1, (a0, 24)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
entry:
  %arrayidx = getelementptr inbounds i64, i64* %a, i64 3
  store i64 %b, i64* %arrayidx, align 4
  ret i64 0
}

define i8 @store_I_i8_anyext(i8* %p, i8 %b) {
; CHECK-LABEL: store_I_i8_anyext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    st16.b a1, (a0, 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  store i8 %b, i8* %p, align 1
  ret i8 0
}

define signext i1 @store_R_bits(i1*  %a, i32 %b, i1 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_bits:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a2, a2, 1
; CHECK-NEXT:    str32.b a2, (a0, a1 << 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 %idxprom
  store i1 %c, i1* %arrayidx, align 1
  ret i1 0
}

define zeroext i1 @store_R_bit_(i1*  %a, i32 %b, i1 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_bit_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a2, a2, 1
; CHECK-NEXT:    str32.b a2, (a0, a1 << 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i1, i1* %a, i64 %idxprom
  store i1 %c, i1* %arrayidx, align 1
  ret i1 0
}


define signext i8 @store_R_bs(i8*  %a, i32 %b, i8 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_bs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.b a2, (a0, a1 << 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 %idxprom
  store i8 %c, i8* %arrayidx, align 1
  ret i8 0
}

define zeroext i8 @store_R_b_(i8*  %a, i32 %b, i8 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_b_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.b a2, (a0, a1 << 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i8, i8* %a, i64 %idxprom
  store i8 %c, i8* %arrayidx, align 1
  ret i8 0
}

define signext i16 @store_R_hs(i16*  %a, i32 %b, i16 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_hs:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.h a2, (a0, a1 << 1)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 %idxprom
  store i16 %c, i16* %arrayidx, align 2
  ret i16 0
}

define zeroext i16 @store_R_h_(i16*  %a, i32 %b, i16 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_h_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.h a2, (a0, a1 << 1)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i16, i16* %a, i64 %idxprom
  store i16 %c, i16* %arrayidx, align 2
  ret i16 0
}

define i32 @store_R_w(i32*  %a, i32 %b, i32 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.w a2, (a0, a1 << 2)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  store i32 %c, i32* %arrayidx, align 4
  ret i32 0
}

define i64 @store_R_d(i64*  %a, i32 %b, i64 %c) local_unnamed_addr #0 {
; CHECK-LABEL: store_R_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ixd32 t0, a0, a1
; CHECK-NEXT:    str32.w a2, (a0, a1 << 3)
; CHECK-NEXT:    st32.w a3, (t0, 4)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %b to i64
  %arrayidx = getelementptr inbounds i64, i64* %a, i64 %idxprom
  store i64 %c, i64* %arrayidx, align 4
  ret i64 0
}

define i8 @storeR_i8_anyext(i8* %c, i32 %a, i8 %d) {
; CHECK-LABEL: storeR_i8_anyext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    str32.b a2, (a0, a1 << 0)
; CHECK-NEXT:    movi16 a0, 0
; CHECK-NEXT:    rts16
entry:
  %idxprom = sext i32 %a to i64
  %arrayidx = getelementptr inbounds i8, i8* %c, i64 %idxprom
  store i8 %d, i8* %arrayidx, align 1
  ret i8 0
}
