module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst, // instruction
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode
    // done
    wire [6:0] opcode = inst[6:0];
    always @(*) begin
        case(opcode)
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map (table in spec) to set imm value
            
            // I-type instructions
            7'b0010011, 7'b0000011: imm = {{20{inst[31]}}, inst[31:20]};
            // S-type instructions
            7'b0100011: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            // B-type instructions
            7'b1100011: imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            default: imm = {32{1'b0}}; // for R-type and other instructions
        endcase
    end
endmodule

