module clk_div(
	input clk,
	output clk_0
);

reg r_clk;
reg n_clk;

reg[3:0] n_tim = 0;
reg[3:0] r_tim = 0;

always@(posedge clk)begin
	r_tim <= n_tim;
	r_clk <= n_clk;
end

always@(*)begin
	n_tim = r_tim + 1;
	case(r_clk)
		1: n_clk = r_clk;
		0: n_clk = r_clk;
		default n_clk = 0;
	endcase
	
	if(n_tim==4'd10) begin
		n_tim = 4'b0;
		
		
		n_clk = ~r_clk;
		
	end
	
end

assign clk_0 = n_clk;

endmodule
