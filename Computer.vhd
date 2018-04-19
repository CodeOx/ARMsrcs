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
         debug_controls : in STD_LOGIC_VECTOR(3 downto 0);
         debug_out : out STD_LOGIC_VECTOR(15 downto 0) );
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

    signal HReadyToProcessor : STD_LOGIC;
    signal HReadyFromMemory : STD_LOGIC;
    signal dataToProcessor : STD_LOGIC_VECTOR(31 downto 0);
    signal dataFromProcessor : STD_LOGIC_VECTOR(31 downto 0);
    signal HWrite : STD_LOGIC;
    signal Haddr : STD_LOGIC_VECTOR(15 downto 0);
    signal HSize : STD_LOGIC_VECTOR(2 downto 0);
    signal HTrans : STD_LOGIC_VECTOR(1 downto 0);
    signal dataFromMemory : STD_LOGIC_VECTOR(31 downto 0);
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);

begin

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
     Port Map(Hsel => '1',
          Haddress => Haddr,
          HWData => dataFromProcessor,
          HWrite => HWrite,
          HSize => HSize,
          HTrans => HTrans,
          HReset => reset,
          HClock => clk,
          HReady => HReadyFromMemory,
          HRData => dataFromMemory);

    HReadyToProcessor <= HReadyFromMemory;
    dataToProcessor <= dataFromMemory;    

end Behavioral;
