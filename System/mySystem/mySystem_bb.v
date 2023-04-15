
module mySystem (
	clk_clk,
	inputin_keys,
	inputin_leds,
	sevensegment_output1,
	sevensegment_output,
	uart_rx,
	uart_tx,
	reset_reset_n);	

	input		clk_clk;
	input	[3:0]	inputin_keys;
	output	[3:0]	inputin_leds;
	output	[3:0]	sevensegment_output1;
	output	[7:0]	sevensegment_output;
	input		uart_rx;
	output		uart_tx;
	input		reset_reset_n;
endmodule
