def i8500Model : SchedMachineModel {
  let MicroOpBufferSize = 1;
  let IssueWidth = 3;
  let LoadLatency = 3;
  let MispredictPenalty = 6;
  let CompleteModel = 0;
}


let SchedModel = i8500Model in {


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


let Latency = 4 in {
def : WriteRes<WriteIMul, [i8500GpMul]>;
def : WriteRes<WriteIMul32, [i8500GpMul]>;
}


def : WriteRes<WriteIDiv, [i8500GpDiv]> {
  let Latency = 32;
  let ReleaseAtCycles = [32];
}
def : WriteRes<WriteIDiv32,  [i8500GpDiv]> {
  let Latency = 32;
  let ReleaseAtCycles = [32];
}


let Latency = 3, ReleaseAtCycles = [1, 1] in {
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


let Latency = 1, ReleaseAtCycles = [1, 1] in {
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


let Latency = 1, ReleaseAtCycles = [1, 1] in {
def : WriteRes<WriteJmp, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJal, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJalr, [i8500Control, i8500Ctu]>;
def : WriteRes<WriteJmpReg, [i8500Control, i8500Ctu]>;
}


let Latency = 1 in {
def : WriteRes<WriteFMovI32ToF32, [i8500Alu01]>;
def : WriteRes<WriteFMovF32ToI32, [i8500Alu01]>;
def : WriteRes<WriteFMovI64ToF64, [i8500Alu01]>;
def : WriteRes<WriteFMovF64ToI64, [i8500Alu01]>;
}


let Latency = 1, ReleaseAtCycles = [1, 1] in {
def : WriteRes<WriteFSGNJ32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFMinMax32, [i8500FpuShort, i8500FpuApu]>;

def : WriteRes<WriteFSGNJ64, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFMinMax64, [i8500FpuShort, i8500FpuApu]>;
}


let Latency = 2, ReleaseAtCycles = [1, 1] in {
def : WriteRes<WriteFCmp32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFCmp64, [i8500FpuShort, i8500FpuApu]>;
}


let Latency = 2, ReleaseAtCycles = [2, 2] in {
def : WriteRes<WriteFClass32, [i8500FpuShort, i8500FpuApu]>;
def : WriteRes<WriteFClass64, [i8500FpuShort, i8500FpuApu]>;

}


let Latency = 4, ReleaseAtCycles = [1, 1] in {
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


let Latency = 4, ReleaseAtCycles = [1, 1] in {
def : WriteRes<WriteFMul32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFMul64, [i8500FpuLong, i8500FpuApu]>;
}


let Latency = 8, ReleaseAtCycles = [1, 1] in {
def : WriteRes<WriteFMA32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFMA64, [i8500FpuLong, i8500FpuApu]>;
}


let Latency = 22, ReleaseAtCycles = [1, 22] in {
def : WriteRes<WriteFDiv32, [i8500FpuLong, i8500FpuApu]>;
def : WriteRes<WriteFSqrt32, [i8500FpuLong, i8500FpuApu]>;
}


let Latency = 30, ReleaseAtCycles = [1, 30] in {
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
def : ReadAdvance<ReadFMA32Addend, 0>;
def : ReadAdvance<ReadFMA64, 0>;
def : ReadAdvance<ReadFMA64Addend, 0>;
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