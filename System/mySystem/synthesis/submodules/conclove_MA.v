
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


reg[15:0] f_addrr;
reg[15:0] n_addrr;

reg[15:0] f_addrw;
reg[15:0] n_addrw;

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
		
		f_addrr <= 0;
		f_addrw <= 0;
	end
	else begin
		f_savebuffer <= n_savebuffer;
		f_readbuffer <= n_readbuffer;
		f_savebufferint <= n_savebufferint;
		f_readbufferint <= n_readbufferint;
		
		f_addrr <= n_addrr;
		f_addrw <= n_addrw;
	end
end

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		IDLE: begin
			if(read) begin
				if(f_addrr[15:2] == readaddr[15:2]) n_status = SELECT_READ;
				else n_status = READ;
			end
			if(write) begin
				if(f_addrw[15:2] == saveaddr[15:2]) n_status = ADD_DATA_TO_SAVE;
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
		ADD_DATA_TO_SAVE: if(f_addrw[1:0] == 3 || f_addrw == stop_write_offset) n_status = SAVE_DATA_TO_SAVE;
								else n_status = FINISH_SAVE;
		SAVE_DATA_TO_SAVE: if(~avm_m1_waitrequest) n_status = FINISH_SAVE;
		FINISH_SAVE: n_status = IDLE;
	endcase
end

always@(*) begin

	n_addrr = f_addrr;
	n_addrw = f_addrw;
	
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
				n_addrr = readaddr;
			end
			if(write) begin
				n_addrw = saveaddr;
				n_savebuffer = save_data;
			end
		end
		READ: begin
			avm_m1_read = 1;
			avm_m1_address = {f_addrr[15:2],2'b0};
		end
		DATA_READ: begin
			if(avm_m1_readdatavalid) n_readbufferint = avm_m1_readdata;
		end
		SELECT_READ: begin
			case(f_addrr[1:0])
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
			avm_m1_address = {f_addrw[15:2],2'b0};
		end
		SAVE_DATA_READ: begin
			if(avm_m1_readdatavalid) n_savebufferint = avm_m1_readdata;
		end
		ADD_DATA_TO_SAVE: begin
			case(f_addrw[1:0])
				0: n_savebufferint = {f_savebufferint[31:8],f_savebuffer};
				1: n_savebufferint = {f_savebufferint[31:16],f_savebuffer,f_savebufferint[7:0]};
				2: n_savebufferint = {f_savebufferint[31:24],f_savebuffer,f_savebufferint[15:0]};
				3: n_savebufferint = {f_savebuffer,f_savebufferint[23:0]};
			endcase
		end
		SAVE_DATA_TO_SAVE: begin
			avm_m1_write = 1;
			avm_m1_address = {f_addrw[15:2],2'b0};
			avm_m1_writedata = f_savebufferint;
		end
		FINISH_SAVE: rdy = 1;
	endcase
	
end
endmodule
