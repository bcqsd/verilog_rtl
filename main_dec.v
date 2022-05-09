module main_dec(
  input wire [5:0] op,
  output wire jump,branch,alusrc,
  memwrite,memtoreg,regwrite,regdst,
  output wire [1:0] aluop
    );
 reg [1:0] aluop_reg;
 reg [6:0] sigs;  
 assign aluop=aluop_reg;
 assign   {jump,branch,alusrc,
  memwrite,memtoreg,regwrite,regdst}=sigs;
  always@(*)
  begin 
   case(op)
   6'b000000:
   begin
   aluop_reg<=2'b10;
   sigs<=7'b0110000;
    end
   default:
   begin
     aluop_reg<=2'b00;
   sigs<=7'b0000000;
   end
   endcase
  end
    
endmodule