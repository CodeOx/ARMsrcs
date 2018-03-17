library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProcessorMemoryPath is
  Port ( processorIn : in STD_LOGIC_VECTOR(31 downto 0); --input from processor
         memoryIn : in STD_LOGIC_VECTOR(31 downto 0); -- input from memory
         mode : in STD_LOGIC_VECTOR(2 downto 0);
         byteOffset : in STD_LOGIC_VECTOR(1 downto 0);
         processorOut : out STD_LOGIC_VECTOR(31 downto 0); --output to processor
         memoryOut : out STD_LOGIC_VECTOR(31 downto 0)); --output to memory
end ProcessorMemoryPath;
--mode : 000 -> ldr
-- 001 -> ldrh
-- 010 -> ldrb
-- 011 -> ldrsh
-- 100 -> ldrsb
-- 101 -> str
-- 110 -> strh
-- 111 -> strb

architecture Behavioral of ProcessorMemoryPath is

begin
    processorOut <= memoryIn when mode = "000" else
                    "0000000000000000" & memoryIn(15 downto 0) when ((mode = "001" or (mode = "011" and memoryIn(15) = '0')) and byteOffset = "00") else
                    "0000000000000000" & memoryIn(31 downto 16) when ((mode = "001" or (mode = "011" and memoryIn(31) = '0')) and byteOffset = "10") else
                    "000000000000000000000000" & memoryIn(7 downto 0) when ((mode = "010" or (mode = "100" and memoryIn(7) = '0')) and byteOffset = "00") else
                    "000000000000000000000000" & memoryIn(15 downto 8) when ((mode = "010" or (mode = "100" and memoryIn(15) = '0')) and byteOffset = "01") else
                    "000000000000000000000000" & memoryIn(23 downto 16) when ((mode = "010" or (mode = "100" and memoryIn(23) = '0')) and byteOffset = "10") else
                    "000000000000000000000000" & memoryIn(31 downto 24) when ((mode = "010" or (mode = "100" and memoryIn(31) = '0')) and byteOffset = "11") else
                    "1111111111111111" & memoryIn(15 downto 0) when ((mode = "011" and memoryIn(15) = '1') and byteOffset = "00") else
                    "1111111111111111" & memoryIn(31 downto 16) when ((mode = "011" and memoryIn(31) = '1') and byteOffset = "10") else
                    "111111111111111111111111" & memoryIn(7 downto 0) when ((mode = "100" and memoryIn(7) = '1') and byteOffset = "00") else 
                    "111111111111111111111111" & memoryIn(15 downto 8) when ((mode = "100" and memoryIn(15) = '1') and byteOffset = "01") else
                    "111111111111111111111111" & memoryIn(23 downto 16) when ((mode = "100" and memoryIn(23) = '1') and byteOffset = "10") else
                    "111111111111111111111111" & memoryIn(31 downto 24) when ((mode = "100" and memoryIn(31) = '1') and byteOffset = "11") else                
                    "00000000000000000000000000000000";
                    
    memoryOut <= processorIn when mode = "101" else
                 "0000000000000000" & processorIn(15 downto 0) when (mode = "110" and byteOffset = "00") else
                 processorIn(15 downto 0) & "0000000000000000" when (mode = "110" and byteOffset = "10") else
                 "000000000000000000000000" & processorIn(7 downto 0) when (mode = "111" and byteOffset = "00") else
                 "0000000000000000" & processorIn(15 downto 8) & "00000000" when (mode = "111" and byteOffset = "01") else
                 "00000000" & processorIn(23 downto 16) & "0000000000000000" when (mode = "111" and byteOffset = "10") else
                 processorIn(31 downto 24) & "000000000000000000000000" when (mode = "111" and byteOffset = "11") else
                 "00000000000000000000000000000000";                             
                                
end Behavioral;
