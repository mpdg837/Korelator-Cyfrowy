module ROM_controller(
	input clk,
	input rst,
	input ena,
	output[12:0] addr
);



reg[12:0] f_tim=1;
reg[12:0] n_tim=0;


always@(posedge clk or posedge rst)begin
	
	if(rst) f_tim <=13'b1;
	else if(ena) f_tim <= n_tim;
	
end

always@(*)begin
	if(f_tim<5000)begin
		n_tim = f_tim + 1;
	end
end

assign addr = n_tim;

endmodule
