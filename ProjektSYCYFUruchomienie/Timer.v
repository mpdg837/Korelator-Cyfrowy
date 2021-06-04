module timer(
	input ena,
	input clk,
	input rst,
	
	output signed[13:0] tim
);

reg signed[13:0] n_tim;
reg signed[13:0] r_tim;

always@(posedge clk, posedge rst)begin
	if(rst) r_tim <=-20;
	else if(ena) r_tim <= n_tim;
end

always@(*)begin
	n_tim = r_tim + 1;
	
end

assign tim = r_tim;
endmodule
