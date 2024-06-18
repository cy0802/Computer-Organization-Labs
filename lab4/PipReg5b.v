module PipReg5b (
    input clk,
    input rst,
    input reg [4:0] data_in,
    output reg [4:0] data_out
);

    always @(posedge clk, negedge rst) begin
        if (!rst)
            data_out <= 0;
        else
            data_out <= data_in;
    end

endmodule
