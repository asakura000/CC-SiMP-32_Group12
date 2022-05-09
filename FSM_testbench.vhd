LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use work.Common.all;
 
ENTITY FSM_testbench IS
END FSM_testbench;
 
ARCHITECTURE behavior OF FSM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSM
    PORT(
         I_FSM_CLK : IN  std_logic;
         I_FSM_EN : IN  std_logic;
         I_FSM_INST : IN  std_logic_vector(31 downto 0);
         O_FSM_IF : OUT  std_logic;
         O_FSM_ID : OUT  std_logic;
         O_FSM_EX : OUT  std_logic;
         O_FSM_ME : OUT  std_logic;
         O_FSM_WB : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_FSM_CLK : std_logic := '0';
   signal I_FSM_EN : std_logic := '0';
   signal I_FSM_INST : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal O_FSM_IF : std_logic;
   signal O_FSM_ID : std_logic;
   signal O_FSM_EX : std_logic;
   signal O_FSM_ME : std_logic;
   signal O_FSM_WB : std_logic;

   -- Clock period definitions
   constant I_FSM_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSM PORT MAP (
          I_FSM_CLK => I_FSM_CLK,
          I_FSM_EN => I_FSM_EN,
          I_FSM_INST => I_FSM_INST,
          O_FSM_IF => O_FSM_IF,
          O_FSM_ID => O_FSM_ID,
          O_FSM_EX => O_FSM_EX,
          O_FSM_ME => O_FSM_ME,
          O_FSM_WB => O_FSM_WB
        );

   -- Clock process definitions
   I_FSM_CLK_process :process
   begin
		I_FSM_CLK <= '0';
		wait for I_FSM_CLK_period/2;
		I_FSM_CLK <= '1';
		wait for I_FSM_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	

      -- insert stimulus here 
		I_FSM_EN <= '1'; 
		
		I_FSM_INST <= X"aaaaaaaa";
		wait for 50 ns;
		
		I_FSM_INST <= X"bbbbbbbb";
		wait for 50 ns;
		
		I_FSM_INST <= X"cccccccc";
		wait for 50 ns;
		
		I_FSM_INST <= X"dddddddd";
		wait for 50 ns;
		
		I_FSM_INST <= X"eeeeeeee";
		wait for 50 ns;
		
		I_FSM_INST <= X"0000000c";
		wait for 100 ns;
		
		I_FSM_EN <= '0';
      wait;
   end process;

END;
