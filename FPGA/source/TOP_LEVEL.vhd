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
		din		: out std_logic
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
	GENERIC ( f_in : INTEGER := 50000000; f_out : INTEGER := 9600 );
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
	------------------------------------------------- signals 
	signal avm_write,avm_read,avm_waitrequest : std_logic;
	signal avm_readdata,avm_writedata : std_logic_vector(31 downto 0);
	signal avm_addess : std_logic_vector(2 downto 0);
	signal data_adc_chanel0, data_adc_chanel1, data_adc_chanel2: std_logic_vector(11 downto 0);
	signal sampling_active_adc : std_logic;
	signal valid_adc : std_logic;
	signal clk_40Mhz,clk_1 : std_logic;

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

	
end architecture rtl;