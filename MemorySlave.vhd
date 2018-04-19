
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemorySlave is
   Port(Hsel : in STD_LOGIC;
        Haddress : in STD_LOGIC_VECTOR(15 downto 0);
        HWData : in STD_LOGIC_VECTOR(31 downto 0);
        HWrite : in STD_LOGIC;
        HSize : in STD_LOGIC_VECTOR(2 downto 0);
        HTrans : in STD_LOGIC_VECTOR(1 downto 0);
        HReset : in STD_LOGIC;
        HClock : in STD_LOGIC;
        HReady : out STD_LOGIC;
        HRData : out STD_LOGIC_VECTOR(31 downto 0));
end MemorySlave;

architecture Behavioral of MemorySlave is
    component data_memory_wrapper
    Port (
        addra : in STD_LOGIC_VECTOR(31 downto 0) ;
        clka : in STD_LOGIC;
        dina : in STD_LOGIC_VECTOR(31 downto 0);
        douta : out STD_LOGIC_VECTOR(31 downto 0);
        ena : in STD_LOGIC;
        rsta : in STD_LOGIC;
        wea : in STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    Type State is (
        IDLE,
        WAIT1,
        WAIT2,
        EXECUTE
    );
    signal mem_address : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_write_enable : STD_LOGIC_VECTOR(3 downto 0);
    signal mem_data :  STD_LOGIC_VECTOR(31 downto 0);
    signal curr_state : State:=IDLE;
begin

    memory: data_memory_wrapper
        Port Map(  
            addra => mem_address,
            clka => HClock,
            dina => HWData,
            douta => mem_data,
            ena => '1',
            rsta => HReset,
            wea => mem_write_enable
            );
            
    
    process(HClock,HReset)
        begin
        if HReset = '1' then 
            curr_state<=IDLE;
        elsif rising_edge(HClock) then
            case curr_state is
            when IDLE =>
                if HTrans = "10" and HSel ='1' then
                    curr_state <= WAIT1;
                    mem_address <= "0000000000000000" & Haddress;
                    HReady<='0';
                    mem_write_enable <= HWrite & HWrite & HWrite & HWrite;
                else
                    HReady <= '1';
                end if;
            when WAIT1 =>
                    curr_state <= WAIT2;
            when WAIT2 =>
                    curr_state <= EXECUTE;
            when EXECUTE =>
                    curr_state <= IDLE;
                    HReady <= '1';
                    HRData <= mem_data;
                    mem_write_enable <= "0000";
            when others => curr_state <= IDLE;
            end case;
            
        end if;
    end process;
         
end Behavioral;
