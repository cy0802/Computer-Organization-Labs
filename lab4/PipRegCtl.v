module PipRegCtl (
    input wire clk,
    input wire rst,
    
    input memRead,
    input memWrite,
    input [1:0] ASel,
    input [1:0] BSel,
    input [1:0] ALUOp,
    input regWrite,
    input [1:0] writeBackSel,
    input hasRs1,
    input hasRs2,
    input hasRd,

    output reg memRead_out,
    output reg memWrite_out,
    output reg [1:0] ASel_out,
    output reg [1:0] BSel_out,
    output reg [1:0] ALUOp_out,
    output reg regWrite_out,
    output reg [1:0] writeBackSel_out,
    output reg hasRs1_out,
    output reg hasRs2_out,
    output reg hasRd_out
);
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            memRead_out <= 1'b0;
            memWrite_out <= 1'b0;
            ASel_out <= 2'b00;
            BSel_out <= 2'b00;
            ALUOp_out <= 2'b00;
            regWrite_out <= 1'b0;
            writeBackSel_out <= 2'b00;
            hasRs1_out <= 1'b0;
            hasRs2_out <= 1'b0;
            hasRd_out <= 1'b0;
        end else begin 
            memRead_out <= memRead;
            memWrite_out <= memWrite;
            ASel_out <= ASel;
            BSel_out <= BSel;
            ALUOp_out <= ALUOp;
            regWrite_out <= regWrite;
            writeBackSel_out <= writeBackSel;
            hasRs1_out <= hasRs1;
            hasRs2_out <= hasRs2;
            hasRd_out <= hasRd;
        end
    end

endmodule
