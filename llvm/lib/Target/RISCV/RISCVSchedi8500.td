def i8500Model : SchedMachineModel {
  let MicroOpBufferSize = 1;
  let IssueWidth = 3;
  let LoadLatency = 3;
  let MispredictPenalty = 6;
  let CompleteModel = 0;
}


// (define_automaton "daimyo_int_pipe, daimyo_mdu_pipe, daimyo_fpu_short_pipe,
// 		   daimyo_fpu_long_pipe")

let SchedModel = i8500Model in {



// (define_cpu_unit "daimyo_gpmul, daimyo_gpdiv" "daimyo_mdu_pipe")
// (define_cpu_unit "daimyo_agen, daimyo_alu1, daimyo_lsu" "daimyo_int_pipe")
// (define_cpu_unit "daimyo_control, daimyo_ctu, daimyo_alu0" "daimyo_int_pipe")

// (define_cpu_unit "daimyo_fpu_short" "daimyo_fpu_short_pipe")
// (define_cpu_unit "daimyo_fpu_long, daimyo_fpu_apu" "daimyo_fpu_long_pipe")

let BufferSize = 0 in {
def i8500GpMul        : ProcResource<1>;
def i8500GpDiv        : ProcResource<1>;

def i8500Agen         : ProcResource<1>;
def i8500Alu1         : ProcResource<1>;
def i8500Lsu          : ProcResource<1>;

def i8500Control      : ProcResource<1>;
def i8500Ctu          : ProcResource<1>;
def i8500Alu0         : ProcResource<1>;

def i8500FpuShort     : ProcResource<1>;

def i8500FpuLong      : ProcResource<1>;
def i8500FpuApu       : ProcResource<1>;


def i8500ControlAlu0  : ProcResource<1>;
def i8500AgenAlu1     : ProcResource<1>;

}

def i8500Alu01 : ProcResGroup<[i8500ControlAlu0, i8500AgenAlu1]>;


//------------------------------------------------------------------------------
// (define_insn_reservation "daimyo_alu" 1
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "unknown,const,arith,shift,slt,multi,auipc,logical,move"))
//   "daimyo_control_alu0 | daimyo_agen_alu1")

let Latency = 1 in {
def : WriteRes<WriteIALU, [i8500Alu01]>;
def : WriteRes<WriteIALU32, [i8500Alu01]>;
def : WriteRes<WriteShiftImm, [i8500Alu01]>;
def : WriteRes<WriteShiftImm32, [i8500Alu01]>;
def : WriteRes<WriteShiftReg, [i8500Alu01]>;
def : WriteRes<WriteShiftReg32, [i8500Alu01]>;


//zba
def : WriteRes<WriteSHXADD, [i8500Alu01]>;
def : WriteRes<WriteSHXADD32, [i8500Alu01]>;

//zbb
def : WriteRes<WriteRotateReg, [i8500Alu01]>;
def : WriteRes<WriteRotateImm, [i8500Alu01]>;
def : WriteRes<WriteCLZ, [i8500Alu01]>;
def : WriteRes<WriteCTZ, [i8500Alu01]>;
def : WriteRes<WriteCPOP, [i8500Alu01]>;
def : WriteRes<WriteRotateReg32, [i8500Alu01]>;
def : WriteRes<WriteRotateImm32, [i8500Alu01]>;
def : WriteRes<WriteCLZ32, [i8500Alu01]>;
def : WriteRes<WriteCTZ32, [i8500Alu01]>;
def : WriteRes<WriteCPOP32, [i8500Alu01]>;
def : WriteRes<WriteREV8, [i8500Alu01]>;
def : WriteRes<WriteORCB, [i8500Alu01]>;

}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_imul" 4
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "imul"))
//   "daimyo_gpmul")

let Latency = 4 in {
def : WriteRes<WriteIMul, [i8500GpMul]>;
def : WriteRes<WriteIMul32, [i8500GpMul]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_idiv" 32
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "idiv"))
//   "daimyo_gpdiv*32")

def : WriteRes<WriteIDiv, [i8500GpDiv]> {
  let Latency = 32;
  let ResourceCycles = [32];
}
def : WriteRes<WriteIDiv32,  [i8500GpDiv]> {
  let Latency = 32;
  let ResourceCycles = [32];
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_load" 3
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "load,fpload"))
//   "daimyo_agen_lsu")

