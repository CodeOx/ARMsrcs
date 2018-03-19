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
         reset : in STD_LOGIC;
         start : in STD_LOGIC;
         ins_type : in STD_LOGIC_VECTOR (1 downto 0);
         ins_subtype : in STD_LOGIC_VECTOR (2 downto 0);
         ins_variant : in STD_LOGIC_VECTOR (1 downto 0);
         skip_ins : in STD_LOGIC;
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
        DP_shiftOp2_updateRES_flags, --0110
        DP_writeBack, --0111
        MulMla_loadRs, --1000
        MulMla_updateM, --1001
        MulMla_loadRn, --1010
        MulMla_updateRES_flags, --1011
        MulMla_writeBack, --1100
        Idle --1111
        );
    
    signal currentState : State_Type := Idle;    -- Create a signal that uses

begin

    process(clk,reset)
    begin
        if reset = '1' then 
            currentState <= Idle;                
        elsif rising_edge(clk) then
            
            case currentState is
            
                when Idle =>
                    if start = '1' then
                        currentState <= InstructionFetch_PCincrement;
                    else 
                        currentState <= Idle;
                    end if;
                
                when  InstructionFetch_PCincrement => 
                    currentState <= PCupdate_LoadAB;
                    
                when PCupdate_LoadAB =>
                    if skip_ins = '1' then
                        currentState <= InstructionFetch_PCincrement;
                    else
                        
                        if ins_type = "00" then
                            currentState <= DP_shiftOp2_updateRES_flags;
                        elsif ins_type = "10" then
                            currentState <= MulMla_LoadRs;
                        elsif ins_type = "11" then
                            currentState <= Branch_IncrementPCby4;
                        else
                            currentState <= InstructionFetch_PCincrement;
                        end if;
                        
                    end if;
                    
                when Branch_IncrementPCby4 => 
                    currentState <= Branch_updatePC_addOffset;
                    
                when Branch_updatePC_addOffset => 
                    currentState <= Branch_updatePCafterOffset;
                    
                when Branch_updatePCafterOffset => 
                    if ins_subtype = "001" then
                        currentState <= Branch_updateLR;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;
                    
                when Branch_updateLR =>
                    currentState <= InstructionFetch_PCincrement; 
                    
                when DP_shiftOp2_updateRES_flags => 
                    if ins_subtype = "001" then
                        currentState <= DP_writeBack;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;   
                    
                when MulMla_loadRs =>
                    currentState <= MulMla_updateM;
                    
                when MulMla_updateM =>
                    currentState <= MulMla_loadRn;
                    
                when MulMla_loadRn =>
                    currentState <= MulMla_updateRES_flags;
                    
                when MulMla_updateRES_flags =>
                    currentState <= MulMla_writeBack;
                    
                when MulMla_writeBack =>
                    currentState <= InstructionFetch_PCincrement;
                    
                when others => currentState <= Idle;               
                
            end case;
        end if;
    end process;

end Behavioral;
