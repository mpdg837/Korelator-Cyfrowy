module timerModule(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[1:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata
	
);

localparam LEN = 4;

wire rst = 0;
wire tick;

tim_tickGen tG(.clk(csi_clk),
					.rst(rst),
	
					.tick(tick)
);

reg[31:0] f_tim[LEN - 1:0];
reg[31:0] n_tim[LEN - 1:0];

integer n = 0;

always@(posedge csi_clk or posedge rst)
	if(rst)begin
		for(n=0;n<LEN;n = n + 1) f_tim[n] <= 0;
	end else
	begin
		for(n=0;n<LEN;n = n + 1) f_tim[n] <= n_tim[n];
	end


always@(*)begin
	avs_s0_readdata = 0;
	
	if(avs_s0_read)begin
		avs_s0_readdata = f_tim[avs_s0_address];
	end
end

always@(*)begin
	
	for(n = 0; n < LEN ; n = n + 1) begin
		n_tim[n] = f_tim[n];
		
		if(tick) n_tim[n] = f_tim[n] + 1;
	end
	
	
	if(avs_s0_write)begin
		n_tim[avs_s0_address] = avs_s0_writedata;
	end
end

endmodule

module tim_tickGen#
(
	parameter MAX_TIM = 50000
)(
	input clk,
	input rst,
	
	output reg tick
);

reg[15:0] f_tim;
reg[15:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(*)begin
	n_tim = f_tim + 1;
	tick = 0;
	
	if(f_tim == MAX_TIM) begin
		tick = 1;
		n_tim = 0;
	end
	
end
endmodule
