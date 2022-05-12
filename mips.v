module mips(
	input wire clk,rst,
	input wire[31:0] instr,
    input wire[31:0] ReadData, 
	output wire[31:0] AluOut,
    output wire[31:0] PC,
    output wire overflow,inst_ram_ena,data_ram_ena,data_ram_wea,WriteData
    );
	
	wire branch,memtoreg,alusrc,regdst,regwrite,jump,PCsrc,zero;
	
    wire[2:0] alucontrol;
    //cpu�?直在读指�?
    assign inst_ram_ena=1'b1;

	controller controller(
    .instruction(instr),
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
       .ALUOut(AluOut), 
       .WriteData(WriteData),
       .jump(jump),
       .regwrite(regwrite),
       .regdst(regdst),
       .alusrc(alusrc),
       .branch(branch),
       .memtoreg(memtoreg),
       .alucontrol(alucontrol),
       .overflow(overflow)
    );
	
endmodule
