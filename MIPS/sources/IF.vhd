----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2022 05:16:52 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instr_Fetch is
    Port ( en : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           PC_plus_1 : out STD_LOGIC_VECTOR (15 downto 0));
end Instr_Fetch;

architecture Behavioral of Instr_Fetch is
signal PC_in: std_logic_vector(15 downto 0);
signal PC_out: std_logic_vector(15 downto 0);
signal ALU_plus_1: std_logic_vector(15 downto 0);
signal mux_out: std_logic_vector(15 downto 0);
type rom_type is array(0 to 256) of std_logic_vector(15 downto 0);
signal rom: rom_type := (
-- program
-- r <- (a+b)x2 - (c-d)/2 + 5;
-- if(r == 40) then
--     return 1;
-- else return 0;

-- dummy instructions
b"011_000_010_0000001",   -- sw r2 1(r0)    MEM[5] <= r2 = 30 = 1E  x"6101"     -1   
b"010_001_011_0000000",   -- lw r3 0(r1)    r3 <= MEM[5] = 30 = 1E  x"4580"     -2   
b"000_011_000_001_0_000", -- add r1 r3 r0   r1 = 30 + 4 = 34 = 22   x"0C10"     -3   

-- intializari
b"000_010_010_010_0_110", -- xor r2 r2 r2   r2 = 0                  x"0926"     -4
b"001_010_000_0000011",   -- addi r0 r2 3   r0 = 3 (a)              x"2803"     -5
b"001_010_001_0001100",   -- addi r1 r2 12  r1 = C (b)              x"288C"     -6
b"001_010_100_0001111",   -- addi r4 r2 15  r4 = F (c)              x"2A0F"     -7
b"001_010_101_0000111",   -- addi r5 r2 7   r5 = 7 (d)              x"2A87"     -8
-- instructiuni program
b"000_000_001_010_0_000", -- add r2 r0 r1   r2=a+b=15=F             x"00A0"     -9
b"000_000_010_011_1_010", -- sll r3 r2 sa   r3=(a+b)x2=30=1E        x"013A"     -10
b"000_100_101_110_0_001", -- sub r6 r4 r5   r6=c-d=8                x"12E1"     -11
b"000_000_110_111_1_011", -- srl r7 r6      r7=(c-d)/2=4            x"037B"     -12
b"000_011_111_000_0_001", -- sub r0 r3 r7   r0=(a+b)x2-(c-d)/2=1A   x"0F81"     -13
b"001_000_000_0000101",   -- addi r0 r0 5   r0=26+5=31=1F           x"2005"     -14
b"000_001_001_001_0_110", -- xor r1 r1 r1   r1=0                    x"0496"     -15
b"001_001_001_0011111",   -- addi r1 r1 31  r1=31=1F                x"249F"     -16
b"000_010_010_010_0_110", -- xor r2 r2 r2   r2=0                    x"0926"     -17
b"100_000_001_0000010",   -- beq r0 r1 2    if(r0==r1)              x"8082"     -18
b"011_010_010_0000001",   -- sw r2 r2 1     else return 0(r2);      x"6901"     -19
b"111_0000000010101",     -- j 21           jump                    x"E016"     -20
b"001_010_010_0000001",   -- addi r2 r2 1   r2=1                    x"2901"     -21
b"011_010_010_0000000",   -- sw r2 r2 0     then return 1(r2);      x"6900"     -22
-- instructiuni neutilizare
b"000_001_001_001_0_110", -- xor r1 r1 r1   r1 = 0                  x"0496"     -23
b"000_111_111_111_0_110", -- xor r7 r7 r7   r7 = 0                  x"1FF6"     -24
b"001_001_001_0000001",   -- addi r1 r1 1   r1 = 1                  x"2481"     -25
b"001_111_111_0000010",   -- addi r7 r7 2   r7 = 2                  x"3F82"     -26
b"000_001_111_011_0_100", -- and r3 r1 r7   r3 = 1 & 2 = 0          x"07B4"     -27
b"000_001_111_011_0_101", -- or r3 r1 r7    r3 = 1 | 2 = 3          x"07B5"     -28
b"000_001_111_011_0_111", -- slt r3 r1 r7   r3 = 1                  x"07B7"     -29
b"010_011_111_0001010",   -- lw r7 10(r3)   r7 <= MEM[B] = C        x"4F8A"     -30
b"101_111_001_0000001",   -- andi r1 r7 1   r1 = 0                  x"BC81"     -31
b"110_111_001_0000001",   -- ori r1 r7 1    r1 = D                  x"DC81"     -32
others => x"0000"         -- 0                                      x"0000"     -33
);

begin

process(clk)
begin
    if rst = '1' then
        PC_out <= x"0000";
    end if;
    if rising_edge(clk) then
        if en = '1' then
            PC_out <= Pc_in;
        end if;
    end if;
end process;


Instruction <= rom(conv_integer(PC_out(15 downto 0)));

ALU_plus_1 <= PC_out + 1;

mux_out <= ALU_plus_1 when PCSrc = '0' else branch_address;

PC_in <= mux_out when Jump = '0' else jump_address;

PC_plus_1 <= ALU_plus_1;

end Behavioral;
