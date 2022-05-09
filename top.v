`timescale 1ns / 1ps

module top(
  input clk,rst,
   output wire jump,branch,alusrc,
  memwrite,memtoreg,regwrite,regdst,
  output wire [2:0] alucontrol,
  output reg [31:0] inst
    );

wire [31:0] instr;
reg [31:0] inst;
always@(*)begin
    inst=instr;
end
wire [31:0] dived_clk;    
clk_div clk_div(
  .clk(clk),
  .dived_clk(dived_clk)
);

wire ena;
wire [31:0] pc;
wire [9:0] addr;
pc top_pc(
 .clk(clk),
 .rst(rst),
 .pc_out(pc),
 .inst_ce(ena)
);
//get addr from last 9 bit of pc
assign addr=pc[9:0];


 // input the addr and get the instr   
 top_memory inst_ram (
    .clka(clk),    // input wire clka
    .ena(ena),
    .rst(rst),
    .addra(addr),  // get addr from pc
  .douta(instr)  // output wire [31 : 0] douta
  );  

//input the instr, get control message and alu_control message
controller controller(
  .instr(instr),
  .jump(jump),
   .branch(branch),
   .alusrc(alusrc),
  .memwrite(memwrite),
  .memtoreg(memtoreg),
  .regwrite(regwrite),
  .regdst(regdst),
  .alucontrol(alucontrol)
 );   

  
endmodule
