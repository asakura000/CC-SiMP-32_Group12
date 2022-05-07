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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity REG is
    Port ( I_REG_EN : in  STD_LOGIC;
           I_REG_WE : in  STD_LOGIC;
           I_REG_SEL_RS : in  STD_LOGIC_VECTOR (4 downto 0);
           I_REG_SEL_RT : in  STD_LOGIC_VECTOR (4 downto 0);
           I_REG_SEL_RD : in  STD_LOGIC_VECTOR (4 downto 0); --This is more of a "write register" than RD
           I_REG_DATA_RD : in  STD_LOGIC_VECTOR (31 downto 0);
           O_REG_DATA_A : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           O_REG_DATA_B : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end REG;

architecture Behavioral of REG is
	type REG_FILE is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	
	--Function to pull 32 32-bit register values from a text file,
	-- and return them as a REG_FILE
	impure function init_reg_file(FileName: in string) return REG_FILE is
		constant LINE_NUM : integer := 32;
		file fp : text;
		variable temp_REG_FILE: REG_FILE := (others => x"00000000");
		variable line_cache : line;
		variable word_cache : bit_vector (31 downto 0) := x"00000000";
	begin
		file_open(fp, FileName, read_mode);
		for i in 0 to LINE_NUM loop
			if endfile(fp) then
				exit;
			else
				readline(fp, line_cache);
				read(line_cache, word_cache);
				temp_REG_FILE(i) := to_stdlogicvector(word_cache);
			end if;
		end loop;
		file_close(fp);
		return temp_REG_FILE;
	end function;
	
	signal Registers : REG_FILE := init_reg_file("REG_init.txt");
begin
	process(I_REG_EN, I_REG_WE, I_REG_SEL_RS, I_REG_SEL_RT, I_REG_SEL_RD, I_REG_DATA_RD)
	variable RS, RT, RD : integer := 0;
	begin
		if(I_REG_EN = '1') then
			RS := to_integer(unsigned(I_REG_SEL_RS));
			RT := to_integer(unsigned(I_REG_SEL_RT));
			RD := to_integer(unsigned(I_REG_SEL_RD));
			O_REG_DATA_A <= Registers(RS);
			O_REG_DATA_B <= Registers(RT);
			if (I_REG_WE = '1') then
				if(I_REG_SEL_RD /= x"00000000") then
					Registers(RD) <= I_REG_DATA_RD;
				end if;
			end if;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use STD.textio.all;

entity ROM is
    Port ( I_ROM_EN : in  STD_LOGIC;
           I_ROM_ADDR : in  STD_LOGIC_VECTOR (31 downto 0);
           O_ROM_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end ROM;

architecture Behavioral of ROM is

	-- declare rom type as array of 256 bytes (64 instructions)
	type rom_type is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
	
	-- declare an instance of rom_type called ROM 
	signal ROM : rom_type;
	
	-- function that initalizes a ROM from a text file 
	impure function initialize_ROM(FileName : in string) return rom_type is
		-- max capacity for ROM is 256 bytes
		constant MAX_LINES : integer := 256;
		file fp : text;
		-- this will be what is returned from the function: 
		-- a ROM instance where all elems not defined from text file will be initialized to all zeros 
		variable temp_mem : rom_type := (others => x"00");
		-- a line from the text file defined as a variable 
		variable line_cache : line;
		-- when the line is read from file, it will have 32 bits
		variable word_cache : bit_vector (31 downto 0); 
		-- split each line into 4 bytes 
		variable byte_1 : STD_LOGIC_VECTOR(7 downto 0);
		variable byte_2 : STD_LOGIC_VECTOR(7 downto 0);
		variable byte_3 : STD_LOGIC_VECTOR(7 downto 0);
		variable byte_4 : STD_LOGIC_VECTOR(7 downto 0);
		-- the "raw" input from each line of of the text file
		variable temp_word : STD_LOGIC_VECTOR(31 downto 0);
		-- "pointer" that defines the index of the first byte in each instruction
		variable first_byte : integer;
		
	begin 
		file_open(fp, FileName, read_mode);
		for i in 0 to MAX_LINES loop
			if endfile(fp) then
				exit;
			else
				-- for each line of the text file:
				-- 1) read it in as a single 32-bit thing
				-- 2) split this up into 4 things of 8-bits each
				-- 3) starting from the index (that is incremented by 4 from the previous instruction),
				-- 4) store all 4 bytes for this instruction, each in its own index
				readline(fp, line_cache);
				read(line_cache, word_cache);
				temp_word := to_stdlogicvector(word_cache);
				byte_1 := temp_word(31 downto 24);
				byte_2 := temp_word(23 downto 16);
				byte_3 := temp_word(15 downto 8);
				byte_4 := temp_word(7 downto 0);
				first_byte := i * 4;
				temp_mem(first_byte) := byte_1;
				temp_mem(first_byte + 1) := byte_2;
				temp_mem(first_byte + 2) := byte_3;
				temp_mem(first_byte + 3) := byte_4;
			end if;
		end loop;
		file_close(fp);
		return temp_mem;
	end function;
		
begin

-- initialize the ROM with the text file
ROM <= initialize_ROM("Fibonacci.bin");
	
fetch_instruction: process (I_ROM_EN, I_ROM_ADDR)
	begin
	
		if I_ROM_EN = '1' then 
			O_ROM_DATA <= ROM(to_integer(unsigned(I_ROM_ADDR)));
			
		end if;
	end process;
end Behavioral;