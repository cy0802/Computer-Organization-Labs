module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
    // done
    always @(*) begin
        case (opcode)
            7'b0110011: // R-type
                begin
                    branch = 1'b0;
                    memRead = 1'b0;
                    memtoReg = 1'b0;
                    ALUOp = 2'b10;
                    memWrite = 1'b0;
                    ALUSrc = 1'b0;
                    regWrite = 1'b1;
                end
            7'b0010011: // I-type
                begin
                    branch = 1'b0;
                    memRead = 1'b0;
                    memtoReg = 1'b0;
                    ALUOp = 2'b11;
                    memWrite = 1'b0;
                    ALUSrc = 1'b1;
                    regWrite = 1'b1;
                end
            7'b0000011: // lw
                begin
                    branch = 1'b0;
                    memRead = 1'b1;
                    memtoReg = 1'b1;
                    ALUOp = 2'b00;
                    memWrite = 1'b0;
                    ALUSrc = 1'b1;
                    regWrite = 1'b1;
                end
            7'b0100011: // sw
                begin
                    branch = 1'b0;
                    memRead = 1'b0;
                    memtoReg = 1'b0;
                    ALUOp = 2'b00;
                    memWrite = 1'b1;
                    ALUSrc = 1'b1;
                    regWrite = 1'b0;
                end
            7'b1100011: // beq
                begin
                    branch = 1'b1;
                    memRead = 1'b0;
                    memtoReg = 1'b0;
                    ALUOp = 2'b01;
                    memWrite = 1'b0;
                    ALUSrc = 1'b0;
                    regWrite = 1'b0;
                end
            default:
                begin
                    branch = 1'b0;
                    memRead = 1'b0;
                    memtoReg = 1'b0;
                    ALUOp = 2'b00;
                    memWrite = 1'b0;
                    ALUSrc = 1'b0;
                    regWrite = 1'b0;
                end
        endcase
    end

endmodule

