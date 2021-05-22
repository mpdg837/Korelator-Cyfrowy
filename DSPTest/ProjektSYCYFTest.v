module ProjektSYCYFTest(
	input clk,
	input rst,
	input ena,
	input[7:0] rec
);

wire signed[13:0] tim;
wire rdy;

ProjektSYCYF dsp(.clk(clk),.rst(rst),.rec(rec),.ena(ena),.tim(tim),.rdy(rdy));
monitor monit(.clk(clk),.tim(tim),.rdy(rdy));


endmodule
