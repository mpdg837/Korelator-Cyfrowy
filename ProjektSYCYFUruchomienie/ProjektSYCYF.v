module ProjektSYCYF(
	input rst,
	input clk,
	input divp,
	input enap,
	input kilop,
	
	output[6:0] sgm,
	output[3:0] sel,
	
	output rdyd,
	output divd,
	output enad
);

// Modul wejscia

wire clk1;

clk_div dv(.clk(clk),.clk1(clk1),.indiv(indiv));

wire press;
wire divpress;
wire enapress;

przycisk p1(.mode(0),.in(rst),.clk(clk),.press(press));
przycisk p2(.mode(1),.in(divp),.clk(clk),.press(divpress));
przycisk p3(.mode(1),.in(enap),.clk(clk),.press(enapress));

wire inrst = ~press;
wire indiv = ~divpress;
wire ena = ~enapress;
wire kilo = ~kilop;


wire [12:0] addr;
wire clk0;
wire signed[7:0] rec;

// Modul przetwornika
counter cou(.ena(ena),.clk(clk1),.rst(inrst),.clk_0(clk0));


ROM rom(.clk(clk0),.addr(addr),.out(rec));
ROM_controller cont(.ena(ena),.clk(clk0),.rst(inrst),.addr(addr));

DSPprocessor dsp(.ena(ena),.rst(inrst),.clk(clk1),.rec(rec),.tim(timx),.rdy(rdy));

// Wykonanie przemnozen

wire signed[13:0] timx;
wire signed[26:0] tim1 = timx*13'b0010011001100;
wire signed[13:0] tim2 = tim1 >> 13;
wire signed[13:0] tim = (kilo)? tim2 : timx;

// Modul wyjscia
wire[15:0] out;
wire[3:0] num;
wire clk1khz;

bin2bcd bcd(.bin(tim),.bcd(out));

timer1kHz khz(.clk(clk),.clk0(clk1khz));



selectDisplay sele(.in(out),.clk0(clk1khz),.rst(inrst),.out(num),.sel(sel),.ena(ena));
segment7 segm(.bcd(num),.seg(sgm));

assign rdyd = ~(rdy && ena);
assign divd = divpress;
assign enad = enapress;
endmodule
