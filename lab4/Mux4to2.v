module Mux4to2 #(
    parameter size = 32
) 
(
    input [1:0] sel,
    input signed [size-1:0] s0,
    input signed [size-1:0] s1,
    input signed [size-1:0] s2,
    input signed [size-1:0] s3,
    output signed [size-1:0] out
);
    // TODO: implement your 4to2 multiplexer here
    // done
    assign out = sel[1] ? (sel[0] ? s3 : s2) : (sel[0] ? s1 : s0);
endmodule

