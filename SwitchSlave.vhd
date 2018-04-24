library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SwitchSlave is
   Port(Hsel : in STD_LOGIC;
        Haddress : in STD_LOGIC_VECTOR(15 downto 0);
        HWrite : in STD_LOGIC;
        HReady : out STD_LOGIC;
        HTrans : in STD_LOGIC_VECTOR(1 downto 0);        
        HReset : in STD_LOGIC;
        HClock : in STD_LOGIC;
        HRData : out STD_LOGIC_VECTOR(31 downto 0);
        Switches : in STD_LOGIC_VECTOR(15 downto 0));
end SwitchSlave;

architecture Behavioral of SwitchSlave is

    Type State is (
        IDLE,
        EXECUTE
    );
begin

    process(HClock,HReset)
    begin
        if HReset = '1' then 
            --curr_state<=IDLE;
            HReady <= '0';
        elsif rising_edge(HClock) then
            --case curr_state is
            --when IDLE =>
                if HTrans = "10" and HSel ='1' and HWrite = '0' then
                --    curr_state <= EXECUTE;
                    HRData <= "0000000000000000" & Switches;
                    HReady <= '1';                    
                end if;
            --when EXECUTE =>
              --  curr_state <= IDLE;
        end if;

    end process;
end Behavioral;