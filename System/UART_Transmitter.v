

module uart_transmitter(
	input clk,
	input rst,
	
	input tick,
	
	input[7:0] character,
	input start,
	
	output reg finish,
	
	output reg uart_tx = 1
);

reg f_start;
reg[7:0] f_char;
reg[3:0] f_tim;

reg n_start;
reg[7:0] n_char;
reg[3:0] n_tim;

reg f_uart_tx= 1;

always@(posedge clk or posedge rst)
	if(rst) f_uart_tx <= 1;
	else f_uart_tx <= uart_tx;
	
always@(posedge clk or posedge rst)
	if(rst) begin
		f_tim <= 0;
		f_start <= 0;
		f_char <= 0;
	end else
	begin
		f_tim <= n_tim;
		f_start <= n_start;
		f_char <= n_char;
	end

always@(*)begin
	uart_tx = f_uart_tx;

	n_tim = f_tim;
	n_start = f_start;
	n_char = f_char;
	
	finish = 0;
	
	if(start & ~f_start)begin
		n_start = 1;
		n_char = character;
		n_tim = 0;
	end
	
	
	if(tick)begin
	
		if(f_start)begin
			
			case(f_tim)
				0: uart_tx = 0; 
				9: uart_tx = 1; 
				default: uart_tx = f_char[f_tim - 1];
			endcase
			
			n_tim = f_tim + 1;
			if(f_tim == 9) begin
				n_start = 0;
				finish = 1;
			end
		end else uart_tx = 1;
		
	end
		
	
end
	
endmodule



module uart_center(
	input clk,
	input rst,
	
	// Transmitter
	
	input trans_finish,
	output reg[7:0] trans_char,
	output reg trans_start,
	
	// Control
	input control_trans_start,
	input[15:0] control_trans_start_addr,
	input[15:0] control_trans_stop_addr,
	
	output reg control_trans_work,
	
	// Avalon MM Master
	
	output reg avm_m1_write,
	output reg avm_m1_read,
	
	input avm_m1_waitrequest,
	input avm_m1_readdatavalid,
	
	output reg[15:0] avm_m1_address,
	output reg[31:0] avm_m1_writedata,
	
	input [31:0] avm_m1_readdata
);

reg[3:0] f_status;
reg[3:0] n_status;

reg[15:0] f_addr;
reg[15:0] n_addr;

reg[31:0] f_mem;
reg[31:0] n_mem;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_status <= 0;
		f_addr <= 0;
		f_mem <= 0;
		end
	else begin
		f_status <= n_status;
		f_addr <= n_addr;
		f_mem <= n_mem;
		end
end

localparam IDLE = 0;
localparam READDATA = 1;
localparam LOADDATA = 2;
localparam SENDIT = 3;
localparam FINISHSEND = 4;
localparam VERIFY = 5;

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		IDLE: if(control_trans_start) n_status = READDATA;
		READDATA: n_status = LOADDATA;
		LOADDATA: if(avm_m1_readdatavalid) n_status = SENDIT;
		SENDIT: n_status = FINISHSEND;
		FINISHSEND: if(trans_finish) n_status = VERIFY;
		VERIFY: 	if(f_addr == control_trans_stop_addr) n_status = IDLE;
					else if(f_addr[1:0] == 3) n_status = READDATA;
					else n_status = SENDIT;
	endcase
	
end

always@(*)begin

	n_addr = f_addr;
	n_mem = f_mem;
	
	control_trans_work = 0;
	
	avm_m1_write = 0;
	avm_m1_read = 0;
	avm_m1_address = 0;
	avm_m1_writedata = 0;
	
	trans_char = 0;
	trans_start = 0;
	
	case(f_status)
		IDLE: if(control_trans_start) begin
					
					n_mem = 0;
					
					n_addr = control_trans_start_addr;
					control_trans_work = 1;
					
				
				end
		READDATA: begin
					control_trans_work = 1;
					
					avm_m1_read = 1;
					avm_m1_address = {f_addr[15:2],2'b0};
					
				end
		LOADDATA: begin
					control_trans_work = 1;
					
					if(avm_m1_readdatavalid) begin
						n_mem = avm_m1_readdata;
						
					end
				end
		SENDIT: begin
					case(f_addr[1:0])
						0: trans_char = f_mem[7:0];
						1: trans_char = f_mem[15:8];
						2: trans_char = f_mem[23:16];
						3: trans_char = f_mem[31:24];
					endcase
					
					trans_start = 1;
					
					control_trans_work = 1;
				end
		FINISHSEND: begin
							control_trans_work = 1;
							
							
						end
		VERIFY: begin
				
						n_addr = f_addr + 1;
						control_trans_work = 1;
					
						
					end
	endcase
end

endmodule

