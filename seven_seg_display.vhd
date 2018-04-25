----------------------------------------------------------------------------------
-- Engineer: Deepanshu Jindal
-- Create Date: 21.10.2017 19:18:08
-- Module Name: seven_seg_display - Behavioral
-- Project Name: CRC Computer
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_seg_display is
    Port ( clk : in STD_LOGIC;
           b : in STD_LOGIC_VECTOR(15 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           cathode : out STD_LOGIC_VECTOR (6 downto 0));
end seven_seg_display;

architecture Behavioral of seven_seg_display is
    signal redclock: STD_LOGIC;
    signal count: STD_LOGIC_VECTOR(26 downto 0):=(others=>'0');
    signal anodecount: integer range 0 to 3;
    signal disp: STD_LOGIC_VECTOR(3 downto 0);
    begin
    
    process (clk)
    begin
        if (rising_edge(clk)) then
            count<=count+1;
        end if;
    end process;
    redclock<=count(19); 
    
    process(redclock)
    begin
        if (redclock='1' and redclock'event) then
            anodecount<=anodecount+1;
            if anodecount=3 then
                anodecount<=0;
            end if;
        end if;
    end process;
    
   with anodecount select
              disp<=b(3 downto 0) when 0,
                    b(7 downto 4) when 1,
                    b(11 downto 8)when 2,
                    b(15 downto 12)when others;
                    
     with anodecount select
             anode<="1110" when 0,
                   "1101" when 1,
                   "1011" when 2,
                   "0111" when others;                    
    
   process(disp)
   begin
        case disp is
               when "0000"=> cathode <="1000000";  -- '0'
               when "0001"=> cathode <="1111001";  -- '1'
               when "0010"=> cathode <="0100100";  -- '2'
               when "0011"=> cathode <="0110000";  -- '3'
               when "0100"=> cathode <="0011001";  -- '4' 
               when "0101"=> cathode <="0010010";  -- '5'
               when "0110"=> cathode <="0000010";  -- '6'
               when "0111"=> cathode <="1111000";  -- '7'
               when "1000"=> cathode <="0000000";  -- '8'
               when "1001"=> cathode <="0010000";  -- '9' 
               when "1010"=> cathode <="0001000"; 
               when "1011"=> cathode <="0000011"; 
               when "1100"=> cathode <="1000110"; 
               when "1101"=> cathode <="0100001"; 
               when "1110"=> cathode <="0000110"; 
               when others=> cathode <="0001110";
              
         end case;
   end process;   

end Behavioral;
