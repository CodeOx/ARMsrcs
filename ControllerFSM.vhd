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
         ins24to20 : in STD_LOGIC_VECTOR(4 downto 0);
         ins_type : in STD_LOGIC_VECTOR (1 downto 0);
         ins_subtype : in STD_LOGIC_VECTOR (2 downto 0);
         ins_variant : in STD_LOGIC_VECTOR (1 downto 0);
         skip_ins : in STD_LOGIC;
         state : out STD_LOGIC_VECTOR(4 downto 0));
end ControllerFSM;

architecture Behavioral of ControllerFSM is

    TYPE State_type IS (
        InstructionFetch_PCincrement, --00000
        PCupdate_LoadAB, --00001 
        Branch_IncrementPCby4, --00010
        Branch_updatePC_addOffset, --00011
        Branch_updatePCafterOffset, --00100
        Branch_updateLR, --00101
        DP_shiftOp2_updateRES_flags, --00110
        DP_writeBack, --00111
        MulMla_loadRs, --01000
        MulMla_updateM, --01001
        MulMla_loadRn, --01010
        MulMla_updateRES_flags, --01011
        MulMla_writeBack, --01100
        DT_preIndex_CalcAddress, --01101
        DT_str_loadRd, --01110
        DT_str, --01111
        DT_writeBack, --10000
        DT_loadDR, --10001
        DT_ldr_writeIntoRF, --10010
        DT_postIndex_CalcAddress, --10011
        InstructionFetch_memoryWait, --10100
        InstructionFetch_instructionStore, --10101
        DT_str_memoryWait, --10110
        DT_loadDR_memoryWait1, --10111
        DT_loadDR_memoryWait2, --11000
        Branch_IncrementPCby4_SavePC, --11001
        Idle --11111
        );
    
    signal currentState : State_Type := Idle;    -- Create a signal that uses
        
begin

    with currentState select state <= 
        "00000" when InstructionFetch_PCincrement, --00000
        "00001" when PCupdate_LoadAB, --00001 
        "00010" when Branch_IncrementPCby4, --00010
        "00011" when Branch_updatePC_addOffset, --00011
        "00100" when Branch_updatePCafterOffset, --00100
        "00101" when Branch_updateLR, --00101
        "00110" when DP_shiftOp2_updateRES_flags, --00110
        "00111" when DP_writeBack, --00111
        "01000" when MulMla_loadRs, --01000
        "01001" when MulMla_updateM, --01001
        "01010" when MulMla_loadRn, --01010
        "01011" when MulMla_updateRES_flags, --01011
        "01100" when MulMla_writeBack, --01100
        "01101" when DT_preIndex_CalcAddress, --01101
        "01110" when DT_str_loadRd, --01110
        "01111" when DT_str, --01111
        "10000" when DT_writeBack, --10000
        "10001" when DT_loadDR, --10001
        "10010" when DT_ldr_writeIntoRF, --10010
        "10011" when DT_postIndex_CalcAddress, --10011
        "10100" when InstructionFetch_memoryWait,
        "10101" when InstructionFetch_instructionStore,
        "10110" when DT_str_memoryWait,
        "10111" when DT_loadDR_memoryWait1,
        "11000" when DT_loadDR_memoryWait2,
        "11001" when Branch_IncrementPCby4_SavePC,
        "11111" when Idle; --11111

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
                    currentState <= InstructionFetch_memoryWait;
                    
                when InstructionFetch_memoryWait =>
                    currentState <= InstructionFetch_instructionStore;
                    
                when InstructionFetch_instructionStore =>
                    currentState <= PCupdate_LoadAB;
                    
                when PCupdate_LoadAB =>
                    if skip_ins = '1' then
                        currentState <= InstructionFetch_PCincrement;
                    else
                        
                        if ins_type = "00" then
                            currentState <= DP_shiftOp2_updateRES_flags;
                        elsif (ins_type = "01" and ins24to20(4) = '1') then
                            currentState <= DT_preIndex_CalcAddress;
                        elsif (ins_type = "01" and ins24to20(4) = '0') then
                            currentState <= DT_postIndex_CalcAddress;
                        elsif ins_type = "10" then
                            currentState <= MulMla_LoadRn;
                        elsif ins_type = "11" then
                            currentState <= Branch_IncrementPCby4;
                        else
                            currentState <= InstructionFetch_PCincrement;
                        end if;
                        
                    end if;
                    
                when Branch_IncrementPCby4 =>
                    currentState <= Branch_IncrementPCby4_SavePC; 
                    
                when Branch_IncrementPCby4_SavePC =>
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
                    
                when DP_writeBack =>
                    currentState <= InstructionFetch_PCincrement;                    
                    
                when MulMla_loadRn =>
                    currentState <= MulMla_updateM;
                    
                when MulMla_updateM =>
                    currentState <= MulMla_loadRs;
                    
                when MulMla_loadRs =>
                    currentState <= MulMla_updateRES_flags;
                    
                when MulMla_updateRES_flags =>
                    currentState <= MulMla_writeBack;
                    
                when MulMla_writeBack =>
                    currentState <= InstructionFetch_PCincrement;
                    
                when DT_preIndex_CalcAddress =>
                    if ins_subtype ="101" or ins_subtype = "111" or ins_subtype = "110" then
                        currentState <= DT_str_loadRd;
                    else
                        currentState <= DT_loadDR_memoryWait1;
                    end if;
                    
                when DT_loadDR_memoryWait1 =>
                    currentState <= DT_loadDR_memoryWait2;
                                    
                when DT_loadDR_memoryWait2 => 
                    currentState <= DT_loadDR;
                    
                when DT_loadDR =>
                    currentState <= DT_ldr_writeIntoRF;
                    
                when DT_ldr_writeIntoRF =>
                    if ins24to20(4) = '1' then
                        currentState <= DT_writeBack;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;
                    
                when DT_str_loadRd =>
                    currentState <= DT_str_memoryWait;
                    
                when DT_str_memoryWait =>
                    currentState <= DT_str;
                    
                when DT_str =>
                    if ins24to20(4) = '1' then
                        currentState <= DT_writeBack;
                    else
                        currentState <= InstructionFetch_PCincrement;
                    end if;
                    
                when DT_writeBack =>
                    currentState <= InstructionFetch_PCincrement;
                    
                when DT_postIndex_CalcAddress =>
                    if ins_subtype ="101" or ins_subtype = "111" or ins_subtype = "110" then
                        currentState <= DT_str_loadRd;
                    else
                        currentState <= DT_loadDR;
                    end if; 
                
                when others => currentState <= Idle;               
                
            end case;
        end if;
    end process;

end Behavioral;
