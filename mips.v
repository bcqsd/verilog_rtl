module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] dataadr,writedata,
	input wire[31:0] readdata 
    );
	
	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,overflow;
	
    wire[2:0] alucontrol;

	controller controller(
    .instruction(instr),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .regdst(regdst),
    .memen(memen),
    .alucontrol(alucontrol)
    );
	datapath datapath(
       .clka(clk),
       .rst(rst),
       .instr(instr),
       .mem_data(),
       .PC(pc), 
       .alu_result, 
       .mem_wdata(),
       .jump(jump),
       .regwrite(regwrite),
       .regdst(regdst),
       .alusrc(alusrc),
       .branch(branch),
       .memtoreg(memtoreg),
       .alucontrol(alucontrol)
    );
	
endmodule
