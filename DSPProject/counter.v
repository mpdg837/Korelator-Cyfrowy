module counter(
	input ena,
	input clk,
	input rst,
	
	output[4:0] tim,
	output clk_0
);

reg[4:0] r_tim=0;
reg[4:0] n_tim=0;

always@(posedge clk, posedge rst)begin
	if(rst) r_tim <= 5'b0;
	else if(ena) r_tim <= n_tim;
end

always@(*)begin
	
	n_tim = r_tim + 1;
	if(n_tim==20) n_tim = 0;
end

assign tim = r_tim;
assign clk_0 = (r_tim == 0) ? 1 : 0;
endmodule
