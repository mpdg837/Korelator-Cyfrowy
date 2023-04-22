	component mySystem is
		port (
			clk_clk                            : in  std_logic                    := 'X';             -- clk
			input_key_0_keys_writebyteenable_n : in  std_logic_vector(3 downto 0) := (others => 'X'); -- writebyteenable_n
			input_key_0_keys_readdata          : out std_logic_vector(3 downto 0);                    -- readdata
			reset_reset_n                      : in  std_logic                    := 'X';             -- reset_n
			uart_fast_0_uart_rx                : in  std_logic                    := 'X';             -- rx
			uart_fast_0_uart_tx                : out std_logic;                                       -- tx
			segmentdisplay_0_display_select    : out std_logic_vector(3 downto 0);                    -- select
			segmentdisplay_0_display_segment   : out std_logic_vector(7 downto 0)                     -- segment
		);
	end component mySystem;

	u0 : component mySystem
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                      clk.clk
			input_key_0_keys_writebyteenable_n => CONNECTED_TO_input_key_0_keys_writebyteenable_n, --         input_key_0_keys.writebyteenable_n
			input_key_0_keys_readdata          => CONNECTED_TO_input_key_0_keys_readdata,          --                         .readdata
			reset_reset_n                      => CONNECTED_TO_reset_reset_n,                      --                    reset.reset_n
			uart_fast_0_uart_rx                => CONNECTED_TO_uart_fast_0_uart_rx,                --         uart_fast_0_uart.rx
			uart_fast_0_uart_tx                => CONNECTED_TO_uart_fast_0_uart_tx,                --                         .tx
			segmentdisplay_0_display_select    => CONNECTED_TO_segmentdisplay_0_display_select,    -- segmentdisplay_0_display.select
			segmentdisplay_0_display_segment   => CONNECTED_TO_segmentdisplay_0_display_segment    --                         .segment
		);

