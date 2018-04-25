library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instructiondecoder is
    Port ( ins : in STD_LOGIC_VECTOR (31 downto 0);
           ins_type : out STD_LOGIC_VECTOR (1 downto 0);
           ins_subtype : out STD_LOGIC_VECTOR (2 downto 0);
           ins_variant : out STD_LOGIC_VECTOR (1 downto 0);
           undefined_encoding: out STD_LOGIC);
end instructiondecoder;
-- 00 DP
--      000 test/cmp
--      001 arith/logical
-- variants
--      00 imm
--      01 imm specified shift
--      10 reg specified shift

-- 01 DT
--      000 -> ldr
--      001 -> ldrh
--      010 -> ldrb
--      011 -> ldrsh
--      100 -> ldrsb
--      101 -> str
--      110 -> strh
--      111 -> strb
-- variants
--      00 reg specified offset
--      01 imm specified offset

-- 10 MUL/MLA
--      000 mul
--      001 mla

-- 11 B/BL
--      000 b
--      001 bl

architecture Behavioral of instructiondecoder is

begin
process (ins)
begin
    if ins(27 downto 26)="00" then
        if ins(25) = '1'then
            ins_type <= "00";
            ins_variant <="00";
            if ins(24 downto 23)="10" then
                ins_subtype<="000";
            else
                ins_subtype <="001";
            end if;
        
        
        else
        if ins(7 downto 4)="1001" then
            ins_type<= "10";
            undefined_encoding <= ins(23) or ins(24);
            ins_subtype <= "00" & ins(21);
        elsif ins(7)='1' and ins(4)='1' and ins(6 downto 5) /= "00" then
            ins_type<= "01";
            if ins(20)='1' then
                if ins(6 downto 5) = "01" then 
                    ins_subtype <="001";
                elsif ins(6 downto 5) = "10" then
                    ins_subtype <= "100";
                else 
                    ins_subtype <= "011";
                end if;
           else 
               ins_subtype <= "110";
           end if;
           ins_variant <= '0' & ins(22);
           undefined_encoding <= ins(5)and ins(6);
           
        else  
            ins_type <= "00";
            if ins(25)='1' then
                ins_variant <="00";
            elsif ins(4) <= '0' then
                ins_variant <="01";
            else
                ins_variant <="10";
            end if;
     
            if ins(11 downto 8)="1111" then
                undefined_encoding <= '1';
            else
                undefined_encoding <= '0';
            end if;  
            
            if ins(24 downto 23)="10" then
                ins_subtype<="000";
            else
                ins_subtype <="001";
            end if;
            
        end if;
        end if;
        
    elsif ins(27 downto 26)="01" then
        ins_type<="01";
        if ins(20)='1' then
            if ins(22)='0' then
                ins_subtype <= "000";
            else
                ins_subtype <= "010";
            end if;
         else
            if ins(22)='0' then
                 ins_subtype <= "101";
             else
                 ins_subtype <= "111";
             end if;
         end if;
         ins_variant <= '0' & ins(25);
         undefined_encoding <= ins(25) and ins(4);
            
    elsif ins(27 downto 26)="10" then
        if ins(25)='0' then
            undefined_encoding <= '1';
        else 
            ins_type <= "11";
            ins_subtype <="00" & ins (24);
            undefined_encoding <= '0';
        end if;
    else 
        undefined_encoding <= '1';
    end if;
end process;
end Behavioral;
