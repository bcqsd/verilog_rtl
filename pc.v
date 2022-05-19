module pc(
    input wire clk,rst,en,
    input wire [31:0] din,
    output reg [31:0] q
    );
always @(posedge clk) begin
    if(rst) q <= 32'b0;
    else if(en) begin
        q<=din;
    end  else begin
       q<=q;
    end
end
endmodule
