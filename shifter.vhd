library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity shifter is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           shift_amount : in STD_LOGIC_VECTOR (4 downto 0);
           shift_type : in STD_LOGIC_VECTOR (1 downto 0);
           carry : out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end shifter;

architecture Behavioral of shifter is
    component reverser port(input : in STD_LOGIC_VECTOR (31 downto 0);
                            reverse : in STD_LOGIC;
                            output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;                            

    signal reverse: std_logic;
    signal r1: std_logic_vector (31 downto 0);
    signal r2: std_logic_vector (31 downto 0);
    signal t0: std_logic_vector (31 downto 0);
    signal t1: std_logic_vector (31 downto 0);
    signal t2: std_logic_vector (31 downto 0);
    signal t3: std_logic_vector (31 downto 0);
    
    signal p0: std_logic;
    signal p1: std_logic_vector (1 downto 0);
    signal p2: std_logic_vector (3 downto 0);
    signal p3: std_logic_vector (7 downto 0);
    signal p4: std_logic_vector (15 downto 0);
    
begin
    reverse <= shift_type(0) nor shift_type(1);
    
    with shift_type select p0 <= 
        r1(31) when "10",
        r1(0) when "11",
        '0' when others; 
        

    with shift_type select p1 <=
        p0 & p0 when "10",
        t0(1 downto 0) when "11",
       "00" when others; 

    with shift_type select p2 <=
        p1 & p1 when "10",
        t1(3 downto 0) when "11",
        "0000" when others; 

    with shift_type select p3 <=
        p2 & p2 when "10",
        t2(7 downto 0) when "11",
        "00000000" when others; 

    with shift_type select p4 <=
        p3 & p3 when "10",
        t3(15 downto 0) when "11",
        "0000000000000000" when others; 
    
    Reverser1: reverser port map ( input => input,
                                   reverse => reverse,
                                   output => r1 ) ;
                           
    Reverser2: reverser port map ( input => r2,
                                   reverse => reverse,
                                   output => output ) ;
                                   
    t0 <= p0 & r1(31 downto 1)  when shift_amount(0)='1' else r1;
    t1 <= p1 & t0(31 downto 2) when shift_amount(1)='1' else t0;
    t2 <= p2 & t1(31 downto 4)  when shift_amount(2)='1' else t1;
    t3 <= p3 & t2(31 downto 8)  when shift_amount(3)='1' else t2;
    r2 <= p4 & t3(31 downto 16)  when shift_amount(4)='1' else t3;
    carry <= t3(16) when shift_amount(4)='1' else t3(31);
                                   

    

end Behavioral;
