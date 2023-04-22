	mySystem u0 (
		.clk_clk                            (<connected-to-clk_clk>),                            //                      clk.clk
		.input_key_0_keys_writebyteenable_n (<connected-to-input_key_0_keys_writebyteenable_n>), //         input_key_0_keys.writebyteenable_n
		.input_key_0_keys_readdata          (<connected-to-input_key_0_keys_readdata>),          //                         .readdata
		.reset_reset_n                      (<connected-to-reset_reset_n>),                      //                    reset.reset_n
		.uart_fast_0_uart_rx                (<connected-to-uart_fast_0_uart_rx>),                //         uart_fast_0_uart.rx
		.uart_fast_0_uart_tx                (<connected-to-uart_fast_0_uart_tx>),                //                         .tx
		.segmentdisplay_0_display_select    (<connected-to-segmentdisplay_0_display_select>),    // segmentdisplay_0_display.select
		.segmentdisplay_0_display_segment   (<connected-to-segmentdisplay_0_display_segment>)    //                         .segment
	);

