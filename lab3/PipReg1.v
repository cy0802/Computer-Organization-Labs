module PipReg1 (
    input clk,
    input rst,
    input in,
    output reg out
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
