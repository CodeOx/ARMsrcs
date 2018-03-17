library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity multiplier is
    Port ( input1 : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end multiplier;

architecture Behavioral of multiplier is
signal temp : std_logic_vector(63 downto 0);
begin
temp <= std_logic_vector(unsigned(input1) * unsigned(input2)); 
output <= temp(31 downto 0); 


end Behavioral;
