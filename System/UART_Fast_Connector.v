module uart_buffer_avalon(
	input clk,
	input rst,
	
	input avm_m_write,
	input avm_m_read,
	input[15:0] avm_m_address,
	input[31:0] avm_m_writedata,
	
	output reg f_avm_m_write,
	output reg f_avm_m_read,
	output reg[15:0] f_avm_m_address,
	output reg[31:0] f_avm_m_writedata,

	input b_clear
);

reg clear = 0;

always@(posedge clk or posedge rst)begin
	if(rst) clear <= 0;
	else clear <= b_clear;
end

reg n_avm_m_write;
reg n_avm_m_read;
reg[15:0] n_avm_m_address;
reg[31:0] n_avm_m_writedata;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_avm_m_write <= 0;
		f_avm_m_read <= 0;
		f_avm_m_address <= 0;
		f_avm_m_writedata <= 0;
		
	end
	else begin
		f_avm_m_write <= n_avm_m_write;
		f_avm_m_read <= n_avm_m_read;
		f_avm_m_address <= n_avm_m_address;
		f_avm_m_writedata <= n_avm_m_writedata;
		
	end
end



always@(*)begin
	n_avm_m_write = f_avm_m_write;
	n_avm_m_read = f_avm_m_read;
	n_avm_m_address = f_avm_m_address;
	n_avm_m_writedata = f_avm_m_writedata;
	
	if(avm_m_write)begin
		n_avm_m_write = 1;
		n_avm_m_read = 0;
		n_avm_m_address = avm_m_address;
		n_avm_m_writedata = avm_m_writedata;
		
	end
	
	if(avm_m_read)begin
		n_avm_m_write = 0;
		n_avm_m_read = 1;
		n_avm_m_address = avm_m_address;
		n_avm_m_writedata = 0;
		
	end

	if(clear)begin
		n_avm_m_write = 0;
		n_avm_m_read = 0;
		n_avm_m_address = 0;
		n_avm_m_writedata = 0;
	end
	
end


endmodule

module uart_uart_avalon_waitrequest(
	input f_avm_m_write,
	input f_avm_m_read,
	input avm_m_write,
	input avm_m_read,
	
	output reg avm_m_waitrequest
);

always@(*)begin
	avm_m_waitrequest = 0;
	
	if(f_avm_m_write || f_avm_m_read || avm_m_write || avm_m_read) avm_m_waitrequest = 1;
end

endmodule

module uart_connector(
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

	// Avalon MM Master
	
	input avm_m2_write,
	input avm_m2_read,
	
	output avm_m2_waitrequest,
	output reg avm_m2_readdatavalid,
	
	input[15:0] avm_m2_address,
	input[31:0] avm_m2_writedata,
	
	output reg[31:0] avm_m2_readdata,	

	// Avalon MM Master
	
	input avm_m3_write,
	input avm_m3_read,
	
	output avm_m3_waitrequest,
	output reg avm_m3_readdatavalid,
	
	input[15:0] avm_m3_address,
	input[31:0] avm_m3_writedata,
	
	output reg[31:0] avm_m3_readdata
	
);

localparam WAITFORONE = 0;
localparam SENDDATAONE = 1;
localparam WAITFORTWO = 2;
localparam SENDDATATWO = 3;


reg b_clear2 = 0;
reg b_clear1 = 0;


wire f_avm_m2_write;
wire f_avm_m2_read;
wire[15:0] f_avm_m2_address;
wire[31:0] f_avm_m2_writedata;

wire f_avm_m3_write;
wire f_avm_m3_read;
wire[15:0] f_avm_m3_address;
wire[31:0] f_avm_m3_writedata;

uart_buffer_avalon b1(.clk(clk),
							 .rst(rst),
	
							 .avm_m_write(avm_m2_write),
							 .avm_m_read(avm_m2_read),
						  	 .avm_m_address(avm_m2_address),
							 .avm_m_writedata(avm_m2_writedata),
							
							
							 .f_avm_m_write(f_avm_m2_write),
							 .f_avm_m_read(f_avm_m2_read),
							 .f_avm_m_address(f_avm_m2_address),
							 .f_avm_m_writedata(f_avm_m2_writedata),

							 .b_clear(b_clear1)
);

uart_buffer_avalon b2(.clk(clk),
							 .rst(rst),
	
							 .avm_m_write(avm_m3_write),
							 .avm_m_read(avm_m3_read),
						  	 .avm_m_address(avm_m3_address),
							 .avm_m_writedata(avm_m3_writedata),
							
							
							 .f_avm_m_write(f_avm_m3_write),
							 .f_avm_m_read(f_avm_m3_read),
							 .f_avm_m_address(f_avm_m3_address),
							 .f_avm_m_writedata(f_avm_m3_writedata),

							 .b_clear(b_clear2)
);


uart_uart_avalon_waitrequest uuaw1(.f_avm_m_write(f_avm_m2_write),
											 .f_avm_m_read(f_avm_m2_read),
											 .avm_m_write(avm_m2_write),
											 .avm_m_read(avm_m2_read),
	
											 .avm_m_waitrequest(avm_m2_waitrequest)
);


