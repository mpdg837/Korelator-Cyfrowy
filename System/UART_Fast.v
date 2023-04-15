

module UART_Fast(
	input csi_clk,
	input rsi_reset_n,
	
	// Avalon MM
	
	input avs_s0_write,
	input avs_s0_read,
	input[2:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output[31:0] avs_s0_readdata,

	// Avalon MM Master
	
	output avm_m1_write,
	output avm_m1_read,
	
	input avm_m1_waitrequest,
	input avm_m1_readdatavalid,
	
	output[15:0] avm_m1_address,
	output[31:0] avm_m1_writedata,
	
	input [31:0] avm_m1_readdata,
	
	// UART
	
	input uart_rx,
	output uart_tx
);


wire inrst = 0;

wire avm_m2_write;
wire avm_m2_read;
	
wire avm_m2_waitrequest;
wire avm_m2_readdatavalid;
	
wire[15:0] avm_m2_address;
wire[31:0] avm_m2_writedata;
	
wire [31:0] avm_m2_readdata;
	


wire avm_m3_write;
wire avm_m3_read;
	
wire avm_m3_waitrequest;
wire avm_m3_readdatavalid;
	
wire[15:0] avm_m3_address;
wire[31:0] avm_m3_writedata;
	
wire [31:0] avm_m3_readdata;

uart_connector ucon(.clk(csi_clk),
						  .rst(inrst),
	
							// Avalon MM Master
								
							.avm_m1_write(avm_m1_write),
							.avm_m1_read(avm_m1_read),
								
							.avm_m1_waitrequest(avm_m1_waitrequest),
							.avm_m1_readdatavalid(avm_m1_readdatavalid),
								
							.avm_m1_address(avm_m1_address),
							.avm_m1_writedata(avm_m1_writedata),
								
							.avm_m1_readdata(avm_m1_readdata),

							// Avalon MM Master
								
							.avm_m2_write(avm_m2_write),
							.avm_m2_read(avm_m2_read),
								
							.avm_m2_waitrequest(avm_m2_waitrequest),
							.avm_m2_readdatavalid(avm_m2_readdatavalid),
								
							.avm_m2_address(avm_m2_address),
							.avm_m2_writedata(avm_m2_writedata),
								
							.avm_m2_readdata(avm_m2_readdata),	

							// Avalon MM Master
								
							.avm_m3_write(avm_m3_write),
							.avm_m3_read(avm_m3_read),
								
							.avm_m3_waitrequest(avm_m3_waitrequest),
							.avm_m3_readdatavalid(avm_m3_readdatavalid),
								
							.avm_m3_address(avm_m3_address),
							.avm_m3_writedata(avm_m3_writedata),
								
							.avm_m3_readdata(avm_m3_readdata)
	
);

	
wire tick;

wire receiv_restart;
wire receiv_tick;
uart_baud_tick_gen ubtg(.clk(csi_clk),
								.rst(inrst),
		
								.tick(tick)
);

uart_baud_tick_gen ubtgr(.clk(csi_clk),
								.rst(inrst),
								
								.restart(receiv_restart),
								.tick(receiv_tick)
);


wire trans_finish;
wire[7:0] trans_char;
wire trans_start;

wire[7:0] receiv_character;
wire 		 receiv_rdy;

uart_receiver(.clk(csi_clk),
				  .rst(inrst),
				  
				  .restart_tick(receiv_restart),
				  
				  .tick(receiv_tick),
				  .rx(uart_rx),
	
				  .character(receiv_character),
				  .rdy(receiv_rdy)
);

uart_transmitter utrans(.clk(csi_clk),
								.rst(inrst),
	
								.tick(tick),
	
								.character(trans_char),
								.start(trans_start),
								
								.finish(trans_finish),
								
								.uart_tx(uart_tx)
);

wire control_trans_start;
wire[15:0] control_trans_start_addr;
wire[15:0] control_trans_stop_addr;
wire control_trans_work;

uart_center uc(.clk(csi_clk),
				.rst(inrst),
				
				// Transmitter
				
				.trans_char(trans_char),
				.trans_start(trans_start),
								
				.trans_finish(trans_finish),
				
				
				// Control
				.control_trans_start(control_trans_start),
				.control_trans_start_addr(control_trans_start_addr),
				.control_trans_stop_addr(control_trans_stop_addr),
	
				.control_trans_work(control_trans_work),
	
				// Avalon MM Master
				
				.avm_m1_write(avm_m3_write),
				.avm_m1_read(avm_m3_read),
				
				.avm_m1_waitrequest(avm_m3_waitrequest),
				.avm_m1_readdatavalid(avm_m3_readdatavalid),
				
				.avm_m1_address(avm_m3_address),
				.avm_m1_writedata(avm_m3_writedata),
				
				.avm_m1_readdata(avm_m3_readdata)
				
				
);

wire control_receiv_enable;
wire [15:0] control_receiv_start_addr;
wire [15:0] control_receiv_stop_addr;
wire control_receiv_work;

uart_center_receiv ucrev(.clk(csi_clk),
								 .rst(inrst),
								
								 // Receiver
								
								 .receiv_rdy(receiv_rdy),
								 .receiv_char(receiv_character),
	
								 // Control
								.control_receiv_enable(control_receiv_enable),
								
								.control_receiv_start_addr(control_receiv_start_addr),
								.control_receiv_stop_addr(control_receiv_stop_addr),
								
								.control_receiv_work(control_receiv_work),
								
								// Avalon MM Master
								
								.avm_m1_write(avm_m2_write),
								.avm_m1_read(avm_m2_read),
								
								.avm_m1_waitrequest(avm_m2_waitrequest),
								.avm_m1_readdatavalid(avm_m2_readdatavalid),
								
								.avm_m1_address(avm_m2_address),
								.avm_m1_writedata(avm_m2_writedata),
								
								.avm_m1_readdata(avm_m2_readdata)
);


uart_control_registers ucr(.clk(csi_clk),
							  .rst(inrst),
				
								// Avalon MM
							  .avs_s0_write(avs_s0_write),
							  .avs_s0_read(avs_s0_read),
							  .avs_s0_address(avs_s0_address),
							  .avs_s0_writedata(avs_s0_writedata),
								
							  .avs_s0_readdata(avs_s0_readdata),
								
								// Control
								
							  .control_trans_start(control_trans_start),
							  .control_trans_start_addr(control_trans_start_addr),
							  .control_trans_stop_addr(control_trans_stop_addr),
							  .control_trans_work(control_trans_work),
							  
							  
							  .control_receiv_enable(control_receiv_enable),						
							  .control_receiv_start_addr(control_receiv_start_addr),
							  .control_receiv_stop_addr(control_receiv_stop_addr),
		
							  .control_receiv_work(control_receiv_work),

);

endmodule

module uart_control_registers(
	input clk,
	input rst,
	
	// Avalon MM
	input avs_s0_write,
	input avs_s0_read,
	input[2:0] avs_s0_address,
	input[31:0] avs_s0_writedata,
	
	output reg[31:0] avs_s0_readdata,
	
	// Control
	
	output reg 		  control_trans_start,
	output reg[15:0] control_trans_start_addr,
	output reg[15:0] control_trans_stop_addr,
	input				  control_trans_work,
	
	output reg control_receiv_enable,
	output reg[15:0] control_receiv_start_addr,
	output reg[15:0] control_receiv_stop_addr,
	
	input control_receiv_work

);
	
reg 		 f_control_receiv_enable;
reg[15:0] f_control_receiv_start_addr;
reg[15:0] f_control_receiv_stop_addr;
	
	
reg[15:0] f_control_trans_start_addr;
reg[15:0] f_control_trans_stop_addr;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_control_trans_start_addr <= 0;
		f_control_trans_stop_addr <= 0;	
		f_control_receiv_enable <= 0;
		f_control_receiv_start_addr <= 0;
		f_control_receiv_stop_addr <= 0;
	end else
	begin
		f_control_trans_start_addr <= control_trans_start_addr;
		f_control_trans_stop_addr <= control_trans_stop_addr;	

		f_control_receiv_enable <= control_receiv_enable;
		f_control_receiv_start_addr <= control_receiv_start_addr;
		f_control_receiv_stop_addr <= control_receiv_stop_addr;
	end
end

always@(*)begin
	control_trans_start_addr = f_control_trans_start_addr;
	control_trans_stop_addr = f_control_trans_stop_addr;	
	
	control_receiv_enable = f_control_receiv_enable;
	control_receiv_start_addr = f_control_receiv_start_addr;
	control_receiv_stop_addr = f_control_receiv_stop_addr;
		
	control_trans_start = 0;
	
	if(avs_s0_write)
		case(avs_s0_address)
			0: control_trans_start = 1;
			1: control_trans_start_addr = avs_s0_writedata;
			2: control_trans_stop_addr = avs_s0_writedata;
			
			4: control_receiv_enable = avs_s0_writedata[0];
			5: control_receiv_start_addr = avs_s0_writedata;
			6: control_receiv_stop_addr = avs_s0_writedata;
			
			default:;
		endcase
	
end

always@(*) begin
	avs_s0_readdata = 0;
	
	if(avs_s0_read)
		case(avs_s0_address)
			1: avs_s0_readdata = f_control_trans_start_addr;
			2: avs_s0_readdata = f_control_trans_stop_addr;
			3: avs_s0_readdata = control_trans_work;
			4: avs_s0_readdata = f_control_receiv_enable;
			5: avs_s0_readdata = f_control_receiv_start_addr;
			6: avs_s0_readdata = f_control_receiv_stop_addr;
			7: avs_s0_readdata = control_receiv_work;
			
			default: avs_s0_readdata = 32'hFFFFFFFF;
		endcase
end

endmodule







