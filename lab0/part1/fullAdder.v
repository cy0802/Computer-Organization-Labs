module fullAdder(input cin, input a, input b, output s, output cout);
    // FullAdder compute addition of input cin, a and b,
    // then output result to s and carry bit to cout.

    // TODO: implement your fullAdder design here
    // For testbench verifying, do not modify input and output pin
    wire AxorB, AxorB_andCin, AandB;
    xor G1(AxorB, a, b);
    and G2(AandB, a, b);
    and G3(AxorB_andCin, AxorB, cin);
    xor G4(s, AxorB, cin);
    or G5(cout, AxorB_andCin, AandB);
endmodule

