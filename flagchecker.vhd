library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flagchecker is
Port (  N : in STD_LOGIC;
        Z : in STD_LOGIC;
        C : in STD_LOGIC;
        V : in STD_LOGIC;
        condition : in STD_LOGIC_VECTOR(3 downto 0);
        result : out STD_LOGIC;
        undefined : out STD_LOGIC
     );
end flagchecker;

architecture Behavioral of flagchecker is

begin
with condition select 
result <=  Z when "0000",
           not(Z) when "0001",
           C when "0010",
           not(C) when "0011",
           N when "0100",
           not(N) when "0101",
           V when "0110",
           not(V) when "0111",
           C and not(Z) when "1000",
           not(C) and Z when "1001",
           N xnor V when "1010",
           N xor V when "1011",
           not(Z) and (N xnor V) when "1100",
           Z or (N xor V) when "1101",
           '1' when others;
undefined <= condition(0) and condition(1) and condition(2) and condition(3);                   

end Behavioral;
