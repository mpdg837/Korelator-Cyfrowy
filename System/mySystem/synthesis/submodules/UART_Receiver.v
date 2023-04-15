
module uart_receiver(
	input clk,
	input rst,
	
	input tick,
	input rx,
	
	output reg restart_tick,
	
	output reg[7:0] character,
	output reg rdy
);

reg b_rx;

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

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_tim <= 0;
		f_character <=0;
		ff_character <= 0;
		f_start <= 0;
		f_s <= 0;
		f_sync_time <= 0;
	end else
	begin
		f_tim <= n_tim;
		f_character <= n_character;
		ff_character <= character;
		f_start <= n_start;
		f_s <= n_s;
		f_sync_time <= n_sync_time;
	end
end

always@(*)begin
	
	restart_tick= 0;
	rdy = 0;
	
	n_sync_time = f_sync_time;
	
	character = ff_character;
	n_character = f_character;
	n_tim = f_tim;
	
	n_start = f_start;
	n_s = f_s;
	
	if(f_s & (~b_rx) & (~f_start))begin
		n_start = 1;
		n_tim = 0;
		n_character = 0;
		restart_tick= 1;
		
		n_sync_time =0;
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
					character = {f_character[0],f_character[1],f_character[2],f_character[3],f_character[4],f_character[5],f_character[6],f_character[7]};
					rdy = 1;
				end
					
			end
			
		end
		
		
	end
	
	
	n_s = b_rx;
	
	
end


always@(*)begin

end

endmodule


module uart_baud_tick_gen#(
	parameter CLK_FREQ = 50000000,
	parameter BAUD_RATE = 115200
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
	
	// Transmitter
	
	input receiv_rdy,
	input[7:0] receiv_char,
	
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
		end
	else begin
		f_status <= n_status;
		f_addr <= n_addr;
		f_maddr <= n_maddr;
		f_mem <= n_mem;
		f_mchar <= n_mchar;
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
				if(f_mchar == 10) n_status = WRITE;
				
				end
		WRITE: n_status = WRITE_RDY;
		WRITE_RDY: if(~avm_m1_waitrequest) n_status = READ;
		NEXT_CHAR: n_status = CHAR_LOAD;
	endcase
	
	if(~control_receiv_enable) n_status = IDLE;
end

always@(*)begin

	n_mchar = f_mchar;
	
	n_maddr = f_maddr;
	n_addr = f_addr;
	
	n_mem = f_mem;
	
	control_receiv_work = f_control_receiv_work;	
	
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
					end
				end
				
		COMPOSE: begin
				
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
					
					if(f_mchar == 10) control_receiv_work = 0;
				
				end
				
			end
			
		NEXT_CHAR: begin
		
				n_addr = f_addr + 1;
			end
	endcase
end

endmodule

