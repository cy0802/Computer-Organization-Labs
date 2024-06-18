module HazardDetect(
    input [4:0] rd_IFID,
    input memRead_IDEX,
    input [4:0] rs1_IDEX,
    input [4:0] rs2_IDEX,
    output reg ctlRst_IDEX,
    output reg PCEnable
);
    always @(*) begin
        if (memRead_IDEX && (rs1_IDEX == rd_IFID || rs2_IDEX == rd_IFID)) begin
            ctlRst_IDEX = 0;
            PCEnable = 0;
        end else begin
            ctlRst_IDEX = 1;
            PCEnable = 1;
        end
    end
endmodule
