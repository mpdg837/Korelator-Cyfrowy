module segmentDisplay(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[4:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output[31:0] avs_s0_readdata,
	
	// Output 
	output[3:0] out_dig,
	output[7:0] out_segment
);

localparam CHAR_LEN = 6;
localparam LEN = 4;

wire[CHAR_LEN - 1:0] number[LEN - 1:0];

wire dot[LEN - 1 : 0];

wire ena;

wire[7:0] segment[LEN - 1:0];

wire freq;

wire[LEN - 1:0] inSelect;
wire[7:0] inSegment;

wire in_rst = 0;

wire[2:0] light[LEN - 1:0];
wire lightSig[LEN - 1:0];

display_sD_avalon_interface sdc(.csi_clk(csi_clk),
								.rsi_reset_n(in_rst),
	
								.avs_s0_write(avs_s0_write),
								.avs_s0_read(avs_s0_read),
								.avs_s0_address(avs_s0_address),
								.avs_s0_writedata(avs_s0_writedata),
	
								.avs_s0_readdata(avs_s0_readdata),
									
								.number1(number[0]),
								.number2(number[1]),
								.number3(number[2]),
								.number4(number[3]),
								
								.dot1(dot[0]),
								.dot2(dot[1]),
								.dot3(dot[2]),
								.dot4(dot[3]),
								
								.light1(light[0]),
								.light2(light[1]),
								.light3(light[2]),
								.light4(light[3]),
								
								.ena(ena)
);

display_lightRegulator lR1(.clk(csi_clk),
						 .rst(in_rst),
	
						 .light(light[0]),
	
						 .ligSig(lightSig[0])
);

display_lightRegulator lR2(.clk(csi_clk),
						 .rst(in_rst),
	
						 .light(light[1]),
	
						 .ligSig(lightSig[1])
);

display_lightRegulator lR3(.clk(csi_clk),
						 .rst(in_rst),
	
						 .light(light[2]),
	
						 .ligSig(lightSig[2])
);

display_lightRegulator lR4(.clk(csi_clk),
						 .rst(in_rst),
	
						 .light(light[3]),
	
						 .ligSig(lightSig[3])
);


display_fromDecToSegment dis1(.clk(csi_clk),
							 .rst(in_rst),
							 
							 .ena(ena),
							 .light(lightSig[0]),
							 .number(number[0]),
							 .dot(dot[0]),
	
							 .segments(segment[0])
);

display_fromDecToSegment dis2(.clk(csi_clk),
							 .rst(in_rst),
							 
							 .ena(ena),
							 .light(lightSig[1]),
							 .number(number[1]),
							 .dot(dot[1]),
	
							 .segments(segment[1])
);

display_fromDecToSegment dis3(.clk(csi_clk),
							 .rst(in_rst),
							 
							 .ena(ena),
							 .light(lightSig[2]),
							 .number(number[2]),
							 .dot(dot[2]),
	
							 .segments(segment[2])
);

display_fromDecToSegment dis4(.clk(csi_clk),
							 .rst(in_rst),
							 
							 .ena(ena),
							 .light(lightSig[3]),
							 .number(number[3]),
							 .dot(dot[3]),
	
							 .segments(segment[3])
);


display_frequencyGen fG(.clk(csi_clk),
				    .rst(in_rst),
	
					 .freq(freq)
);

display_displayMultiplex dM(.clk(csi_clk),
						  .rst(in_rst),
						 
						  .freq(freq),
	
					   	.segment1(segment[0]),
						   .segment2(segment[1]),
					   	.segment3(segment[2]),
					   	.segment4(segment[3]),
	
							.select(inSelect),
							.seg(inSegment)
);


display_outBuffer oB(.clk(csi_clk),
				 .rst(in_rst),
	
				.inSegment(inSegment),
				.inSelect(inSelect),
				
				.segment(out_segment),
				.select(out_dig)
);

endmodule

module display_lightRegulator(
	input clk,
	input rst,
	
	input[2:0] light,
	
	output reg ligSig
);

reg[4:0] f_tim;
reg[4:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;

always@(*)begin
	n_tim = f_tim + 1;
	ligSig = 0;
	
	case(light)
		1: if(f_tim <= 4) ligSig = 1;
		2: if(f_tim <= 5) ligSig = 1;
		3: if(f_tim <= 6) ligSig = 1;
		4: if(f_tim <= 7) ligSig = 1;
		5: if(f_tim <= 9) ligSig = 1;
		6: if(f_tim <= 12) ligSig = 1;
		7: if(f_tim <= 15) ligSig = 1;
		default:;
	endcase
	
end

endmodule

module display_outBuffer(
	input clk,
	input rst,
	
	input[7:0] inSegment,
	input[3:0] inSelect,
	
	output reg[7:0] segment,
	output reg[3:0] select
);

always@(posedge clk or posedge rst)
	if(rst) begin
		segment <= 0;
		select <= 0;	
	end
	else begin
		segment <= ~inSegment;
		select <= ~inSelect;
	end
	
endmodule


module display_displayMultiplex(
	input clk,
	input rst,
	
	input freq,
	
	input[7:0] segment1,
	input[7:0] segment2,
	input[7:0] segment3,
	input[7:0] segment4,
	
	output reg[3:0] select,
	output reg[7:0] seg
);

localparam LEN = 2;

reg[3:0] f_select;
reg[7:0] f_segment;

reg[LEN - 1:0] f_tim;
reg[LEN - 1:0] n_tim;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		f_segment <= 0;
		f_select <= 0;
		end
	else begin
		f_tim <= n_tim;
		f_segment <= seg;
		f_select <= select;
		end
end

always@(*)begin
	n_tim = f_tim;

	if(freq) n_tim = f_tim + 1;

end

always@(*)begin
	seg = f_segment;
	
	case(f_tim)
		0: seg = segment1;
		1: seg = segment2;
		2: seg = segment3;
		3: seg = segment4;
	endcase
	
end

always@(*)begin

	select = f_select;
	
	case(f_tim)
		0: select = 4'b1000;
		1: select = 4'b0100;
		2: select = 4'b0010;
		3: select = 4'b0001;
		default:;
	endcase
end

endmodule

module display_frequencyGen #(
	parameter SPEED = 18
)(
	input clk,
	input rst,
	
	output reg freq
);

reg[SPEED - 1: 0] f_tim;
reg[SPEED - 1: 0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;

always@(*)begin
	n_tim = f_tim + 1;
	freq = 0;
	
	if(f_tim == 0) freq = 1;
	
end
endmodule

module display_fromDecToSegment(
	input clk,
	input rst,
	
	input ena,
	input light,
	
	input[5:0] number,
	input dot,
	
	output reg[7:0] segments
);

reg[7:0] n_segments;

reg A = 0;
reg B = 0;
reg C = 0;
reg D = 0;
reg E = 0;
reg F = 0;
reg G = 0;

always@(posedge clk or posedge rst)
	if(rst) segments <= 0;
	else segments <= n_segments;

always@(*)begin
	
	A = 0;
	B = 0;
	C = 0;
	D = 0;
	E = 0;
	F = 0;
	G = 0;
	
		case(number)
			1:begin // 0
				A = 1; B = 1; C = 1; D = 1; E = 1; F = 1; G = 0;
			end
			2:begin // 1
				A = 0; B = 1; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			3:begin // 2
				A = 1; B = 1; C = 0; D = 1; E = 1; F = 0; G = 1;
			end
			4:begin // 3
				A = 1; B = 1; C = 1; D = 1; E = 0; F = 0; G = 1;
			end
			5:begin // 4
				A = 0; B = 1; C = 1; D = 0; E = 0; F = 1; G = 1;
			end
			6:begin // 5
				A = 1; B = 0; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			7:begin // 6
				A = 1; B = 0; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			8:begin // 7
				A = 1; B = 1; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			9:begin // 8
				A = 1; B = 1; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			10:begin // 9
				A = 1; B = 1; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			
			11:begin // A
				A = 1; B = 1; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			12:begin // b
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			13:begin // c
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 0; G = 1;
			end
			14:begin // d
				A = 0; B = 1; C = 1; D = 1; E = 1; F = 0; G = 1;
			end
			15:begin // E
				A = 1; B = 0; C = 0; D = 1; E = 1; F = 1; G = 1;
			end
			16:begin // F
				A = 1; B = 0; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			17:begin // G
				A = 1; B = 0; C = 1; D = 1; E = 1; F = 1; G = 0;
			end
			18:begin // h
				A = 0; B = 0; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			19:begin // i
				A = 0; B = 0; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			20:begin // J
				A = 0; B = 1; C = 1; D = 1; E = 0; F = 0; G = 0;
			end
			21:begin // k
				A = 0; B = 1; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			22:begin // l
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 1; G = 0;
			end
			23:begin // m
				A = 0; B = 0; C = 1; D = 0; E = 0; F = 0; G = 1;
			end
			24:begin // n
				A = 0; B = 0; C = 1; D = 0; E = 1; F = 0; G = 1;
			end
			25:begin // o
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 1;
			end
			26:begin // P
				A = 1; B = 1; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			27:begin // q
				A = 1; B = 1; C = 1; D = 0; E = 0; F = 1; G = 1;
			end
			28:begin // r
				A = 0; B = 0; C = 0; D = 0; E = 1; F = 0; G = 1;
			end
			29:begin // S
				A = 0; B = 0; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			30:begin // t
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 1; G = 1;
			end
			31:begin // u 
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 0;
			end
			32:begin // v 
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 0;
			end
			33:begin // w 
				A = 0; B = 0; C = 1; D = 1; E = 0; F = 0; G = 0;
			end
			34:begin // X
				A = 0; B = 1; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			35:begin // y
				A = 0; B = 1; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			36:begin // z
				A = 1; B = 1; C = 0; D = 1; E = 1; F = 0; G = 0;
			end
			37:begin // {
				A = 1; B = 0; C = 0; D = 1; E = 1; F = 0; G = 0;
			end
			38: begin
				A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 1;
			end
			default:;
		endcase
		
	if(ena & light) n_segments = {dot,G,F,E,D,C,B,A};
	else n_segments = 0;
	
end

endmodule

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
