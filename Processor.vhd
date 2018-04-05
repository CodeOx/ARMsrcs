library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; 

entity processor is
  Port( clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        start: in STD_LOGIC;
        debug_controls : in STD_LOGIC_VECTOR(3 downto 0);
        debug_out : out STD_LOGIC_VECTOR(15 downto 0));
        --state : out STD_LOGIC_VECTOR(4 downto 0) );
end processor;

        
architecture Behavioral of processor is

    component controller
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
          flagC : in STD_LOGIC;
          state_out : out STD_LOGIC_VECTOR(4 downto 0) );
    end component;
    
    component datapath
      Port (reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            --control signals :
            carry : in STD_LOGIC;
            memoryReadEnable : in STD_LOGIC;
            memoryWriteEnable : in STD_LOGIC;
            memoryAddressSelect : in STD_LOGIC;
            IRenable : in STD_LOGIC;
            DRenable : in STD_LOGIC;
            RESenable : in STD_LOGIC;
            RFenable : in STD_LOGIC;
            Aenable : in STD_LOGIC;
            Benable : in STD_LOGIC;
            Menable : in STD_LOGIC;
            PMPathMode : in STD_LOGIC_VECTOR(2 downto 0);
            PMPathByteOffset : in STD_LOGIC_VECTOR(1 downto 0);
            ALUmode : in STD_LOGIC_VECTOR(3 downto 0);
            ALUop1select : in STD_LOGIC;
            ALUop2select : in STD_LOGIC_VECTOR(2 downto 0);
            rad1select : in STD_LOGIC_VECTOR(1 downto 0);
            rad2select : in STD_LOGIC;
            wadselect : in STD_LOGIC_VECTOR(1 downto 0);
            wdselect : in STD_LOGIC;
            --ShiftType : in STD_LOGIC_VECTOR(1 downto 0);  --read directly from instruction
            ShiftAmountSelect : in STD_LOGIC;
            ShifterInSelect : in STD_LOGIC;
            Fset : in STD_LOGIC;
            --output to controller :
            instruction : out STD_LOGIC_VECTOR(31 downto 0);
            flagZ : out STD_LOGIC;
            flagN : out STD_LOGIC;
            flagV : out STD_LOGIC;
            flagC : out STD_LOGIC;
            debug_controls : in STD_LOGIC_VECTOR(3 downto 0);
            debug_out : out STD_LOGIC_VECTOR(31 downto 0));
            
    end component;

    signal carry :  STD_LOGIC;
    signal memoryReadEnable :  STD_LOGIC;
    signal memoryWriteEnable :  STD_LOGIC;
    signal memoryAddressSelect :  STD_LOGIC;
    signal IRenable :  STD_LOGIC;
    signal DRenable :  STD_LOGIC;
    signal RESenable :  STD_LOGIC;
    signal RFenable :  STD_LOGIC;
    signal Aenable :  STD_LOGIC;
    signal Benable :  STD_LOGIC;
    signal Menable :  STD_LOGIC;
    signal PMPathMode :  STD_LOGIC_VECTOR(2 downto 0);
    signal PMPathByteOffset :  STD_LOGIC_VECTOR(1 downto 0);
    signal ALUmode :  STD_LOGIC_VECTOR(3 downto 0);
    signal ALUop1select :  STD_LOGIC;
    signal ALUop2select :  STD_LOGIC_VECTOR(2 downto 0);
    signal rad1select :  STD_LOGIC_VECTOR(1 downto 0);
    signal rad2select :  STD_LOGIC;
    signal wadselect :  STD_LOGIC_VECTOR(1 downto 0);
    signal wdselect :  STD_LOGIC;
    signal ShiftAmountSelect :  STD_LOGIC;
    signal ShifterSelect :  STD_LOGIC;
    signal Fset :  STD_LOGIC;
    signal instruction :  STD_LOGIC_VECTOR(31 downto 0);
    signal state_temp : STD_LOGIC_VECTOR(4 downto 0);
    signal flagZ :  STD_LOGIC;
    signal flagN :  STD_LOGIC;
    signal flagV :  STD_LOGIC;
    signal flagC :  STD_LOGIC;
    signal slowclock : STD_LOGIC;
    signal slowclockvector : STD_LOGIC_VECTOR(27 downto 0);
    signal debug_out_internal : STD_LOGIC_VECTOR(31 downto 0) ;
begin
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			slowclockvector <= std_logic_vector(unsigned(slowclockvector)+1);
	   end if;
	end process;
    
    slowclock<= slowclockvector(27);
    debug_out <= debug_out_internal(15 downto 0);

    data_path: datapath
    Port Map(reset => reset,
            clk => clk,
            carry => carry,
            memoryReadEnable => memoryReadEnable,
            memoryWriteEnable => memoryWriteEnable,
            memoryAddressSelect => memoryAddressSelect,
            IRenable => IRenable,
            DRenable => DRenable,
            RESenable => RESenable,
            RFenable => RFenable,
            Aenable => Aenable,
            Benable => Benable,
            Menable => Menable,
            PMPathMode => PMPathMode,
            PMPathByteOffset => PMPathByteOffset,
            ALUmode => ALUmode,
            ALUop1select => ALUop1select,
            ALUop2select => ALUop2select,
            rad1select => rad1select,
            rad2select => rad2select,
            wadselect => wadselect,
            wdselect => wdselect,
            ShiftAmountSelect => ShiftAmountSelect,
            ShifterInSelect => ShifterSelect,
            Fset => Fset,
            instruction => instruction,
            flagZ => flagZ,
            flagN => flagN,
            flagV => flagV,
            flagC => flagC,
            debug_controls => debug_controls,
            debug_out => debug_out_internal);
            
    processor_controller: controller
    Port Map(reset => reset,
            clk => clk,
            start => start,
            carry => carry,
            memoryReadEnable => memoryReadEnable,
            memoryWriteEnable => memoryWriteEnable,
            memoryAddressSelect => memoryAddressSelect,
            IRenable => IRenable,
            DRenable => DRenable,
            RESenable => RESenable,
            RFenable => RFenable,
            Aenable => Aenable,
            Benable => Benable,
            Menable => Menable,
            PMPathMode => PMPathMode,
            PMPathByteOffset => PMPathByteOffset,
            ALUmode => ALUmode,
            ALUop1select => ALUop1select,
            ALUop2select => ALUop2select,
            rad1select => rad1select,
            rad2select => rad2select,
            wadselect => wadselect,
            wdselect => wdselect,
            ShiftAmountSelect => ShiftAmountSelect,
            ShifterInSelect => ShifterSelect,
            Fset => Fset,
            instruction => instruction,
            flagZ => flagZ,
            flagN => flagN,
            flagV => flagV,
            flagC => flagC,
            state_out => state_temp);
            
    --state <= state_temp;

end architecture;