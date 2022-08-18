LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


entity div_clk is
port (clk1 : in std_logic;
       clk : out std_logic
     );
end div_clk;

architecture Behavioral of div_clk is

signal count : integer :=0;
signal b : std_logic :='0';
begin

process(clk1) 
begin
if(rising_edge(clk1)) then
count <=count+1;
if(count = 50-1) then --3.125M
b <= not b;
count <=0;

end if;
end if;
clk<=b;
end process;
end;