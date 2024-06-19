module CtlMux(
    input sel,

    input flush,
    input memRead,
    input memWrite,
    input [1:0] ASel,
    input [1:0] BSel,
    input pcSel,
    input [1:0] ALUOp,
    input regWrite,
    input [1:0] writeBackSel,

    output reg flush_o,
    output reg memRead_o,
    output reg memWrite_o,
    output reg [1:0] ASel_o,
    output reg [1:0] BSel_o,
    output reg pcSel_o,
    output reg [1:0] ALUOp_o,
    output reg regWrite_o,
    output reg [1:0] writeBackSel_o
);

assign flush_o = sel ? 1'b0 : flush;
assign memRead_o = sel ? 1'b0 : memRead;
assign memWrite_o = sel ? 1'b0 : memWrite;
assign ASel_o = sel ? 2'b00 : ASel;
assign BSel_o = sel ? 2'b00 : BSel;
assign pcSel_o = sel ? 1'b0 : pcSel;
assign ALUOp_o = sel ? 2'b00 : ALUOp;
assign regWrite_o = sel ? 1'b0 : regWrite;
assign writeBackSel_o = sel ? 2'b00 : writeBackSel;

endmodule
