module conclover(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[4:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output[31:0] avs_s0_readdata,

	// Avalon MM Master
	
	output avm_m1_write,
	output avm_m1_read,
	
	input avm_m1_waitrequest,
	input avm_m1_readdatavalid,
	
	output[15:0] avm_m1_address,
	output[31:0] avm_m1_writedata,
	
	input [31:0] avm_m1_readdata
);

wire[31:0] avs_s0_readdata1;
wire[31:0] avs_s0_readdata2;
assign avs_s0_readdata = avs_s0_readdata1 | avs_s0_readdata2;

wire clk = csi_clk;
wire rst = ~rsi_reset_n;

wire start;
wire work;

wire[15:0] read_start_addr;
wire[15:0] read_stop_addr;

wire[15:0] write_start_addr;
wire[15:0] write_stop_addr;

wire signed[7:0] sin0;
wire signed[7:0] sin1;
wire signed[7:0] sin2;
wire signed[7:0] sin3;
wire signed[7:0] sin4;
wire signed[7:0] sin5;
wire signed[7:0] sin6;
wire signed[7:0] sin7;
wire signed[7:0] sin8;
wire signed[7:0] sin9;
wire signed[7:0] sin10;
wire signed[7:0] sin11;
wire signed[7:0] sin12;
wire signed[7:0] sin13;
wire signed[7:0] sin14;
wire signed[7:0] sin15;
wire signed[7:0] sin16;
wire signed[7:0] sin17;
wire signed[7:0] sin18;
wire signed[7:0] sin19;

conclover_conclover_signal ccvvs(.clk(clk),
											.rst(rst),
		
											// Avalon MM
											
											.avs_s0_write(avs_s0_write),
											.avs_s0_read(avs_s0_read),
											.avs_s0_address(avs_s0_address),
											.avs_s0_writedata(avs_s0_writedata),
											
											.avs_s0_readdata(avs_s0_readdata1),
											
											// Signal
											
											.sin0(sin0),
											.sin1(sin1),
											.sin2(sin2),
											.sin3(sin3),
											.sin4(sin4),
											.sin5(sin5),
											.sin6(sin6),
											.sin7(sin7),
											.sin8(sin8),
											.sin9(sin9),
											.sin10(sin10),
											.sin11(sin11),
											.sin12(sin12),
											.sin13(sin13),
											.sin14(sin14),
											.sin15(sin15),
											.sin16(sin16),
											.sin17(sin17),
											.sin18(sin18),
											.sin19(sin19)
);


conclover_controller ccon(.clk(clk),
								  .rst(rst),
	
								// Avalon MM
								
								.avs_s0_write(avs_s0_write),
								.avs_s0_read(avs_s0_read),
								.avs_s0_address(avs_s0_address),
								.avs_s0_writedata(avs_s0_writedata),
								
								.avs_s0_readdata(avs_s0_readdata2),
								
								// Outputs
								
								.read_start_addr(read_start_addr),
								.read_stop_addr(read_stop_addr),
								
								.write_start_addr(write_start_addr),
								.write_stop_addr(write_stop_addr),
								
								.start(start),
								.work(work)
);

wire[15:0] rel_addr;
wire write;
wire read;
	
wire[7:0] save_data;
wire[7:0] read_data;
wire rdy;
	
conclover_memory_access cms(.clk(clk),
									 .rst(rst),
	
									// Avalon MM Master
									
									.avm_m1_write(avm_m1_write),
									.avm_m1_read(avm_m1_read),
									
									.avm_m1_waitrequest(avm_m1_waitrequest),
									.avm_m1_readdatavalid(avm_m1_readdatavalid),
									
									.avm_m1_address(avm_m1_address),
									.avm_m1_writedata(avm_m1_writedata),
									
									.avm_m1_readdata(avm_m1_readdata),
									
									// Addr
									
									.read_offset(read_start_addr),
									.write_offset(write_start_addr),
									.stop_write_offset(write_stop_addr),
									// Inside bus
									
									.rel_addr(rel_addr),
									.write(write),
									.read(read),
									
									.save_data(save_data),
									.read_data(read_data),
									.rdy(rdy)
);

wire signed[7:0] rec;
wire startrec;
wire signed[24:0] outrec;

conclover_core cc(.clk(clk),
						.rst(rst),
						
						.len_write(read_stop_addr-read_start_addr),
						.len_read(write_stop_addr-write_start_addr),
						
						.start(start),
						.work(work),
						
						// Inside bus
						
						.rel_addr(rel_addr),
						.write(write),
						.read(read),
						
						.save_data(save_data),
						.read_data(read_data),
						.rdy(rdy),
						
						// Conclove bus
						
						.rec(rec),
						.startrec(startrec),
						.outrec(outrec)
);

conclove_conclover ccont(.ena(1),
								
								 .start(startrec),
								 .rst(rst),
								 .clk(clk),

								 .rec(rec),
								 .out(outrec),
								 
								 .sin0(sin0),
								.sin1(sin1),
								.sin2(sin2),
								.sin3(sin3),
								.sin4(sin4),
								.sin5(sin5),
								.sin6(sin6),
								.sin7(sin7),
								.sin8(sin8),
								.sin9(sin9),
								.sin10(sin10),
								.sin11(sin11),
								.sin12(sin12),
								.sin13(sin13),
								.sin14(sin14),
								.sin15(sin15),
								.sin16(sin16),
								.sin17(sin17),
								.sin18(sin18),
								.sin19(sin19)
								 
);

endmodule