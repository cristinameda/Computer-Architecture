----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 09:53:39 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
  Port ( CLK: in std_logic;
         ALUResIn: in std_logic_vector(15 downto 0);
         RD2: in std_logic_vector(15 downto 0);
         MemWrite: in std_logic;
         MemData: out std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 127) of std_logic_vector(15 downto 0);
signal RAM:ram_type := (
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"000E",
		X"000F",
		X"00A0",
		X"00A1",
		X"00A2",
		X"00A3",
		X"00A4",
		X"00A5",
		X"00A6",
		X"00A7",
		others =>X"0000"
		);

begin

-- RAM
process(clk)
begin
    if rising_edge(clk) then
        if MemWrite = '1' then
            RAM(conv_integer(ALUResIn(6 downto 0))) <= RD2;
        end if;
    end if;
    MemData <= RAM(conv_integer(ALUResIn(6 downto 0)));
end process;

end Behavioral;
