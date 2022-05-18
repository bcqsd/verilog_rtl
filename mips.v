module mips(
	input wire clk,rst,
	input wire[31:0] instr,ReadData, 
	output wire[31:0] AluOut,PC,WriteData,
    output wire inst_ram_ena,data_ram_ena,data_ram_wea
    );
	
	wire branch,memtoreg,alusrc,regdst,regwrite,jump,PCsrc,zero;
	
    wire[2:0] alucontrol;

    assign inst_ram_ena=1'b1;

	controller controller(
    .instr(instr),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(data_ram_wea),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .regdst(regdst),
    .memen(data_ram_ena),
    .alucontrol(alucontrol)
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
       .regwrite(regwrite),
       .regdst(regdst),
       .alusrc(alusrc),
       .branch(branch),
       .memtoreg(memtoreg),
       .alucontrol(alucontrol)
    );
	
endmodule
