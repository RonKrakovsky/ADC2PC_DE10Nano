library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divide_uart is
generic(
		f_in : integer := 50000000;
		f_out: integer := 115200
		
);
port(
		i_clk : in std_logic;
		i_reset : in std_logic;
		o_clock : out std_logic
		
);
end entity clock_divide_uart;

architecture rtl of clock_divide_uart is
signal signal_counter : integer;
signal signal_max_counter : integer;
signal signal_clock : std_logic;
begin

	process(i_clk,i_reset)
	begin	
	
		if(i_reset = '0') then 
			signal_max_counter <= ((f_in/f_out)/2)-1;
			signal_counter <= 0;
			signal_clock <= '1';
		else	
			if rising_edge(i_clk) then
				if signal_counter < signal_max_counter then 
					signal_counter <= signal_counter + 1;
				else
					signal_counter <= 0;
					signal_clock <= (not signal_clock);
				end if;
			end if;
		end if;
	end process;
o_clock <= signal_clock;
end architecture rtl;