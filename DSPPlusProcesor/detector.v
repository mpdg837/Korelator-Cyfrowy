module detector(
	input signed[23:0] in,
	output out
);

assign out = (in > 80000 || in < -80000) ? 1 : 0;

endmodule
