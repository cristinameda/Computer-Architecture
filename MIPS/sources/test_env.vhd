----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2022 06:34:32 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

-- btn(0): MPG in btn
-- btn(1): reset Instr_Fetch

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
Port ( clk : in STD_LOGIC;
           cnt : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component REG_FILE is
Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component RAM is
Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (7 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component Instr_Fetch is
 Port ( en : in STD_LOGIC;
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          jump_address : in STD_LOGIC_VECTOR (15 downto 0);
          branch_address : in STD_LOGIC_VECTOR (15 downto 0);
          PCSrc : in STD_LOGIC;
          Jump : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR (15 downto 0);
          PC_plus_1 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ID is
Port (   CLK: in std_logic;
           Instr: in std_logic_vector(15 downto 0);
           WD: in std_logic_vector(15 downto 0);
           RegWrite: in std_logic;
           RegDst: in std_logic;
           ExtOp: in std_logic;
           en: in std_logic;
           RD1: out std_logic_vector(15 downto 0);
           RD2: out std_logic_vector(15 downto 0);
           Ext_Imm: out std_logic_vector(15 downto 0);
           func: out std_logic_vector(2 downto 0);
           sa: out std_logic
        );

end component;

component CU is
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
end component;

component EX is
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
end component;

component MEM is
Port ( CLK: in std_logic;
         ALUResIn: in std_logic_vector(15 downto 0);
         RD2: in std_logic_vector(15 downto 0);
         MemWrite: in std_logic;
         MemData: out std_logic_vector(15 downto 0)
       );
end component;

-- semnale MPG
signal en: std_logic; -- enable
signal rst: std_logic; -- reset

-- semnale SSD
signal digits : std_logic_vector (15 downto 0);

-- semnale Instr_Fetch
signal JumpAddr: std_logic_vector(15 downto 0);
signal BranchAddr: std_logic_vector(15 downto 0);
signal PCSrc: std_logic;
signal Instr : std_logic_vector(15 downto 0);
signal PCNext: std_logic_vector(15 downto 0);

-- semnale CU
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemToReg: std_logic;
signal RegWrite: std_logic;

-- semnale ID
signal MUX_WD: std_logic_vector(15 downto 0); -- mux care decine daca se va lua rezultatul din ALU sau valoarea din memorie
signal rd1: std_logic_vector(15 downto 0);
signal rd2: std_logic_vector(15 downto 0);
signal Ext_Imm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;

-- semnale EX
signal AluResIn: std_logic_vector(15 downto 0);
signal Zero: std_logic;

-- semnale MEM
signal AluResOut: std_logic_vector(15 downto 0);
signal MemData: std_logic_vector(15 downto 0);

begin

    MPG_P1: MPG port map(
        btn => btn(0),
        clk => clk,
        en => en);
   
    MPG_P2: MPG port map(
                btn => btn(1),
                clk => clk,
                en => rst);
    
    SSD_P: SSD port map(
        clk => clk,
        cnt => digits,
        an => an,
        cat => cat);
    
    Instr_Fetch_P: Instr_Fetch port map(
        en => en,
        clk => clk,
        rst => rst,
        jump_address => JumpAddr,
        branch_address => BranchAddr,
        PCSrc => PCSrc,
        Jump => Jump,
        Instruction => Instr,
        PC_plus_1 => PCNext);
        
    CU_P: CU port map(
        OpCode => Instr(15 downto 13),
        RegDst => RegDst,
        ExtOp => ExtOp,
        ALUSrc => ALUSrc,
        Branch => Branch,
        Jump => Jump,
        ALUOp => ALUOp,
        MemWrite => MemWrite,
        MemToReg => MemToReg,
        RegWrite => RegWrite);        
        
    ID_P: ID port map(
        CLK => clk,
        Instr => Instr,
        WD => MUX_WD,
        RegWrite => RegWrite,
        RegDst => RegDst,
        ExtOp => ExtOp,
        en => en,
        RD1 => rd1,
        RD2 => rd2,
        Ext_Imm => Ext_Imm,
        func => func,
        sa => sa);
        
    EX_P: EX port map(
        PC_next => PCNext,
        RD1 => rd1,
        RD2 => rd2,
        Ext_Imm => Ext_Imm,
        sa => sa,
        func => func,
        AluOp => AluOp,
        AluSrc => AluSrc,
        Branch_Addr => BranchAddr,
        AluRes => AluResIn,
        Zero => Zero);
    
    MEM_P: MEM port map(
        CLK => clk,
        ALUResIn => ALUResIn,
        RD2 => rd2,
        MemWrite => MemWrite,
        MemData => MemData);
       
    MUX_WD <= ALUResIn when MemToReg = '0' else MemData;
    PCSrc <= Branch and Zero;
    JumpAddr <= "000" & Instr(12 downto 0);
    
    process(sw)
    begin
        case sw(2 downto 0) is
            when "000" => digits <= instr;
            when "001" => digits <= PCNext;
            when "010" => digits <= rd1;
            when "011" => digits <= rd2;
            when "100" => digits <= Ext_Imm;
            when "101" => digits <= ALUResIn;
            when "110" => digits <= MemData;
            when "111" => digits <= MUX_WD;
        end case;
    end process;
    
    led(15) <= RegDst;
    led(14) <= ExtOp;
    led(13) <= ALUSrc;
    led(12) <= Branch;
    led(11) <= Jump;
    led(10 downto 8) <= ALUOp;
    led(7) <= MemWrite;
    led(6) <= MemToReg;
    led(5) <= RegWrite;
    
end Behavioral;
