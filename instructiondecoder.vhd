library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instructiondecoder is
    Port ( instruction : in STD_LOGIC_VECTOR (31 downto 0);
           ins_type : out STD_LOGIC_VECTOR (1 downto 0);
           ins_subtype : out STD_LOGIC_VECTOR (4 downto 0);
           ins_variant : out STD_LOGIC_VECTOR (1 downto 0));
end instructiondecoder;

architecture Behavioral of instructiondecoder is

begin


end Behavioral;
