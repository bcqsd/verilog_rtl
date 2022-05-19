module top(
	input wire clka,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite
    );
wire inst_ram_ena, data_ram_ena, data_ram_wea;
wire [31:0] pc, instr, mem_wdata, mem_rdata; 


assign inst_ram_ena = 1'b1;

assign memwrite = data_ram_wea;
assign writedata = mem_wdata;   	
mips mips(
    .clka(clka),
    .rst(rst),
    .inst_ram_ena(inst_ram_ena),
    .data_ram_ena(data_ram_ena),
    .data_ram_wea(data_ram_wea),
    
    .instr(instr),
    .alu_result(dataadr),
    .mem_wdata(mem_wdata),
    .pc(pc),
    .mem_rdata(mem_rdata)
);
//inst_ram
inst_ram inst_ram (
  .clka(~clka),    // input wire clka
  .ena(inst_ram_ena),      // input wire ena
  .wea(4'b0000),      // input wire [3 : 0] wea
  .addra(pc),  // 
  .dina(32'b0),    // input wire [31 : 0] dina
  .douta(instr)  // output wire [31 : 0] douta
);
//data_ram
data_ram data_ram(
  .clka(~clka),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea({4{data_ram_wea}}),      // input wire [3 : 0] wea
  .addra(dataadr),  
  .dina(mem_wdata),    // input wire [31 : 0] dina
  .douta(mem_rdata)  // output wire [31 : 0] douta
);
endmodule
