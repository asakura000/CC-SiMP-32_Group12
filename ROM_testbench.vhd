LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.all;
 
ENTITY ROM_testbench IS
END ROM_testbench;
 
ARCHITECTURE behavior OF ROM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ROM
    PORT(
         I_ROM_EN : IN  std_logic;
         I_ROM_ADDR : IN  std_logic_vector(31 downto 0);
         O_ROM_DATA : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_ROM_EN : std_logic := '0';
   signal I_ROM_ADDR : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal O_ROM_DATA : std_logic_vector(31 downto 0);
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM PORT MAP (
          I_ROM_EN => I_ROM_EN,
          I_ROM_ADDR => I_ROM_ADDR,
          O_ROM_DATA => O_ROM_DATA
        );

   -- Stimulus process
   stim_proc: process
	variable num_lines : integer := 12;
	variable address : integer := 0;
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;
		
      -- insert stimulus here 
		for i in 0 to num_lines loop
			I_ROM_EN <= '1';
			I_ROM_ADDR <= STD_LOGIC_VECTOR(to_unsigned(address, I_ROM_ADDR'length));
			wait for 10 ns;
			I_ROM_EN <= '0';
			address := address + 4;
			wait for 10 ns;
		end loop;

      wait;
   end process;

END;
