module controller(
    input wire [31:0] instr,
    input wire clk,rst,
    output wire jump,
    output wire branch,
    output wire alusrc,
    output wire memwrite,
    output wire memtoregE,memtoregM,memtoregW,
    output wire regwriteE,regwriteM, regwriteW,
    output wire regdst,
    output wire memen,
    output wire [2:0] alucontrol,
    input wire flushE

    );
wire [1:0] aluop;
wire [7:0] sigs, sigsD, sigsE;

main_dec main_dec(
    .op(instr[31:26]),
    .sigs(sigs),
    .aluop(aluop)
);
wire [2:0] alucontrolD, alucontrolE;
alu_dec alu_dec(
    .funct(instr[5:0]),
    .op(aluop),
    .alucontrol(alucontrolD)
);
assign sigsD = sigs;
floprc #(8) r1E(
    .clk(clk),
    .rst(rst),
    .clear(flushE),
    .d(sigsD),
    .q(sigsE)
    );
floprc #(3) r2E(
    .clk(clk),
    .rst(rst),
    .clear(flushE),
    .d(alucontrolD),
    .q(alucontrolE)
    );
assign branch = sigsD[6];
assign jump = sigsD[7];

//jump,branch,alusrc,memwrite,memtoreg,regwrite,regdst,memen,
assign regdst = sigsE[1];
assign alusrc = sigsE[5];
assign alucontrol = alucontrolE;
assign memtoregE = sigsE[3];
assign regwriteE = sigsE[2];
wire [7:0] sigsM;
floprc #(8) r1M(
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
    .d(sigsE),
    .q(sigsM)
    );
assign memwrite = sigsM[4];
assign memen = sigsM[0];
assign memtoregM = sigsM[3];
assign regwriteM = sigsM[2];
wire [7:0] sigsW;
floprc #(8) r1W(
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
    .d(sigsM),
    .q(sigsW)
    );
assign regwriteW = sigsW[2];
assign memtoregW = sigsW[3];
endmodule
