----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 06:51:57 PM
-- Design Name: 
-- Module Name: REG_FILE - Behavioral
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

entity REG_FILE is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           en: in STD_LOGIC;
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is
type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
0 => X"0004", -- r0 = 4
1 => X"0005", -- r1 = 5
2 => X"001E", -- r2 = 30
3 => X"0028", -- r3 = 40
4 => X"0032", -- r4 = 50
5 => X"003C", -- r5 = 60
others => x"0000");

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            if wen = '1' then
                reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

end Behavioral;
