module pc(
    input wire clk,rst,
    input wire [31:0] din,
    output reg [31:0] q
    );
always @(posedge clk) begin
    if(rst) q <= 32'b00000000_00000000_00000000_00000000;
    else q <= din;
end
endmodule
