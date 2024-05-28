module PipRegCtl(
    input clk,
    input rst,
    
    input branch,
    input memRead,
    input memtoReg,
    input [1:0] ALUOp,
    input memWrite,
    input ALUSrc,
    input regWrite, 

    output reg branch_out,
    output reg memRead_out,
    output reg memtoReg_out,
    output reg [1:0] ALUOp_out,
    output reg memWrite_out,
    output reg ALUSrc_out,
    output reg regWrite_out
);
    always @(posedge clk) begin
        if (!rst) begin
            branch_out <= 0;
            memRead_out <= 0;
            memtoReg_out <= 0;
            ALUOp_out <= 2'b0;
            memWrite_out <= 0;
            ALUSrc_out <= 0;
            regWrite_out <= 0;
        end
        else begin
            branch_out <= branch;
            memRead_out <= memRead;
            memtoReg_out <= memtoReg;
            ALUOp_out <= ALUOp;
            memWrite_out <= memWrite;
            ALUSrc_out <= ALUSrc;
            regWrite_out <= regWrite;
        end
    end
endmodule
