`timescale 1ns / 1ps
//  input 10-bit address and display it 

module top_memory(
 input wire clka,ena,rst,
 input wire [9:0] addra,
 output wire [6:0] segs,
 output wire [7:0] ans,
 output wire [31:0] douta
);

/** 
call Memeroy interface generator to generator an single-port rom
input 10-bit address and get 32-bit inst as douta

*/

blk_mem_gen_0 rom(
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .addra(addra),  // input wire [9 : 0] addra
  .douta(douta)  
);


endmodule