let Latency = 3, ResourceCycles = [1, 1] in {
def : WriteRes<WriteLDB, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteLDH, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteLDW, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteLDD, [i8500Agen ,i8500Lsu]>;

def : WriteRes<WriteFLD32, [i8500Agen ,i8500Lsu]>;
def : WriteRes<WriteFLD64, [i8500Agen ,i8500Lsu]>;

// Atomic memory
def : WriteRes<WriteAtomicW, [i8500Agen ,i8500Lsu]>;
def : WriteRes<WriteAtomicD, [i8500Agen ,i8500Lsu]>;
def : WriteRes<WriteAtomicLDW, [i8500Agen ,i8500Lsu]>;
def : WriteRes<WriteAtomicLDD, [i8500Agen ,i8500Lsu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_store" 1
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "store,fpstore"))
//   "daimyo_agen_lsu")

let Latency = 1, ResourceCycles = [1, 1] in {
def : WriteRes<WriteSTB, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteSTH, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteSTW, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteSTD, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteFST32, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteFST64, [i8500Agen, i8500Lsu]>;


// Atomic memory
def : WriteRes<WriteAtomicSTW, [i8500Agen, i8500Lsu]>;
def : WriteRes<WriteAtomicSTD, [i8500Agen, i8500Lsu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_branch" 1
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "branch,jump,call"))
//   "daimyo_control_ctu")

let Latency = 1, ResourceCycles = [1, 1] in {
def : WriteRes<WriteJmp, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJal, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJalr, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJmpReg, [i8500Control, i8500Ctu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_xfer" 1
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "mfc,mtc"))
//   "daimyo_control_alu0 | daimyo_agen_alu1")

let Latency = 1 in {
def : WriteRes<WriteFMovI32ToF32, [i8500Alu01]>;
def : WriteRes<WriteFMovF32ToI32, [i8500Alu01]>;
def : WriteRes<WriteFMovI64ToF64, [i8500Alu01]>;
def : WriteRes<WriteFMovF64ToI64, [i8500Alu01]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fmove" 1
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "fmove"))
//   "daimyo_fpu_short, daimyo_fpu_apu")

let Latency = 1, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFSGNJ32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFMinMax32, [i8500FpuShort, i8500FpuApu]>;

def : WriteRes<WriteFSGNJ64, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFMinMax64, [i8500FpuShort, i8500FpuApu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fcmp" 2
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "fcmp"))
//   "daimyo_fpu_short, daimyo_fpu_apu")

let Latency = 2, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFCmp32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFCmp64, [i8500FpuShort, i8500FpuApu]>;
}


let Latency = 2, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFClass32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFClass64, [i8500FpuShort, i8500FpuApu]>;

}

//---------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fcvt" 4
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "fadd,fcvt"))
//   "daimyo_fpu_long, daimyo_fpu_apu")

let Latency = 4, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFCvtI32ToF32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtI32ToF64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtI64ToF32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtI64ToF64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF32ToI32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF32ToI64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF32ToF64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF64ToI32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF64ToI64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFCvtF64ToF32, [i8500FpuLong, i8500FpuApu]>;

def : WriteRes<WriteFAdd32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFAdd64, [i8500FpuLong, i8500FpuApu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fmul" 5
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "fmul"))
//   "daimyo_fpu_long, daimyo_fpu_apu")

let Latency = 4, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFMul32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFMul64, [i8500FpuLong, i8500FpuApu]>;
}


//----------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fmadd" 8
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (eq_attr "type" "fmadd"))
//   "daimyo_fpu_long, daimyo_fpu_apu")

let Latency = 8, ResourceCycles = [1, 1] in {
def : WriteRes<WriteFMA32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFMA64, [i8500FpuLong, i8500FpuApu]>;
}


