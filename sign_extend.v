module sign_extend(
    input wire [15:0] src,
    output wire [31:0] ret
);
assign ret={{16{src[15]}},src}
endmodule
