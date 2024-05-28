module PipReg32 #(
    parameter size = 32
) 
(
    input clk,
    input rst,
    input [size-1:0] in,
    output reg [size-1:0] out
);
    always @(posedge clk) begin
        if (!rst) begin
            out <= 0;
        end
        else begin
            out <= in;
        end
    end
endmodule
