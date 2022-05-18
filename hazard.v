module hazard(
    input wire[4:0] rsD,rtD,rsE, rtE,writeregE, writeregM, writeregW,
    input wire regwriteE,regwriteM,regwriteW,memtoregE,memtoregM,branchD,
    output wire[1:0] forwardAE, forwardBE,
    output wire forwardAD, forwardBD,
    output wire stallF,stallD,flushE
    );

wire lwstall, branch_stall;

assign forwardAE = ((rsE != 5'b00000) & (rsE == writeregM) & regwriteM) ? 2'b10:
                    ((rsE != 5'b00000) & (rsE == writeregW) & regwriteW) ? 2'b01: 2'b00;
assign forwardBE = ((rtE != 5'b00000) & (rtE == writeregM) & regwriteM) ? 2'b10:
                    ((rtE != 5'b00000) & (rtE == writeregW) & regwriteW) ? 2'b01: 2'b00;
assign forwardAD = (rsD != 5'b00000) & (rsD == writeregM) & regwriteM;
assign forwardBD = (rtD != 5'b00000) & (rtD == writeregM) & regwriteM;



assign lwstall = ((rsD == rtE) | (rtD == rtE)) & memtoregE;
assign branch_stall = branchD & (regwriteE & ((writeregE == rsD) | (writeregE == rtD)) |
                    (memtoregM &((writeregM == rsD) | (writeregM == rtD))));
assign stallF = lwstall | branch_stall;
assign stallD = lwstall | branch_stall;
assign flushE = lwstall | branch_stall;                      
endmodule
