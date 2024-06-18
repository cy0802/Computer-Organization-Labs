module Control(
    input [6:0] opcode,
    input [2:0] funct3,
    input breq,
    input brlt,
    output reg flush,
    output reg memRead,
    output reg memWrite,
    output reg [1:0] ASel,
    output reg [1:0] Bsel,
    output reg pcSel,
    output reg ALUOp,
    output reg regWrite,
    output reg [1:0] writeBackSel
);

always @(*) begin
    case(opcode)
        7'b1101111: begin // jal
            flush = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b01;
            Bsel = 2'b01;
            pcSel = 1'b1;
            ALUOp = 2'b00;
            regWrite = 1'b1;
            writeBackSel = 2'b10;
        end
        7'b1100111: begin // jalr
            flush = 1'b1;
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            Bsel = 2'b01;
            pcSel = 1'b1;
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
            WriteBackSel = 2'b00; // dont care
            case(funct3)
                3'b000: begin // beq
                    pcSel = breq ? 1'b1 : 1'b0;
                    flush = breq ? 1'b1 : 1'b0;
                end
                3'b001: begin // bne
                    pcSel = breq ? 1'b0 : 1'b1;
                    flush = breq ? 1'b0 : 1'b1;
                end
                3'b100: begin // blt
                    pcSel = brlt ? 1'b1 : 1'b0;
                    flush = brlt ? 1'b1 : 1'b0;
                end
                3'b101: begin // bge
                    pcSel = brlt ? 1'b0 : 1'b1;
                    flush = brlt ? 1'b0 : 1'b1;
                end
            endcase
        end
        7'b0000011: begin // lw
            flush = 1'b0;
            memRead = 1'b1;
            memWrite = 1'b0;
            ASel = 2'b00;
            Bsel = 2'b01;
            pcSel = 1'b0;
            ALUOp = 2'b00;
            regWrite = 1'b1;
            writeBackSel = 2'b00;
        end
        7'b0100011: begin // S type
            flush = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b1;
            ASel = 2'b00;
            Bsel = 2'b01;
            pcSel = 1'b0;
            ALUOp = 2'b00;
            regWrite = 1'b0;
            writeBackSel = 2'b00; // dont care
        end
        7'b0010011: begin // I type
            flush = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            Bsel = 2'b01;
            pcSel = 1'b0;
            ALUOp = 2'b11;
            regWrite = 1'b1;
            writeBackSel = 2'b01;
        end
        7'b0110011: begin // R type
            flush = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            Bsel = 2'b00;
            pcSel = 1'b0;
            ALUOp = 2'b10;
            regWrite = 1'b1;
            writeBackSel = 2'b01;
        end
        default: begin
            flush = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            ASel = 2'b00;
            Bsel = 2'b00;
            pcSel = 1'b0;
            ALUOp = 2'b00;
            regWrite = 1'b0;
            writeBackSel = 2'b00;
        end
    endcase
end
endmodule
