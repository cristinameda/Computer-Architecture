----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 09:21:26 PM
-- Design Name: 
-- Module Name: CU - Behavioral
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

entity CU is
    Port (
            OpCode: in std_logic_vector(2 downto 0);
            RegDst: out std_logic;
            ExtOp: out std_logic;
            ALUSrc: out std_logic;
            Branch: out std_logic;
            Jump: out std_logic;
            ALUOp: out std_logic_vector(2 downto 0);
            MemWrite: out std_logic;
            MemToReg: out std_logic;
            RegWrite: out std_logic
            );
end CU;

architecture Behavioral of CU is

begin

process(OpCode)
begin
    RegDst<='0';
	ExtOp<='0';
	ALUSrc<='0';
	Branch<='0';
	Jump<='0';
	ALUOp<="000";
	MemWrite<='0';
	MemtoReg<='0';
	RegWrite<='0';
    case(OpCode) is
        when "000" =>     --R-Type
            RegDst<='1';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='0';
			ALUOp<="000";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			             
		when "001" =>     --ADDI
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
		
		when "010" =>     --LW
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";
			MemWrite<='0';
			MemtoReg<='1';
			RegWrite<='1';
			
		when "011" =>     --SW
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";
			MemWrite<='1';
			MemtoReg<='0';
			RegWrite<='0';
			
		when "100" =>     --BEQ
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='0';
			Branch<='1';
			Jump<='0';
			ALUOp<="100";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
			
		when "101" =>     --ANDI
            RegDst<='0';
            ExtOp<='1';
            ALUSrc<='1';
            Branch<='0';
            Jump<='0';
            ALUOp<="101";
            MemWrite<='0';
            MemtoReg<='0';
            RegWrite<='1';
			
		when "110" =>     --ORI
            RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="110";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			
		when "111" =>     --JUMP
            RegDst<='0';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='1';
			ALUOp<="111";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
	end case;	
end process;

end Behavioral;
