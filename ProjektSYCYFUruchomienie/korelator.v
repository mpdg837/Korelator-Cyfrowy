module korelator(
	input ena,
	input rst,
	input clk,

	input signed[7:0] rec,
	
	output signed[24:0] out,
	output clk0
);


wire clk_0;
wire [4:0] tim;

wire signed[7:0] out0;
wire signed[7:0] out1;
wire signed[7:0] out2;
wire signed[7:0] out3;
wire signed[7:0] out4;
wire signed[7:0] out5;
wire signed[7:0] out6;
wire signed[7:0] out7;
wire signed[7:0] out8;
wire signed[7:0] out9;
wire signed[7:0] out10;
wire signed[7:0] out11;
wire signed[7:0] out12;
wire signed[7:0] out13;
wire signed[7:0] out14;
wire signed[7:0] out15;
wire signed[7:0] out16;
wire signed[7:0] out17;
wire signed[7:0] out18;
wire signed[7:0] out19;

wire signed[7:0] sin0 = $signed(8'b00000000);
wire signed[7:0] sin1 = $signed(8'b00100111);
wire signed[7:0] sin2 = $signed(8'b01001011);
wire signed[7:0] sin3 = $signed(8'b01100111);
wire signed[7:0] sin4 = $signed(8'b01111001);
wire signed[7:0] sin5 = $signed(8'b01111111);
wire signed[7:0] sin6 = $signed(8'b01111001);
wire signed[7:0] sin7 = $signed(8'b01100111);
wire signed[7:0] sin8 = $signed(8'b01001011);
wire signed[7:0] sin9 = $signed(8'b00100111);
wire signed[7:0] sin10 = $signed(8'b00000000);
wire signed[7:0] sin11 = $signed(8'b11011001);
wire signed[7:0] sin12 = $signed(8'b10110101);
wire signed[7:0] sin13 = $signed(8'b10011001);
wire signed[7:0] sin14 = $signed(8'b10000111);
wire signed[7:0] sin15 = $signed(8'b10000001);
wire signed[7:0] sin16 = $signed(8'b10000111);
wire signed[7:0] sin17 = $signed(8'b10000111);
wire signed[7:0] sin18 = $signed(8'b10110101);
wire signed[7:0] sin19 = $signed(8'b11011001);

counter tima(.ena(ena),.rst(rst),.clk(clk),.tim(tim),.clk_0(clk_0));
regPrzes rega(.ena(ena),.rst(rst),.clk(clk_0),.rec(rec),.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7),.out8(out8),.out9(out9),.out10(out10),.out11(out11),.out12(out12),.out13(out13),.out14(out14),.out15(out15),.out16(out16),.out17(out17),.out18(out18),.out19(out19));

assign out = out1 * sin1 +  out2 * sin2 +  out3 * sin3 +  out4 * sin4 +  out5 * sin5 +  out6 * sin6 +  out7 * sin7 +  out8 * sin8 +  out9 * sin9 + out10 * sin10 + out11 * sin11 + out12 * sin12 + out13 * sin13 +  out14 * sin14 + out15 * sin15 + out16 * sin16 +  out17 * sin17 +  out18 * sin18 +  out19 * sin19;
assign detect = (out > 80000 || out <-80000) ? 1 : 0; 

assign clk0 = clk_0;

endmodule
