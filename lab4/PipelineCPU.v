module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

/* verilator lint_off UNUSEDSIGNAL */
wire [31:0] pcPlus4, pcOutput, pcInput, pc_IFID, pc_IDEX, pc_EXMEM, pcPlus4_EXMEM, pcPlus4_MEMWB;
wire [31:0] inst, inst_IFID, inst_IDEX, imm, imm_IDEX, readData1, readData2, rs2_IDEX, rs2_EXMEM, rs1_IDEX;
wire [4:0] rd_EXMEM, rd_MEMWB;
wire [31:0] ALUOut, ALU_EXMEM, readData, readData_MEMWB, ALU_EXMEM, ALU_MEMWB, WBData, muxA, muxB, readData1_IDEX, readData2_IDEX;
wire [3:0] ALUCtl;
wire [1:0] ASel, ASel_mux, ASel_IDEX, ASel_EXMEM, ASel_MEMWB, BSel, BSel_mux, BSel_IDEX, BSel_EXMEM, BSel_MEMWB, forwardA, forwardB;
wire [1:0] ALUOp, ALUOp_mux, ALUOp_IDEX, ALUOp_EXMEM, ALUOp_MEMWB, WBSel, WBSel_mux, WBSel_IDEX, WBSel_EXMEM, WBSel_MEMWB, forward_muxA, forward_muxB;
wire flush, pcEnable, rstCtl_IDEX;
wire memRead, memRead_mux, memRead_IDEX, memRead_EXMEM, memRead_MEMWB, memWrite, memWrite_mux, memWrite_IDEX, memWrite_EXMEM, memWrite_MEMWB;
wire pcSel, regWrite, regWrite_mux, regWrite_IDEX, regWrite_EXMEM, regWrite_MEMWB;

PC m_PC(
    .clk(clk),
    .rst(start),
    .enable(pcEnable),
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
    .opcode(inst_IFID[6:0]),
    .funct3(inst_IFID[14:12]),
    .memRead(memRead),
    .memWrite(memWrite),
    .ASel(ASel),
    .BSel(BSel),
    .ALUOp(ALUOp),
    .regWrite(regWrite),
    .writeBackSel(WBSel)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite_MEMWB),
    .readReg1(inst_IFID[19:15]),
    .readReg2(inst_IFID[24:20]),
    .writeReg(rd_MEMWB),
    .writeData(WBData),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(inst_IFID),
    .imm(imm)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(pcSel),
    .s0(pcPlus4),
    .s1(ALUOut),
    .out(pcInput)
);

Mux4to1 #(.size(32)) m_Mux_ALU_A(
    .sel(forwardA),
    .s0(rs1_IDEX),
    .s1(pc_IDEX),
    .s2(WBData),
    .s3(ALU_EXMEM),
    .out(muxA)
);

Mux4to1 #(.size(32)) m_Mux_ALU_B(
    .sel(forwardB),
    .s0(rs2_IDEX),
    .s1(imm_IDEX),
    .s2(WBData),
    .s3(ALU_EXMEM),
    .out(muxB)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp_IDEX),
    .funct7(inst_IDEX[30]),
    .funct3(inst_IDEX[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(muxA),
    .B(muxB),
    .ALUOut(ALUOut)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite_EXMEM),
    .memRead(memRead_EXMEM),
    .address(ALU_EXMEM),
    .writeData(rs2_EXMEM),
    .readData(readData)
);
/* verilator lint_off PINMISSING */
BranchCmp m_BranchCmp(
    .data1(readData1_IDEX),
    .data2(readData2_IDEX),
    .opcode(inst_IDEX[6:0]),
    .funct3(inst_IDEX[14:12]),
    .flush(flush),
    .pcSel(pcSel)
);

