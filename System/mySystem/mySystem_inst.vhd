	component mySystem is
		port (
			clk_clk              : in  std_logic                    := 'X';             -- clk
			inputin_keys         : in  std_logic_vector(3 downto 0) := (others => 'X'); -- keys
			inputin_leds         : out std_logic_vector(3 downto 0);                    -- leds
			sevensegment_output1 : out std_logic_vector(3 downto 0);                    -- output1
			sevensegment_output  : out std_logic_vector(7 downto 0);                    -- output
			uart_rx              : in  std_logic                    := 'X';             -- rx
			uart_tx              : out std_logic;                                       -- tx
			reset_reset_n        : in  std_logic                    := 'X'              -- reset_n
		);
	end component mySystem;

	u0 : component mySystem
		port map (
			clk_clk              => CONNECTED_TO_clk_clk,              --          clk.clk
			inputin_keys         => CONNECTED_TO_inputin_keys,         --      inputin.keys
			inputin_leds         => CONNECTED_TO_inputin_leds,         --             .leds
			sevensegment_output1 => CONNECTED_TO_sevensegment_output1, -- sevensegment.output1
			sevensegment_output  => CONNECTED_TO_sevensegment_output,  --             .output
			uart_rx              => CONNECTED_TO_uart_rx,              --         uart.rx
			uart_tx              => CONNECTED_TO_uart_tx,              --             .tx
			reset_reset_n        => CONNECTED_TO_reset_reset_n         --        reset.reset_n
		);

