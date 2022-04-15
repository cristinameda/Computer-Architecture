----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2022 06:49:00 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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


entity SSD is
    Port ( clk : in STD_LOGIC;
           cnt : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal ss: std_logic_vector(1 downto 0);
signal input1: std_logic_vector(3 downto 0) := "0111";
signal input2: std_logic_vector(3 downto 0) := "1011";
signal input3: std_logic_vector(3 downto 0) := "1101";
signal input4: std_logic_vector(3 downto 0) := "1110";
signal anout: std_logic_vector(3 downto 0);
signal dig: std_logic_vector(15 downto 0);
signal HEX: std_logic_vector(3 downto 0);
signal LED: std_logic_vector(6 downto 0);

begin

ss <= dig(15 downto 14);

-- counter
process(clk)
begin
    if rising_edge(clk) then
        dig <= dig + 1;
    end if;
end process;
   
process (ss, input1, input2, input3, input4)
begin
   case ss is
      when "00" => anout <= input1;
      when "01" => anout <= input2;
      when "10" => anout <= input3;
      when "11" => anout <= input4;
      when others => anout <= input1;
   end case;
end process;

process (ss, cnt)
begin
   case ss is
      when "00" => HEX <= cnt(15 downto 12);
      when "01" => HEX <= cnt(11 downto 8);
      when "10" => HEX <= cnt(7 downto 4);
      when "11" => HEX <= cnt(3 downto 0);
      when others => HEX <= cnt(15 downto 12);
   end case;
end process;

with HEX SELect
   LED<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

an <= anout;
cat <= LED;

end Behavioral;
