library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Module is
    Port ( I_EN : in  STD_LOGIC;
           I_Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           O_RegDst : out  STD_LOGIC;
           O_Jump : out  STD_LOGIC;
           O_Beq : out  STD_LOGIC;
           O_Bne : out  STD_LOGIC;
           O_MemRead  : out  STD_LOGIC;
           O_MemtoReg : out  STD_LOGIC;
           O_MemWrite : out  STD_LOGIC;
           O_ALUSrc : out  STD_LOGIC;
           O_RegWrite : out  STD_LOGIC;
           O_ALUCtl : out  STD_LOGIC_VECTOR (3 downto 0));
end Test_Module;

architecture Structural of Test_Module is

	signal Buffer_ALU_Op: STD_LOGIC_VECTOR(1 downto 0);
	
	component DEC 
		Port ( 
			  I_DEC_EN : in  STD_LOGIC;
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
	
	component ACU
		 Port ( 
			  I_ACU_ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           I_ACU_Funct : in  STD_LOGIC_VECTOR (5 downto 0);
           O_ACU_CTL : out  STD_LOGIC_VECTOR (3 downto 0));
	end component; 
	
	
	begin
	U1: DEC port map(I_EN, I_Instr(31 downto 26), O_RegDst, O_Jump, O_Beq, O_Bne, O_MemRead, O_MemtoReg, Buffer_ALU_Op(1 downto 0) , O_MemWrite, O_ALUSrc, O_RegWrite);
	U2: ACU port map (Buffer_ALU_Op(1 downto 0), I_Instr(5 downto 0) , O_ALUCtl(3 downto 0));

end Structural;

