module count(
	input signed[13:0] timx,
	input kilo,
	
	output signed[13:0] tim
);

wire signed[26:0] tim1 = timx*13'b0010011001100;
wire signed[13:0] tim2 = tim1 >> 13;

assign tim = (kilo)? tim2 : timx;

endmodule
