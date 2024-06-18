module Forward(
    input [4:0] rs1_IDEX,
    input [4:0] rs2_IDEX,
    input [4:0] rd_EXMEM,
    input [4:0] rd_MEMWB,
    input [1:0] ASel,
    input [1:0] Bsel,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    if (rd_EXMEM != 0 && rd_EXMEM == rs1_IDEX)
        forwardA = 2'b11;
    else if (rd_MEMWB != 0 && rd_MEMWB == rs1_IDEX)
        forwardA = 2'b10;
    else
        forwardA = ASel;

    if (rd_EXMEM != 0 && rd_EXMEM == rs2_IDEX)
        forwardB = 2'b11;
    else if (rd_MEMWB != 0 && rd_MEMWB == rs2_IDEX)
        forwardB = 2'b10;
    else
        forwardB = Bsel;
end

endmodule
