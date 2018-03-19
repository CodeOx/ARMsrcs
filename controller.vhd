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
      start : in STD_LOGIC;
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
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ins_type : in STD_LOGIC_VECTOR (1 downto 0);
           ins_subtype : in STD_LOGIC_VECTOR (2 downto 0);
           ins_variant : in STD_LOGIC_VECTOR (1 downto 0);
           skip_ins : in STD_LOGIC;
           state : out STD_LOGIC_VECTOR(3 downto 0));
    end Component;

    component flagchecker
    Port (  N : in STD_LOGIC;
            Z : in STD_LOGIC;
            C : in STD_LOGIC;
            V : in STD_LOGIC;
            condition : in STD_LOGIC_VECTOR(3 downto 0);
            result : out STD_LOGIC;
            undefined : out STD_LOGIC
         );
     end component;
     
     component aluctrl is
     Port (  condition : in STD_LOGIC_VECTOR(3 downto 0); --instruction bits (24 downto 21);
             ins_type : in STD_LOGIC_VECTOR(1 downto 0); --from instruction decoder 
             alu_signal : out STD_LOGIC_VECTOR (3 downto 0)
              );
     end component;
     
     component instructiondecoder is
         Port ( ins : in STD_LOGIC_VECTOR (31 downto 0);
                ins_type : out STD_LOGIC_VECTOR (1 downto 0);
                ins_subtype : out STD_LOGIC_VECTOR (2 downto 0);
                ins_variant : out STD_LOGIC_VECTOR (1 downto 0);
                undefined_encoding: out STD_LOGIC);
     end component;
     
    signal predicationResult : STD_LOGIC;
    signal undefined_ins : STD_LOGIC;
    signal undefined_predication : STD_LOGIC;
    signal undefined_encoding : STD_LOGIC;
    signal ins_type : STD_LOGIC_VECTOR(1 downto 0);
    signal ins_subtype : STD_LOGIC_VECTOR(2 downto 0);
    signal ins_variant : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_signal : STD_LOGIC_VECTOR(3 downto 0);
    signal skip_ins : STD_LOGIC;
    signal state : STD_LOGIC_VECTOR(3 downto 0);

begin
    --state controller    
    stateController : ControllerFSM
    Port Map ( clk => clk,
               reset => reset,
               start => start,
               ins_type => ins_type,
               ins_subtype => ins_subtype,
               ins_variant => ins_variant,
               skip_ins => skip_ins,
               state => state);
             
    --condition checker
    conditionChecker : flagchecker 
    Port Map (  N => flagN,
                Z => flagZ,
                C => flagC,
                V => flagV,
                condition => instruction (24 downto 21),
                result => predicationResult,
                undefined => undefined_predication
             );
             
    --alu control             
     ALUControl : aluctrl
     Port Map(condition => instruction (24 downto 21),
              ins_type => ins_type, 
              alu_signal => alu_signal
             );
             
    --instruction decoder
    IRDecoder : instructiondecoder
    Port Map (  ins => instruction,
                ins_type => ins_type,
                ins_subtype => ins_subtype,
                ins_variant => ins_variant,
                undefined_encoding =>undefined_encoding);
                
                
    undefined_ins <= undefined_encoding or undefined_predication; 
    
    --carry : out STD_LOGIC;            
            
    memoryReadEnable <= '1';
   
    --generating control signals from state and instruction -> combinational
    
    --memoryWriteEnable : out STD_LOGIC;
    
    memoryAddressSelect <= '0' when state = "0000" else '1';
    
    IRenable <= '1' when state = "0000" else '0';
    
    --DRenable <=;
    
    RESenable <= '1' when state = "0000" or state = "0010" or state = "0011" or state = "0110" or state = "1011" else '0';
    
    RFenable <= '1' when state = "0001" or state = "0011" or state = "0100" or state = "0101" or (state = "0111" and predicationResult = '1') or state = "1100" 
                else '0';
    
    Aenable <= '1' when state = "0001" or state = "1000" or state = "1010" else '0';
    
    Benable <= '1' when state = "0001" else '0';
    
    Menable <= '1' when state = "1001" else '0';
    
    --PMPathMode : out STD_LOGIC_VECTOR(2 downto 0);
    
    --PMPathByteOffset : out STD_LOGIC_VECTOR(1 downto 0);
    
    ALUop1select <= '0' when state = "0000" or state = "0010" or state = "0011" else '1';
    
    ALUop2select <= "001" when state = "0000" or state = "0010" else
                    "011" when state = "0011" else
                    "100" when state = "1011" else
                    "000";
                    
    ALUmode <= alu_signal when state = "0110" else
               "1101" when state = "1011" and ins_subtype = "000" else  
               "0100";
    
    rad1select <= "00" when state = "0001" else
                  "01" when state = "1010" else
                  "00";
    
    rad2select <= '0';
    
    wadselect <= "11" when state = "0001" or state = "0011" or state = "0100" else
                 "10" when state = "1100" else 
                 "00" when state = "0101" else
                 "01";
    
    wdselect <= '0';
    
    ShiftAmountSelect <= '1' when (state = "0110" and ins_variant = "01") else '0';
          
    ShifterInSelect <= '1' when (state = "0110" and ins_variant = "00") else '0';
    
    Fset <= '1' when (state = "0110" and predicationResult = '1') or (state = "1011" and predicationResult = '1') else '0'; 


end Behavioral;
