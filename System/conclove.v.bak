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

module conclover_core(
	input clk,
	input rst,
	
	input[15:0] len_write,
	input[15:0] len_read,
	
	input start,
	output reg work,
	// Inside bus
	
	output reg[15:0] rel_addr,
	output reg write,
	output reg read,
	
	output reg[7:0] save_data,
	input[7:0] read_data,
	input rdy,
	
	// Conclover Bus
	
	output reg signed[7:0] rec,
	output reg startrec,
	input signed[24:0] outrec

);


reg signed[24:0] f_abs;
reg signed[24:0] n_abs;

reg[15:0] f_reladdr;
reg[15:0] n_reladdr;

reg[7:0] f_mem;
reg[7:0] n_mem;

reg[3:0] f_status;
reg[3:0] n_status;

always@(posedge clk or posedge rst)begin
	if(rst) f_reladdr <= 0;
	else f_reladdr <= n_reladdr;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_status <= 0;
	else f_status <= n_status;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_mem <= 0;
	else f_mem <= n_mem;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_abs <= 0;
	else f_abs <= n_abs;
end

localparam IDLE = 0;
localparam LOAD_DATA = 1;
localparam WAIT_DATA = 2;
localparam SEND_COPPER = 3;
localparam RECEIV_COPPER = 4;
localparam ABS = 5;
localparam REDUCE_VAL = 6;
localparam SAVE = 7;
localparam WAIT_SAVE = 8;
localparam VERIFY = 9;

always@(*)begin
	n_status = f_status;
	n_mem = f_mem;
	n_reladdr = f_reladdr;
	n_abs = f_abs;
	
	work = 1;
	
	rel_addr = 0;
	write = 0;
	read = 0;
	save_data = 0;
	
	rec = 0;
	startrec = 0;
	
	case(f_status)
		IDLE: begin 
			work = 0;
			
			if(start) begin
				n_status = LOAD_DATA;
				n_reladdr = 0;
			end
			
			end
		LOAD_DATA: begin
				rel_addr = f_reladdr;
				read = 1;
				
				n_status = WAIT_DATA;
			end
		WAIT_DATA: begin
				if(rdy) begin
					n_mem = read_data;
					n_status = SEND_COPPER;
				end
			end
			
		SEND_COPPER: begin
			work = 1;
			
			rec = $signed(f_mem);
			startrec = 1;
			
			n_status = RECEIV_COPPER;
		end
		RECEIV_COPPER: begin
			
			n_abs = outrec;
			n_status = ABS;
		end
		ABS: begin
			if(f_abs[24] == 1) begin
				n_abs = (~f_abs) + 1;
				n_status = REDUCE_VAL;		
			end
			else begin
		
				n_status = REDUCE_VAL;
			end
			
			
		end
		REDUCE_VAL: begin
		
			if(f_abs[24:20] == 0) n_mem = f_abs[19:12];
			else n_mem = 255;
			
			n_status = SAVE;
		end
		SAVE: begin
				rel_addr = f_reladdr;
				write = 1;
				save_data = f_mem;
				
				n_status = WAIT_SAVE;
			end
		WAIT_SAVE: begin
				if(rdy) n_status = VERIFY;
			end
		VERIFY: begin
				n_reladdr = f_reladdr + 1;
				
				if(f_reladdr == len_read) n_status = IDLE;
				else n_status = LOAD_DATA;
			end
	endcase
end

endmodule

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

module conclover_memory_access(
	input clk,
	input rst,
	
	// Avalon MM Master
	
	output reg avm_m1_write,
	output reg avm_m1_read,
	
	input avm_m1_waitrequest,
	input avm_m1_readdatavalid,
	
	output reg[15:0] avm_m1_address,
	output reg[31:0] avm_m1_writedata,
	
	input [31:0] avm_m1_readdata,
	
	// Addr
	
	input[15:0] read_offset,
	input[15:0] write_offset,
	
	input[15:0] stop_write_offset,
	
	// Inside bus
	
	input[15:0] rel_addr,
	input write,
	input read,
	
	input[7:0] save_data,
	output reg[7:0] read_data,
	output reg rdy
);

reg[15:0] f_addr;
reg[15:0] n_addr;

reg[7:0] f_savebuffer;
reg[7:0] n_savebuffer;

reg[7:0] f_readbuffer;
reg[7:0] n_readbuffer;


