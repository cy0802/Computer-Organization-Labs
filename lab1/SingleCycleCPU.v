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

wire [31:0] pc_input, pc_output, add1_out, add2_out;
wire [31:0] inst, imm, imm_shifted, ALU_out, mux_data_out, mux_ALU_out, readData1, readData2, readData;
wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite;
wire [1:0] ALUOp;
wire zero, mux_pc_sel;
wire [3:0] ALUCtl;


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_input),
    .pc_o(pc_output)
);

and m_and(mux_pc_sel, branch, zero);

Adder m_Adder_1(
    .a(pc_output),
    .b(4),
    .sum(add1_out)
);

InstructionMemory m_InstMem(
    .readAddr(pc_output),
    .inst(inst)
);

Control m_Control(
    .opcode(inst[6:0]),
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
    .regWrite(regWrite),
    .readReg1(inst[19:15]),
    .readReg2(inst[24:20]),
    .writeReg(inst[11:7]),
    .writeData(mux_data_out),
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

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(imm_shifted)
);

Adder m_Adder_2(
    .a(pc_output),
    .b(imm_shifted),
    .sum(add2_out)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(mux_pc_sel),
    .s0(add1_out),
    .s1(add2_out),
    .out(pc_input)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(mux_ALU_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(readData1),
    .B(mux_ALU_out),
    .ALUOut(ALU_out),
    .zero(zero)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALU_out),
    .writeData(readData2),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALU_out),
    .s1(readData),
    .out(mux_data_out)
);

endmodule
