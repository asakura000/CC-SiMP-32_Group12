library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CCSiMP32 is
    Port ( I_EN : in  STD_LOGIC;
           I_CLK : in  STD_LOGIC);
end CCSiMP32;

architecture Behavioral of CCSiMP32 is
component PC is
    Port ( I_PC_UPDATE : in  STD_LOGIC;
			  I_PC : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_PC: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component ADD1 is
    Port ( I_ADD1_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_ADD1_Out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_ADD1_Out: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component JumpModule is
    Port ( JumpImm : in  STD_LOGIC_VECTOR (25 downto 0);
			  PC : in  STD_LOGIC_VECTOR (31 downto 0);
           JumpAddr : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal JumpAddr: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component ADD2 is --Includes shift left by 2
    Port ( I_ADD2_A : in  STD_LOGIC_VECTOR (31 downto 0); --PC+4 goes to this one
			  I_ADD2_B : in  STD_LOGIC_VECTOR (31 downto 0); --Immediate goes to this one
           O_ADD2_Out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_ADD2_Out: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component MUX32 is
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (31 downto 0);
           I_MUX_1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_MUX_Sel : in STD_LOGIC;
           O_MUX_Out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_MUX1: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal O_MUX2: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal O_MUX3: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal O_MUX5: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component MUX5 is
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (4 downto 0);
           I_MUX_1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  I_MUX_Sel : in STD_LOGIC;
           O_MUX_Out : out STD_LOGIC_VECTOR (4 downto 0));
end component;
signal O_MUX4: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

component ROM is
    Port ( I_ROM_EN : in  STD_LOGIC;
           I_ROM_ADDR : in  STD_LOGIC_VECTOR (31 downto 0);
           O_ROM_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_ROM_DATA: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component DEC is
    Port ( I_DEC_EN : in  STD_LOGIC;
           I_DEC_Opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           O_DEC_RegDst : out  STD_LOGIC;
           O_DEC_Jump : out  STD_LOGIC;
           O_DEC_Beq : out  STD_LOGIC;
           O_DEC_Bne : out  STD_LOGIC;
           O_DEC_MemRead : out  STD_LOGIC;
           O_DEC_MemtoReg : out  STD_LOGIC;
           O_DEC_ALUOp : out  STD_LOGIC_VECTOR (1 downto 0);
           O_DEC_MemWrite : out  STD_LOGIC;
           O_DEC_ALUSrc : out  STD_LOGIC;
           O_DEC_RegWrite : out  STD_LOGIC);
end component;
signal O_DEC_RegDst: STD_LOGIC := '0';
signal O_DEC_Jump: STD_LOGIC := '0';
signal O_DEC_Beq: STD_LOGIC := '0';
signal O_DEC_Bne: STD_LOGIC := '0';
signal O_DEC_MemRead: STD_LOGIC := '0';
signal O_DEC_MemtoReg: STD_LOGIC := '0';
signal O_DEC_ALUOp: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal O_DEC_MemWrite: STD_LOGIC := '0';
signal O_DEC_ALUSrc: STD_LOGIC := '0';
signal O_DEC_RegWrite: STD_LOGIC := '0';

component REG is
    Port ( I_REG_EN : in  STD_LOGIC;
           I_REG_WE : in  STD_LOGIC;
           I_REG_SEL_RS : in  STD_LOGIC_VECTOR (4 downto 0);
           I_REG_SEL_RT : in  STD_LOGIC_VECTOR (4 downto 0);
           I_REG_SEL_RD : in  STD_LOGIC_VECTOR (4 downto 0); --This is more of a "write register" than RD
           I_REG_DATA_RD : in  STD_LOGIC_VECTOR (31 downto 0);
           O_REG_DATA_A : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           O_REG_DATA_B : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end component;
signal O_REG_DATA_A: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal O_REG_DATA_B: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component EXT is
    Port ( I_EXT_16 : in  STD_LOGIC_VECTOR (15 downto 0);
           O_EXT_32 : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_EXT_32: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component BranchModule is
    Port ( beq : in  STD_LOGIC;
           bne : in  STD_LOGIC;
			  zero : in STD_LOGIC;
           branch : out STD_LOGIC);
end component;
signal branch: STD_LOGIC := '0';

component ALU is
    Port ( I_ALU_EN : in  STD_LOGIC;
			  I_ALU_CTL : in  STD_LOGIC_VECTOR (3 downto 0);
			  I_ALU_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_ALU_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_ALU_Out : out  STD_LOGIC_VECTOR (31 downto 0);
			  O_ALU_Zero : out  STD_LOGIC);
end component;
signal O_ALU_Out: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal O_ALU_Zero: STD_LOGIC := '0';

component ACU is
    Port ( I_ACU_ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           I_ACU_Funct : in  STD_LOGIC_VECTOR (5 downto 0);
           O_ACU_CTL : out  STD_LOGIC_VECTOR (3 downto 0));
end component;
signal O_ACU_CTL: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

component RAM is
    Port ( I_RAM_EN : in  STD_LOGIC;
           I_RAM_RE : in  STD_LOGIC;
           I_RAM_WE : in  STD_LOGIC;
           I_RAM_ADDR : in  STD_LOGIC_VECTOR (31 downto 0);
           I_RAM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           O_RAM_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal O_RAM_DATA: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

component OR1bit is --Used to OR O_FSM_ID and O_FSM_WB into REG's I_REG_EN
    Port ( I_Left : in  STD_LOGIC := '0';
			  I_Right : in  STD_LOGIC := '0';
			  O_OR_GATE : out STD_LOGIC := '0');
end component;
signal O_OR_GATE: STD_LOGIC := '0';

component AND1bit is --Used to AND O_DEC_RegWrite and O_FSM_WB into REG's I_REG_WE
    Port ( I_Left : in  STD_LOGIC := '0';
			  I_Right : in  STD_LOGIC := '0';
			  O_AND_GATE : out STD_LOGIC := '0');
end component;
signal O_AND_GATE: STD_LOGIC := '0';

component FSM is
    Port ( I_FSM_CLK : in  STD_LOGIC;
           I_FSM_EN : in  STD_LOGIC;
           I_FSM_INST : in  STD_LOGIC_VECTOR (31 downto 0);
           O_FSM_IF : out  STD_LOGIC;
           O_FSM_ID : out  STD_LOGIC;
           O_FSM_EX : out  STD_LOGIC;
           O_FSM_ME : out  STD_LOGIC;
           O_FSM_WB : out  STD_LOGIC);
end component;
signal O_FSM_IF: STD_LOGIC := '0';
signal O_FSM_ID: STD_LOGIC := '0';
signal O_FSM_EX: STD_LOGIC := '0';
signal O_FSM_ME: STD_LOGIC := '0';
signal O_FSM_WB: STD_LOGIC := '0';


begin
PC_Mod : PC port map(O_FSM_ME, O_MUX5, O_PC);
ADD1_Mod : ADD1 port map(O_PC, O_ADD1_Out);
JumpModule_Mod : JumpModule port map(O_ROM_DATA(25 downto 0), O_PC, JumpAddr);
MUX1 : MUX32 port map(O_ADD1_Out, O_ADD2_Out, branch, O_MUX1);
MUX2 : MUX32 port map(O_ALU_Out, O_RAM_DATA, O_DEC_MemtoReg, O_MUX2);
MUX3 : MUX32 port map(O_REG_DATA_B, O_EXT_32, O_DEC_ALUSrc, O_MUX3);
MUX4 : MUX5 port map(O_ROM_DATA(20 downto 16), O_ROM_DATA(15 downto 11), O_DEC_RegDst, O_MUX4);
MUX5_Mod : MUX32 port map(O_MUX1, JumpAddr, O_DEC_Jump, O_MUX5); --Becareful: Mux5 and Mux5_Mod are different. One is the 5 bit mux entity, and the other is the MUX5 IC.
ADD2_Mod : ADD2 port map(O_ADD1_Out, O_EXT_32, O_ADD2_Out);
BranchModule_Mod : BranchModule port map(O_DEC_Beq, O_DEC_Bne, O_ALU_Zero, branch);
ROM_Mod : ROM port map(O_FSM_IF, O_PC, O_ROM_DATA);
DEC_Mod : DEC port map(O_FSM_ID, O_ROM_DATA(31 downto 26), O_DEC_RegDst, O_DEC_Jump, O_DEC_Beq, O_DEC_Bne, O_DEC_MemRead, O_DEC_MemtoReg, O_DEC_ALUOp, O_DEC_MemWrite, O_DEC_ALUSrc, O_DEC_RegWrite);
EXT_Mod : EXT port map(O_ROM_DATA(15 downto 0), O_EXT_32);
ACU_Mod : ACU port map(O_DEC_ALUOp, O_ROM_DATA(5 downto 0), O_ACU_CTL);
OR1bit_Mod : OR1bit port map(O_FSM_ID, O_FSM_WB, O_OR_GATE);
AND1bit_Mod : AND1bit port map(O_DEC_RegWrite, O_FSM_WB, O_AND_GATE);
REG_Mod : REG port map(O_OR_GATE, O_AND_GATE, O_ROM_DATA(25 downto 21), O_ROM_DATA(20 downto 16), O_MUX4, O_MUX2, O_REG_DATA_A, O_REG_DATA_B);
ALU_Mod : ALU port map(O_FSM_EX, O_ACU_CTL, O_REG_DATA_A, O_MUX3, O_ALU_Out, O_ALU_Zero);
RAM_Mod : RAM port map(O_FSM_ME, O_DEC_MemRead, O_DEC_MemWrite, O_ALU_Out, O_REG_DATA_B, O_RAM_DATA);
FSM_Mod : FSM port map(I_CLK, I_EN, O_ROM_DATA, O_FSM_IF, O_FSM_ID, O_FSM_EX, O_FSM_ME, O_FSM_WB);

	process(I_EN, I_CLK)
	begin
			--Recommended to set runtime to 3,700ns in wave window.
	end process;
end Behavioral;

