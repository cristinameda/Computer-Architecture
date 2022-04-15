----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 08:43:46 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
  Port (   CLK: in std_logic;
           Instr: in std_logic_vector(15 downto 0);
           WD: in std_logic_vector(15 downto 0);
           RegWrite: in std_logic;
           RegDst: in std_logic;
           ExtOp: in std_logic;
           en : in std_logic;
           RD1: out std_logic_vector(15 downto 0);
           RD2: out std_logic_vector(15 downto 0);
           Ext_Imm: out std_logic_vector(15 downto 0);
           func: out std_logic_vector(2 downto 0);
           sa: out std_logic
        );
end ID;

architecture Behavioral of ID is

component REG_FILE is
Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal Ext_Imm_Out: std_logic_vector(15 downto 0);
signal WriteAddr: std_logic_vector(2 downto 0);
signal rt: std_logic_vector(2 downto 0) := Instr(9 downto 7);
signal rd: std_logic_vector(2 downto 0) := Instr(6 downto 4);
signal imm: std_logic_vector(6 downto 0) := Instr(6 downto 0);

begin

RF: REG_FILE port map(
    clk => CLK,
    ra1 => Instr(12 downto 10),
    ra2 => Instr(9 downto 7),
    wa => WriteAddr,
    wd => WD,
    en => en,
    wen => RegWrite,
    rd1 => RD1,
    rd2 => RD2);

-- MUX
WriteAddr <= rt when RegDst = '0' else rd;

-- Ext Unit
process(ExtOp, Instr)
begin
case(ExtOp) is
    when '0' => Ext_Imm_Out <= "000000000" & imm;
    when others => 
        case (Instr(6)) is
            when '0' => Ext_Imm_Out <= "000000000" & imm;
            when '1' => Ext_Imm_Out <= "111111111" & imm;
            when others => Ext_Imm_Out <= Ext_Imm_Out;
        end case;
end case;
end process;

func <= Instr(2 downto 0);
sa <= Instr(3);
Ext_Imm <= Ext_Imm_Out;

end Behavioral;