module Control(
    input [6:0] opcode,
    input [2:0] funct3,
    input BrEQ,
    input BrLT,
    output reg PcSel,
    output reg RegWEn,
    output reg BrUn,
    output reg Bsel,
    output reg ASel,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] WriteBackSel
);

    always @(*) begin
        case(opcode)
            7'b1100011: begin // B type
                // set PCSel according to BrEQ and BrLT
                BrUn = 1'b1;
                case((funct3))
                    3'b000: begin // beq
                        PcSel = BrEQ ? 1'b1 : 1'b0;
                    end
                    3'b001: begin // bne
                        PcSel = BrEQ ? 1'b0 : 1'b1;
                    end
                    3'b100: begin // blt
                        PcSel = BrLT ? 1'b1 : 1'b0;
                    end
                    3'b101: begin // bge
                        PcSel = BrLT ? 1'b0 : 1'b1;
                    end
                    default: begin
                        PcSel = 1'b0;
                    end
                endcase
                
                RegWEn = 1'b0;
                Bsel = 1'b1;
                ASel = 1'b1;
                ALUOp = 2'b00;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                WriteBackSel = 2'b01; // dont care
            end
            7'b1101111: begin // jal
                PcSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0; // dont care
                Bsel = 1'b1;
                ASel = 1'b1;
                ALUOp = 2'b00; // check
                MemRead = 1'b1;
                MemWrite = 1'b0;
                WriteBackSel = 2'b10;
            end
            7'b1100111: begin // jalr
                PcSel = 1'b1;
                RegWEn = 1'b1;
                BrUn = 1'b0; // not sure
                Bsel = 1'b1;
                ASel = 1'b0;
                ALUOp = 2'b00; // add
                MemRead = 1'b1;
                MemWrite = 1'b0;
                WriteBackSel = 2'b10;
            end
            7'b0000011: begin // lw
                PcSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0; // dont care
                Bsel = 1'b1;
                ASel = 1'b0;
                ALUOp = 2'b00; // add
                MemRead = 1'b1;
                MemWrite = 1'b0;
                WriteBackSel = 2'b00;
            end
            7'b0100011: begin // sw
                PcSel = 1'b0;
                RegWEn = 1'b0;
                BrUn = 1'b0; // dont care
                Bsel = 1'b1;
                ASel = 1'b0;
                ALUOp = 2'b00; // add
                MemRead = 1'b0; 
                MemWrite = 1'b1;
                WriteBackSel = 2'b00; // dont care
            end
            7'b0010011: begin // I type
                PcSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0; // dont care
                Bsel = 1'b1;
                ASel = 1'b0;
                ALUOp = 2'b11;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                WriteBackSel = 2'b01;
            end
            7'b0110011: begin // R type
                PcSel = 1'b0;
                RegWEn = 1'b1;
                BrUn = 1'b0; // dont care
                Bsel = 1'b0; 
                ASel = 1'b0;
                ALUOp = 2'b10;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                WriteBackSel = 2'b01;
            end
            default: begin
                PcSel = 1'b0;
                RegWEn = 1'b0;
                BrUn = 1'b0; // dont care
                Bsel = 1'b0;
                ASel = 1'b0;
                ALUOp = 2'b00;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                WriteBackSel = 2'b00;
            end
        endcase
    end
    
endmodule
