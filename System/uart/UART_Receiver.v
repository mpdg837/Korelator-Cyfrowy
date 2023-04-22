
module uart_receiver(
	input clk,
	input rst,
	
	input tick,
	input rx,
	
	output reg restart_tick,
	
	input ack,
	
	output reg[7:0] character,
	output reg rdy,
	output reg finish
);

reg b_rx;

reg[7:0] b_character;
reg b_rdy;
reg b_finish;
	
always@(posedge clk or posedge rst)
	if(rst) b_rx <= 0;
	else b_rx <= rx;
	
reg[4:0] f_sync_time;
reg[4:0] n_sync_time;

reg[7:0] f_character;
reg[7:0] n_character;

reg[7:0] ff_character;

reg[3:0] f_tim;
reg[3:0] n_tim;

reg f_start;
reg n_start;

reg f_s;
reg n_s;

reg f_last;
reg n_last;

reg[9:0] f_cycles;
reg[9:0] n_cycles;


reg[7:0] f_len;
reg[7:0] n_len;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_tim <= 0;
		f_character <=0;
		ff_character <= 0;
		f_start <= 0;
		f_s <= 0;
		f_sync_time <= 0;
		
		f_cycles <= 0;
		f_last <= 0;
		
		f_len <= 0;
	end else
	begin
		f_tim <= n_tim;
		f_character <= n_character;
		ff_character <= b_character;
		f_start <= n_start;
		f_s <= n_s;
		f_sync_time <= n_sync_time;
		
		f_last <= n_last;
		f_cycles <= n_cycles;
		f_len <= n_len;
	end
end

always@(*)begin
	
	b_finish = 0;
	
	restart_tick= 0;
	b_rdy = 0;
	
	n_sync_time = f_sync_time;
	
	b_character = ff_character;
	n_character = f_character;
	n_tim = f_tim;
	
	n_start = f_start;
	n_s = f_s;
	
	n_last = f_last;
	n_cycles = f_cycles;
	
	n_len = f_len;
	
	if(f_s & (~b_rx) & (~f_start))begin
		n_start = 1;
		n_tim = 0;
		n_character = 0;
		restart_tick= 1;
		
		n_sync_time =0;
		
		if(~f_last) begin
			n_len = 0;
			
			b_character = 65;
			n_last = 1;
			b_rdy = 1;
			n_cycles = 0;
		end
	end
	
	if(f_start)begin
		if(f_sync_time != 31) begin
		
			n_sync_time = f_sync_time + 1;
			
			if(b_rx) begin
				n_start = 0;
			end
			
		end 
		
	end
	
	if(tick)begin
	
		if(f_start)begin
			
			n_character = {f_character[6:0],b_rx};
			
			if((f_tim == 0) & rx) n_start = 0;
			
			n_tim = f_tim + 1;
			
			if(f_tim == 9) begin
				n_start = 0;
				
				if(b_rx) begin
					n_len = f_len + 1;
					
					b_character = {f_character[0],f_character[1],f_character[2],f_character[3],f_character[4],f_character[5],f_character[6],f_character[7]};
					n_last = 1;
					b_rdy = 1;
					
					n_cycles = 0;
				end
					
			end
			
		end else
		begin
			if(f_last)begin
				n_cycles = f_cycles + 1;
				
				if(f_cycles == 1023)begin
					if(f_last && b_rx)begin
						b_finish = 1;
						b_rdy = 1;
						b_character = f_len;
					end
					
					n_last = 0;
				end
			end
		end
		
		
	end
	
	
	n_s = b_rx;
	
	
end

reg[7:0] bn_character;
reg bn_rdy;
reg bn_finish;
	
reg[7:0] bf_character;
reg bf_rdy;
reg bf_finish;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		bf_character <= 0;
		bf_rdy <= 0;
		bf_finish <= 0;
	end else
	begin
		bf_character <= bn_character;
		bf_rdy <= bn_rdy;
		bf_finish <= bn_finish;
	end
end

always@(*)begin
	bn_character = bf_character;
	bn_rdy = bf_rdy;
	bn_finish = bf_finish;
	
	if(ack)begin
		bn_character = 0;
		bn_rdy = 0;
		bn_finish = 0;
	end
	
	if(b_rdy)begin
		bn_character = b_character;
		bn_rdy = b_rdy;
		bn_finish = b_finish;
	end
	
