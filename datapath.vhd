library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
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
        flagC : out STD_LOGIC );
end datapath;

architecture Behavioral of datapath is
    component ALU
    Port( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
          operand2 : in STD_LOGIC_VECTOR (31 downto 0);
          mode : in STD_LOGIC_VECTOR (3 downto 0);
          carry : in STD_LOGIC;
          output : out STD_LOGIC_VECTOR (31 downto 0);
          flagZ : out STD_LOGIC;
          flagN : out STD_LOGIC;
          flagV : out STD_LOGIC;
          flagC : out STD_LOGIC);
    end component;

    component shifter
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           shift_amount : in STD_LOGIC_VECTOR (4 downto 0);
           shift_type : in STD_LOGIC_VECTOR (1 downto 0);
           carry : out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component RegisterFile
    Port ( write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_addressA : in STD_LOGIC_VECTOR (3 downto 0);
           read_addressB : in STD_LOGIC_VECTOR (3 downto 0);
           write_address : in STD_LOGIC_VECTOR (3 downto 0);
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           read_dataA : out STD_LOGIC_VECTOR (31 downto 0);
           read_dataB : out STD_LOGIC_VECTOR (31 downto 0);
           pc : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component ProcessorMemoryPath
    Port ( processorIn : in STD_LOGIC_VECTOR(31 downto 0);
           memoryIn : in STD_LOGIC_VECTOR(31 downto 0);
           mode : in STD_LOGIC_VECTOR(2 downto 0);
           byteOffset : in STD_LOGIC_VECTOR(1 downto 0);
           processorOut : out STD_LOGIC_VECTOR(31 downto 0);
           memoryOut : out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    component multiplier
    Port ( input1 : in STD_LOGIC_VECTOR (31 downto 0);
           input2 : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component bram_wrapper
    Port ( addra : in STD_LOGIC_VECTOR ( 31 downto 0 );
            clka : in STD_LOGIC;
            dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
            douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
            ena : in STD_LOGIC;
            rsta : in STD_LOGIC;
            wea : in STD_LOGIC_VECTOR ( 3 downto 0 ));
    end component;
    
    signal ins : STD_LOGIC_VECTOR(31 downto 0);
    signal PC : STD_LOGIC_VECTOR(31 downto 0);
    signal dataFromMemory : STD_LOGIC_VECTOR(31 downto 0);
    signal dataToMemory : STD_LOGIC_VECTOR(31 downto 0);
    signal memoryAddress : STD_LOGIC_VECTOR(31 downto 0);
    signal rd1 : STD_LOGIC_VECTOR(31 downto 0);
    signal rd2 : STD_LOGIC_VECTOR(31 downto 0);                                 
    signal rad1 : STD_LOGIC_VECTOR(3 downto 0);
    signal rad2 : STD_LOGIC_VECTOR(3 downto 0);
    signal wad : STD_LOGIC_VECTOR(3 downto 0);
    signal wd : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUop1 : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUop2 : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUcarry : STD_LOGIC;
    signal ALUz : STD_LOGIC;
    signal ALUn : STD_LOGIC;
    signal ALUv : STD_LOGIC;
    signal ALUc : STD_LOGIC;
    signal ALUout : STD_LOGIC_VECTOR(31 downto 0);
    signal MulOp1 : STD_LOGIC_VECTOR(31 downto 0);
    signal MulOp2 : STD_LOGIC_VECTOR(31 downto 0);
    signal MulOut : STD_LOGIC_VECTOR(31 downto 0); 
    signal PMPathMemoryOut : STD_LOGIC_VECTOR(31 downto 0);
    signal PMPathProcessorOut : STD_LOGIC_VECTOR(31 downto 0);
    signal PMPathMemoryIn : STD_LOGIC_VECTOR(31 downto 0);
    signal PMPathProcessorIn : STD_LOGIC_VECTOR(31 downto 0);
    signal ShifterIn : STD_LOGIC_VECTOR(31 downto 0);
    signal ShifterOut : STD_LOGIC_VECTOR(31 downto 0);
    signal ShifterCarry : STD_LOGIC;
    signal ShiftAmount : STD_LOGIC_VECTOR(4 downto 0);
    signal ShiftType : STD_LOGIC_VECTOR(1 downto 0);
    signal IR : STD_LOGIC_VECTOR(31 downto 0);
    signal DR : STD_LOGIC_VECTOR(31 downto 0);
    signal RES : STD_LOGIC_VECTOR(31 downto 0);
    signal A : STD_LOGIC_VECTOR(31 downto 0);
    signal B : STD_LOGIC_VECTOR(31 downto 0);
    signal M : STD_LOGIC_VECTOR(31 downto 0); --multiplier result
    signal Z : STD_LOGIC;
    signal N : STD_LOGIC;
    signal V : STD_LOGIC;
    signal C : STD_LOGIC;
    signal MemoryWea : STD_LOGIC_VECTOR(3 downto 0);
    signal MemoryEna : STD_LOGIC;
begin
    instruction <= ins;
    flagZ <= Z;
    flagN <= N;
    flagV <= V;
    flagC <= C;

    ALUCarry <= carry when Fset='0' else ShifterCarry;  

    memoryAddress <= PC when memoryAddressSelect = '0' else ALUout;
    ins <= IR;
    rad1 <= ins(19 downto 16) when rad1select = "00" else 
            ins(15 downto 12) when rad1select = "01" else
            ins(11 downto 8);

    rad2 <= ins(3 downto 0) when rad2select = '0' else 
            ins(15 downto 12);

    wad <= ins(15 downto 12) when wadselect = "01" else 
           ins(19 downto 16) when wadselect = "10" else
           "1111" when wadselect = "11" else
           "1110";

    wd <= RES when wdselect = '0' else DR ;

    ALUop1 <= PC when ALUop1select = '0' else A;
    ALUop2 <= "00000000000000000000000000000100" when ALUop2select = "001" else
              "00000000000000000000" & ins(11 downto 0) when ALUop2select = "010" else
              "000000" & ins(23 downto 0) & "00" when ALUop2select = "011" and ins(23) = '0' else
              "111111" & ins(23 downto 0) & "00" when ALUop2select = "011" and ins(23) = '1' else
              M when ALUop2select = "100" else
              ShifterOut;

    MulOp1 <= A;
    MulOp2 <= B;

    shifterIn <= B when ShifterInSelect = '0' else "000000000000000000000000" & ins(7 downto 0);
    shiftAmount <= rd1(4 downto 0) when ShiftAmountSelect = '0' and ShifterInSelect = '0' else 
                   ins(11 downto 7) when ShiftAmountSelect = '1' and ShifterInSelect = '0' else
                   ins(11 downto 8) & '0';
    shiftType <= "11" when ShifterInSelect = '1' else
                 ins(6 downto 5);             

    PMPathMemoryIn <= dataFromMemory;
    dataToMemory <= PMPathMemoryOut;
    PMPathProcessorIn <= B;
    MemoryWea <= "0000" when memoryWriteEnable = '0' else
                 "0011" when PMPathMode="110" and PMPathByteOffset="00" else
                 "1100" when PMPathMode="110" and PMPathByteOffset="10" else
                 "0001" when PMPathMode="111" and PMPathByteOffset="00" else
                 "0010" when PMPathMode="111" and PMPathByteOffset="01" else
                 "0100" when PMPathMode="111" and PMPathByteOffset="10" else
                 "1000" when PMPathMode="111" and PMPathByteOffset="11" else
                 "1111";
    MemoryEna <= (memoryReadEnable or memoryWriteEnable);
    
    memory : bram_wrapper
    Port Map (  addra => memoryAddress,
                clka => clk,
                dina => dataToMemory,
                douta => dataFromMemory,
                ena => MemoryEna,
                rsta => reset,
                wea => MemoryWea
    );
    shift : shifter
    Port Map ( input => ShifterIn,
               shift_amount => ShiftAmount,
               shift_type => ShiftType,
               carry => ShifterCarry,
               output => ShifterOut
    );    
    RF : RegisterFile
    Port Map ( write_data => wd,
               read_addressA => rad1,
               read_addressB => rad2,
               write_address => wad,
               clock => clk,
               reset => reset,
               write_enable => RFenable,
               read_dataA => rd1,
               read_dataB => rd2,
               pc => PC
    );
    PMPath : ProcessorMemoryPath
    Port Map ( processorIn => PMPathProcessorIn,
               memoryIn => PMPathMemoryIn,
               mode => PMPathMode,
               byteOffset => PMPathByteOffset,
               processorOut => PMPathProcessorOut,
               memoryOut => PMPathMemoryOut
    );
    alu1 : ALU
    Port Map ( operand1 => ALUop1,
              operand2 => ALUop2,
              mode => ALUmode,
              carry => ALUcarry,
              output => ALUout,
              flagZ => ALUz,
              flagN => ALUn,
              flagV => ALUv,
              flagC => ALUc
    );
    mul : multiplier
    Port Map ( input1 => MulOp1,
               input2 => MulOp2,
               output => MulOut
    );
    process (clk)
    begin
        if rising_edge(clk) and IRenable = '1' then
            IR <= PMPathProcessorOut;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and DRenable = '1' then
            DR <= PMPathProcessorOut;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and RESenable = '1' then
            RES <= ALUout;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and Aenable = '1' then
            A <= rd1;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and Benable = '1' then
            B <= rd2;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and Menable = '1' then
            M <= MulOut;
        end if;
    end process;
    process (clk)
    begin
        if rising_edge(clk) and Fset = '1' then
            Z <= ALUz;
            N <= ALUn;
            V <= ALUv;
            C <= ALUc;
        end if;
    end process;
end Behavioral;