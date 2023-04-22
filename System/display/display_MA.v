

module display_sD_avalon_interface #(
	parameter LEN = 4,
	parameter CHAR_LEN = 6
)(

	input csi_clk,
	input rsi_reset_n,
	
	input avs_s0_write,
	input avs_s0_read,
	input[3:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata,
	
	output[CHAR_LEN - 1:0] number1,
	output[CHAR_LEN - 1:0] number2,
	output[CHAR_LEN - 1:0] number3,
	output[CHAR_LEN - 1:0] number4,
	
	output dot1,
	output dot2,
	output dot3,
	output dot4,
	
	output[2:0] light1,
	output[2:0] light2,
	output[2:0] light3,
	output[2:0] light4,
	
	output ena
);

reg[CHAR_LEN - 1:0] f_numbers[LEN - 1:0];
reg[CHAR_LEN - 1:0] n_numbers[LEN - 1:0];

reg f_dot[LEN - 1:0];
reg n_dot[LEN - 1:0];

reg[2:0] f_light[LEN - 1:0];
reg[2:0] n_light[LEN - 1:0];

reg f_ena;
reg n_ena;

integer n = 0;

always@(posedge csi_clk or posedge rsi_reset_n)
	if(rsi_reset_n)begin
		for(n=0;n< LEN; n = n + 1) begin
			f_numbers[n] <= 0;
			f_dot[n] <= 0;
			f_light[n] <= 0;
		end
		f_ena <= 0;
	end else
	begin
		for(n=0;n< LEN; n = n + 1) begin
			f_numbers[n] <= n_numbers[n];
			f_dot[n] <= n_dot[n];
			f_light[n] <= n_light[n];
		end
		f_ena <= n_ena;
	end
	
always@(*)begin
	avs_s0_readdata = 0;

	if(avs_s0_read) begin
	
		case(avs_s0_address)
			4'd0: avs_s0_readdata = 32'd64;
			4'd1: avs_s0_readdata = f_numbers[0];
			4'd2: avs_s0_readdata = f_numbers[1];
			4'd3: avs_s0_readdata = f_numbers[2];
			4'd4: avs_s0_readdata = f_numbers[3];
			4'd5: avs_s0_readdata = f_dot[0];
			4'd6: avs_s0_readdata = f_dot[1];
			4'd7: avs_s0_readdata = f_dot[2];
			4'd8: avs_s0_readdata = f_dot[3];
			4'd9: avs_s0_readdata = f_ena;
			4'd11: avs_s0_readdata = f_light[0];
			4'd12: avs_s0_readdata = f_light[1];
			4'd13: avs_s0_readdata = f_light[2];
			4'd14: avs_s0_readdata = f_light[3];
			default: avs_s0_readdata = 32'hFFFFFFFF;
		endcase
	end
	
end

always@(*)begin
	
	n_ena = f_ena;
	
	for(n=0;n< LEN; n = n + 1) begin
		n_numbers[n] = f_numbers[n];
		n_dot[n] = f_dot[n];
		n_light[n] = f_light[n];
	end
	
	if(avs_s0_write)begin
		case(avs_s0_address)
			4'd1: n_numbers[0] = avs_s0_writedata;
			4'd2: n_numbers[1] = avs_s0_writedata;
			4'd3: n_numbers[2] = avs_s0_writedata;
			4'd4: n_numbers[3] = avs_s0_writedata;
			4'd5: n_dot[0] = avs_s0_writedata;
			4'd6: n_dot[1] = avs_s0_writedata;
			4'd7: n_dot[2] = avs_s0_writedata;
			4'd8: n_dot[3] = avs_s0_writedata;
			4'd9: n_ena = avs_s0_writedata;
			
			4'd11: n_light[0] = avs_s0_writedata;
			4'd12: n_light[1] = avs_s0_writedata;
			4'd13: n_light[2] = avs_s0_writedata;
			4'd14: n_light[3] = avs_s0_writedata;
			default:;
		endcase
	end
	
end

assign number1 = f_numbers[0];
assign number2 = f_numbers[1];
assign number3 = f_numbers[2];
assign number4 = f_numbers[3];
	
assign dot1 = f_dot[0];
assign dot2 = f_dot[1];
assign dot3 = f_dot[2];
assign dot4 = f_dot[3];

	
assign light1 = f_light[0];
assign light2 = f_light[1];
assign light3 = f_light[2];
assign light4 = f_light[3];

assign ena = f_ena;
	
endmodule
