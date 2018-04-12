----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2018 23:39:02
-- Design Name: 
-- Module Name: AHB - Behavioral
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

entity AHB is
    Port(  HreadyToMaster : out STD_LOGIC; --
        dataToMaster : out STD_LOGIC_VECTOR(31 downto 0); --
        
        addressFromMaster : in STD_LOGIC_VECTOR(31 downto 0); --
        dataFromMaster : in STD_LOGIC_VECTOR(31 downto 0); --
        HwriteFromMaster : in STD_LOGIC; --
        HsizeFromMaster : in STD_LOGIC_VECTOR(2 downto 0); 
        HtransFromMaster : in STD_LOGIC_VECTOR(1 downto 0);
        
        HselToSlave_memory : out STD_LOGIC; 
        addressToSlave : out STD_LOGIC_VECTOR(31 downto 0); 
        dataToSlave : out STD_LOGIC_VECTOR(31 downto 0);
        HwriteToSlave : out STD_LOGIC;
        HsizeToSlave : out STD_LOGIC_VECTOR(2 downto 0);
        HtransToSlave : out STD_LOGIC_VECTOR(1 downto 0);
        
        HreadyFromSlave_memory : in STD_LOGIC;
        dataFromSlave_memory : in STD_LOGIC_VECTOR(31 downto 0));
end AHB;

architecture Behavioral of AHB is
    
    signal HselTemp : STD_LOGIC_VECTOR(2 downto 0); --000 for memory
    
begin

    addressToSlave <= addressFromMaster;
    dataToSlave <= dataFromMaster;
    HwriteToSlave <= HwriteFromMaster;
    HsizeToSlave <= HsizeFromMaster;
    HtransToSlave <= HtransFromMaster;
    
    HselTemp <= "000";
    
    HselToSlave_memory <= '1' when HselTemp = "000" else '0';
    
    HreadyToMaster <= HreadyFromSlave_memory; -- when HselTemp = "000" ;
    
    dataToMaster <= dataFromSlave_memory; --when HselTemp = "000"

end Behavioral;
