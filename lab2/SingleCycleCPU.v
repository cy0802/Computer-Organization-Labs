module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] pcInput, pcOutput, pcPlus4;
wire [31:0] inst, imm, ALUOut, readData1, readData2, readData;
wire [31:0] muxMemOut, muxALUAOut, muxALUBOut;
wire PcSel, RegWEn, BrUn, ASel, BSel, memRead, memWrite, BrEQ, BrLT;
wire [1:0] ALUOp, WBSel;
wire [3:0] ALUCtl;

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pcInput),
    .pc_o(pcOutput)
);


Adder m_Adder_1(
    .a(pcOutput),
    .b(4),
    .sum(pcPlus4)
);

InstructionMemory m_InstMem(
    .readAddr(pcOutput),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
    .funct3(inst[14:12]),
    .BrEQ(BrEQ),
    .BrLT(BrLT),
    .PcSel(PcSel),
    .RegWEn(RegWEn),
    .BrUn(BrUn),
    .Bsel(BSel),
    .ASel(ASel),
    .ALUOp(ALUOp),
    .MemRead(memRead),
    .MemWrite(memWrite),
    .WriteBackSel(WBSel)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(RegWEn),
    .readReg1(inst[19:15]),
    .readReg2(inst[24:20]),
    .writeReg(inst[11:7]),
    .writeData(muxMemOut),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(inst),
    .imm(imm)
);


Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(PcSel),
    .s0(pcPlus4),
    .s1(ALUOut),
    .out(pcInput)
);

Mux2to1 #(.size(32)) m_Mux_ALU_A(
    .sel(ASel),
    .s0(readData1),
    .s1(pcOutput),
    .out(muxALUAOut)
);

Mux2to1 #(.size(32)) m_Mux_ALU_B(
    .sel(BSel),
    .s0(readData2),
    .s1(imm),
    .out(muxALUBOut)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(muxALUAOut),
    .B(muxALUBOut),
    .ALUOut(ALUOut)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(readData2),
    .readData(readData)
);
/* verilator lint_off PINMISSING */
BranchCmp m_BranchCmp(
    .data1(readData1),
    .data2(readData2),
    .BrUn(BrUn),
    .BrLT(BrLT),
    .BrEQ(BrEQ)
);
Mux4to2 #(.size(32)) m_Mux_mem(
    .sel(WBSel),
    .s0(readData),
    .s1(ALUOut),
    .s2(pcPlus4),
    .s3({32{1'b0}}),
    .out(muxMemOut)
);

endmodule
