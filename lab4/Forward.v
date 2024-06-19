module Forward(
    input [4:0] rs1_IDEX,
    input [4:0] rs2_IDEX,
    input [4:0] rd_EXMEM,
    input [4:0] rd_MEMWB,
    input [1:0] ASel,
    input [1:0] BSel,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB,
    output reg [1:0] forward_mux
);

always @(*) begin
    if (rd_EXMEM != 0 && rd_EXMEM == rs1_IDEX && ASel == 2'b00)
        forwardA = 2'b11;
    else if (rd_MEMWB != 0 && rd_MEMWB == rs1_IDEX && ASel == 2'b00)
        forwardA = 2'b10;
    else
        forwardA = ASel;

    if (rd_EXMEM != 0 && rd_EXMEM == rs2_IDEX) begin
        forward_mux = 2'b10; 
        if (BSel == 2'b00)
            forwardB = 2'b11;
        else 
            forwardB = BSel;
    end else if (rd_MEMWB != 0 && rd_MEMWB == rs2_IDEX) begin
        forward_mux = 2'b01;
        if (BSel == 2'b00)
            forwardB = 2'b10;
        else
            forwardB = BSel;
    end else begin
        forwardB = BSel;
        forward_mux = 2'b00;
    end
end

endmodule
