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
