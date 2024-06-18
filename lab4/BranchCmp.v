/* verilator lint_off NULLPORT */
/* verilator lint_off UNUSEDSIGNAL */
module BranchCmp(
    input [31:0] data1,
    input [31:0] data2,
    output reg BrLT,
    output reg BrEQ,
);
    assign BrLT = (data1 < data2);
    assign BrEQ = (data1 == data2);
    // always @(BrUn) begin
    //     if (BrUn) begin
    //         BrLT = (data1 < data2);
    //         BrEQ = (data1 == data2);
    //     end
    // end
endmodule