reg[31:0] f_savebufferint;
reg[31:0] n_savebufferint;

reg[31:0] f_readbufferint;
reg[31:0] n_readbufferint;


reg[3:0] f_status;
reg[3:0] n_status;

localparam IDLE = 0;
localparam READ = 1;
localparam DATA_READ = 2;
localparam SELECT_READ = 3;
localparam FINISH_READ = 4;
localparam SAVE = 5;
localparam SAVE_DATA_READ = 6;
localparam ADD_DATA_TO_SAVE = 7;
localparam SAVE_DATA_TO_SAVE = 8;
localparam FINISH_SAVE = 9;

wire[15:0] readaddr = rel_addr + read_offset;
wire[15:0] saveaddr = rel_addr + write_offset;

always@(posedge clk or posedge rst) begin
	if(rst) f_status <= 0;
	else f_status <= n_status;
end

always@(posedge clk or posedge rst) begin
	if(rst) begin
		f_savebuffer <= 0;
		f_readbuffer <= 0;
		f_savebufferint <= 0;
		f_readbufferint <= 0;
		
		f_addr <= 0;
	end
	else begin
		f_savebuffer <= n_savebuffer;
		f_readbuffer <= n_readbuffer;
		f_savebufferint <= n_savebufferint;
		f_readbufferint <= n_readbufferint;
		
		f_addr <= n_addr;
	end
end

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		IDLE: begin
			if(read) begin
				if(f_addr[15:2] == readaddr[15:2]) n_status = SELECT_READ;
				else n_status = READ;
			end
			if(write) begin
				if(f_addr[15:2] == saveaddr[15:2]) n_status = ADD_DATA_TO_SAVE;
				else n_status = SAVE;
			end
		end
		READ: begin
			if(~avm_m1_waitrequest) n_status = DATA_READ;
		end
		DATA_READ: begin
			if(avm_m1_readdatavalid) n_status = SELECT_READ;
		end
		SELECT_READ: n_status = FINISH_READ;
		FINISH_READ: n_status = IDLE;
		SAVE: begin
			if(~avm_m1_waitrequest) n_status = SAVE_DATA_READ;
		end
		SAVE_DATA_READ: if(avm_m1_readdatavalid) n_status = ADD_DATA_TO_SAVE;
		ADD_DATA_TO_SAVE: if(f_addr[1:0] == 3 || f_addr == stop_write_offset) n_status = SAVE_DATA_TO_SAVE;
								else n_status = FINISH_SAVE;
		SAVE_DATA_TO_SAVE: if(~avm_m1_waitrequest) n_status = FINISH_SAVE;
		FINISH_SAVE: n_status = IDLE;
	endcase
end

