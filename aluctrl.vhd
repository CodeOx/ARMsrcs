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
        alu_signal<= condition;
    elsif ins_type ="01" then
        if condition(2)='1' then
            alu_signal <= "0100";
        else 
            alu_signal <= "0010";
        end if;
   elsif ins_type="11" then
        alu_signal <= "0100";
   else
        if condition(0)='0' then
            alu_signal <= "1101";
        else
            alu_signal <= "0100";
        end if;
   end if;
         
end process;


end Behavioral;
