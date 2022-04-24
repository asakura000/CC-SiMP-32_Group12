library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity RAM is
    Port ( I_RAM_EN : in  STD_LOGIC;
           I_RAM_RE : in  STD_LOGIC;
           I_RAM_WE : in  STD_LOGIC;
           I_RAM_ADDR : in  STD_LOGIC_VECTOR (31 downto 0);
           I_RAM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           O_RAM_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end RAM;

architecture Behavioral of RAM is
	
	type RAM256x8 is array(0 to 255) of std_logic_vector(7 downto 0);
	
	--function to load the contents of a file into RAM memory
	--will read up to 64 lines of the file 
	impure function init_buf(FileName: in string) return RAM256x8 is
		constant LINE_NUM : integer := 64;
		file fp : text;
		variable temp_mem: RAM256x8 := (others => x"00");
		variable line_cache : line;
		variable byte_cache : bit_vector (31 downto 0) := x"00000000";
	begin
		file_open(fp, FileName, read_mode);
		for i in 0 to LINE_NUM loop
			if endfile(fp) then
				exit;
			else 
				readline(fp, line_cache);
				read(line_cache, byte_cache);
				temp_mem(i*4) := to_stdlogicvector(byte_cache)(31 downto 24);
				temp_mem((i*4)+1) := to_stdlogicvector(byte_cache)(23 downto 16);
				temp_mem((i*4)+2) := to_stdlogicvector(byte_cache)(15 downto 8);
				temp_mem((i*4)+3) := to_stdlogicvector(byte_cache)(7 downto 0);
			end if;
		end loop;
		file_close(fp);
		return temp_mem;
	end function;
	
	-- init mem from the file 
	signal mem : RAM256x8 := init_buf("RAM_init.txt");
	
begin	
	process (I_RAM_EN, I_RAM_WE, I_RAM_RE, I_RAM_DATA, I_RAM_ADDR)
	begin
		-- enable = '1'
		if (I_RAM_EN = '1') then 
			-- write = '1'
			if (I_RAM_WE = '1') then
				mem(to_integer(unsigned(I_RAM_ADDR)) - 8192) <= I_RAM_DATA(31 downto 24);
				mem(to_integer(unsigned(I_RAM_ADDR)) - 8191) <= I_RAM_DATA(23 downto 16);
				mem(to_integer(unsigned(I_RAM_ADDR)) - 8190) <= I_RAM_DATA(15 downto 8);
				mem(to_integer(unsigned(I_RAM_ADDR)) - 8189) <= I_RAM_DATA(7 downto 0);
			end if;
			-- read = '1'
			if (I_RAM_RE = '1') then
				-- reads a word automatically 
				O_RAM_DATA <= mem(to_integer(unsigned(I_RAM_ADDR)) - 8192);
			end if;
		end if;
	end process;
end Behavioral;


