library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP_LEVEL is
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;

		sclk	: out std_logic;
		cs_n	: out std_logic;
		dout	: in std_logic;
		din		: out std_logic;

		o_Tx 	: out std_logic;
		i_Rx	: in std_logic
	);
end entity TOP_LEVEL;

architecture rtl of TOP_LEVEL is
	
	COMPONENT ADC_spi_master
	PORT
	(
		ADC_clk		:	 IN STD_LOGIC;
		ADC_DOUT		:	 IN STD_LOGIC;
		ADC_DIN		:	 OUT STD_LOGIC;
		ADC_SCLK		:	 OUT STD_LOGIC;
		ADC_CONVST		:	 OUT STD_LOGIC;
		sampling_active		:	 OUT STD_LOGIC;
		chanel_0		:	 OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		chanel_1		:	 OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		chanel_2		:	 OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END COMPONENT;

	-- div clk 
	COMPONENT PLL
	PORT
	(
		clk_clk		:	 IN STD_LOGIC;
		pll_0_outclk0_clk		:	 OUT STD_LOGIC;
		reset_reset_n		:	 IN STD_LOGIC
	);
	END COMPONENT;

	COMPONENT div_clk
	PORT
	(
		clk1		:	 IN STD_LOGIC;
		clk		:	 OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT clock_divide_uart
	GENERIC ( f_in : INTEGER := 50000000; f_out : INTEGER := 250000 );
	PORT
	(
		i_clk		:	 IN STD_LOGIC;
		i_reset		:	 IN STD_LOGIC;
		o_clock		:	 OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT UartTx
	GENERIC ( bit_data : INTEGER := 8; Stop_bit : INTEGER := 2 );
	PORT
	(
		i_Clk		:	 IN STD_LOGIC;
		i_reset		:	 IN STD_LOGIC;
		i_start		:	 IN STD_LOGIC;
		i_data		:	 IN STD_LOGIC_VECTOR(bit_data-1 DOWNTO 0);
		o_active		:	 OUT STD_LOGIC;
		o_Serial		:	 OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT UartRx
	GENERIC ( bit_data : INTEGER := 8; Stop_bit : INTEGER := 2 );
	PORT
	(
		i_Clk		:	 IN STD_LOGIC;
		i_reset		:	 IN STD_LOGIC;
		i_serial		:	 IN STD_LOGIC;
		o_data		:	 OUT STD_LOGIC_VECTOR(bit_data-1 DOWNTO 0);
		o_valid		:	 OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT Uart_manager
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset_n		:	 IN STD_LOGIC;
		i_channel_0		:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		i_channel_1		:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		i_channel_2		:	 IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		o_data2uart		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		o_valid_start		:	 OUT STD_LOGIC;
		i_valid_tx		:	 IN STD_LOGIC;
		i_data_Rx		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		i_valid_Rx		:	 IN STD_LOGIC
	);
	END COMPONENT;

	------------------------------------------------- signals 
	signal avm_write,avm_read,avm_waitrequest : std_logic;
	signal avm_readdata,avm_writedata : std_logic_vector(31 downto 0);
	signal avm_addess : std_logic_vector(2 downto 0);
	signal data_adc_chanel0, data_adc_chanel1, data_adc_chanel2: std_logic_vector(11 downto 0);
	signal sampling_active_adc : std_logic;
	signal valid_adc : std_logic;
	signal clk_40Mhz,clk_1,clk_9600Hz : std_logic;
	signal sig_active_Tx_n,sig_start_tx,sig_valid_parallel_rx : std_logic;
	signal sig_parallel_uart,sig_parallel_uart_rx : std_logic_vector(7 downto 0);

begin

	u01 : div_clk
	port map(
		clk1 =>clk,
		clk => clk_1
	);

	uo : PLL
	port map(
		clk_clk => clk,
		pll_0_outclk0_clk => clk_40Mhz,
		reset_reset_n => reset_n
	);

	u1 : ADC_spi_master 
	port map(
		ADC_clk => clk_40Mhz,
		ADC_DOUT => dout,	
		ADC_DIN => din,
		ADC_SCLK => sclk,
		ADC_CONVST => cs_n,
		sampling_active => sampling_active_adc,
		chanel_0 => data_adc_chanel0,
		chanel_1 => data_adc_chanel1,
		chanel_2 => data_adc_chanel2

	);

	u2 : clock_divide_uart
	port map (
		i_clk => clk,
		i_reset => reset_n,
		o_clock	=> clk_9600Hz
	);

	u3 : UartTx
	port map(
		i_Clk => clk_9600Hz,
		i_reset => reset_n,
		i_start => sig_start_tx,
		i_data => sig_parallel_uart,
		o_active => sig_active_Tx_n,
		o_Serial => o_Tx

	);

	u4 : UartRx
	port map(
		i_Clk => clk_9600Hz,
		i_reset => reset_n,
		i_serial => i_Rx,
		o_data => sig_parallel_uart_rx,
		o_valid	=> sig_valid_parallel_rx

	);

	u5 : Uart_manager
	port map(
		clk => clk_9600Hz,
		reset_n => reset_n,
		i_channel_0 => data_adc_chanel0,
		i_channel_1	=> data_adc_chanel1,
		i_channel_2 => data_adc_chanel2,
		o_data2uart => sig_parallel_uart,
		o_valid_start => sig_start_tx,
		i_valid_tx => sig_active_Tx_n,
		i_data_Rx => sig_parallel_uart_rx,
		i_valid_Rx => sig_valid_parallel_rx


	);
	
end architecture rtl;