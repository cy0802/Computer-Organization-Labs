/* verilator lint_off NULLPORT */
/* verilator lint_off UNUSEDSIGNAL */
module BranchCmp(
    input [31:0] data1,
    input [31:0] data2,
    input [6:0] opcode,
    input [2:0] funct3,
    output reg flush,
    output reg pcSel
);
    always @(*) begin
        case(opcode)
            7'b1100011: begin // B type
                case(funct3)
                    3'b000: begin // beq
                        if(data1 == data2) begin
                            flush = 1'b0;
                            pcSel = 1'b1;
                        end
                        else begin
                            flush = 1'b1;
                            pcSel = 1'b0;
                        end
                    end
                    3'b001: begin // bne
                        if(data1 != data2) begin
                            flush = 1'b0;
                            pcSel = 1'b1;
                        end
                        else begin
                            flush = 1'b1;
                            pcSel = 1'b0;
                        end
                    end
                    3'b100: begin // blt
                        if(data1 < data2) begin
                            flush = 1'b0;
                            pcSel = 1'b1;
                        end
                        else begin
                            flush = 1'b1;
                            pcSel = 1'b0;
                        end
                    end
                    3'b101: begin // bge
                        if(data1 >= data2) begin
                            flush = 1'b0;
                            pcSel = 1'b1;
                        end
                        else begin
                            flush = 1'b1;
                            pcSel = 1'b0;
                        end
                    end
                    default: begin
                        flush = 1'b1;
                        pcSel = 1'b0;
                    end
                endcase
            end
            7'b1101111, 7'b1100111: begin // jal, jalr
                flush = 1'b0;
                pcSel = 1'b1;
            end
            default: begin
                flush = 1'b1;
                pcSel = 1'b0;
            end
        endcase
    end
endmodule

