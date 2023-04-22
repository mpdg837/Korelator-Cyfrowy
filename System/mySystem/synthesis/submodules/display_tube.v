
module display_lightRegulator(
	input clk,
	input rst,
	
	input[2:0] light,
	
	output reg ligSig
);

reg[4:0] f_tim;
reg[4:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;

always@(*)begin
	n_tim = f_tim + 1;
	ligSig = 0;
	
	case(light)
		1: if(f_tim <= 4) ligSig = 1;
		2: if(f_tim <= 5) ligSig = 1;
		3: if(f_tim <= 6) ligSig = 1;
		4: if(f_tim <= 7) ligSig = 1;
		5: if(f_tim <= 9) ligSig = 1;
		6: if(f_tim <= 12) ligSig = 1;
		7: if(f_tim <= 15) ligSig = 1;
		default:;
	endcase
	
end

endmodule

module display_outBuffer(
	input clk,
	input rst,
	
	input[7:0] inSegment,
	input[3:0] inSelect,
	
	output reg[7:0] segment,
	output reg[3:0] select
);

always@(posedge clk or posedge rst)
	if(rst) begin
		segment <= 0;
		select <= 0;	
	end
	else begin
		segment <= ~inSegment;
		select <= ~inSelect;
	end
	
endmodule


module display_displayMultiplex(
	input clk,
	input rst,
	
	input freq,
	
	input[7:0] segment1,
	input[7:0] segment2,
	input[7:0] segment3,
	input[7:0] segment4,
	
	output reg[3:0] select,
	output reg[7:0] seg
);

localparam LEN = 2;

reg[3:0] f_select;
reg[7:0] f_segment;

reg[LEN - 1:0] f_tim;
reg[LEN - 1:0] n_tim;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		f_segment <= 0;
		f_select <= 0;
		end
	else begin
		f_tim <= n_tim;
		f_segment <= seg;
		f_select <= select;
		end
end

always@(*)begin
	n_tim = f_tim;

	if(freq) n_tim = f_tim + 1;

end

always@(*)begin
	seg = f_segment;
	
	case(f_tim)
		0: seg = segment1;
		1: seg = segment2;
		2: seg = segment3;
		3: seg = segment4;
	endcase
	
end

always@(*)begin

	select = f_select;
	
	case(f_tim)
		0: select = 4'b1000;
		1: select = 4'b0100;
		2: select = 4'b0010;
		3: select = 4'b0001;
		default:;
	endcase
end

endmodule

module display_frequencyGen #(
	parameter SPEED = 18
)(
	input clk,
	input rst,
	
	output reg freq
);

reg[SPEED - 1: 0] f_tim;
reg[SPEED - 1: 0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;

always@(*)begin
	n_tim = f_tim + 1;
	freq = 0;
	
	if(f_tim == 0) freq = 1;
	
end
endmodule

