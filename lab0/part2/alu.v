module alu(
    input [3:0] a,
    input [3:0] b,
    input [2:0] s,
    output reg [3:0] y
); 
    // alu has two input operand a and b.
    // It executes different operation over input a and b based on input s
    // then generate result to output y
    
    // TODO: implement your 4bits ALU design here and using your own fulladder module in this module
    // For testbench verifying, do not modify input and output pin
    // reg cout;
    wire [2:0] notS;
    not G0(notS[0], s[0]),
        G1(notS[1], s[1]),
        G2(notS[2], s[2]);
    
    wire [7:0] option;
    and O0(option[0], notS[2], notS[1], notS[0]),
        O1(option[1], notS[2], notS[1], s[0]),
        O2(option[2], notS[2], s[1], notS[0]),
        O3(option[3], notS[2], s[1], s[0]),
        O4(option[4], s[2], notS[1], notS[0]),
        O5(option[5], s[2], notS[1], s[0]),
        O6(option[6], s[2], s[1], notS[0]),
        O7(option[7], s[2], s[1], s[0]);
    
    wire [3:0] result0;
    wire [3:0] result1;
    wire [3:0] result2;
    wire [3:0] result3;
    wire [3:0] result4;
    wire [3:0] result5;
    wire [3:0] result6;
    wire [3:0] result7;
    
    //add_sub_4bit(input A[3:0], B[3:0], Mode, output reg S[3:0], cout);
    // verilator lint_off UNUSEDSIGNAL
    wire tmp0, tmp1;
    add_sub_4bit FAB0(a, b, 1'b0, result0, tmp0);
    add_sub_4bit FAB1(a, b, 1'b1, result1, tmp1);
    // verilator lint_on UNUSEDSIGNAL
    
    // fix error: signal not used
    // assign result2 = {{2{1'b0}}, tmp0 & 1'b0, tmp1 & 1'b0};

    not N(result2, a);
    and A(result3, a, b);
    or OR(result4, a, b);
    xor XOR(result5, a, b);

    // magnitude comparator
    wire [3:0] x;
    wire [1:0] mag;
    assign x = ~(((~a) & b) | (a & (~b)));
    assign mag[1] = (a[3] & (~b[3])) | 
            (x[3] & (a[2] & (~b[2]))) | 
            ((x[3] & x[2]) & (a[1] & (~b[1]))) | 
            (((x[3] & x[2]) & x[1]) & (a[0] & (~b[0])));
    assign result6 = {{3{1'b0}}, mag[1]};

    assign mag[0] = ((x[3] & x[2]) & (x[1] & x[0]));
    assign result7 = {{3{1'b0}}, mag[0]};

    assign y = option[0] ? result0 : 
            option[1] ? result1 : 
            option[2] ? result2 : 
            option[3] ? result3 : 
            option[4] ? result4 : 
            option[5] ? result5 : 
            option[6] ? result6 : 
            option[7] ? result7 : 4'b0;
endmodule