Mux4to1 #(.size(32)) m_Mux_BrCmpA(
    .sel(forward_muxA),
    .s0(rs1_IDEX),
    .s1(WBData),
    .s2(ALU_EXMEM),
    .s3({32{1'b0}}),
    .out(readData1_IDEX)
);

Mux4to1 #(.size(32)) m_Mux_BrCmpB(
    .sel(forward_muxB),
    .s0(rs2_IDEX),
    .s1(WBData),
    .s2(ALU_EXMEM),
    .s3({32{1'b0}}),
    .out(readData2_IDEX)
);

Mux4to1 #(.size(32)) m_Mux_mem(
    .sel(WBSel_MEMWB),
    .s0(readData_MEMWB),
    .s1(ALU_MEMWB),
    .s2(pcPlus4_MEMWB),
    .s3({32{1'b0}}),
    .out(WBData)
);

Forward m_Forward(
    .rs1_IDEX(inst_IDEX[19:15]),
    .rs2_IDEX(inst_IDEX[24:20]),
    .rd_EXMEM(rd_EXMEM),
    .rd_MEMWB(rd_MEMWB),
    .ASel(ASel_IDEX),
    .BSel(BSel_IDEX),
    .forwardA(forwardA),
    .forwardB(forwardB),
    .forward_muxA(forward_muxA),
    .forward_muxB(forward_muxB)
);


HazardDetect m_HazardDetect(
    .rd_IFID(inst_IDEX[11:7]),
    .memRead_IDEX(memRead_IDEX),
    .rs1_IDEX(inst_IFID[19:15]),
    .rs2_IDEX(inst_IFID[24:20]),
    .ctlRst_IDEX(rstCtl_IDEX),
    .PCEnable(pcEnable)
);

CtlMux m_CtlMux(
    .sel(rstCtl_IDEX),
    .memRead(memRead),
    .memWrite(memWrite),
    .ASel(ASel),
    .BSel(BSel),
    .ALUOp(ALUOp),
    .regWrite(regWrite),
    .writeBackSel(WBSel),

    .memRead_o(memRead_mux),
    .memWrite_o(memWrite_mux),
    .ASel_o(ASel_mux),
    .BSel_o(BSel_mux),
    .ALUOp_o(ALUOp_mux),
    .regWrite_o(regWrite_mux),
    .writeBackSel_o(WBSel_mux)
);

// ------- Pipeline Register -------

PipReg32bEn m_PC_IFID(
    .clk(clk),
    .rst(flush),
    .enable(pcEnable),
    .data_in(pcOutput),
    .data_out(pc_IFID)
);
PipReg32bEn m_inst_IFID(
    .clk(clk),
    .rst(flush),
    .enable(pcEnable),
    .data_in(inst),
    .data_out(inst_IFID)
);
PipReg32b m_PC_IDEX(
    .clk(clk),
    .rst(flush),
    .data_in(pc_IFID),
    .data_out(pc_IDEX)
);
PipReg32b m_rs1_IDEX(
    .clk(clk),
    .rst(flush),
    .data_in(readData1),
    .data_out(rs1_IDEX)
);
PipReg32b m_rs2_IDEX(
    .clk(clk),
    .rst(flush),
    .data_in(readData2),
    .data_out(rs2_IDEX)
);
PipReg32b m_imm_IDEX(
    .clk(clk),
    .rst(flush),
    .data_in(imm),
    .data_out(imm_IDEX)
);
PipReg32b m_inst_IDEX(
    .clk(clk),
    .rst(flush),
    .data_in(inst_IFID),
    .data_out(inst_IDEX)
);
PipReg32b m_PC_EXMEM(
    .clk(clk),
    .rst(start),
    .data_in(pc_IDEX),
    .data_out(pc_EXMEM)
);
PipReg32b m_ALU_EXMEM(
    .clk(clk),
    .rst(start),
    .data_in(ALUOut),
    .data_out(ALU_EXMEM)
);
PipReg32b m_rs2_EXMEM(
    .clk(clk),
    .rst(start),
    .data_in(readData2),
    .data_out(rs2_EXMEM)
);
PipReg5b m_rd_EXMEM(
    .clk(clk),
    .rst(start),
    .data_in(inst_IDEX[11:7]),
    .data_out(rd_EXMEM)
);
PipReg32b m_PCPlus4_MEMWB(
    .clk(clk),
    .rst(start),
    .data_in(pcPlus4_EXMEM),
    .data_out(pcPlus4_MEMWB)
);
PipReg32b m_ALU_MEMWB(
    .clk(clk),
    .rst(start),
    .data_in(ALU_EXMEM),
    .data_out(ALU_MEMWB)
);
PipReg32b m_readData_MEMWB(
    .clk(clk),
    .rst(start),
    .data_in(readData),
    .data_out(readData_MEMWB)
);
PipReg5b m_rd_MEMWB(
    .clk(clk),
    .rst(start),
    .data_in(rd_EXMEM),
    .data_out(rd_MEMWB)
);

Adder m_Adder_2(
    .a(pc_EXMEM),
    .b(4),
    .sum(pcPlus4_EXMEM)
);

PipRegCtl m_Ctl_IDEX(
    .clk(clk),
    .rst(flush),
    
    .memRead(memRead_mux),
    .memWrite(memWrite_mux),
    .ASel(ASel_mux),
    .BSel(BSel_mux),
    .ALUOp(ALUOp_mux),
    .regWrite(regWrite_mux),
    .writeBackSel(WBSel_mux),
    
    .memRead_out(memRead_IDEX),
    .memWrite_out(memWrite_IDEX),
    .ASel_out(ASel_IDEX),
    .BSel_out(BSel_IDEX),
    .ALUOp_out(ALUOp_IDEX),
    .regWrite_out(regWrite_IDEX),
    .writeBackSel_out(WBSel_IDEX)
);

PipRegCtl m_Ctl_EXMEM(
    .clk(clk),
    .rst(start),
    
    .memRead(memRead_IDEX),
    .memWrite(memWrite_IDEX),
    .ASel(ASel_IDEX),
    .BSel(BSel_IDEX),
    .ALUOp(ALUOp_IDEX),
    .regWrite(regWrite_IDEX),
    .writeBackSel(WBSel_IDEX),
    
    .memRead_out(memRead_EXMEM),
    .memWrite_out(memWrite_EXMEM),
    .ASel_out(ASel_EXMEM),
    .BSel_out(BSel_EXMEM),
    .ALUOp_out(ALUOp_EXMEM),
    .regWrite_out(regWrite_EXMEM),
    .writeBackSel_out(WBSel_EXMEM)
);

PipRegCtl m_Ctl_MEMWB(
    .clk(clk),
    .rst(start),
    
    .memRead(memRead_EXMEM),
    .memWrite(memWrite_EXMEM),
    .ASel(ASel_EXMEM),
    .BSel(BSel_EXMEM),
    .ALUOp(ALUOp_EXMEM),
    .regWrite(regWrite_EXMEM),
    .writeBackSel(WBSel_EXMEM),
    
    .memRead_out(memRead_MEMWB),
    .memWrite_out(memWrite_MEMWB),
    .ASel_out(ASel_MEMWB),
    .BSel_out(BSel_MEMWB),
    .ALUOp_out(ALUOp_MEMWB),
    .regWrite_out(regWrite_MEMWB),
    .writeBackSel_out(WBSel_MEMWB)
);

endmodule
