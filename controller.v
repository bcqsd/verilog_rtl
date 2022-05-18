module controller(
    input wire [31:0] instr,
    output wire jump,regdst,alusrc,branch,memwrite,memtoreg,memen,regwriteM,regwriteW,
    output wire [2:0] alucontrol
    );
wire [1:0] aluop;
wire [7:0] sigsD,sigsE;
wire [2:0] alucontrolD,alucontrolE;
main_dec main_dec(
    .op(instr[31:26]),
    .sigs(sigsD),
    .aluop(aluop)
);
alu_dec alu_dec(
    .funct(instr[5:0]),
    .op(aluop),
    .alucontrol(alucontrolD)
);

assign jump=sigsD[0];


//jump,regwrite,regdst,alusrc,branch,memwrite,memtoreg,memen

floprc #(8) r1E(clka,rst,1'b0,sigsD,sigsE);
floprc #(3) r2E(clka,rst,1'b0,alucontrolD,alucontrolE);
assign regdst=sigsE[2];
assign alusrc=sigsE[3];
assign alucontrol=alucontrolE;
assign memtoregE=sigsE[6];

//jump,regwrite,branch,memwrite,memtoreg,memen
wire [5:0] sigsM;
floprc #(8) r1M(clka,rst,1'b0,{sigsE[0:1],sigsE[4:7]},sigsM);
floprc #(3) r2M(clka,rst,1'b0,alucontrolD,alucontrolE);

assign memwrite=sigsM[3];
assign memen=sigsM[5];
assign branch=sigsM[2];
assign regwriteM=sigsM[1];
//jump,regwrite,memtoreg

wire [1:0] sigsW;
floprc #(5) r2M(clka,rst,1'b0,{sigsM[1],sigsM[4]},sigsW);
assign regwriteW=sigsW[0];
assign memtoregW=sigsW[1];

endmodule
