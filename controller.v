module controller(
 input wire [31:0] instr,
 output wire jump,branch,alusrc,
  memwrite,memtoreg,regwrite,regdst,
  output wire [2:0] alucontrol
    );
  wire [1:0] aluop;
  main_dec main_dec(
   .op(instr[31:26]),
   .jump(jump),
   .branch(branch),
   .alusrc(alusrc),
  .memwrite(memwrite),
  .memtoreg(memtoreg),
  .regwrite(regwrite),
  .regdst(regdst),
  .aluop(aluop)
  );  
  alu_dec aludec(
  .funct(instr[5:0]),
  .op(aluop),
  .alucontrol(alucontrol)
  );  
endmodule

