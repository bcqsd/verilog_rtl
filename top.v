`timescale 1ns / 1ps

module top(
	input wire clk,rst,
    output wire [31:0] writedata,dataadr,
    output wire memwrite
    );
	// wire clk;
    wire inst_ram_ena,data_ram_ena,data_ram_wea;
	wire[31:0] pc,instr,WriteData,ReadData;
    assign writedata=WriteData;
   assign memwrite=data_ram_wea;
	mips mips(
          .clk(clk),
          .rst(rst),
	      .instr(instr),
          .ReadData(ReadData), 
	      .WriteData(WriteData),
          .AluOut(dataadr),
          .PC(pc),
          .inst_ram_ena(inst_ram_ena),
          .data_ram_ena(data_ram_ena),
          .data_ram_wea(data_ram_wea)
    );
	inst_ram inst_ram(
       .clka(clk),    // input wire clka
       .ena(inst_ram_ena),      // input wire ena
       .wea(4'b0000),      // input wire [3 : 0] wea
       .addra(pc),   // input wire [31 : 0] addra
       .dina(32'b0),    // readonly
       .douta(instr)  // output wire [31 : 0] douta
    );
	data_ram data_ram(
        .clka(~clk),    // input wire clka
        .ena(1'b1),      // input wire ena
        .wea({4{data_ram_wea}}),      // input wire [3 : 0] wea
        .addra(dataadr),  // input wire [31 : 0] addra
        .dina(WriteData),    // input wire [31 : 0] dina
        .douta(ReadData)  // output wire [31 : 0] douta
    );
endmodule   
     