end

always@(*)begin
	character <= bf_character;
	rdy <= bf_rdy;
	finish <= bf_finish;
end


endmodule


module uart_baud_tick_gen#(
	parameter CLK_FREQ = 50000000,
	parameter BAUD_RATE = 1228800
)(
	input clk,
	input rst,
	
	input restart,
	
	output reg tick
);

integer baud_time = CLK_FREQ / BAUD_RATE;

reg[15:0] f_tim;
reg[15:0] n_tim;

always@(posedge clk or posedge rst) begin
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
end

always@(*)begin
	n_tim = f_tim + 1;
	tick = 0;
	
	if(f_tim == baud_time) begin
		n_tim = 0;
		tick = 1;
	end
	
	if(restart) n_tim = baud_time/2;
end


endmodule


module uart_center_receiv(
	input clk,
	input rst,
	
	// Receiver
	
	input receiv_rdy,
	input[7:0] receiv_char,
	
	input receiv_finish,
	output reg receiv_ack,
	
	// Control
	input control_receiv_enable,
	
	input[15:0] control_receiv_start_addr,
	input[15:0] control_receiv_stop_addr,
	
	output reg control_receiv_work,
	
	// Avalon MM Master
	
	output reg avm_m1_write,
	output reg avm_m1_read,
	
	input avm_m1_waitrequest,
	input avm_m1_readdatavalid,
	
	output reg[15:0] avm_m1_address,
	output reg[31:0] avm_m1_writedata,
	
	input [31:0] avm_m1_readdata
);


reg f_control_receiv_work;

localparam IDLE = 0;
localparam LOAD_START = 1;
localparam READ = 2;
localparam FINISH_READ = 3;
localparam CHAR_LOAD = 4;
localparam COMPOSE = 5;
localparam WRITE = 6;
localparam WRITE_RDY = 7;
localparam NEXT_CHAR = 8;

localparam LOAD_SAVE_LEN = 9;
localparam LOAD_SAVE_LEN_W = 10;
localparam COMPOSE_LEN = 11;
localparam WRITE_LEN = 12;
localparam WRITE_LEN_W = 13;

reg[3:0] f_status = 0;
reg[3:0] n_status = 0;

reg[15:0] f_addr = 0;
reg[15:0] n_addr = 0;

reg[15:0] f_maddr = 0;
reg[15:0] n_maddr = 0;

reg[31:0] f_mem = 0;
reg[31:0] n_mem = 0;

reg[7:0] f_mchar = 0;
reg[7:0] n_mchar = 0;

reg[15:0] f_addrstartmem = 0;
reg[15:0] n_addrstartmem = 0;

reg f_finish = 0;
reg n_finish = 0;

always@(posedge clk or posedge rst)begin
	if(rst) f_control_receiv_work <= 0;
	else f_control_receiv_work <= control_receiv_work;
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_status <= 0;
		f_addr <= 0;
		f_maddr <= 0;
		f_mem <= 0;
		f_mchar <= 0;
		
		f_addrstartmem <= 0;
		
		f_finish <= 0;
		end
	else begin
		f_status <= n_status;
		f_addr <= n_addr;
		f_maddr <= n_maddr;
		f_mem <= n_mem;
		f_mchar <= n_mchar;
		
		f_addrstartmem <= n_addrstartmem;
		
		f_finish <= n_finish;
		end
end

always@(*)begin
	n_status = f_status;

	case(f_status)
		IDLE:  if(control_receiv_enable) n_status = LOAD_START;
		LOAD_START: n_status = READ;
		READ:  n_status = FINISH_READ;
		FINISH_READ: if(avm_m1_readdatavalid) n_status = CHAR_LOAD;
		CHAR_LOAD: if(receiv_rdy)n_status = COMPOSE;
		COMPOSE: begin
				n_status = NEXT_CHAR;
				
				if(f_addr[1:0] == 3) n_status = WRITE;
				if(f_finish && f_control_receiv_work) n_status = WRITE;
				
				end
		WRITE: n_status = WRITE_RDY;
		WRITE_RDY: if(~avm_m1_waitrequest)
							if(f_finish) n_status = LOAD_SAVE_LEN;
							else n_status = READ;
		NEXT_CHAR: n_status = CHAR_LOAD;
		
		LOAD_SAVE_LEN: n_status = LOAD_SAVE_LEN_W;
		LOAD_SAVE_LEN_W: if(avm_m1_readdatavalid) n_status = COMPOSE_LEN;
		COMPOSE_LEN: n_status = WRITE_LEN;
		WRITE_LEN: n_status = WRITE_LEN_W;
		WRITE_LEN_W: if(~avm_m1_waitrequest) n_status = READ;
	endcase
	
	if(~control_receiv_enable) n_status = IDLE;
