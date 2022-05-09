// 1hz分频

module clk_div(
 input clk,
 output reg dived_clk
    );
  reg [31:0] cnt=32'b0;
  always@(posedge clk)
  begin 
  cnt<=cnt+32'b1;
  if(cnt[26]==1) begin 
    dived_clk<=32'b1;
  end
  else begin
   dived_clk<=32'b0;
   end
  end  
    
endmodule
