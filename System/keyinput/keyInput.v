module keyInput(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[3:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output[31:0] avs_s0_readdata,
	
	// Output 
	input[3:0] in_key,
	output[3:0] out_led
);

localparam LEN = 4;

wire in_rst = 0;
wire tick;

wire short_key[LEN - 1:0];

key_tick kT(.clk(csi_clk),
	 	 	   .rst(in_rst),
	  
			   .tick(tick)
);

key_debouncer kD0(.clk(csi_clk),
					  .rst(in_rst),
	
					  .tick(tick),
	
					  .key_in(~in_key[0]),
					  .short_key_out(short_key[0])
);

key_debouncer kD1(.clk(csi_clk),
					  .rst(in_rst),
	
					  .tick(tick),
	
					  .key_in(~in_key[1]),
					  .short_key_out(short_key[1])
);


key_debouncer kD2(.clk(csi_clk),
					  .rst(in_rst),
	
					  .tick(tick),
	
					  .key_in(~in_key[2]),
					  .short_key_out(short_key[2])
);


key_debouncer kD3(.clk(csi_clk),
					  .rst(in_rst),
	
					  .tick(tick),
	
					  .key_in(~in_key[3]),
					  .short_key_out(short_key[3])
);

input_key_avalon_interface iD(.csi_clk(csi_clk),
										.rsi_reset_n(in_rst),

										.avs_s0_write(avs_s0_write),
										.avs_s0_read(avs_s0_read),
										.avs_s0_address(avs_s0_address),
										.avs_s0_writedata(avs_s0_writedata),
			
										.avs_s0_readdata(avs_s0_readdata),
	
	
										.short_key_1(short_key[0]),
									   .short_key_2(short_key[1]),
										.short_key_3(short_key[2]),
										.short_key_4(short_key[3])

);


endmodule


module input_key_avalon_interface#(
	parameter LEN = 4
)(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon
	
	input avs_s0_write,
	input avs_s0_read,
	input[3:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata,
	
	// Input
	
	input short_key_1,
	input short_key_2,
	input short_key_3,
	input short_key_4

);

reg f_key[LEN - 1:0];
reg n_key[LEN - 1:0];

integer n = 0;

always@(posedge csi_clk or posedge rsi_reset_n)begin
	if(rsi_reset_n) begin
		for(n = 0; n< LEN ; n = n + 1) f_key[n] <= 0;
	end
	else begin
		for(n = 0; n< LEN ; n = n + 1) f_key[n] <= n_key[n];
	end
	
end

always@(*)begin
	
	
	avs_s0_readdata = 0;
	
	if(avs_s0_read)
		case(avs_s0_address)
			0: avs_s0_readdata = 64;
			1: begin
				avs_s0_readdata = f_key[0];
			end
			2: begin
				avs_s0_readdata = f_key[1];
			end
			3: begin
				avs_s0_readdata = f_key[2];
			end
			4: begin
				avs_s0_readdata = f_key[3];
			end
			default:;
			
		endcase
		
	
	
end

always@(*)begin
	for(n = 0; n< LEN ; n = n + 1) n_key[n] = f_key[n];
	
	if(avs_s0_write)
		case(avs_s0_address)
			1: begin
				n_key[0] = 0;
			end
			2: begin
				n_key[1] = 0;
			end
			3: begin
				n_key[2] = 0;
			end
			4: begin
				n_key[3] = 0;
			end
			default:;
		endcase	
	
	if(short_key_1) n_key[0] = 1;
	if(short_key_2) n_key[1] = 1;
	if(short_key_3) n_key[2] = 1;
	if(short_key_4) n_key[3] = 1;
end

endmodule

module key_debouncer#(
	parameter MIN_LEVEL = 64,
	parameter MAX_LEVEL = 192

)(
	input clk,
	input rst,
	
	input tick,
	
	input key_in,
	
	output reg key_out,
	output reg short_key_out
);

reg[7:0] f_tim;
reg[7:0] n_tim;

reg n_key_out = 0;

always@(posedge clk or posedge rst)begin
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
end

always@(posedge clk or posedge rst)begin
	if(rst) key_out <= 0;
	else key_out <= n_key_out;
end


always@(*)begin
	n_tim = f_tim;

	if(tick)
		if(key_in) begin
			if(f_tim != 255) n_tim = f_tim + 1;
		end else
		begin
			if(f_tim != 0) n_tim = f_tim - 1;
		end
	
end

always@(*)begin
	n_key_out = key_out;
	
	short_key_out = 0;
	
	if(~key_out & f_tim > MAX_LEVEL) begin
		n_key_out = 1;
		short_key_out = 1;
	end
	if(key_out & f_tim < MIN_LEVEL) n_key_out = 0;
	
end

endmodule


module key_tick#(
	parameter MAX_TIM = 4095
)(
	input clk,
	input rst,
	
	output reg tick
);

reg[11:0] f_tim;
reg[11:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(*)begin
	n_tim = f_tim + 1;
	tick = 0;
	
	if(f_tim == MAX_TIM) begin
		n_tim = 0;
		tick = 1;
	end
	
end

endmodule
