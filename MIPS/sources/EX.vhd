----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 09:30:53 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity EX is
    Port ( -- intrari
           PC_next : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           -- semnale
           AluOp : in STD_LOGIC_VECTOR (2 downto 0);
           AluSrc : in STD_LOGIC;
           -- iesiri
           Branch_Addr : out STD_LOGIC_VECTOR (15 downto 0);
           AluRes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end EX;

architecture Behavioral of EX is
signal ALU_A: std_logic_vector(15 downto 0) := RD1;
signal ALU_B: std_logic_vector(15 downto 0);
signal AluOut: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);
signal Comp: std_logic_vector(15 downto 0);
signal MUX_SLT_SS: std_logic;

begin

Branch_addr <= PC_next + Ext_Imm;

-- MUX
ALU_B <= RD2 when AluSrc = '0' else Ext_Imm;

-- ALU Control
process(AluOp, func)
begin
    case(AluOp) is
        when "000" => AluCtrl <= func;  -- R-Type
        when "001" => AluCtrl <= "000"; -- ADDI does addition
        when "100" => AluCtrl <= "001"; -- BEQ does subtraction
        when "101" => AluCtrl <= "100"; -- ANDI
        when "110" => AluCtrl <= "101"; -- ORI
        when others => AluCtrl <= "XXX";
    end case;
end process;

-- ALU
process(AluCtrl, RD1, ALU_B)
begin
    case AluCtrl is
        when "000" => AluOut <= ALU_A + ALU_B;   -- add
        when "001" => AluOut <= ALU_A - ALU_B;   -- sub
        when "010" => AluOut <= ALU_B(14 downto 0) & "0";   -- sll
        when "011" => AluOut <= "0" & ALU_B(15 downto 1);   -- srl
        when "100" => AluOut <= ALU_A and ALU_B;  -- and
        when "101" => AluOut <= ALU_A or ALU_B;   -- or
        when "110" => AluOut <= ALU_A xor ALU_B;  -- xor
        when "111" =>  Comp <= ALU_A - ALU_B;     -- slt
                       MUX_SLT_SS <= Comp(15);
                       case MUX_SLT_SS is
                           when '0' => AluOut <= x"0000";
                           when '1' => AluOut <= x"0001";
                       end case;
    end case;
end process;


AluRes <= AluOut;

-- Zero
Zero <= '1' when AluOut = x"0000" else '0';


end Behavioral;
