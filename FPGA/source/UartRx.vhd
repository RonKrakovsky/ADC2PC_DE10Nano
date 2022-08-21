--Ron Krakovsky
--24/01/2021
--this entity is the UART transmitter.
--Parallel Input Serial Output.
-----------------------------------------------------------------
--entity pin discription :
--	inputs 	:
--					i_clk				  - input clock signal.
--					i_start			  - input start transmit information,active high.
--					i_reset			  - input reset, active high.
-- 				i_data			  - input Parallel data.

--	outputs	:
-- 				o_active			  - output that represent the activity uart, if UART transmit the data
--											 ,output "o_active" is high.
-- 				o_Serial         - output serial data.
-----------------------------------------------------------------
--entity generics discription :
--					clock 			  - clock that use UART.
-- 				baud_UART        - bits per second.
-- 				bit_data         - The width of the bits information in each frame.	
-- 				Stop_bit         - How many stop bits.	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UartRx is
  generic (
	bit_data  : integer := 8;
	Stop_bit  : integer := 2
   );
  port (
   i_Clk,i_reset    : in  std_logic;
   i_serial      	: in  std_logic;
   o_data    		: out std_logic_vector((bit_data-1) downto 0);
   o_valid			: out std_logic
   );
end UartRx;

architecture RTL of UartRx is
	type stage is (s_Idle, s_Data_Bits, s_Stop_Bit);
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
					o_data <= (others=>'0');
					if i_serial = '0' then
						stage_main <= s_Data_Bits;
					end if;
					
	
-------------------------------------------- Data Bits stage	
 
				when s_Data_Bits =>	
					Data(Bit_Index) <= i_serial;
					
					if Bit_Index < bit_data-1 then
						Bit_Index <= Bit_Index + 1;
					else
						Bit_Index <= 0;
						stage_main <= s_Stop_Bit;
					end if;					
	
-------------------------------------------- Stop Bit stage	 	

				when s_Stop_Bit =>
					o_data <= data;
					o_valid <= '1';
					if counter < Stop_bit -1 then
						counter <= counter + 1;
					else
						stage_main <= s_Idle;
						o_valid <= '0';
					end if;

-------------------------------------------- others					 
				when others =>
					 stage_main <= s_Idle;
					 
			end case;
		end if;
   end process;
	
end RTL;