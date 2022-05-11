module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] f,
    output reg [31:0] s,
    output reg overflow,
    output wire zero
    );
    
    always @(*) begin
        case (f)
            3'b000: begin
                s<= a & b;
                overflow <= a[31] & b[31];
            end
            3'b001: begin
                s<= a | b;
                overflow <= 0;
            end
            3'b010: begin
                s<= a + b;
                overflow <= 0;
            end
            3'b110: begin
                s<= a - b;
                overflow <= 0;
            end
            3'b100: begin
                s<= -a;
                overflow <= 0;
            end
            3'b111: begin
                s<= (a<b);
                overflow <= 0;
            end
            default: begin
                s<=32'b0;
                overflow <= 0;
            end
        endcase
    end
    assign zero = (s == 32'b0);
endmodule
