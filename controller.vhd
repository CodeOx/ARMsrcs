library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
  Port(reset : in STD_LOGIC;
      clk : in STD_LOGIC;
      --control signals :
      carry : out STD_LOGIC;
      memoryReadEnable : out STD_LOGIC;
      memoryWriteEnable : out STD_LOGIC;
      memoryAddressSelect : out STD_LOGIC;
      IRenable : out STD_LOGIC;
      DRenable : out STD_LOGIC;
      RESenable : out STD_LOGIC;
      RFenable : out STD_LOGIC;
      Aenable : out STD_LOGIC;
      Benable : out STD_LOGIC;
      Menable : out STD_LOGIC;
      PMPathMode : out STD_LOGIC_VECTOR(2 downto 0);
      PMPathByteOffset : out STD_LOGIC_VECTOR(1 downto 0);
      ALUmode : out STD_LOGIC_VECTOR(3 downto 0);
      ALUop1select : out STD_LOGIC;
      ALUop2select : out STD_LOGIC_VECTOR(2 downto 0);
      rad1select : out STD_LOGIC_VECTOR(1 downto 0);
      rad2select : out STD_LOGIC;
      wadselect : out STD_LOGIC_VECTOR(1 downto 0);
      wdselect : out STD_LOGIC;
      --ShiftType : in STD_LOGIC_VECTOR(1 downto 0);  --read directly from instruction
      ShiftAmountSelect : out STD_LOGIC;
      ShifterInSelect : out STD_LOGIC;
      Fset : out STD_LOGIC;
      --output to controller :
      instruction : in STD_LOGIC_VECTOR(31 downto 0);
      flagZ : in STD_LOGIC;
      flagN : in STD_LOGIC;
      flagV : in STD_LOGIC;
      flagC : in STD_LOGIC );
end controller;

architecture Behavioral of controller is
    Component ControllerFSM
    Port ( clk : in  STD_LOGIC;
         ins : in STD_LOGIC_VECTOR(31 downto 0);
         state : out STD_LOGIC_VECTOR(3 downto 0));
    end Component;

    signal state : STD_LOGIC_VECTOR(3 downto 0);

begin
    
    memoryReadEnable <= '1';
   
    --generating control signals from state and instruction -> combinational
    
    --memoryWriteEnable : out STD_LOGIC;
    
    memoryAddressSelect <= '0' when state = "0000" else '1';
    
    IRenable <= '1' when state = "0000" else '0';
    
    --DRenable <=;
    
    RESenable <= '1' when state = "0000" or state = "0010" or state = "0011" else '0';
    
    RFenable <= '1' when state = "0001" or state = "0011" or state = "0100" or state = "0101" else '0';
    
    Aenable <= '1' when state = "0001" else '0';
    
    Benable <= '1' when state = "0001" else '0';
    
    --Menable : out STD_LOGIC;
    
    --PMPathMode : out STD_LOGIC_VECTOR(2 downto 0);
    
    --PMPathByteOffset : out STD_LOGIC_VECTOR(1 downto 0);
    
    ALUop1select <= '0' when state = "0000" or state = "0010" or state = "0011" else '1';
    
    ALUop2select <= "001" when state = "0000" or state = "0010" else  
                    "011" when state = "0011" else
                    "000";
    
    rad1select <= "00";
    
    rad2select <= '0';
    
    wadselect <= "11" when state = "0001" or state = "0011" or state = "0100" else 
                 "00" when state = "0101" else
                 "01";
    
    wdselect <= '0';
    
    --state controller    
    stateController : ControllerFSM
    Port Map ( clk => clk,
               ins => instruction,
               state => state);


end Behavioral;
