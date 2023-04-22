
module mySystem (
	clk_clk,
	input_key_0_keys_writebyteenable_n,
	input_key_0_keys_readdata,
	reset_reset_n,
	uart_fast_0_uart_rx,
	uart_fast_0_uart_tx,
	segmentdisplay_0_display_select,
	segmentdisplay_0_display_segment);	

	input		clk_clk;
	input	[3:0]	input_key_0_keys_writebyteenable_n;
	output	[3:0]	input_key_0_keys_readdata;
	input		reset_reset_n;
	input		uart_fast_0_uart_rx;
	output		uart_fast_0_uart_tx;
	output	[3:0]	segmentdisplay_0_display_select;
	output	[7:0]	segmentdisplay_0_display_segment;
endmodule
