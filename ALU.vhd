----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2018 02:36:17 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
          operand2 : in STD_LOGIC_VECTOR (31 downto 0);
          mode : in STD_LOGIC_VECTOR (3 downto 0);
          carry : in STD_LOGIC;
          output : out STD_LOGIC_VECTOR (31 downto 0);
          flagZ : out STD_LOGIC;
          flagN : out STD_LOGIC;
          flagV : out STD_LOGIC;
          flagC : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal temp_output : STD_LOGIC_VECTOR(31 downto 0);
    signal temp_or : STD_LOGIC_VECTOR(31 downto 0);
    signal carry_32bit : STD_LOGIC_VECTOR(31 downto 0);
    signal c31 : STD_LOGIC;
    signal c32 : STD_LOGIC;
begin
    carry_32bit <= "0000000000000000000000000000000" & carry;
    with mode select temp_output <=
        (operand1 and operand2) when "0000",
        (operand1 xor operand2) when "0001",
        std_logic_vector(unsigned(operand1) - unsigned(operand2)) when "0010",
        std_logic_vector(unsigned(operand2) - unsigned(operand1)) when "0011",
        std_logic_vector(unsigned(operand1) + unsigned(operand2)) when "0100",
        std_logic_vector(unsigned(operand1) + unsigned(operand2) + unsigned(carry_32bit)) when "0101",
        std_logic_vector(unsigned(operand1) + unsigned(not operand2) + unsigned(carry_32bit)) when "0110",
        std_logic_vector(unsigned(not operand1) + unsigned(operand2) + unsigned(carry_32bit)) when "0111",
        (operand1 and operand2) when "1000",        
        (operand1 xor operand2) when "1001",
        std_logic_vector(unsigned(operand1) - unsigned(operand2)) when "1010",
        std_logic_vector(unsigned(operand1) + unsigned(operand2)) when "1011",
        (operand1 or operand2) when "1100",
        operand2 when "1101",
        (operand1 and (not(operand2))) when "1110",
        (not operand2) when "1111";
        
        
    c31 <= operand1(31) xor operand2(31) xor temp_output(31);
    c32 <= (operand1(31) and operand2(31)) or (operand2(31) and temp_output(31)) or (temp_output(31) and operand1(31)); 
    output <= temp_output;
    
    --for or of all bits in output
    temp_or(0) <= temp_output(0);
    gen: for i in 1 to 31 generate
        temp_or(i) <= temp_or(i-1) or temp_output(i);
    end generate;
    --end
    
    flagZ <= not (temp_or (31));
    flagN <= temp_output(31);
    flagV <= c31 xor c32;
    flagC <= c32;

end Behavioral;
