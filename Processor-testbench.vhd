LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ProcessorTestbench IS
END ProcessorTestbench;
 
ARCHITECTURE behavior OF ProcessorTestbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CCSiMP32
    PORT(
         I_EN : IN  std_logic;
         I_CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_EN : std_logic := '0';
   signal I_CLK : std_logic := '0';

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CCSiMP32 PORT MAP (
          I_EN => I_EN,
          I_CLK => I_CLK
        );

   -- Clock process definitions
   I_CLK_process :process
   begin
		I_CLK <= '0';
		wait for I_CLK_period/2;
		I_CLK <= '1';
		wait for I_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 10 ns;	
	I_EN <= '1';
      wait;
   end process;

END;