always@(*) begin

	n_addr = f_addr;
	
	n_savebuffer = f_savebuffer;
	n_readbuffer = f_readbuffer;

	n_savebufferint = f_savebufferint;
	n_readbufferint = f_readbufferint;

	read_data = 0;
	rdy = 0;
	
	avm_m1_write = 0;
	avm_m1_read = 0;
	
	avm_m1_address = 0;
	avm_m1_writedata = 0;
	
	case(f_status)
		IDLE: begin
			if(read) begin
				n_addr = readaddr;
			end
			if(write) begin
				n_addr = saveaddr;
				n_savebuffer = save_data;
			end
		end
		READ: begin
			avm_m1_read = 1;
			avm_m1_address = {f_addr[15:2],2'b0};
		end
		DATA_READ: begin
			if(avm_m1_readdatavalid) n_readbufferint = avm_m1_readdata;
		end
		SELECT_READ: begin
			case(f_addr[1:0])
				0: n_readbuffer = f_readbufferint[7:0];
				1: n_readbuffer = f_readbufferint[15:8];
				2: n_readbuffer = f_readbufferint[23:16];
				3: n_readbuffer = f_readbufferint[31:24];
				default:;
			endcase
		end
		FINISH_READ: begin
			rdy = 1;
			read_data = f_readbuffer;
		end
		SAVE: begin
			avm_m1_read = 1;
			avm_m1_address = {f_addr[15:2],2'b0};
		end
		SAVE_DATA_READ: begin
			if(avm_m1_readdatavalid) n_savebufferint = avm_m1_readdata;
		end
		ADD_DATA_TO_SAVE: begin
			case(f_addr[1:0])
				0: n_savebufferint = {f_savebufferint[31:8],f_savebuffer};
				1: n_savebufferint = {f_savebufferint[31:16],f_savebuffer,f_savebufferint[7:0]};
				2: n_savebufferint = {f_savebufferint[31:24],f_savebuffer,f_savebufferint[15:0]};
				3: n_savebufferint = {f_savebuffer,f_savebufferint[23:0]};
			endcase
		end
		SAVE_DATA_TO_SAVE: begin
			avm_m1_write = 1;
			avm_m1_address = {f_addr[15:2],2'b0};
			avm_m1_writedata = f_savebufferint;
		end
		FINISH_SAVE: rdy = 1;
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

module conclove_conclover(
	input ena,
	
	input start,
	input rst,
	input clk,

	input signed[7:0] rec,
	output signed[24:0] out,
	
	
	input signed[7:0] sin0,
	input signed[7:0] sin1,
	input signed[7:0] sin2,
	input signed[7:0] sin3,
	input signed[7:0] sin4,
	input signed[7:0] sin5,
	input signed[7:0] sin6,
	input signed[7:0] sin7,
	input signed[7:0] sin8,
	input signed[7:0] sin9,
	input signed[7:0] sin10,
	input signed[7:0] sin11,
	input signed[7:0] sin12,
	input signed[7:0] sin13,
	input signed[7:0] sin14,
	input signed[7:0] sin15,
	input signed[7:0] sin16,
	input signed[7:0] sin17,
	input signed[7:0] sin18,
	input signed[7:0] sin19
	
);


wire clk_0;
wire [4:0] tim;

wire signed[7:0] out0;
wire signed[7:0] out1;
wire signed[7:0] out2;
wire signed[7:0] out3;
wire signed[7:0] out4;
wire signed[7:0] out5;
wire signed[7:0] out6;
wire signed[7:0] out7;
wire signed[7:0] out8;
wire signed[7:0] out9;
wire signed[7:0] out10;
wire signed[7:0] out11;
wire signed[7:0] out12;
wire signed[7:0] out13;
wire signed[7:0] out14;
wire signed[7:0] out15;
wire signed[7:0] out16;
wire signed[7:0] out17;
wire signed[7:0] out18;
wire signed[7:0] out19;


conclover_shift rega(.ena(ena),.rst(rst),.clk(start),.rec(rec),.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7),.out8(out8),.out9(out9),.out10(out10),.out11(out11),.out12(out12),.out13(out13),.out14(out14),.out15(out15),.out16(out16),.out17(out17),.out18(out18),.out19(out19));

assign out = out1 * sin1 +  out2 * sin2 +  out3 * sin3 +  out4 * sin4 +  out5 * sin5 +  out6 * sin6 +  out7 * sin7 +  out8 * sin8 +  out9 * sin9 + out10 * sin10 + out11 * sin11 + out12 * sin12 + out13 * sin13 +  out14 * sin14 + out15 * sin15 + out16 * sin16 +  out17 * sin17 +  out18 * sin18 +  out19 * sin19;

endmodule

module conclover_shift(
	input ena,
	input clk,
	input rst,
	input signed[7:0] rec,
	
	output signed[7:0] out0,
	output signed[7:0] out1,
	output signed[7:0] out2,
	output signed[7:0] out3,
	output signed[7:0] out4,
	output signed[7:0] out5,
	output signed[7:0] out6,
	output signed[7:0] out7,
	output signed[7:0] out8,
	output signed[7:0] out9,
	output signed[7:0] out10,
	output signed[7:0] out11,
	output signed[7:0] out12,
	output signed[7:0] out13,
	output signed[7:0] out14,
	output signed[7:0] out15,
	output signed[7:0] out16,
	output signed[7:0] out17,
	output signed[7:0] out18,
	output signed[7:0] out19
);

reg[19:0] bit1;
reg[19:0] bit2;
reg[19:0] bit3;
reg[19:0] bit4;
reg[19:0] bit5;
reg[19:0] bit6;
reg[19:0] bit7;
reg[19:0] bit8;

reg[19:0] mbit1;
reg[19:0] mbit2;
reg[19:0] mbit3;
reg[19:0] mbit4;
reg[19:0] mbit5;
reg[19:0] mbit6;
reg[19:0] mbit7;
reg[19:0] mbit8;


reg signed[7:0] outr;

always@(posedge clk,posedge rst)begin
	if(rst)begin
		bit1 <= 20'b0;
		bit2 <= 20'b0;
		bit3 <= 20'b0;
		bit4 <= 20'b0;
		bit5 <= 20'b0;
		bit6 <= 20'b0;
		bit7 <= 20'b0;
		bit8 <= 20'b0;
	end else if(ena)
	begin
		bit1 <= mbit1;
		bit2 <= mbit2;
		bit3 <= mbit3;
		bit4 <= mbit4;
		bit5 <= mbit5;
		bit6 <= mbit6;
		bit7 <= mbit7;
		bit8 <= mbit8;
	end
end

always@(*)begin
	mbit1 = bit1 << 1;
	mbit1[0] = rec[0];
end

always@(*)begin
	mbit2 = bit2 << 1;
	mbit2[0] = rec[1];
end

always@(*)begin
	mbit3 = bit3 << 1;
	mbit3[0] = rec[2];
end

always@(*)begin
	mbit4 = bit4 << 1;
	mbit4[0] = rec[3];
end

always@(*)begin
	mbit5 = bit5 << 1;
	mbit5[0] = rec[4];
end

always@(*)begin
	mbit6 = bit6 << 1;
	mbit6[0] = rec[5];
end

always@(*)begin
	mbit7 = bit7 << 1;
	mbit7[0] = rec[6];
end

always@(*)begin
	mbit8 = bit8 << 1;
	mbit8[0] = rec[7];
end


assign out0 = {bit8[0], bit7[0], bit6[0], bit5[0], bit4[0], bit3[0], bit2[0], bit1[0]};
assign out1 = {bit8[1], bit7[1], bit6[1], bit5[1], bit4[1], bit3[1], bit2[1], bit1[1]};
assign out2 = {bit8[2], bit7[2], bit6[2], bit5[2], bit4[2], bit3[2], bit2[2], bit1[2]};
assign out3 = {bit8[3], bit7[3], bit6[3], bit5[3], bit4[3], bit3[3], bit2[3], bit1[3]};
assign out4 = {bit8[4], bit7[4], bit6[4], bit5[4], bit4[4], bit3[4], bit2[4], bit1[4]};
assign out5 = {bit8[5], bit7[5], bit6[5], bit5[5], bit4[5], bit3[5], bit2[5], bit1[5]};
assign out6 = {bit8[6], bit7[6], bit6[6], bit5[6], bit4[6], bit3[6], bit2[6], bit1[6]};
assign out7 = {bit8[7], bit7[7], bit6[7], bit5[7], bit4[7], bit3[7], bit2[7], bit1[7]};
assign out8 = {bit8[8], bit7[8], bit6[8], bit5[8], bit4[8], bit3[8], bit2[8], bit1[8]};
assign out9 = {bit8[9], bit7[9], bit6[9], bit5[9], bit4[9], bit3[9], bit2[9], bit1[9]};
assign out10 = {bit8[10], bit7[10], bit6[10], bit5[10], bit4[10], bit3[10], bit2[10], bit1[10]};
assign out11 = {bit8[11], bit7[11], bit6[11], bit5[11], bit4[11], bit3[11], bit2[11], bit1[11]};
assign out12 = {bit8[12], bit7[12], bit6[12], bit5[12], bit4[12], bit3[12], bit2[12], bit1[12]};
assign out13 = {bit8[13], bit7[13], bit6[13], bit5[13], bit4[13], bit3[13], bit2[13], bit1[13]};
assign out14 = {bit8[14], bit7[14], bit6[14], bit5[14], bit4[14], bit3[14], bit2[14], bit1[14]};
assign out15 = {bit8[15], bit7[15], bit6[15], bit5[15], bit4[15], bit3[15], bit2[15], bit1[15]};
assign out16 = {bit8[16], bit7[16], bit6[16], bit5[16], bit4[16], bit3[16], bit2[16], bit1[16]};
assign out17 = {bit8[17], bit7[17], bit6[17], bit5[17], bit4[17], bit3[17], bit2[17], bit1[17]};
assign out18 = {bit8[18], bit7[18], bit6[18], bit5[18], bit4[18], bit3[18], bit2[18], bit1[18]};
assign out19 = {bit8[19], bit7[19], bit6[19], bit5[19], bit4[19], bit3[19], bit2[19], bit1[19]};


assign out = outr;


endmodule

