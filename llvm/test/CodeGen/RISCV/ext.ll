; RUN: llc -mtriple=riscv64 -mcpu=i8500 -riscv-ext=1 -asm-show-inst \
; RUN: -verify-machineinstrs --show-mc-encoding < %s | FileCheck %s

define i32 @ext0(i32 %a) {
; CHECK-LABEL: ext0:
; CHECK-NOT: srl a0, a0, 12
; CHECK-NOT: andi a0, a0, 255
; CHECK: ext a0, a0, 12, 8    # encoding: [0x8b,0x19,0xa5,0x1e]
  %rshift = lshr i32 %a, 12
  %and = and i32 %rshift, 255 ; 0xff
  ret i32 %and
}

define i32 @ext1(i32 %a) {
; CHECK-LABEL: ext1:
; CHECK-NOT: li a1, 1048575
; CHECK-NOT: and a0, a0, a1
; CHECK: ext a0, a0, 0, 20    # encoding: [0x8b,0x1f,0xa5,0x4e]
  %and = and i32 %a, 1048575  ; 0xfffff
  ret i32 %and
}

define i32 @notext0(i32 %a) {
; CHECK-LABEL: notext0:
; CHECK-NOT: ext [[REG:a[0-9]]], [[REG]], [[#]], [[#]]
; CHECK: andi a0, a0, 47
  %and = and i32 %a, 47 ; 0b101111
  ret i32 %and
}

define i32 @notext1(i32 %a) {
; CHECK-LABEL: notext1:
; CHECK-NOT: ext [[REG:a[0-9]]], [[REG]], [[#]], [[#]]
  %and = and i32 %a, 4095 ; 0xff
  ret i32 %and
}
