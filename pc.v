`timescale 1ns / 1ps

//输出递增4的一个32位数字

module pc(
 input clk,rst,
 output reg [31:0] pc_out=32'b0,
 output wire inst_ce
    );
    
wire [31:0] pc_in;    
assign inst_ce = 
(pc_out<32'b00000000_00000000_00000100_00000000) 
? 1 : 0;

always@(posedge clk)
begin 
pc_out<=pc_in;
end
always@(posedge rst) begin
  pc_out<=32'b0;
end    

adder pc_adder(
 .v1(pc_out),
 .v2(32'h4),
 .out(pc_in)
);

endmodule
