module controller(
    input wire [31:0] instruction,
    output wire jump,
    output wire branch,
    output wire alusrc,
    output wire memwrite,
    output wire memtoreg,
    output wire regwrite,
    output wire regdst,
    output wire memen,
    output wire [2:0] alucontrol
    );
wire [1:0] aluop;
main_dec main_dec(
    .op(instruction[31:26]),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .regdst(regdst),
    .memen(memen),
    .aluop(aluop)
);
alu_dec alu_dec(
    .funct(instruction[5:0]),
    .op(aluop),
    .alucontrol(alucontrol)
);
endmodule
