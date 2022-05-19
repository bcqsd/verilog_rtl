module mips(
    input wire clka,rst,
	output wire inst_ram_ena, data_ram_ena,
    output wire data_ram_wea,
    output wire [31:0] pc,alu_result, mem_wdata,
    input wire [31:0] instr, mem_rdata
    );
	
	wire memtoregE,memtoregM,memtoregW,alusrc,regdst,regwriteE,regwriteW,regwriteM,jump,pcsrc,zero,overflow;
	wire[2:0] alucontrol;
    wire[31:0] instrD;
    wire flushE;

controller controller(
    .instr(instrD),
    .clk(clka),
    .rst(rst),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(data_ram_wea),
    .memtoregE(memtoregE),
    .memtoregM(memtoregM),
    .memtoregW(memtoregW),
    .regwriteE(regwriteE),
    .regwriteM(regwriteM),
    .regwriteW(regwriteW),
    .regdst(regdst),
    .memen(data_ram_ena),
    .alucontrol(alucontrol),
    .flushE(flushE)
);
datapath datapath(
    .clka(clka),
    .rst(rst),
    .instr(instr),
    .mem_data(mem_rdata),
    .PC(pc),
    .alu_resultM(alu_result),
    .writedataM(mem_wdata),
    .jump(jump),
    .regwriteE(regwriteE),
    .regwriteM(regwriteM),
    .regwriteW(regwriteW),
    .regdst(regdst),
    .alusrc(alusrc),
    .branch(branch),
    .memtoregE(memtoregE),
    .memtoregM(memtoregM),
    .memtoregW(memtoregW),
    .alucontrol(alucontrol),
    .instrD(instrD),
    .flushE(flushE)
);	
endmodule