uart_uart_avalon_waitrequest uuaw2(.f_avm_m_write(f_avm_m3_write),
											 .f_avm_m_read(f_avm_m3_read),
											 .avm_m_write(avm_m3_write),
											 .avm_m_read(avm_m3_read),
	
											 .avm_m_waitrequest(avm_m3_waitrequest)
);



reg[1:0] f_status;
reg[1:0] n_status;

reg[31:0] f_avm_m2_readdata;
reg[31:0] n_avm_m2_readdata;

reg[31:0] f_avm_m3_readdata;
reg[31:0] n_avm_m3_readdata;

always@(posedge clk or posedge rst)begin
	if(rst) f_avm_m2_readdata <= 0;
	else f_avm_m2_readdata <= n_avm_m2_readdata;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_avm_m3_readdata <= 0;
	else f_avm_m3_readdata <= n_avm_m3_readdata;
end

always@(posedge clk or posedge rst)
	if(rst) f_status <= 0;
	else f_status <= n_status;

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		WAITFORONE:	if(f_avm_m2_write) begin
							if(~avm_m1_waitrequest) n_status = WAITFORTWO;
							else n_status = WAITFORONE;
							
						end
						else if(f_avm_m2_read) begin
							if(avm_m1_readdatavalid) n_status = SENDDATAONE;
							else n_status = WAITFORONE;
							
						end
						else n_status = WAITFORTWO;
		SENDDATAONE: n_status = WAITFORTWO;
		WAITFORTWO: if(f_avm_m3_write) begin
							if(~avm_m1_waitrequest) n_status = WAITFORONE;
							else n_status = WAITFORTWO;
						end
						else if(f_avm_m3_read) begin
							if(avm_m1_readdatavalid) n_status = SENDDATATWO;
							else n_status = WAITFORTWO;
						end
						else n_status = WAITFORONE;
		SENDDATATWO: n_status = WAITFORONE;
		default:;
	endcase
	
end

reg 		 avm_m11_write = 0;
reg 		 avm_m11_read = 0;
reg[15:0] avm_m11_address = 0;
reg[31:0] avm_m11_writedata = 0;

reg 		 avm_m12_write = 0;
reg 		 avm_m12_read = 0;
reg[15:0] avm_m12_address = 0;
reg[31:0] avm_m12_writedata = 0;


always@(*)begin


	avm_m11_write = 0;
	avm_m11_read = 0;
	avm_m11_address = 0;
	avm_m11_writedata = 0;
	
	avm_m2_readdatavalid = 0;
	avm_m2_readdata = 0;
	
	n_avm_m2_readdata = f_avm_m2_readdata;
	
	b_clear1 = 0;

	case(f_status)
		WAITFORONE: begin
			if(f_avm_m2_write) begin
			
				avm_m11_write = 1;
				avm_m11_read = 0;
				avm_m11_address = f_avm_m2_address;
				avm_m11_writedata = f_avm_m2_writedata;
				
				if(~avm_m1_waitrequest) begin;
					b_clear1 = 1;
					n_avm_m2_readdata = 0;
				end
			
			end else if(f_avm_m2_read) begin
				
				avm_m11_write = 0;
				avm_m11_read = 1;
				avm_m11_address = f_avm_m2_address;
				avm_m11_writedata = 0;
				
				if(avm_m1_readdatavalid) begin
					b_clear1 = 1;
					n_avm_m2_readdata = avm_m1_readdata;
				end
				
			end
			 
		end
		SENDDATAONE: begin
			avm_m2_readdatavalid = 1;
			avm_m2_readdata = f_avm_m2_readdata;
		end
		
		default:;
	endcase

	
end


always@(*)begin
	
	avm_m12_write = 0;
	avm_m12_read = 0;
	avm_m12_address = 0;
	avm_m12_writedata = 0;
	
	avm_m3_readdatavalid = 0;
	avm_m3_readdata = 0;
	
	n_avm_m3_readdata = f_avm_m3_readdata;

	b_clear2 = 0;
	
	case(f_status)
		WAITFORTWO: begin
			if(f_avm_m3_write) begin

				avm_m12_write = 1;
				avm_m12_read = 0;
				avm_m12_address = f_avm_m3_address;
				avm_m12_writedata = f_avm_m3_writedata;
				
				if(~avm_m1_waitrequest) begin
					b_clear2 = 1;
					n_avm_m3_readdata = 0;
				end
			
			end else if(f_avm_m3_read) begin
				
				avm_m12_write = 0;
				avm_m12_read = 1;
				avm_m12_address = f_avm_m3_address;
				avm_m12_writedata = 0;
				
				if(avm_m1_readdatavalid) begin
					b_clear2 = 1;
					n_avm_m3_readdata = avm_m1_readdata;
				end
			
			end
			 
		end 
		SENDDATATWO: begin
			avm_m3_readdatavalid = 1;
			avm_m3_readdata = f_avm_m3_readdata;
		end
		default:;
	endcase
	
end

always@(*)begin
	avm_m1_write <= avm_m11_write | avm_m12_write;
	avm_m1_read <= avm_m11_read | avm_m12_read;
	avm_m1_address <= avm_m11_address | avm_m12_address;
	avm_m1_writedata <= avm_m11_writedata | avm_m12_writedata;
end


endmodule
