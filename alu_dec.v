module alu_dec(
  input wire [5:0] funct,
  input wire [1:0] op,
  output wire [2:0] alucontrol
) ;
 assign alucontrol=
 (op==2'b00)?3'b010:
 (op==2'b01)?3'b110:
 (op==2'b10)?
        (funct==6'b100000)?3'b010:
        (funct==6'b100010)?3'b110:
        (funct==6'b100100)?3'b000:
        (funct==6'b100101)?3'b001:
        (funct==6'b101010)?3'b111:
        3'b000:3'b000;
endmodule

