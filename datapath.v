module datapath(
    input wire clka,rst,
    input wire[31:0] instr,ReadData,
    input wire jump,regwrite,regdst,alusrc,branch,memtoreg,
    output wire overflow,
    input wire [2:0] alucontrol,
    output wire[31:0] PC, AluOutM, WriteData
    );

wire [31:0] rd1, rd2, imme_extend;
wire [31:0] alu_srcB, wd3, imme_sl2,instr_sl2;
wire [31:0]  PC_plus4,pc_branch,pc_next,pc_next_jump;
wire [4:0] write2reg;

wire [31:0] instrD,pc_plus_4D,rd1D,rd2D;
wire [4:0] rsD,rtD,rdD;

wire [31:0] rd1E,rd2E,imme_extendE;
wire [4:0] rsE,rtE,rdE;


wire [31:0] AluOutM,rd2M,pc_branchM,rtM,rdM;
wire  zeroM;

wire[31:0] AluOutW,ReadDataW,rtW,rdW;

wire zero,pcsrc;
assign pcsrc = zero & branch;
assign WriteData = rd2E;
// mux2 for pc_next
mux2 #(32) mux_pc_next(
    .a(PC_plus4),
    .b(pc_branchM),
    .s(pcsrc), // pcsrc
    .c(pc_next)
    );
// left shift 2 for pc_jump instr_index
sl2 sl2_pc_jump(
    .a(instr),
    .y(instr_sl2)
    );
// mux2 for pc_jump
mux2 #(32) mux_pc_jump(
    .a(pc_next),
    .b({PC_plus4[31:28],instr_sl2[27:0]}),
    .s(jump), // jump
    .c(pc_next_jump)
    );    
// pc
pc pc(
    .clk(~clka),
    .rst(rst),
    .din(pc_next_jump),
    .q(PC)
    );
// left shift 2 for pc_branch imme
sl2 sl2(
    .a(imme_extendE),
    .y(imme_sl2)
    );
// pc+4
adder pc_plus_4(
    .a(PC),
    .b(32'b00000000_00000000_00000000_00000100),
    .c(PC_plus4)
    );

//F-D  stage

floprc #(32) r1D(clka,rst,1'b0,instr,instrD);

floprc #(32) r2D(clka,rst,1'b0,pc_plus_4,pc_plus_4D);


//D-E stage


floprc #(32) r1E(clka,rst,1'b0,rd1,rd1E);
floprc #(32) r2E(clka,rst,1'b0,rd2,rd2E);

floprc #(5) r3E(clka,rst,1'b0,rtD,rtE);
floprc #(5) r4E(clka,rst,1'b0,rdD,rdE);
floprc #(5) r5E(clka,rst,1'b0,pc_plus_4D,pc_plus_4E);
floprc #(32) r6E(clka,rst,1'b0,imme_extend,imme_extendE);



//E-M stage

floprc #(32) r1M(clka,rst,1'b0,AluOut,AluOutM);
floprc #(1) r2M(clka,rst,1'b0,zero,zeroM);
floprc #(32) r3M(clka,rst,1'b0,WriteData,rd2M);
floprc #(32) r4M(clka,rst,1'b0,pc_branch,pc_branchM);
floprc #(32) r5M(clka,rst,1'b0,rtE,rtM);
floprc #(32) r6M(clka,rst,1'b0,rdE,rdM);

//M-W stage

floprc #(32) r1W(clka,rst,1'b0,AluOutM,AluOutW);
floprc #(32) r2W(clka,rst,1'b0,ReadData,ReadDataW);
floprc #(32) r3W(clka,rst,1'b0,rtM,rtW);
floprc #(32) r4W(clka,rst,1'b0,rdM,rdW);

// pc_branch  = pc+4 + signextent imm<<2
adder pcbranch(
    .a(PC_plus4E),
    .b(imme_sl2), //!!!!
    .c(pc_branch)
);

// imme extend
sign_extend sign_extend(
    .a(instrD[15:0]),
    .y(imme_extend)
    );

// mux2 for wd3, write data port of regfile
mux2 #(32) mux_wd3(
    .a(AluOutW),
    .b(ReadDataW),
    .s(memtoreg), //memtoreg
    .c(wd3)
    );
 

assign rtD=instrD[20:16];
assign rdD=instrD[15:11];


//regfile
regfile regfile(
    .clk(clka),
    .we3(regwrite), //regwrite
    .ra1(rtE), //base
    .ra2(rdE), // sw, load from rt
    .wa3(write2reg), // lw, store to rt
    .wd3(wd3),
    .rd1(rd1),
    .rd2(rd2) 
    );
// mux2 for alu_srcB
mux2 #(32) mux_alu_srcb(
    .a(rd2),
    .b(imme_extend),
    .s(alusrc), //alusrc
    .c(alu_srcB)
    );    
    
//alu
alu alu(
    .a(rd1),   //alu_srcA  read from regfile
    .b(alu_srcB),
    .f(alucontrol), //alucontrol
    .s(AluOut),
    .overflow(overflow),
    .zero(zero)
    );

// mux2 for wa3, write addr port of regfile
mux2 #(5) mux_wa3(
    .a(rtW),
    .b(rdW),
    .s(regdst), //regdst
    .c(write2reg)
    );   


endmodule
