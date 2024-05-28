module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);
/* verilator lint_off UNUSEDSIGNAL */
// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] added_pc, PC_EXMEM, PC_in, PC_out, PC_out_IFID, PC_out_IDEX, PC_adder_out;
wire PCSrc;
wire [31:0] inst, inst_IFID, inst_IDEX, inst_EXMEM, inst_MEMWB, imm, imm_IDEX, imm_shifted;
wire [31:0] readData1, readData2, readData1_IDEX, readData2_IDEX, readData2_EXMEM;
wire [31:0] readData, readData_MEMWB, mux_out, ALU_result, ALU_result_EXMEM, ALU_result_MEMWB;
wire [31:0] mux_ALU_out;
wire [3:0] ALUCtl;
wire ALU_zero, ALU_zero_EXMEM;

wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite;
wire branch_IDEX, memRead_IDEX, memtoReg_IDEX, memWrite_IDEX, ALUSrc_IDEX, regWrite_IDEX;
wire branch_EXMEM, memRead_EXMEM, memtoReg_EXMEM, memWrite_EXMEM, ALUSrc_EXMEM, regWrite_EXMEM;
wire branch_MEMWB, memRead_MEMWB, memtoReg_MEMWB, memWrite_MEMWB, ALUSrc_MEMWB, regWrite_MEMWB;
wire [1:0] ALUOp, ALUOp_IDEX, ALUOp_EXMEM, ALUOp_MEMWB;


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(PC_in),
    .pc_o(PC_out)
);

and m_and(PCSrc, branch_EXMEM, ALU_zero_EXMEM);

Adder m_Adder_1(
    .a(PC_out),
    .b(4),
    .sum(added_pc)
);

InstructionMemory m_InstMem(
    .readAddr(PC_out),
    .inst(inst)
);

Control m_Control(
    .opcode(inst_IFID[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
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
    .writeReg(inst_MEMWB[11:7]),
    .writeData(mux_out),
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

ShiftLeftOne m_ShiftLeftOne(
    .i(imm_IDEX),
    .o(imm_shifted)
);

Adder m_Adder_2(
    .a(PC_out_IDEX),
    .b(imm_shifted),
    .sum(PC_adder_out)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(PCSrc),
    .s0(added_pc),
    .s1(PC_EXMEM),
    .out(PC_in)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc_IDEX),
    .s0(readData2_IDEX),
    .s1(imm_IDEX),
    .out(mux_ALU_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp_IDEX),
    .funct7(inst_IDEX[30]),
    .funct3(inst_IDEX[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(readData1_IDEX),
    .B(mux_ALU_out),
    .ALUOut(ALU_result),
    .zero(ALU_zero)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite_EXMEM),
    .memRead(memRead_EXMEM),
    .address(ALU_result_EXMEM),
    .writeData(readData2_EXMEM),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg_MEMWB),
    .s0(ALU_result_MEMWB),
    .s1(readData_MEMWB),
    .out(mux_out)
);

PipReg32 m_PC_IFID(
    .clk(clk),
    .rst(start),
    .in(PC_out),
    .out(PC_out_IFID)
);

PipReg32 m_PC_IDEX(
    .clk(clk),
    .rst(start),
    .in(PC_out_IFID),
    .out(PC_out_IDEX)
);

PipReg32 m_PC_EXMEM(
    .clk(clk),
    .rst(start),
    .in(PC_adder_out),
    .out(PC_EXMEM)
);

PipReg32 m_inst_IFID(
    .clk(clk),
    .rst(start),
    .in(inst),
    .out(inst_IFID)
);

PipReg32 m_inst_IDEX(
    .clk(clk),
    .rst(start),
    .in(inst_IFID),
    .out(inst_IDEX)
);

PipReg32 m_inst_EXMEM(
    .clk(clk),
    .rst(start),
    .in(inst_IDEX),
    .out(inst_EXMEM)
);

PipReg32 m_inst_MEMWB(
    .clk(clk),
    .rst(start),
    .in(inst_EXMEM),
    .out(inst_MEMWB)
);

PipReg32 m_readData1_IDEX(
    .clk(clk),
    .rst(start),
    .in(readData1),
    .out(readData1_IDEX)
);

PipReg32 m_readData2_IDEX(
    .clk(clk),
    .rst(start),
    .in(readData2),
    .out(readData2_IDEX)
);

PipReg32 m_readData2_EXMEM(
    .clk(clk),
    .rst(start),
    .in(readData2_IDEX),
    .out(readData2_EXMEM)
);

PipReg32 m_Imm_IDEX(
    .clk(clk),
    .rst(start),
    .in(imm),
    .out(imm_IDEX)
);

PipReg32 m_ALU_EXMEM(
    .clk(clk),
    .rst(start),
    .in(ALU_result),
    .out(ALU_result_EXMEM)
);

PipReg1 m_ALU_zero_EXMEM(
    .clk(clk),
    .rst(start),
    .in(ALU_zero),
    .out(ALU_zero_EXMEM)
);

PipReg32 m_DMem_MEMWB(
    .clk(clk),
    .rst(start),
    .in(readData),
    .out(readData_MEMWB)
);

PipReg32 m_ALU_MEMWB(
    .clk(clk),
    .rst(start),
    .in(ALU_result_EXMEM),
    .out(ALU_result_MEMWB)
);


PipRegCtl m_Control_IDEX(
    .clk(clk),
    .rst(start),

    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),

    .branch_out(branch_IDEX),
    .memRead_out(memRead_IDEX),
    .memtoReg_out(memtoReg_IDEX),
    .ALUOp_out(ALUOp_IDEX),
    .memWrite_out(memWrite_IDEX),
    .ALUSrc_out(ALUSrc_IDEX),
    .regWrite_out(regWrite_IDEX)
);

PipRegCtl m_Control_EXMEM(
    .clk(clk),
    .rst(start),

    .branch(branch_IDEX),
    .memRead(memRead_IDEX),
    .memtoReg(memtoReg_IDEX),
    .ALUOp(ALUOp_IDEX),
    .memWrite(memWrite_IDEX),
    .ALUSrc(ALUSrc_IDEX),
    .regWrite(regWrite_IDEX),

    .branch_out(branch_EXMEM),
    .memRead_out(memRead_EXMEM),
    .memtoReg_out(memtoReg_EXMEM),
    .ALUOp_out(ALUOp_EXMEM),
    .memWrite_out(memWrite_EXMEM),
    .ALUSrc_out(ALUSrc_EXMEM),
    .regWrite_out(regWrite_EXMEM)
);

PipRegCtl m_Control_MEMWB(
    .clk(clk),
    .rst(start),

    .branch(branch_EXMEM),
    .memRead(memRead_EXMEM),
    .memtoReg(memtoReg_EXMEM),
    .ALUOp(ALUOp_EXMEM),
    .memWrite(memWrite_EXMEM),
    .ALUSrc(ALUSrc_EXMEM),
    .regWrite(regWrite_EXMEM),

    .branch_out(branch_MEMWB),
    .memRead_out(memRead_MEMWB),
    .memtoReg_out(memtoReg_MEMWB),
    .ALUOp_out(ALUOp_MEMWB),
    .memWrite_out(memWrite_MEMWB),
    .ALUSrc_out(ALUSrc_MEMWB),
    .regWrite_out(regWrite_MEMWB)
);

endmodule
