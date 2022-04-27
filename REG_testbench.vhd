LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY REG_testbench IS
END REG_testbench;
 
ARCHITECTURE behavior OF REG_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT REG
    PORT(
         I_REG_EN : IN  std_logic;
         I_REG_WE : IN  std_logic;
         I_REG_SEL_RS : IN  std_logic_vector(4 downto 0);
         I_REG_SEL_RT : IN  std_logic_vector(4 downto 0);
         I_REG_SEL_RD : IN  std_logic_vector(4 downto 0);
         I_REG_DATA_RD : IN  std_logic_vector(31 downto 0);
         O_REG_DATA_A : OUT  std_logic_vector(31 downto 0);
         O_REG_DATA_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal I_REG_EN : std_logic := '0';
   signal I_REG_WE : std_logic := '0';
   signal I_REG_SEL_RS : std_logic_vector(4 downto 0) := (others => '0');
   signal I_REG_SEL_RT : std_logic_vector(4 downto 0) := (others => '0');
   signal I_REG_SEL_RD : std_logic_vector(4 downto 0) := (others => '0');
   signal I_REG_DATA_RD : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal O_REG_DATA_A : std_logic_vector(31 downto 0);
   signal O_REG_DATA_B : std_logic_vector(31 downto 0);
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: REG PORT MAP (
          I_REG_EN => I_REG_EN,
          I_REG_WE => I_REG_WE,
          I_REG_SEL_RS => I_REG_SEL_RS,
          I_REG_SEL_RT => I_REG_SEL_RT,
          I_REG_SEL_RD => I_REG_SEL_RD,
          I_REG_DATA_RD => I_REG_DATA_RD,
          O_REG_DATA_A => O_REG_DATA_A,
          O_REG_DATA_B => O_REG_DATA_B
        );
		  
   -- Stimulus process
   stim_proc: process
	variable index : integer := 0;
	constant NUM_OF_REGISTER : integer := 32;
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;	
      -- show all register values
		for i in 0 to (NUM_OF_REGISTER/2-1) loop
			I_REG_EN <= '1';
			I_REG_SEL_RS <= std_logic_vector(to_unsigned(index, I_REG_SEL_RS'length));
			I_REG_SEL_RT <= std_logic_vector(to_unsigned(index+1, I_REG_SEL_RS'length));
			wait for 10 ns;
			I_REG_EN <= '0';
			index := index + 2;
			wait for 10 ns;
		end loop;
		-- attemp to update register values with WE disabled
		I_REG_WE <= '0';
		for i in 0 to (NUM_OF_REGISTER-1) loop
			I_REG_EN <= '1';
			I_REG_SEL_RD <= std_logic_vector(to_unsigned(i, I_REG_SEL_RS'length));
			I_REG_DATA_RD <= x"00000000";
			wait for 5 ns;
			I_REG_EN <= '0';
			wait for 5 ns;
		end loop;
		-- show all register values
		index := 0;
		I_REG_WE <= '0';
		for i in 0 to (NUM_OF_REGISTER/2-1) loop
			I_REG_EN <= '1';
			I_REG_SEL_RS <= std_logic_vector(to_unsigned(index, I_REG_SEL_RS'length));
			I_REG_SEL_RT <= std_logic_vector(to_unsigned(index+1, I_REG_SEL_RS'length));
			wait for 10 ns;
			I_REG_EN <= '0';
			index := index + 2;
			wait for 10 ns;
		end loop;
		-- attemp to update register values with WE enabled
		I_REG_WE <= '1';
		for i in 0 to (NUM_OF_REGISTER-1) loop
			I_REG_EN <= '1';
			I_REG_SEL_RD <= std_logic_vector(to_unsigned(i, I_REG_SEL_RS'length));
			I_REG_DATA_RD <= x"00000000";
			wait for 5 ns;
			I_REG_EN <= '0';
			wait for 5 ns;
		end loop;
		-- show all register values
		index := 0;
		I_REG_WE <= '0';
		for i in 0 to (NUM_OF_REGISTER/2-1) loop
			I_REG_EN <= '1';
			I_REG_SEL_RS <= std_logic_vector(to_unsigned(index, I_REG_SEL_RS'length));
			I_REG_SEL_RT <= std_logic_vector(to_unsigned(index+1, I_REG_SEL_RS'length));
			wait for 10 ns;
			I_REG_EN <= '0';
			index := index + 2;
			wait for 10 ns;
		end loop;
      wait;
   end process;
END;