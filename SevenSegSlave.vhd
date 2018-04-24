library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegSlave is
   Port(Hsel : in STD_LOGIC;
        Haddress : in STD_LOGIC_VECTOR(15 downto 0);
        HWrite : in STD_LOGIC;
        HReady : out STD_LOGIC;
        HTrans : in STD_LOGIC_VECTOR(1 downto 0);        
        HReset : in STD_LOGIC;
        HClock : in STD_LOGIC;
        HWData : in STD_LOGIC_VECTOR(31 downto 0);
        SevenSegData : out STD_LOGIC_VECTOR(15 downto 0));
end SevenSegSlave;

architecture Behavioral of SevenSegSlave is

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
                if HTrans = "10" and HSel ='1' and HWrite = '1' then
                --    curr_state <= EXECUTE;
                    SevenSegData <= HWData(15 downto 0);
                end if;
            --when EXECUTE =>
              --  curr_state <= IDLE;
        end if;

    end process;
end Behavioral;