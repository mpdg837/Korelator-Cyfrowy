

module display_fromDecToSegment(
	input clk,
	input rst,
	
	input ena,
	input light,
	
	input[5:0] number,
	input dot,
	
	output reg[7:0] segments
);

reg[7:0] n_segments;

reg A = 0;
reg B = 0;
reg C = 0;
reg D = 0;
reg E = 0;
reg F = 0;
reg G = 0;

always@(posedge clk or posedge rst)
	if(rst) segments <= 0;
	else segments <= n_segments;

always@(*)begin
	
	A = 0;
	B = 0;
	C = 0;
	D = 0;
	E = 0;
	F = 0;
	G = 0;
	
		case(number)
			1:begin // 0
				A = 1; B = 1; C = 1; D = 1; E = 1; F = 1; G = 0;
			end
			2:begin // 1
				A = 0; B = 1; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			3:begin // 2
				A = 1; B = 1; C = 0; D = 1; E = 1; F = 0; G = 1;
			end
			4:begin // 3
				A = 1; B = 1; C = 1; D = 1; E = 0; F = 0; G = 1;
			end
			5:begin // 4
				A = 0; B = 1; C = 1; D = 0; E = 0; F = 1; G = 1;
			end
			6:begin // 5
				A = 1; B = 0; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			7:begin // 6
				A = 1; B = 0; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			8:begin // 7
				A = 1; B = 1; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			9:begin // 8
				A = 1; B = 1; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			10:begin // 9
				A = 1; B = 1; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			
			11:begin // A
				A = 1; B = 1; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			12:begin // b
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 1; G = 1;
			end
			13:begin // c
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 0; G = 1;
			end
			14:begin // d
				A = 0; B = 1; C = 1; D = 1; E = 1; F = 0; G = 1;
			end
			15:begin // E
				A = 1; B = 0; C = 0; D = 1; E = 1; F = 1; G = 1;
			end
			16:begin // F
				A = 1; B = 0; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			17:begin // G
				A = 1; B = 0; C = 1; D = 1; E = 1; F = 1; G = 0;
			end
			18:begin // h
				A = 0; B = 0; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			19:begin // i
				A = 0; B = 0; C = 1; D = 0; E = 0; F = 0; G = 0;
			end
			20:begin // J
				A = 0; B = 1; C = 1; D = 1; E = 0; F = 0; G = 0;
			end
			21:begin // k
				A = 0; B = 1; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			22:begin // l
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 1; G = 0;
			end
			23:begin // m
				A = 0; B = 0; C = 1; D = 0; E = 0; F = 0; G = 1;
			end
			24:begin // n
				A = 0; B = 0; C = 1; D = 0; E = 1; F = 0; G = 1;
			end
			25:begin // o
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 1;
			end
			26:begin // P
				A = 1; B = 1; C = 0; D = 0; E = 1; F = 1; G = 1;
			end
			27:begin // q
				A = 1; B = 1; C = 1; D = 0; E = 0; F = 1; G = 1;
			end
			28:begin // r
				A = 0; B = 0; C = 0; D = 0; E = 1; F = 0; G = 1;
			end
			29:begin // S
				A = 0; B = 0; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			30:begin // t
				A = 0; B = 0; C = 0; D = 1; E = 1; F = 1; G = 1;
			end
			31:begin // u 
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 0;
			end
			32:begin // v 
				A = 0; B = 0; C = 1; D = 1; E = 1; F = 0; G = 0;
			end
			33:begin // w 
				A = 0; B = 0; C = 1; D = 1; E = 0; F = 0; G = 0;
			end
			34:begin // X
				A = 0; B = 1; C = 1; D = 0; E = 1; F = 1; G = 1;
			end
			35:begin // y
				A = 0; B = 1; C = 1; D = 1; E = 0; F = 1; G = 1;
			end
			36:begin // z
				A = 1; B = 1; C = 0; D = 1; E = 1; F = 0; G = 0;
			end
			37:begin // {
				A = 1; B = 0; C = 0; D = 1; E = 1; F = 0; G = 0;
			end
			38: begin
				A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 1;
			end
			default:;
		endcase
		
	if(ena & light) n_segments = {dot,G,F,E,D,C,B,A};
	else n_segments = 0;
	
end

endmodule