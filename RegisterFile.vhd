library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; 

entity RegisterFile is
    Port ( write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_addressA : in STD_LOGIC_VECTOR (3 downto 0);
           read_addressB : in STD_LOGIC_VECTOR (3 downto 0);
           read_addressC : in STD_LOGIC_VECTOR (3 downto 0);
           write_address : in STD_LOGIC_VECTOR (3 downto 0);
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           read_dataA : out STD_LOGIC_VECTOR (31 downto 0);
           read_dataB : out STD_LOGIC_VECTOR (31 downto 0);
           read_dataC : out STD_LOGIC_VECTOR (31 downto 0);
           pc : out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
subtype	word is std_logic_vector(31 downto 0) ;
type regArray is array (0 to 15) of word;
signal registerfile : regArray := ((others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'));
begin
    read_dataA <= registerfile(to_integer(unsigned(read_addressA)));
    read_dataB <= registerfile(to_integer(unsigned(read_addressB)));
    read_dataC <= registerfile(to_integer(unsigned(read_addressC)));
    pc <= registerfile(15);
    process(clock)
    begin
    if rising_edge(clock) then         
        if write_enable='1' then 
            registerfile(to_integer(unsigned(write_address))) <= write_data;
        end if;
        if reset='1' then
            registerfile(15) <= "00000000000000000000000000000000";
        end if;
        
    end if;
    
    end process;

end Behavioral;
