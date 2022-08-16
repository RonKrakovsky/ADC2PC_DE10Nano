library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADC_Controller is
	port (
		clk		: in std_logic;
		reset_n	: in std_logic;

		-- AVALON_MM 
		avm_master_read : out std_logic; -- '1' its read 
		avm_master_write : out std_logic;
		avm_master_address : out std_logic_vector (2 downto 0);
		avm_master_readdata : in std_logic_vector (31 downto 0); 
		avm_master_writedata : out std_logic_vector(31 downto 0);
		avm_master_waitrequest : in std_logic;

		aso_source_data : out std_logic_vector(11 downto 0);
		aso_source_valid : out std_logic
	);
end entity ADC_Controller;

architecture rtl of ADC_Controller is
	
	signal counter_chanel : integer range 2 downto 0;
	signal sig_write, sig_read : std_logic;
	signal sig_data_source : std_logic_vector(11 downto 0);
	signal sig_valid_source : std_logic;

	type adc_ctrl_states is (idle, write, read);
	signal ctrl_state : adc_ctrl_states;

begin
	
	proc_name: process(clk)
	begin
		if reset_n = '0' then 
			sig_read <= '0';
			sig_write <= '0';
			avm_master_address <= (others => '0');
			avm_master_writedata <= (others => '0');
			ctrl_state <= idle;

		elsif rising_edge(clk) then
			case ctrl_state is
				when idle =>
					sig_read <= '0';
					sig_write <= '0';
					avm_master_address <= (others => '0');
					avm_master_writedata <= (others => '0');
					counter_chanel <= 0;
					sig_valid_source <= '0';
					ctrl_state <= write;
			
				when write =>
					avm_master_address <= "001";
					avm_master_writedata <= (others => '1');
					if sig_write = '1' then 
						ctrl_state <= read;
						sig_write <= '0';
					end if;
					if avm_master_waitrequest = '0' then 
						sig_write <= '1';
					end if;


				when read => 
					if avm_master_waitrequest = '0' then 
						if sig_read = '1' then 
							sig_valid_source <= '1';
						end if;
						sig_read <= '1';
						--avm_master_address <= std_logic_vector(to_unsigned(counter_chanel,3));
						avm_master_address <= "000";
						sig_data_source <= avm_master_readdata(11 downto 0);
						if counter_chanel = 2 then 
							counter_chanel <= 0;
						else
							counter_chanel <= counter_chanel + 1;
						end if;
					
					else
						sig_valid_source <= '0';
					end if;
			
			end case;

		end if;
	end process proc_name;
	avm_master_write <= sig_write;
	avm_master_read <= sig_read;
	aso_source_data <= sig_data_source;
	aso_source_valid <= sig_valid_source;
	
end architecture rtl;