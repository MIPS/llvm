; RUN: llc -mtriple=riscv64 -mcpu=i8500 -riscv-ins=1 -asm-show-inst \
; RUN: -verify-machineinstrs --show-mc-encoding < %s | FileCheck %s

define i64 @ins0(i64 %a) {
; CHECK-LABEL: ins0:
; CHECK-NOT: li a1, 17293823668614332415
; CHECK-NOT: and a0, a0, a1
; CHECK: ins a0, zero, 40, 20             # encoding: [0x0b,0x14,0xa0,0xee]
  %and = and i64 %a, 17293823668614332415 ; 0xf00000ffffffffff
  ret i64 %and
}

define i32 @ins1(i32 %a, i32 %b) {
; CHECK-LABEL: ins1:
; CHECK: ins a0, a1, 8, 8        # encoding: [0x0b,0x94,0xa5,0x3c]
  %and1 = and i32 %a, 4294902015 ; 0xffff00ff
  %lshift = shl i32 %b, 8
  %and2 = and i32 %lshift, 65280 ; 0x0000ff00
  %or = or i32 %and1, %and2
  ret i32 %or
}

define i32 @ins2(i32 %a, i32 %b) {
; CHECK-LABEL: ins2:
; CHECK: ins a0, a1, 8, 8        # encoding: [0x0b,0x94,0xa5,0x3c]
  %and1 = and i32 %a, 4294902015 ; 0xffff00ff
  %lshift = shl i32 %b, 8
  %and2 = and i32 %lshift, 65280 ; 0x0000ff00
  %or = or i32 %and2, %and1
  ret i32 %or
}

define i32 @ins3(i32 %a, i32 %b) {
; CHECK-LABEL: ins3:
; CHECK: ins a0, a1, 8, 8        # encoding: [0x0b,0x94,0xa5,0x3c]
  %and1 = and i32 %a, 4294902015 ; 0xffff00ff
  %and2 = and i32 %b, 255        ; 0x000000ff
  %lshift = shl i32 %and2, 8
  %or = or i32 %and1, %lshift
  ret i32 %or
}

define i32 @ins4(i32 %a, i32 %b) {
; CHECK-LABEL: ins4:
; CHECK: ins a0, a1, 0, 16       # encoding: [0x0b,0x90,0xa5,0x3c]
  %and1 = and i32 %a, 4294901760 ; 0xffff0000
  %and2 = and i32 %b, 65535      ; 0x0000ffff
  %or = or i32 %and1, %and2
  ret i32 %or
}

define i32 @ins5(i32 %a, i32 %b) {
; CHECK-LABEL: ins5:
; CHECK: ins a1, a0, 0, 16
; CHECK-NOT: ins a0, a1, 16, 16
  %and1 = and i32 %a, 65535      ; 0x0000ffff
  %and2 = and i32 %b, 4294901760 ; 0xffff0000
  %or = or i32 %and1, %and2
  ret i32 %or
}

define i32 @ins6(i32 %a, i32 %b) {
; CHECK-LABEL: ins6:
; CHECK: ins a0, a1, 20, 44      # encoding: [0x0b,0x9a,0xa5,0xfc]
  %and1 = and i32 %a, 1048575    ; 0x000fffff
  %shift = shl i32 %b, 20
  %or = or i32 %and1, %shift
  ret i32 %or
}
