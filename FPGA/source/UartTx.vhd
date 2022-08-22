--this entity is the UART transmitter.
--Parallel Input Serial Output.	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UartTx is
  generic (
	bit_data  : integer := 8;
	Stop_bit  : integer := 2
   );
  port (
   i_Clk,i_reset,i_start      : in  std_logic;
   i_data      					: in  std_logic_vector((bit_data-1) downto 0);
   o_active,o_Serial    		: out std_logic
   );
end UartTx;

architecture RTL of UartTx is
	type stage is (s_Idle, s_Start_Bit, s_Data_Bits, s_Stop_Bit);
	signal stage_main : stage;
	signal Bit_Index  : integer range 0 to (bit_data-1);
   signal Data       : std_logic_vector((bit_data-1) downto 0);
	signal counter    : integer range 0 to (Stop_bit-1);
  
begin 

	process (i_Clk)
	begin
		if(i_reset = '0') then
			stage_main <= s_Idle;
		elsif rising_edge(i_Clk) then
			case stage_main is
-------------------------------------------- Idle stage

				when s_Idle =>
					Bit_Index <= 0;
					counter <= 0;
					if i_start = '1' then
						Data <= i_data;
						stage_main <= s_Start_Bit;
					end if;
					
-------------------------------------------- Start Bit stage

				when s_Start_Bit =>  stage_main <= s_Data_Bits;
	
-------------------------------------------- Data Bits stage	
 
				when s_Data_Bits =>	
					-- Check if we have sent out all bits
					if Bit_Index < bit_data-1 then
						Bit_Index <= Bit_Index + 1;
					else
						Bit_Index <= 0;
						stage_main <= s_Stop_Bit;
					end if;					
	
-------------------------------------------- Stop Bit stage	 	

				when s_Stop_Bit =>
					if counter < Stop_bit -1 then
						counter <= counter + 1;
					else
						stage_main   <= s_Idle;
					end if;

-------------------------------------------- others					 
				when others =>
					 stage_main <= s_Idle;
					 
			end case;
		end if;
   end process;
	
	o_Serial <= '0' when stage_main = s_Start_Bit else
					Data(Bit_Index) when stage_main = s_Data_Bits else
					'1';
	
	o_active <= '0' when stage_main = s_Idle else
					'1';

end RTL;