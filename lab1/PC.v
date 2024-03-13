module PC (
    input clk,
    input rst,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
    
    // not sure if this is correct
    always @(posedge clk) begin
        if (!rst) begin
                pc_o <= 32'b0;
            end 
        else begin
                pc_o <= pc_i;
            end
    end


endmodule

