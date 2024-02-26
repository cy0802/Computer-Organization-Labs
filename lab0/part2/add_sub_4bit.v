module add_sub_4bit(input [3:0] A, input [3:0] B, input Mode, output [3:0] S, output cout);
    // full_adder(input cin, input a, input b, output s, output cout);
    wire [3:0] C;
    wire [3:0] MxorB;
    // and G0(C[0], Mode, 1'b1);
    xor G1(MxorB[0], Mode, B[0]);
    xor G2(MxorB[1], Mode, B[1]);
    xor G3(MxorB[2], Mode, B[2]);
    xor G4(MxorB[3], Mode, B[3]);
    full_adder FA1(Mode, A[0], MxorB[0], S[0], C[1]);
    full_adder FA2(C[1], A[1], MxorB[1], S[1], C[2]);
    full_adder FA3(C[2], A[2], MxorB[2], S[2], C[3]);
    full_adder FA4(C[3], A[3], MxorB[3], S[3], C[0]);
    assign cout = C[0];
endmodule
