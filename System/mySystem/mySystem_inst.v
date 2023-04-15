	mySystem u0 (
		.clk_clk              (<connected-to-clk_clk>),              //          clk.clk
		.inputin_keys         (<connected-to-inputin_keys>),         //      inputin.keys
		.inputin_leds         (<connected-to-inputin_leds>),         //             .leds
		.sevensegment_output1 (<connected-to-sevensegment_output1>), // sevensegment.output1
		.sevensegment_output  (<connected-to-sevensegment_output>),  //             .output
		.uart_rx              (<connected-to-uart_rx>),              //         uart.rx
		.uart_tx              (<connected-to-uart_tx>),              //             .tx
		.reset_reset_n        (<connected-to-reset_reset_n>)         //        reset.reset_n
	);

