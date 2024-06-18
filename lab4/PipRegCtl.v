module PipRegCtl (
    input wire clk,
    input wire rst,
    
    input flush,
    input memRead,
    input memWrite,
    input [1:0] ASel,
    input [1:0] Bsel,
    input pcSel,
    input ALUOp,
    input regWrite,
    input [1:0] writeBackSel,

    output reg flush_out,
    output reg memRead_out,
    output reg memWrite_out,
    output reg [1:0] ASel_out,
    output reg [1:0] Bsel_out,
    output reg pcSel_out,
    output reg ALUOp_out,
    output reg regWrite_out,
    output reg [1:0] writeBackSel_out
);

    always @(posedge clk, negedge rst) begin
        if (!rst)
            flush_out <= 1'b0;
            memRead_out <= 1'b0;
            memWrite_out <= 1'b0;
            ASel_out <= 2'b00;
            BSel_out <= 2'b00;
            pcSel_out <= 1'b0;
            ALUOp_out <= 1'b0;
            regWrite_out <= 1'b0;
            writeBackSel_out <= 2'b00;
        else
            flush_out <= flush;
            memRead_out <= memRead;
            memWrite_out <= memWrite;
            ASel_out <= ASel;
            BSel_out <= BSel;
            pcSel_out <= pcSel;
            ALUOp_out <= ALUOp;
            regWrite_out <= regWrite;
            writeBackSel_out <= writeBackSel;
    end

endmodule
