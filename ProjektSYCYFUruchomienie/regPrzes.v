module regPrzes(
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
