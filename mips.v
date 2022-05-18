module mips(
	input wire clk,rst,
	input wire[31:0] instr,ReadData, 
	output wire[31:0] AluOut,PC,WriteData,
    output wire inst_ram_ena,data_ram_ena,data_ram_wea
    );
	
	wire memtoregE,memtoregM,memtoregW,alusrc,regdst,regwriteE,regwriteW,regwriteM,jump,pcsrc,zero,overflow;
	wire[2:0] alucontrol;
    wire flushE;
    assign inst_ram_ena=1'b1;

	controller controller(
    .instr(instr),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(data_ram_wea),
    .memtoreg(memtoreg),
    .regwriteW(regwriteW),
    .regwriteM(regwriteM),
    .regwriteE(regwriteEE),
    .regdst(regdst),
    .memen(data_ram_ena),
    .alucontrol(alucontrol),
    .flushE(flushE)
    );
	datapath datapath(
       .clka(clk),
       .rst(rst),
       .instr(instr),
       .ReadData(ReadData),
       .PC(PC), 
       .AluOut(AluOut), 
       .WriteData(WriteData),
       .jump(jump),
       .regwriteW(regwrite),
       .regwriteM(regwrite),
       .regdst(regdst),
       .alusrc(alusrc),
       .branch(branch),
       .memtoreg(memtoreg),
       .alucontrol(alucontrol),
       .flushE(flushE)
    );
	
endmodule
