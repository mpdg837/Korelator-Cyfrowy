module ProjektSYCYFProcesor(
	input ena,
	input clk,
	input rst,
	input[7:0] in,
	
	output[11:0] out
);
	 
	 system u0 (
        .clk_clk       (clk),       //   clk.clk
        .reset_reset_n (rst), 		// reset.reset_n
        .in_export     ({rdy,tim}),     //    in.export
        .out_export    (out)     //   out.export
    );

	 wire[13:0] tim;
	 wire rdy;
	 
	 ProjektSYCYF kore(
		.ena(ena),
		.rst(rst),
		.clk(clk),

		.rec(in),
		
		.tim(tim),
		.rdy(rdy)
	);
endmodule
