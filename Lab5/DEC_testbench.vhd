LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY DEC_testbench IS
END DEC_testbench;
 
ARCHITECTURE behavior OF DEC_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DEC
    PORT(
         I_DEC_EN : IN  std_logic;
         I_DEC_Opcode : IN  std_logic_vector(5 downto 0);
         O_DEC_RegDst : OUT  std_logic;
         O_DEC_Jump : OUT  std_logic;
         O_DEC_Beq : OUT  std_logic;
         O_DEC_Bne : OUT  std_logic;
         O_DEC_MemRead : OUT  std_logic;
         O_DEC_MemtoReg : OUT  std_logic;
         O_DEC_ALUOp : OUT  std_logic_vector(1 downto 0);
         O_DEC_MemWrite : OUT  std_logic;
         O_DEC_ALUSrc : OUT  std_logic;
         O_DEC_RegWrite : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_DEC_EN : std_logic := '0';
   signal I_DEC_Opcode : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal O_DEC_RegDst : std_logic;
   signal O_DEC_Jump : std_logic;
   signal O_DEC_Beq : std_logic;
   signal O_DEC_Bne : std_logic;
   signal O_DEC_MemRead : std_logic;
   signal O_DEC_MemtoReg : std_logic;
   signal O_DEC_ALUOp : std_logic_vector(1 downto 0);
   signal O_DEC_MemWrite : std_logic;
   signal O_DEC_ALUSrc : std_logic;
   signal O_DEC_RegWrite : std_logic;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DEC PORT MAP (
          I_DEC_EN => I_DEC_EN,
          I_DEC_Opcode => I_DEC_Opcode,
          O_DEC_RegDst => O_DEC_RegDst,
          O_DEC_Jump => O_DEC_Jump,
          O_DEC_Beq => O_DEC_Beq,
          O_DEC_Bne => O_DEC_Bne,
          O_DEC_MemRead => O_DEC_MemRead,
          O_DEC_MemtoReg => O_DEC_MemtoReg,
          O_DEC_ALUOp => O_DEC_ALUOp,
          O_DEC_MemWrite => O_DEC_MemWrite,
          O_DEC_ALUSrc => O_DEC_ALUSrc,
          O_DEC_RegWrite => O_DEC_RegWrite
        );
		  
   -- Stimulus process
   stim_proc: process
   begin
		I_DEC_EN <= '1';
		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- insert stimulus here
		--Testing ADDU and SUBU
      I_DEC_Opcode <= "000000";
		wait for 100 ns;
		
		--Testing ADDI
      I_DEC_Opcode <= "001000";
		wait for 100 ns;
		
		--Testing ADDIU
      I_DEC_Opcode <= "001001";
		wait for 100 ns;
		
		--Testing BEQ
      I_DEC_Opcode <= "000100";
		wait for 100 ns;
		
		--Testing BNE
      I_DEC_Opcode <= "000101";
		wait for 100 ns;
		
		--Testing LW
      I_DEC_Opcode <= "010011";
		wait for 100 ns;
		
		--Testing SW
      I_DEC_Opcode <= "011011";
		wait for 100 ns;
		
		--Testing J
      I_DEC_Opcode <= "000010";
		wait for 100 ns;
		
		--Testing Unplanned input
      I_DEC_Opcode <= "111111";
		wait for 100 ns;
		
      wait;
   end process;

END;
