LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY RAM_testbench IS
END RAM_testbench;
 
ARCHITECTURE behavior OF RAM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAM
    PORT(
         I_RAM_EN : IN  std_logic;
         I_RAM_RE : IN  std_logic;
         I_RAM_WE : IN  std_logic;
         I_RAM_ADDR : IN  std_logic_vector(31 downto 0);
         I_RAM_DATA : IN  std_logic_vector(31 downto 0);
         O_RAM_DATA : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_RAM_EN : std_logic := '0';
   signal I_RAM_RE : std_logic := '0';
   signal I_RAM_WE : std_logic := '0';
   signal I_RAM_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal I_RAM_DATA : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal O_RAM_DATA : std_logic_vector(31 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          I_RAM_EN => I_RAM_EN,
          I_RAM_RE => I_RAM_RE,
          I_RAM_WE => I_RAM_WE,
          I_RAM_ADDR => I_RAM_ADDR,
          I_RAM_DATA => I_RAM_DATA,
          O_RAM_DATA => O_RAM_DATA
        );
		  
   -- Stimulus process
   stim_proc: process
      variable num_lines: integer := 32; 
		-- the RAM range is 0x00002000 - 0x000020FF
		-- that is 8192 to 8447 in decimal 
		variable address : integer := 8192;
		begin 
			-- hold reset state for 10 ns
			wait for 10ns;
			-- TEST #01
			-- read the first 128 bytes of the RAM 
			-- i.e from 8192 to 8319
			-- 0x00002000 - 0x0000207F
 			for i in 0 to (num_lines-1) loop
				I_RAM_EN <= '1';
				I_RAM_RE <= '1';
				I_RAM_WE <= '0';
				I_RAM_ADDR <= std_logic_vector(to_unsigned(address, I_RAM_ADDR'length));
				wait for 10 ns;
				I_RAM_EN <= '0';
				address := address + 4;
				wait for 10 ns;
			end loop;
			-- stop the RAM 
			I_RAM_EN <= '0';
			I_RAM_RE <= '0';
			I_RAM_WE <= '0';
			wait for 10ns;
			-- TEST #02
			-- write the first 8 bytes of the RAM without WE asserted 
			-- i.e from 8192 to 8199
			-- 0x00002000 - 0x00002007
			I_RAM_EN <= '1';
			I_RAM_RE <= '1';
			I_RAM_WE <= '0';
			I_RAM_ADDR <= x"00002000";
			I_RAM_DATA <= x"66778899";
			wait for 5 ns;
			I_RAM_EN <= '0';
			wait for 5 ns;
			I_RAM_EN <= '1';
			I_RAM_ADDR <= x"00002004";
			I_RAM_DATA <= x"AABBCCDD";
			wait for 5 ns;
			I_RAM_EN <= '0';
			wait for 5 ns;
			-- stop the RAM
			I_RAM_EN <= '0';
			I_RAM_RE <= '0';
			I_RAM_WE <= '0';
			wait for 10 ns;
			--TEST #03
			--read the first 8 bytes of the RAM 
			--verify the RAM content cannot be overwritten
			-- if WE is not asserted 
			I_RAM_EN <= '1';
			I_RAM_RE <= '1';
			I_RAM_ADDR <= x"00002000";
			wait for 10ns;
			I_RAM_EN<= '0';
			wait for 10 ns;
			I_RAM_EN <= '1';
			I_RAM_ADDR <= x"00002004";
			wait for 10 ns;
			I_RAM_EN <= '0';
			wait for 10 ns;
			-- stop the RAM 
			I_RAM_EN <= '0';
			I_RAM_RE <= '0';
			I_RAM_WE <= '0';
			wait for 10 ns;
			-- Test #4
			-- write the first 8 bytes of the RAM with WE asserted 
			-- i.e from 8192 to 8199 
			-- 0x00002000 - 0x00002007
			I_RAM_EN <= '1';
			I_RAM_RE <= '0';
			I_RAM_WE <= '1';
			I_RAM_ADDR <= x"00002000";
			I_RAM_DATA <= x"66778899";
			wait for 5ns;
			I_RAM_EN <= '0';
			wait for 5 ns;
			I_RAM_EN <= '1';
			I_RAM_RE <= '0';
			I_RAM_WE <= '1';
			I_RAM_ADDR <= x"00002004";
			I_RAM_DATA <= x"AABBCCDD";
			wait for 5 ns;
			I_RAM_EN <= '0';
			wait for 5 ns;
			-- stop the RAM 
			I_RAM_EN <= '0';
			I_RAM_RE <= '0';
			I_RAM_WE <= '0';
			wait for 10 ns;
			-- TEST #05
			-- read the frist 8 bytes of RAM 
			-- verify that the RAM content can be updated when needed 
			I_RAM_EN <= '1';
			I_RAM_RE <= '1';
			I_RAM_WE <= '0';
			I_RAM_ADDR <= x"00002000";
			I_RAM_DATA <= x"00000000";
			wait for 10ns;
			I_RAM_EN <= '0';
			wait for 10 ns;
			I_RAM_EN <= '1';
			I_RAM_RE <= '1';
			I_RAM_WE <= '0';
			I_RAM_ADDR <= x"00002004";
			wait for 10 ns;
			--end of test 
			--disable the module 
			I_RAM_EN <= '0';
			I_RAM_RE <= '0';
			I_RAM_WE <= '0';
      wait;
   end process;

END;
