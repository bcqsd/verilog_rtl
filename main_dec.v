
//input left 6-bit of instr and get control message and aluop

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
        6'b000000:begin
              aluop_reg<=2'b10;
              sigs<=7'b0110000;
       end
        6'b100011:begin
            aluop_reg <= 2'b00;
            sigs <= 7'b0010110;
        end
        6'b101011:begin
            aluop_reg <= 2'b00;
            sigs <= 7'b0011000;
        end
        6'b000100:begin
            aluop_reg <= 2'b01;
            sigs <= 7'b0100000;
        end
        6'b001000:begin
            aluop_reg <= 2'b00;
            sigs <= 7'b0010010;
        end
        6'b000010:begin
            aluop_reg <= 2'b00;
            sigs <= 7'b1000000;
        end

   default:
   begin
     aluop_reg<=2'b00;
   sigs<=7'b0000000;
   end
   endcase
  end
    
endmodule