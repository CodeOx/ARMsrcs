----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2018 11:40:19
-- Design Name: 
-- Module Name: Computer - Behavioral
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

entity Computer is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         start : in STD_LOGIC;
         switches : in STD_LOGIC_VECTOR(15 downto 0);
         LEDout : out STD_LOGIC_VECTOR(15 downto 0);
         anodeOut : out STD_LOGIC_VECTOR (3 downto 0);
         cathodeOut : out STD_LOGIC_VECTOR (6 downto 0));
         --debug_controls : in STD_LOGIC_VECTOR(3 downto 0);
         --debug_out : out STD_LOGIC_VECTOR(15 downto 0) );
end Computer;

architecture Behavioral of Computer is

    component processor
      Port( clk: in STD_LOGIC;
            reset: in STD_LOGIC;
            start: in STD_LOGIC;
            
            Hready : in STD_LOGIC; --
            HRdata : in STD_LOGIC_VECTOR(31 downto 0); --
            
            Hwrite : out STD_LOGIC; --
            Haddr : out STD_LOGIC_VECTOR(15 downto 0); --
            Hsize : out STD_LOGIC_VECTOR(2 downto 0); --
            Htrans : out STD_LOGIC_VECTOR(1 downto 0); --
            HWdata : out STD_LOGIC_VECTOR(31 downto 0); --
            
            debug_controls : in STD_LOGIC_VECTOR(3 downto 0);
            debug_out : out STD_LOGIC_VECTOR(15 downto 0);
            ins_out : out STD_LOGIC_VECTOR(31 downto 0));
            --state : out STD_LOGIC_VECTOR(4 downto 0) );
    end component;

    component MemorySlave
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
    end component;
    
    component SwitchSlave is
       Port(Hsel : in STD_LOGIC;
            Haddress : in STD_LOGIC_VECTOR(15 downto 0);
            HWrite : in STD_LOGIC;
            HReady : out STD_LOGIC;
            HTrans : in STD_LOGIC_VECTOR(1 downto 0);        
            HReset : in STD_LOGIC;
            HClock : in STD_LOGIC;
            HRData : out STD_LOGIC_VECTOR(31 downto 0);
            Switches : in STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    component LEDSlave is
       Port(Hsel : in STD_LOGIC;
            Haddress : in STD_LOGIC_VECTOR(15 downto 0);
            HWrite : in STD_LOGIC;
            HReady : out STD_LOGIC;
            HTrans : in STD_LOGIC_VECTOR(1 downto 0);        
            HReset : in STD_LOGIC;
            HClock : in STD_LOGIC;
            HWData : in STD_LOGIC_VECTOR(31 downto 0);
            LED : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    component SevenSegSlave is
       Port(Hsel : in STD_LOGIC;
            Haddress : in STD_LOGIC_VECTOR(15 downto 0);
            HWrite : in STD_LOGIC;
            HReady : out STD_LOGIC;
            HTrans : in STD_LOGIC_VECTOR(1 downto 0);        
            HReset : in STD_LOGIC;
            HClock : in STD_LOGIC;
            HWData : in STD_LOGIC_VECTOR(31 downto 0);
            anode : out STD_LOGIC_VECTOR (3 downto 0);
            cathode : out STD_LOGIC_VECTOR (6 downto 0));
    end component;


    signal HReadyToProcessor : STD_LOGIC;
    signal HReadyFromMemory : STD_LOGIC;
    signal HReadyFromSwitch : STD_LOGIC;
    signal HReadyFromLED : STD_LOGIC;
    signal HReadyFromSevenSeg : STD_LOGIC;
    
    signal dataToProcessor : STD_LOGIC_VECTOR(31 downto 0);
    signal dataFromProcessor : STD_LOGIC_VECTOR(31 downto 0);
    signal HWrite : STD_LOGIC;
    signal Haddr : STD_LOGIC_VECTOR(15 downto 0);
    signal HSize : STD_LOGIC_VECTOR(2 downto 0);
    signal HTrans : STD_LOGIC_VECTOR(1 downto 0);
    
    signal dataFromMemory : STD_LOGIC_VECTOR(31 downto 0);
    signal dataFromSwitch : STD_LOGIC_VECTOR(31 downto 0);

    signal instruction : STD_LOGIC_VECTOR(31 downto 0);
    
    signal HselMemory : STD_LOGIC;
    signal HselSwitch : STD_LOGIC;
    signal HselLED : STD_LOGIC;
    signal HselSevenSeg : STD_LOGIC;
    
    signal selectSlave : STD_LOGIC_VECTOR(2 downto 0); --000 : memory, 001 -> Switch, 010 -> LED, 011 -> 7seg

    signal debug_controls : STD_LOGIC_VECTOR(3 downto 0);
    signal debug_out : STD_LOGIC_VECTOR(15 downto 0);

begin

    selectSlave <= "001" when Haddr = "0000111111111100" else
                   "010" when Haddr = "0000111111111101" else
                   "011" when Haddr = "0000111111111110" or Haddr = "0000111111111111" else
                   "000";
    
    HReadyToProcessor <= HReadyFromSwitch when selectSlave = "001" else
                         HReadyFromLED when selectSlave = "010" else
                         HReadyFromSevenSeg when selectSlave = "011"
                         else HReadyFromMemory;
    
    dataToProcessor <= dataFromSwitch when selectSlave = "001" else dataFromMemory; 

    HselMemory <= '1' when selectSlave = "000" else '0';
    HselSwitch <= '1' when selectSlave = "001" else '0';
    HselLED <= '1' when selectSlave = "010" else '0';
    HselSevenSeg <= '1' when selectSlave = "011" else '0';


    main_processor : processor
      Port Map(   clk => clk,
                  reset => reset,
                  start => start,
                  
                  Hready => HReadyToProcessor,
                  HRdata => dataToProcessor,
                  
                  Hwrite => HWrite,
                  Haddr => Haddr,
                  Hsize => HSize,
                  Htrans => HTrans,
                  HWdata => dataFromProcessor,
                  
                  debug_controls => debug_controls,
                  debug_out => debug_out,
                  ins_out => instruction);
                  
    memory : MemorySlave
     Port Map(Hsel => HselMemory,
          Haddress => Haddr,
          HWData => dataFromProcessor,
          HWrite => HWrite,
          HSize => HSize,
          HTrans => HTrans,
          HReset => reset,
          HClock => clk,
          HReady => HReadyFromMemory,
          HRData => dataFromMemory);
    
    switch : SwitchSlave
    Port Map(Hsel => HselSwitch,
          Haddress => Haddr,
          HWrite => HWrite,
          HReady => HReadyFromSwitch,
          HTrans => HTrans,        
          HReset => reset,
          HClock => clk,
          HRData => dataFromSwitch,
          Switches => switches);
          
    LED : LEDSlave
     Port Map(Hsel => HselLED,
          Haddress => Haddr,
          HWrite => HWrite,
          HReady => HReadyFromLED,
          HTrans => HTrans,        
          HReset => reset,
          HClock => clk,
          HWData => dataFromProcessor,
          LED => LEDout);
          
    sevenSeg : SevenSegSlave
     Port Map(Hsel => HselSevenSeg,
          Haddress => Haddr,
          HWrite => HWrite,
          HReady => HReadyFromSevenSeg,
          HTrans => HTrans,        
          HReset => reset,
          HClock => clk,
          HWData => dataFromProcessor,
          anode => anodeOut,
          cathode => cathodeOut);
   

end Behavioral;
