module main_dec(
    input wire [5:0] op,
    output wire jump,
    output wire branch,
    output wire alusrc,
    output wire memwrite,
    output wire memtoreg,
    output wire regwrite,
    output wire regdst,
    output wire memen,
    output wire [1:0] aluop
    );

reg [1:0] aluop_reg;
reg [7:0] sigs;    
assign aluop = aluop_reg;
assign {jump,branch,alusrc,memwrite,memtoreg,regwrite,regdst,memen} = sigs;   
always @(*) begin
    case (op)
        6'b000000:begin
            aluop_reg <= 2'b10;
            sigs <= 8'b00000110;
        end
        6'b100011:begin
            aluop_reg <= 2'b00;
            sigs <= 8'b00101101;
        end
        6'b101011:begin
            aluop_reg <= 2'b00;
            sigs <= 8'b00110000;
        end
        6'b000100:begin
            aluop_reg <= 2'b01;
            sigs <= 8'b01000000;
        end
        6'b001000:begin
            aluop_reg <= 2'b00;
            sigs <= 8'b00100100;
        end
        6'b000010:begin
            aluop_reg <= 2'b00;
            sigs <= 8'b10000000;
        end
        default: begin
            aluop_reg <= 2'b00;
            sigs <= 8'b00000000;
        end
    endcase
end
endmodule
