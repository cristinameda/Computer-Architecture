----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2022 07:34:14 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt: std_logic_vector(15 downto 0);
signal enCnt: std_logic;
signal out1: std_logic;
signal out2: std_logic;
signal out3: std_logic;

begin

process(clk)
begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
    end if;
end process;

enCnt <= '1' when cnt = x"FFFF" else '0';

process(clk)
begin
    if rising_edge(clk) then
        if enCnt = '1' then
            out1 <= btn;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        out2 <= out1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        out3 <= out2;
    end if;
end process;

en <= out2 AND not(out3);

end Behavioral; 