//------------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fdiv_sf" 22
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (and (eq_attr "type" "fdiv,fsqrt")
//             (eq_attr "mode" "SF")))
//   "daimyo_fpu_long+daimyo_fpu_apu*22")

let Latency = 22, ResourceCycles = [1, 21] in {
def : WriteRes<WriteFDiv32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFSqrt32, [i8500FpuLong, i8500FpuApu]>;
}


//------------------------------------------------------------------------------
// (define_insn_reservation "daimyo_fdiv_df" 30
//   (and (ior (eq_attr "tune" "daimyo") (eq_attr "tune" "i8500"))
//        (and (eq_attr "type" "fdiv,fsqrt")
//             (eq_attr "mode" "DF")))
//   "daimyo_fpu_long+daimyo_fpu_apu*30")

let Latency = 30, ResourceCycles = [1, 29] in {
def : WriteRes<WriteFDiv64, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFSqrt64, [i8500FpuLong, i8500FpuApu]>;
}


// Others
def : WriteRes<WriteCSR, [SiFive7PipeB]>;
def : WriteRes<WriteNop, []>;
def : InstRW<[WriteIALU], (instrs COPY)>;


//===----------------------------------------------------------------------===//
// Bypass and advance
def : ReadAdvance<ReadIALU, 0>;
def : ReadAdvance<ReadIALU32, 0>;
def : ReadAdvance<ReadShiftImm, 0>;
def : ReadAdvance<ReadShiftImm32, 0>;
def : ReadAdvance<ReadShiftReg, 0>;
def : ReadAdvance<ReadShiftReg32, 0>;
def : ReadAdvance<ReadSHXADD, 0>;
def : ReadAdvance<ReadSHXADD32, 0>;
def : ReadAdvance<ReadRotateReg, 0>;
def : ReadAdvance<ReadRotateImm, 0>;
def : ReadAdvance<ReadCLZ, 0>;
def : ReadAdvance<ReadCTZ, 0>;
def : ReadAdvance<ReadCPOP, 0>;
def : ReadAdvance<ReadRotateReg32, 0>;
def : ReadAdvance<ReadRotateImm32, 0>;
def : ReadAdvance<ReadCLZ32, 0>;
def : ReadAdvance<ReadCTZ32, 0>;
def : ReadAdvance<ReadCPOP32, 0>;
def : ReadAdvance<ReadREV8, 0>;
def : ReadAdvance<ReadORCB, 0>;
def : ReadAdvance<ReadIMul, 0>;
def : ReadAdvance<ReadIMul32, 0>;
def : ReadAdvance<ReadIDiv, 0>;
def : ReadAdvance<ReadIDiv32, 0>;
def : ReadAdvance<ReadJmp, 0>;
def : ReadAdvance<ReadJalr, 0>;
def : ReadAdvance<ReadFMovI32ToF32, 0>;
def : ReadAdvance<ReadFMovF32ToI32, 0>;
def : ReadAdvance<ReadFMovI64ToF64, 0>;
def : ReadAdvance<ReadFMovF64ToI64, 0>;
def : ReadAdvance<ReadFSGNJ32, 0>;
def : ReadAdvance<ReadFMinMax32, 0>;
def : ReadAdvance<ReadFSGNJ64, 0>;
def : ReadAdvance<ReadFMinMax64, 0>;
def : ReadAdvance<ReadFCmp32, 0>;
def : ReadAdvance<ReadFCmp64, 0>;
def : ReadAdvance<ReadFCvtI32ToF32, 0>;
def : ReadAdvance<ReadFCvtI32ToF64, 0>;
def : ReadAdvance<ReadFCvtI64ToF32, 0>;
def : ReadAdvance<ReadFCvtI64ToF64, 0>;
def : ReadAdvance<ReadFCvtF32ToI32, 0>;
def : ReadAdvance<ReadFCvtF32ToI64, 0>;
def : ReadAdvance<ReadFCvtF32ToF64, 0>;
def : ReadAdvance<ReadFCvtF64ToI32, 0>;
def : ReadAdvance<ReadFCvtF64ToI64, 0>;
def : ReadAdvance<ReadFCvtF64ToF32, 0>;
def : ReadAdvance<ReadFAdd32, 0>;
def : ReadAdvance<ReadFAdd64, 0>;
def : ReadAdvance<ReadFMul32, 0>;
def : ReadAdvance<ReadFMul64, 0>;
def : ReadAdvance<ReadFMA32, 0>;
def : ReadAdvance<ReadFMA64, 0>;
def : ReadAdvance<ReadFDiv32, 0>;
def : ReadAdvance<ReadFSqrt32, 0>;
def : ReadAdvance<ReadFDiv64, 0>;
def : ReadAdvance<ReadFSqrt64, 0>;
def : ReadAdvance<ReadAtomicWA, 0>;
def : ReadAdvance<ReadAtomicWD, 0>;
def : ReadAdvance<ReadAtomicDA, 0>;
def : ReadAdvance<ReadAtomicDD, 0>;
def : ReadAdvance<ReadAtomicLDW, 0>;
def : ReadAdvance<ReadAtomicLDD, 0>;
def : ReadAdvance<ReadAtomicSTW, 0>;
def : ReadAdvance<ReadAtomicSTD, 0>;
def : ReadAdvance<ReadFStoreData, 0>;
def : ReadAdvance<ReadCSR, 0>;
def : ReadAdvance<ReadMemBase, 0>;
def : ReadAdvance<ReadStoreData, 0>;
def : ReadAdvance<ReadFMemBase, 0>;
def : ReadAdvance<ReadFClass32, 0>;
def : ReadAdvance<ReadFClass64, 0>;

//===----------------------------------------------------------------------===//
// Unsupported extensions
defm : UnsupportedSchedV;
defm : UnsupportedSchedZbc;
defm : UnsupportedSchedZbs;
defm : UnsupportedSchedZbkb;
defm : UnsupportedSchedZbkx;
defm : UnsupportedSchedZfa;
defm : UnsupportedSchedZfh;
defm : UnsupportedSchedSFB;
}