module conclover_conclover_signal(
	input clk,
	input rst,

	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[4:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata,
	
	// Signal
	
	output reg signed[7:0] sin0,
	output reg signed[7:0] sin1,
	output reg signed[7:0] sin2,
	output reg signed[7:0] sin3,
	output reg signed[7:0] sin4,
	output reg signed[7:0] sin5,
	output reg signed[7:0] sin6,
	output reg signed[7:0] sin7,
	output reg signed[7:0] sin8,
	output reg signed[7:0] sin9,
	output reg signed[7:0] sin10,
	output reg signed[7:0] sin11,
	output reg signed[7:0] sin12,
	output reg signed[7:0] sin13,
	output reg signed[7:0] sin14,
	output reg signed[7:0] sin15,
	output reg signed[7:0] sin16,
	output reg signed[7:0] sin17,
	output reg signed[7:0] sin18,
	output reg signed[7:0] sin19
);
reg signed[7:0] f_sin0;
reg signed[7:0] f_sin1;
reg signed[7:0] f_sin2;
reg signed[7:0] f_sin3;
reg signed[7:0] f_sin4;
reg signed[7:0] f_sin5;
reg signed[7:0] f_sin6;
reg signed[7:0] f_sin7;
reg signed[7:0] f_sin8;
reg signed[7:0] f_sin9;
reg signed[7:0] f_sin10;
reg signed[7:0] f_sin11;
reg signed[7:0] f_sin12;
reg signed[7:0] f_sin13;
reg signed[7:0] f_sin14;
reg signed[7:0] f_sin15;
reg signed[7:0] f_sin16;
reg signed[7:0] f_sin17;
reg signed[7:0] f_sin18;
reg signed[7:0] f_sin19;

always@(posedge clk or posedge rst) begin
	if(rst) begin
		sin0 <= 0;
		sin1 <= 0;
		sin2 <= 0;
		sin3 <= 0;
		sin4 <= 0;
		sin5 <= 0;
		sin6 <= 0;
		sin7 <= 0;
		sin8 <= 0;
		sin9 <= 0;
		sin10 <= 0;
		sin11 <= 0;
		sin12 <= 0;
		sin13 <= 0;
		sin14 <= 0;
		sin15 <= 0;
		sin16 <= 0;
		sin17 <= 0;
		sin18 <= 0;
		sin19 <= 0;
	end
	else begin
		sin0 <= f_sin0;
		sin1 <= f_sin1;
		sin2 <= f_sin2;
		sin3 <= f_sin3;
		sin4 <= f_sin4;
		sin5 <= f_sin5;
		sin6 <= f_sin6;
		sin7 <= f_sin7;
		sin8 <= f_sin8;
		sin9 <= f_sin9;
		sin10 <= f_sin10;
		sin11 <= f_sin11;
		sin12 <= f_sin12;
		sin13 <= f_sin13;
		sin14 <= f_sin14;
		sin15 <= f_sin15;
		sin16 <= f_sin16;
		sin17 <= f_sin17;
		sin18 <= f_sin18;
		sin19 <= f_sin19;
	end
end

always@(*) begin
	f_sin0 = sin0;
	f_sin1 = sin1;
	f_sin2 = sin2;
	f_sin3 = sin3;
	f_sin4 = sin4;
	f_sin5 = sin5;
	f_sin6 = sin6;
	f_sin7 = sin7;
	f_sin8 = sin8;
	f_sin9 = sin9;
	f_sin10 = sin10;
	f_sin11 = sin11;
	f_sin12 = sin12;
	f_sin13 = sin13;
	f_sin14 = sin14;
	f_sin15 = sin15;
	f_sin16 = sin16;
	f_sin17 = sin17;
	f_sin18 = sin18;
	f_sin19 = sin19;
	
	if(avs_s0_write)
		case(avs_s0_address)
			8: begin
				f_sin0 = $signed(avs_s0_writedata[7:0]);
				f_sin1 = $signed(avs_s0_writedata[15:8]);
				f_sin2 = $signed(avs_s0_writedata[23:16]);
				f_sin3 = $signed(avs_s0_writedata[31:24]);
			end
			9: begin
				f_sin4 = $signed(avs_s0_writedata[7:0]);
				f_sin5 = $signed(avs_s0_writedata[15:8]);
				f_sin6 = $signed(avs_s0_writedata[23:16]);
				f_sin7 = $signed(avs_s0_writedata[31:24]);
			end
			10: begin
				f_sin8 = $signed(avs_s0_writedata[7:0]);
				f_sin9 = $signed(avs_s0_writedata[15:8]);
				f_sin10 = $signed(avs_s0_writedata[23:16]);
				f_sin11 = $signed(avs_s0_writedata[31:24]);
			end
			11: begin
				f_sin12 = $signed(avs_s0_writedata[7:0]);
				f_sin13 = $signed(avs_s0_writedata[15:8]);
				f_sin14 = $signed(avs_s0_writedata[23:16]);
				f_sin15 = $signed(avs_s0_writedata[31:24]);
			end
			12: begin
				f_sin16 = $signed(avs_s0_writedata[7:0]);
				f_sin17 = $signed(avs_s0_writedata[15:8]);
				f_sin18 = $signed(avs_s0_writedata[23:16]);
				f_sin19 = $signed(avs_s0_writedata[31:24]);
			end
		endcase
end

always@(*)begin
	avs_s0_readdata = 0;
	
	if(avs_s0_read) 
		case(avs_s0_address)
			8: avs_s0_readdata = {sin3,sin2,sin1,sin0};
			9: avs_s0_readdata = {sin7,sin6,sin5,sin4};
			10: avs_s0_readdata = {sin11,sin10,sin9,sin8};
			11: avs_s0_readdata = {sin15,sin14,sin13,sin12};
			12: avs_s0_readdata = {sin19,sin18,sin17,sin16};
		endcase
end

endmodule


module conclover_controller(
	input clk,
	input rst,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[4:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata,
	
	// Outputs
	
	output reg[15:0] read_start_addr,
	output reg[15:0] read_stop_addr,
	
	output reg[15:0] write_start_addr,
	output reg[15:0] write_stop_addr,
	
	output reg start,
	input work
);

reg[15:0] f_write_start_addr;
reg[15:0] f_write_stop_addr;

reg[15:0] f_read_start_addr;
reg[15:0] f_read_stop_addr;

reg b_work;

always@(posedge clk or posedge rst)
	if(rst) b_work <= 0;
	else b_work = work;
	
always@(posedge clk or posedge rst)
	if(rst) begin
		f_read_start_addr <= 0;
		f_read_stop_addr <= 0;
		
		f_write_start_addr <= 0;
		f_write_stop_addr <= 0;
	end
	else begin
		f_read_start_addr <= read_start_addr;
		f_read_stop_addr <= read_stop_addr;
		
		f_write_start_addr <= write_start_addr;
		f_write_stop_addr <= write_stop_addr;
	end
	

always@(*) begin
	
	avs_s0_readdata = 0;
	
	if(avs_s0_read) begin
		case(avs_s0_address)
			1: avs_s0_readdata = f_read_start_addr;
			2: avs_s0_readdata = f_read_stop_addr;
			3: avs_s0_readdata = b_work;
			5: avs_s0_readdata = f_write_start_addr;
			6: avs_s0_readdata = f_write_stop_addr;
		endcase
	end
end

always@(*) begin
	read_start_addr = f_read_start_addr;
	read_stop_addr = f_read_stop_addr;
	
	write_start_addr = write_start_addr;
	write_stop_addr = f_write_stop_addr;
	
	start = 0;

	if(avs_s0_write)
		case(avs_s0_address)
			1: read_start_addr = avs_s0_writedata;
			2: read_stop_addr = avs_s0_writedata;
			4: start = 1;
			5: write_start_addr = avs_s0_writedata;
			6: write_stop_addr = avs_s0_writedata;
		endcase
	
end

endmodule

