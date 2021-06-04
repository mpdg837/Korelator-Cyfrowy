module timer1kHz(
	input clk,
	output clk0
);

reg[17:0] f_tim=0;
reg[17:0] n_tim=0;

reg f_clk_0=0;
reg n_clk_0=0;

always@(posedge clk)begin
	f_clk_0 <= n_clk_0;
	f_tim <= n_tim;
end

always@(*)begin
	n_tim = f_tim + 1;
	n_clk_0 = f_clk_0;
	
	if(n_tim > 50000) begin
		n_clk_0 = ~f_clk_0;
		n_tim = 0;
	end
end

assign clk0 = n_clk_0;

endmodule