end

always@(*)begin
	
	n_finish = f_finish;
	
	n_mchar = f_mchar;
	
	n_maddr = f_maddr;
	n_addr = f_addr;
	n_addrstartmem = f_addrstartmem;
	
	n_mem = f_mem;
	
	control_receiv_work = f_control_receiv_work;	
	
	receiv_ack = 0;
	
	avm_m1_write = 0;
	avm_m1_read = 0;
	avm_m1_address = 0;
	avm_m1_writedata = 0;
	
	case(f_status)
		IDLE:  begin
					
					if(control_receiv_enable) begin
						n_addr = 0;
						n_mem = 0;
					end
				end
		LOAD_START: begin
					
					n_addr = control_receiv_start_addr;
					end
		READ:  begin
					
					avm_m1_read = 1;
					avm_m1_address = {f_addr[15:2],2'b0};
					
				end
		FINISH_READ: begin
					
					if(avm_m1_readdatavalid)  n_mem = avm_m1_readdata;
				end
		CHAR_LOAD: begin
					
					if(receiv_rdy) begin
						control_receiv_work = 1;
						n_mchar = receiv_char;
						n_finish = 0;
						receiv_ack = 1;
						
					end
					
					if(receiv_finish && f_control_receiv_work) begin
						n_finish =1;
					end
					
					if(receiv_rdy && ~f_control_receiv_work) begin
						n_addrstartmem = f_addr;
					end
					
				end
				
		COMPOSE: begin
				
				if(f_finish) begin
					case(f_addr[1:0])
						0: n_mem = {f_mem[31:8],8'hFF};
						1: n_mem = {f_mem[31:16],8'hFF,f_mem[7:0]};
						2: n_mem = {f_mem[31:24],8'hFF,f_mem[15:0]};
						3: n_mem = {8'hFF,f_mem[23:0]};
					endcase

				end else
					case(f_addr[1:0])
						0: n_mem = {f_mem[31:8],f_mchar};
						1: n_mem = {f_mem[31:16],f_mchar,f_mem[7:0]};
						2: n_mem = {f_mem[31:24],f_mchar,f_mem[15:0]};
						3: n_mem = {f_mchar,f_mem[23:0]};
					endcase
	
				end
		WRITE: begin
			
				avm_m1_write = 1;
				avm_m1_address = {f_addr[15:2],2'b0};
				avm_m1_writedata = f_mem;
				
				end
		WRITE_RDY: begin
	
				if(~avm_m1_waitrequest) begin
				
					if(f_addr == control_receiv_stop_addr) n_addr = control_receiv_start_addr;
					else n_addr = f_addr + 1;
					
				
				end
				
			end
			
		NEXT_CHAR: begin
		
				n_addr = f_addr + 1;
			end
			
		LOAD_SAVE_LEN: begin
								
								avm_m1_read = 1;
								avm_m1_address = {f_addrstartmem[15:2],2'b0};
								
							end
		LOAD_SAVE_LEN_W: if(avm_m1_readdatavalid)begin
									n_mem = avm_m1_readdata;
								end
		COMPOSE_LEN: case(f_addrstartmem[1:0])
							0: n_mem = {f_mem[31:8],f_mchar};
							1: n_mem = {f_mem[31:16],f_mchar,f_mem[7:0]};
							2: n_mem = {f_mem[31:24],f_mchar,f_mem[15:0]};
							3: n_mem = {f_mchar,f_mem[23:0]};
						endcase
		WRITE_LEN: begin
			
				avm_m1_write = 1;
				avm_m1_address = {f_addrstartmem[15:2],2'b0};
				avm_m1_writedata = f_mem;
				
				end
		WRITE_LEN_W: begin
	
				if(~avm_m1_waitrequest) begin
						control_receiv_work = 0;
					
					
				
				end
				
			end
	endcase
end

endmodule

