module selectDisplay(
	input[15:0] in,
	input clk0,
	input rst,
	input ena,
	
	output[3:0] out,
	output[3:0] sel
);

reg[3:0] f_out=0;
reg[3:0] n_out=0;

reg[3:0] f_sel=0;
reg[3:0] n_sel=0;
	
reg[2:0] f_sn=0;
reg[2:0] n_sn=0;

always@(posedge clk0 or posedge rst)begin
	if(rst)begin
		f_sn <= 3'd0;
	end else
	begin
		f_sn <= n_sn;
	end
end

always@(*)begin
	n_sn = f_sn + 1;
end

always@(*)begin
	if(~ena) n_sel = 4'b1111;
	else
	case(n_sn)
		0: n_sel = 4'b1110;
		1: n_sel = 4'b1110;
		2: n_sel = 4'b1101;
		3: n_sel = 4'b1101;
		4: n_sel = 4'b1011;
		5: n_sel = 4'b1011;
		6: n_sel = 4'b0111;
		7: n_sel = 4'b0111;
	endcase
end

always@(*)begin	
	case(n_sn)
		0: n_out = in[3:0];
		1: n_out = in[3:0];
		2: n_out = in[7:4];
		3: n_out = in[7:4];
		4: n_out = in[11:8];
		5: n_out = in[11:8];
		6: n_out = in[15:12];
		7: n_out = in[15:12];
		default: n_out =4'b1111;
	endcase
	
end

assign out = n_out;
assign sel = n_sel;
endmodule
