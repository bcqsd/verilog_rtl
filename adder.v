module adder(
   input [31:0] v1,
   input [31:0] v2,
   output wire [31:0] out
    );
   assign out=v1+v2; 
endmodule
