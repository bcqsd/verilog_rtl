module test_bench(
    
    );
reg clk;
reg rst;
wire jump;
wire branch;
wire alusrc;
wire memwrite;
wire memtoreg;
wire regwrite;
wire regdst;
wire [31:0] inst;
wire [2:0] alucontrol; 

initial
begin 
    clk = 1'b0;
    rst = 1'b0;
    #50;
    repeat(20)
     begin 
 clk = ~clk;
   $display("instruction: %h, memtoreg: %b,memwrite: %b,alusrc:%b, regdst:%b, regwrite : %b, jump: %b,branch: %b, alucontrol: %b",
 inst,memtoreg,memwrite,alusrc,regdst,regwrite,jump,branch,alucontrol);
 #50;
end
end
top top(
    .inst(inst),
    .clk(clk),
    .rst(rst),
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
