/* verilator lint_off UNUSEDSIGNAL */
module Control(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg memRead,
    output reg memWrite,
    output reg [1:0] ASel,
    output reg [1:0] BSel,
    output reg [1:0] ALUOp,
    output reg regWrite,
    output reg [1:0] writeBackSel
);

always @(*) begin
    case(opcode)
        7'b1101111: begin // jal
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b01;
            BSel = 2'b01;
            ALUOp = 2'b00;
            regWrite = 1'b1;
            writeBackSel = 2'b10;
        end
        7'b1100111: begin // jalr
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            BSel = 2'b01;
            ALUOp = 2'b00;
            regWrite = 1'b1;
            writeBackSel = 2'b10;
        end
        7'b1100011: begin // B type
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b01;
            BSel = 2'b01;
            ALUOp = 2'b00;
            regWrite = 1'b0;
            writeBackSel = 2'b00; // dont care
        end
        7'b0000011: begin // lw
            memRead = 1'b1;
            memWrite = 1'b0;
            ASel = 2'b00;
            BSel = 2'b01;
            ALUOp = 2'b00;
            regWrite = 1'b1;
            writeBackSel = 2'b00;
        end
        7'b0100011: begin // S type
            memRead = 1'b0;
            memWrite = 1'b1;
            ASel = 2'b00;
            BSel = 2'b01;
            ALUOp = 2'b00;
            regWrite = 1'b0;
            writeBackSel = 2'b00; // dont care
        end
        7'b0010011: begin // I type
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            BSel = 2'b01;
            ALUOp = 2'b11;
            regWrite = 1'b1;
            writeBackSel = 2'b01;
        end
        7'b0110011: begin // R type
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            BSel = 2'b00;
            ALUOp = 2'b10;
            regWrite = 1'b1;
            writeBackSel = 2'b01;
        end
        default: begin
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            BSel = 2'b00;
            ALUOp = 2'b00;
            regWrite = 1'b0;
            writeBackSel = 2'b00;
        end
    endcase
end
endmodule
