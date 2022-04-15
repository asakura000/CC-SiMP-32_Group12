library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DEC is
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
end DEC;

architecture Behavioral of DEC is

begin
	process(I_DEC_EN)
	begin
		if(I_DEC_EN = '1') then
		case I_DEC_Opcode is
			--R Type Instructions
			--ADDU, SUBU
			when "000000" =>
				O_DEC_RegDst <= '1';
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0';
				O_DEC_ALUOp <= "10";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '0';
				O_DEC_RegWrite <= '1';
			--I Type Instructions
			--ADDI
			when "001000" =>
				O_DEC_RegDst <= '0';
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0';
				O_DEC_ALUOp <= "00";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '1';
				O_DEC_RegWrite <= '1';
			--ADDIU
			when "001001" =>
				O_DEC_RegDst <= '0';
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0';
				O_DEC_ALUOp <= "00";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '1';
				O_DEC_RegWrite <= '1';
			--BEQ
			when "000100" =>
				O_DEC_RegDst <= '0'; --Not used
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '1';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0'; --Not used
				O_DEC_ALUOp <= "01";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '0';
				O_DEC_RegWrite <= '0';
			--BNE
			when "000101" =>
				O_DEC_RegDst <= '0'; --Not used
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '1';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0'; --Not used
				O_DEC_ALUOp <= "01";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '0';
				O_DEC_RegWrite <= '0';
			--LW
			when "010011" =>
				O_DEC_RegDst <= '0';
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '1';
				O_DEC_MemtoReg <= '1';
				O_DEC_ALUOp <= "00";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '1';
				O_DEC_RegWrite <= '1';
			--SW
			when "011011" =>
				O_DEC_RegDst <= '0'; --Not used
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0'; --Not used
				O_DEC_ALUOp <= "00";
				O_DEC_MemWrite <= '1';
				O_DEC_ALUSrc <= '1';
				O_DEC_RegWrite <= '0';
			--J Type Instructions
			--J
			when "000010" =>
				O_DEC_RegDst <= '0'; --Not used
				O_DEC_Jump <= '1';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0'; --Not used
				O_DEC_ALUOp <= "00"; --Not used
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '0'; --Not used
				O_DEC_RegWrite <= '0';
			--N/A (Sets all controls to zero if instruction is not found)
			when others =>
				O_DEC_RegDst <= '0';
				O_DEC_Jump <= '0';
				O_DEC_Beq <= '0';
				O_DEC_Bne <= '0';
				O_DEC_MemRead <= '0';
				O_DEC_MemtoReg <= '0';
				O_DEC_ALUOp <= "00";
				O_DEC_MemWrite <= '0';
				O_DEC_ALUSrc <= '0';
				O_DEC_RegWrite <= '0';
		end case;
		end if;
	end process;
end Behavioral;