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


reg[15:0] f_cycles;
reg[15:0] n_cycles;

reg[15:0] f_reladdrread;
reg[15:0] n_reladdrread;

reg[15:0] f_reladdrsave;
reg[15:0] n_reladdrsave;

reg[7:0] f_memread;
reg[7:0] n_memread;

reg[7:0] f_memsave;
reg[7:0] n_memsave;

reg[3:0] f_status;
reg[3:0] n_status;

always@(posedge clk or posedge rst)begin
	if(rst) f_reladdrsave <= 0;
	else f_reladdrsave <= n_reladdrsave;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_reladdrread <= 0;
	else f_reladdrread <= n_reladdrread;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_status <= 0;
	else f_status <= n_status;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_memsave <= 0;
	else f_memsave <= n_memsave;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_memread <= 0;
	else f_memread <= n_memread;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_abs <= 0;
	else f_abs <= n_abs;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_cycles <= 0;
	else f_cycles <= n_cycles;
end


localparam IDLE = 0;
localparam LOAD_DATA = 1;
localparam WAIT_DATA = 2;
localparam SEND_COPPER = 3;
localparam WAIT_COPPER = 10;
localparam RECEIV_COPPER = 4;
localparam ABS = 5;
localparam REDUCE_VAL = 6;
localparam SAVE = 7;
localparam WAIT_SAVE = 8;
localparam VERIFY = 9;

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		IDLE:
			if(start) n_status = LOAD_DATA;
		LOAD_DATA: n_status = WAIT_DATA;
		WAIT_DATA: 
			if(rdy) n_status = SAVE;
		SAVE: n_status = WAIT_SAVE;
		WAIT_SAVE: 
					if(rdy || f_cycles == 0) n_status = VERIFY;
		VERIFY: 
					if(f_reladdrread== len_read) n_status = IDLE;
					else n_status = LOAD_DATA;
		
	endcase
end

always@(*) begin

	n_abs = f_abs;
	
	rec = 0;
	startrec = 0;
	save_data = 0;
	
	case(f_status)
		LOAD_DATA: begin
				n_abs = 0;
				
				rec = $signed(f_memread);
				startrec = 1;
				
			end
		WAIT_DATA: begin
				if(rdy) begin
					
					if(outrec[24] == 1) n_abs = (~outrec) + 1;
					else n_abs = outrec;
					
				end
			end
		SAVE: begin
		
				if(f_cycles != 0) begin
					
					if(f_abs[24:20] == 0) save_data = f_abs[19:12];
					else save_data = 255;

				end else save_data = 0;
				
			end

	endcase
	
end

always@(*)begin

	
	n_memread = f_memread;
	n_memsave = f_memsave;
	
	n_reladdrread = f_reladdrread;
	n_reladdrsave = f_reladdrsave;

	n_cycles = f_cycles;
	
	work = 1;
	
	rel_addr = 0;
	write = 0;
	read = 0;
	
	case(f_status)
		IDLE: begin 
			work = 0;
			
			if(start) begin
				n_reladdrread = 0;
				n_reladdrsave = 0;
				n_cycles = 0;
				
				n_memread = 0;
				n_memsave = 0;
				
			end
				
			end
		LOAD_DATA: begin
		
				rel_addr = f_reladdrread;
				read = 1;
				
				
			end
		WAIT_DATA: begin
				if(rdy) begin
					
					n_memread = read_data;
					
				end
			end
		SAVE: begin
		
				rel_addr = f_reladdrsave;
				write = 1;
				
			end
		VERIFY: begin
				n_reladdrread = f_reladdrread + 1;
				n_reladdrsave = f_reladdrsave + 1;
				
				n_cycles = f_cycles + 1;
				
			end
	endcase
end

endmodule
