module HazardDetect(
    input [4:0] rd_IDEX,
    input memRead_IDEX,
    input hasRd_IDEX,
    input [4:0] rs1_IFID,
    input [4:0] rs2_IFID,
    input hasRs1_IFID,
    input hasRs2_IFID,
    output reg ctlRst_IDEX,
    output reg PCEnable
);
    always @(*) begin
        if (hasRd_IDEX == 1'b0) begin
            ctlRst_IDEX = 0;
            PCEnable = 1;
        end else if (memRead_IDEX && ((rs1_IFID == rd_IDEX && hasRs1_IFID == 1'b1) || (rs2_IFID == rd_IDEX && hasRs2_IFID == 1'b1))) begin
            ctlRst_IDEX = 1;
            PCEnable = 0;
        end else begin
            ctlRst_IDEX = 0;
            PCEnable = 1;
        end
    end
endmodule
