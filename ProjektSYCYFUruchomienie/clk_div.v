module clk_div(
	input clk,
	input indiv,
	output clk1
);

reg f_clk1;
reg[9:0] tim;

always@(posedge clk)begin
	if(indiv)begin
		tim <= tim + 1;
		
		if(tim == 0)begin
			f_clk1 <= ~f_clk1;
		end
	end else
	begin
		f_clk1 = ~f_clk1;
	end
end



assign clk1 = f_clk1; 
endmodule
