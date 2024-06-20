module PipReg1b (
    input clk,
    input rst,
    input reg data_in,
    output reg data_out
);

    always @(posedge clk, negedge rst) begin
        if (!rst)
            data_out <= 0;
        else
            data_out <= data_in;
    end

endmodule
