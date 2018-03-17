library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reverser is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           reverse : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end reverser;

architecture Behavioral of reverser is
    signal temp: std_logic_vector (31 downto 0);
begin

    gen: for i in 0 to 31 generate
      output(i) <= input(i) when reverse='0' else input(31-i);
    end generate;


end Behavioral;
