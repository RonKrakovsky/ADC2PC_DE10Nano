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
	-- ADC Transmitter - AVALON_MM control / external for ADC pins  
	COMPONENT ADC_Transmitter
	PORT
	(
		adc_0_adc_slave_write			:	 IN STD_LOGIC;
		adc_0_adc_slave_readdata		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		adc_0_adc_slave_writedata		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		adc_0_adc_slave_address			:	 IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		adc_0_adc_slave_waitrequest		:	 OUT STD_LOGIC;
		adc_0_adc_slave_read			:	 IN STD_LOGIC;
		adc_0_external_interface_sclk	:	 OUT STD_LOGIC;
		adc_0_external_interface_cs_n	:	 OUT STD_LOGIC;
		adc_0_external_interface_dout	:	 IN STD_LOGIC;
		adc_0_external_interface_din	:	 OUT STD_LOGIC;
		clk_clk							:	 IN STD_LOGIC;
		reset_reset_n					:	 IN STD_LOGIC
	);
	END COMPONENT;	

	-- ADC Controller - Control the ADC Transmitter 
	COMPONENT ADC_Controller
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset_n		:	 IN STD_LOGIC;
		avm_master_read		:	 OUT STD_LOGIC;
		avm_master_write		:	 OUT STD_LOGIC;
		avm_master_address		:	 OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		avm_master_readdata		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		avm_master_writedata		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		avm_master_waitrequest		:	 IN STD_LOGIC;
		aso_source_data		:	 OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		aso_source_valid		:	 OUT STD_LOGIC
	);
	END COMPONENT;

	------------------------------------------------- signals 
	signal avm_write,avm_read,avm_waitrequest : std_logic;
	signal avm_readdata,avm_writedata : std_logic_vector(31 downto 0);
	signal avm_addess : std_logic_vector(2 downto 0);
	signal data_adc : std_logic_vector(11 downto 0);
	signal valid_adc : std_logic;

begin
	u1 : ADC_Transmitter 
	port map(
		clk_clk => clk,
		reset_reset_n => reset_n,
		adc_0_adc_slave_write => avm_write,
		adc_0_adc_slave_readdata => avm_readdata,
		adc_0_adc_slave_writedata => avm_writedata,
		adc_0_adc_slave_address => avm_addess,
		adc_0_adc_slave_waitrequest => avm_waitrequest, 
		adc_0_adc_slave_read => avm_read,
		adc_0_external_interface_sclk => sclk,
		adc_0_external_interface_cs_n => cs_n,
		adc_0_external_interface_dout => dout,
		adc_0_external_interface_din => din
	);
	
	u2 : ADC_Controller
	port map(
		clk => clk,
		reset_n => reset_n,
		avm_master_read => avm_read,
		avm_master_write => avm_write,
		avm_master_address => avm_addess,
		avm_master_readdata => avm_readdata,
		avm_master_writedata => avm_writedata,
		avm_master_waitrequest => avm_waitrequest,
		aso_source_data => data_adc,
		aso_source_valid => valid_adc
	);
	
end architecture rtl;