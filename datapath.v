module datapath(
   input wire clka,rst
);

wire [31:0] instr,rd1,rd2,imm_extend;

//pc
wire [31:0] pc,pc_plus4;

pc pc(
   .clk(clka),
   .rst(rst),
   .din(pc_plus4),
   .q(pc)
);

adder pc_plus4(
  .v1(pc),
  .v2(32'd4),
  .out(pc_plus4)
);

// imm_extend

sign_extend sign_extend(
   .src(instr[15:0]),
   .ret(imm_extend)
);



//inst_ram
inst_ram inst_ram (
    .clka(clka),
    .ena(),
    .wea(),
    .addra(pc[7:0]),  //input wire [7:0] addra
    .dina(),
    .douta(instr)  //output wire [31:0] douta
);


//regfile
regfile regfile (
     .clk(),
     .we3(),
     .ra1(instr[25:21]),  //base
     .ra2(),
     .wa3(instr[20:16]),  //rt
     .wd3(mem_rdata),
     .rd1(rd1),
     .rd2(rd2)
);


//data_ram
wire [31:0] mem_rdata;

data_ram data_ram (
    .clka(clka),
    .ena(),          //enable
    .wea(),        //write enable
    .addra(alu_result[9:0]),  //input wire [9:0] addra
    .dina(),
    .douta(mem_rdata)  //output wire [31:0] douta
);

//alu 


wire [31:0] alu_result;
alu alu(
   .a(rd1),
   .b(imm_extend),
   .f(),   //alucontrol
   .s(alu_result),
   .overflow()
)


endmodule