library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Uart_manager is
	port (
		clk : in std_logic;
		reset_n : in std_logic;

		i_channel_0 : in std_logic_vector(11 downto 0);
		i_channel_1 : in std_logic_vector(11 downto 0);
		i_channel_2 : in std_logic_vector(11 downto 0);

		o_data2uart : out std_logic_vector(7 downto 0);
		o_valid_start : out std_logic;
		i_valid_tx : in std_logic
	);
end entity Uart_manager;

architecture rtl of Uart_manager is
	signal channel : integer range 10 downto 0;
begin
	
	proc_name: process(clk)
	begin
		if reset_n = '0' then 
			o_valid_start <= '0';
			o_data2uart <= (others => '0');
		elsif rising_edge(clk) then

			if channel < 2 then 
				if channel = 0 then 
					o_data2uart <= "0000" & i_channel_0(11 downto 8);
				else
					o_data2uart <= i_channel_0(7 downto 0);
				end if;
				
			elsif channel < 4 then 
				if channel = 2 then 
					o_data2uart <= "0001" & i_channel_1(11 downto 8);
				else
					o_data2uart <= i_channel_1(7 downto 0);
				end if;
			else
				if channel = 4 then 
					o_data2uart <= "0010" & i_channel_2(11 downto 8);
				else
					o_data2uart <= i_channel_2(7 downto 0);
				end if;
			end if;

			if i_valid_tx = '0' then 
				o_valid_start <= '1';
				if channel = 5 then 
					channel <= 0;
				else
					channel <= channel + 1;
				end if;
				
			end if;
			
		end if;
	end process proc_name;
	
end architecture rtl;