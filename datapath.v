module datapath(
    input wire clka,rst,
    input wire[31:0] instr,ReadData,
    input wire jump,regwrite,regdst,alusrc,branch,memtoreg,
    output wire overflow,
    input wire [2:0] alucontrol,
    output wire[31:0] PC, AluOut, WriteData
    );

wire [31:0] rd1, rd2, imme_extend;
wire [31:0] alu_srcB, wd3, imme_sl2,instr_sl2;
wire [31:0]  PC_plus4,pc_branch,pc_next,pc_next_jump;
wire [4:0] write2reg;
wire zero,pcsrc;
assign pcsrc = zero & branch;
assign WriteData = rd2;
// mux2 for pc_next
mux2 #(32) mux_pc_next(
    .a(PC_plus4),
    .b(pc_branch),
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
    .a(imme_extend),
    .y(imme_sl2)
    );
// pc+4
adder pc_plus_4(
    .a(PC),
    .b(32'b00000000_00000000_00000000_00000100),
    .c(PC_plus4)
    );
// pc_beanch  = pc+4 + signextent imm<<2
adder pcbranch(
    .a(PC_plus4),
    .b(imme_sl2), //!!!!
    .c(pc_branch)
);

// imme extend
sign_extend sign_extend(
    .a(instr[15:0]),
    .y(imme_extend)
    );

// mux2 for wd3, write data port of regfile
mux2 #(32) mux_wd3(
    .a(AluOut),
    .b(ReadData),
    .s(memtoreg), //memtoreg
    .c(wd3)
    );
// mux2 for wa3, write addr port of regfile
mux2 #(5) mux_wa3(
    .a(instr[20:16]),
    .b(instr[15:11]),
    .s(regdst), //regdst
    .c(write2reg)
    );    
//regfile
regfile regfile(
    .clk(clka),
    .we3(regwrite), //regwrite
    .ra1(instr[25:21]), //base
    .ra2(instr[20:16]), // sw, load from rt
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

endmodule
