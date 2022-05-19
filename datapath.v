module datapath(
    input wire clka,rst,
    input wire[31:0] instr,mem_data,
    output wire[31:0] PC, alu_resultM, writedataM,
    input wire jump,regwriteE,regwriteM,regwriteW,regdst,alusrc,branch,memtoregE,memtoregM, memtoregW,
    input wire [2:0] alucontrol,
    output wire [31:0] instrD,
    output wire flushE
    );

wire [31:0] PC_plus4F,imme_extend;
wire [31:0] alu_srcA, alu_srcB, wd3, imme_sl2, pc_next, pc_next_jump, instr_sl2;
wire [4:0] write2regE,write2regM,write2regW;
wire zero,pcsrc,zeroM;
wire [31:0] PC_plus4D, rd1D, rd2D, rd1E, rd2E,imme_extendE, alu_result,alu_resultM, pc_branchD, alu_resultW, mem_dataW, writedataE;
wire [4:0] rsD, rtD, rdD, rsE, rtE, rdE;
wire stallF,stallD;

wire [1:0] forwardAE,forwardBE;
wire  forwardAD, forwardBD;
wire [31:0] equalRD1, equalRD2;
wire equalD;   
assign pcsrc = equalD & branch;
// mux2 for pc_next
mux2 #(32) mux_pc_next(
    .a(PC_plus4F),
    .b(pc_branchD),
    .s(pcsrc), // pcsrc
    .c(pc_next)
    );
// left shift 2 for pc_jump instr_index
sl2 sl2_pc_jump(
    .a(instrD),
    .y(instr_sl2)
    );
// mux2 for pc_jump
wire [31:0] tmp1111;
assign tmp1111 = {PC_plus4D[31:28],instr_sl2[27:0]};
mux2 #(32) mux_pc_jump(
    .a(pc_next),
    .b({PC_plus4D[31:28],instr_sl2[27:0]}),
    .s(jump), // jump
    .c(pc_next_jump)
    );    
// pc
pc pc(
    .clk(clka),
    .rst(rst),
    .en(~stallF),
    .din(pc_next_jump),
    .q(PC)
    );
// F-D
flopenrc #(32) r1D(.clk(clka),.rst(rst),.en(~stallD),.clear(1'b0),.d(instr),.q(instrD));
flopenrc #(32) r2D(.clk(clka),.rst(rst),.en(~stallD),.clear(1'b0),.d(PC_plus4F),.q(PC_plus4D));

// pc+4
adder pc_plus_4(
    .a(PC),
    .b(32'b00000000_00000000_00000000_00000100),
    .c(PC_plus4F)
    );

// imme extend
sign_extend sign_extend(
    .a(instrD[15:0]),
    .y(imme_extend)
    );
// left shift 2 for pc_branch imme
sl2 sl2(
    .a(imme_extend),
    .y(imme_sl2)
    );
// pc_beanch  = pc+4 + signextent imm<<2
adder pcbranch(
    .a(PC_plus4D),
    .b(imme_sl2), //!!!!
    .c(pc_branchD)
);
assign rsD = instrD[25:21];    
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
    
//regfile
regfile regfile(
    .clk(~clka),
    .we3(regwriteW), //regwrite
    .ra1(instrD[25:21]), //base
    .ra2(instrD[20:16]), // sw, load from rt
    .wa3(write2regW), // lw, store to rt
    .wd3(wd3),
    .rd1(rd1D),
    .rd2(rd2D) 
    );
//D-E
flopenrc #(32) r1E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(rd1D),.q(rd1E));
flopenrc #(32) r2E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(rd2D),.q(rd2E));
flopenrc #(5) r3E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(rtD),.q(rtE));
flopenrc #(5) r4E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(rdD),.q(rdE));
//flopenrc #(5) r5E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(PC_plus4D),.q(PC_plus4E));
flopenrc #(32) r6E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(imme_extend),.q(imme_extendE));
flopenrc #(5) r7E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(rsD),.q(rsE));
//flopenrc #(3) r8E(.clk(clka),.rst(rst),.en(1'b1),.clear(flushE),.d(alucontrol),.q(alucontrolE));
  
mux3 #(32) srcA_sel(rd1E,wd3,alu_resultM,forwardAE, alu_srcA);
mux3 #(32) srcB_sel(rd2E,wd3,alu_resultM,forwardBE, writedataE);
// mux2 for alu_srcB
mux2 #(32) mux_alu_srcb(
    .a(writedataE),
    .b(imme_extendE),
    .s(alusrc), //alusrc
    .c(alu_srcB)
    );  
//alu
alu alu(
    .a(alu_srcA),
    .b(alu_srcB),
    .f(alucontrol), //alucontrol
    .s(alu_result),
    .overflow(),
    .zero(zero)
    );
// mux2 for wa3, write addr port of regfile
mux2 #(5) mux_wa3(
    .a(rtE),
    .b(rdE),
    .s(regdst), //regdst
    .c(write2regE)
    );
// E-M
floprc #(32) r1M(.clk(clka),.rst(rst),.clear(1'b0),.d(alu_result),.q(alu_resultM));
floprc #(1) r2M(.clk(clka),.rst(rst),.clear(1'b0),.d(zero),.q(zeroM));
floprc #(32) r3M(.clk(clka),.rst(rst),.clear(1'b0),.d(writedataE),.q(writedataM));
//floprc #(32) r4M(.clk(clka),.rst(rst),.clear(1'b0),.d(pc_branch),.q(pc_branchM));
floprc #(5) r5M(.clk(clka),.rst(rst),.clear(1'b0),.d(write2regE),.q(write2regM));
//floprc #(5) r6M(
//    .clk(clka),
//    .rst(rst),
//    .clear(1'b0),
//    .d(rdE),
//    .q(rdM)
//    );
// M-W    
floprc #(32) r1W(.clk(clka),.rst(rst),.clear(1'b0),.d(alu_resultM),.q(alu_resultW));
floprc #(32) r2W(.clk(clka),.rst(rst),.clear(1'b0),.d(mem_data),.q(mem_dataW));
floprc #(5) r3W(.clk(clka),.rst(rst),.clear(1'b0),.d(write2regM),.q(write2regW));
//floprc #(5) r4W(
//    .clk(clka),
//    .rst(rst),
//    .clear(1'b0),
//    .d(rdM),
//    .q(rdW)
//    );
// mux2 for wd3, write data port of regfile
mux2 #(32) mux_wd3(
    .a(alu_resultW),
    .b(mem_dataW),
    .s(memtoregW), //memtoreg
    .c(wd3)
    );
      
//hazard
hazard hazard(
    .rsD(rsD),
    .rtD(rtD),
    .rsE(rsE),
    .rtE(rtE),
    .writeregE(write2regE),
    .writeregM(write2regM),
    .writeregW(write2regW),
    .regwriteE(regwriteE),
    .regwriteM(regwriteM),
    .regwriteW(regwriteW),
    .memtoregE(memtoregE),
    .memtoregM(memtoregM),
    .branchD(branch),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE),
    .forwardAD(forwardAD),
    .forwardBD(forwardBD),
    .stallF(stallF),
    .stallD(stallD),
    .flushE(flushE)
    
);
mux2 #(32) equal1(
    .a(rd1D),
    .b(alu_resultM),
    .s(forwardAD),
    .c(equalRD1)
);
mux2 #(32) equal2(
    .a(rd2D),
    .b(alu_resultM),
    .s(forwardBD),
    .c(equalRD2)
);
assign equalD = (equalRD1 == equalRD2);
endmodule

