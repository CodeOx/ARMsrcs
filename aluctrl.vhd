library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aluctrl is
  Port (condition : in STD_LOGIC_VECTOR(3 downto 0); --instruction bits (24 downto 21);
        ins_type : in STD_LOGIC_VECTOR(1 downto 0); --from instruction decoder 
        alu_signal : out STD_LOGIC_VECTOR (3 downto 0)
         );
end aluctrl;

--ins type
-- 00 DP
-- 01 DT
-- 10 MUL/MLA
-- 11 B/BL

architecture Behavioral of aluctrl is

begin

process (condition,ins_type)
begin
    if ins_type = "00" then
        case condition is 
            when "0000" => alu_signal <= "0000";
        end case;
end process;


end Behavioral;
