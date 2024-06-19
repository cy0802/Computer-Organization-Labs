module PipReg32bEn (
    input clk,
    input rst,
    input enable,
    input reg [31:0] data_in,
    output reg [31:0] data_out
);

    always @(posedge clk, negedge rst) begin
        if (!rst && enable)
            data_out <= 0;
        else if (enable)
            data_out <= data_in;
    end

endmodule
