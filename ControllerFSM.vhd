----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2018 23:51:17
-- Design Name: 
-- Module Name: ControllerFSM - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControllerFSM is
  Port ( clk : in  STD_LOGIC;
         ins : in STD_LOGIC_VECTOR(31 downto 0);
         state : out STD_LOGIC_VECTOR(3 downto 0));
end ControllerFSM;

architecture Behavioral of ControllerFSM is

    TYPE State_type IS (
        InstructionFetch_PCincrement, --0000
        PCupdate_LoadAB, --0001 
        Branch_IncrementPCby4, --0010
        Branch_updatePC_addOffset, --0011
        Branch_updatePCafterOffset, --0100
        Branch_updateLR, --0101
        D);  -- Define the states
    
    signal currentState : State_Type;    -- Create a signal that uses

begin

    process(clk)
    begin
        if rising_edge(clk) then
            case currentState is
                
                when  InstructionFetch_PCincrement => 
                    currentState <= PCupdate_LoadAB;
                    
                when PCupdate_LoadAB =>
                    if ins(27 downto 26) = "10" then
                        if ins(25) = '1' then
                            currentState <= Branch_IncrementPCby4;
                        else
                            currentState <= InstructionFetch_PCincrement;
                        end if;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;
                    
                when Branch_IncrementPCby4 => 
                    currentState <= Branch_updatePC_addOffset;
                    
                when Branch_updatePC_addOffset => 
                    currentState <= Branch_updatePCafterOffset;
                    
                when Branch_updatePCafterOffset => 
                    if ins(24) = '1' then
                        currentState <= Branch_updateLR;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;
                    
                
                
            end case;
        end if;
    end process;

end Behavioral;
