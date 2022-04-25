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
ROM <= initialize_ROM("ROM_init.txt");
	
fetch_instruction: process (I_ROM_EN, I_ROM_ADDR)
	begin
	
		if I_ROM_EN = '1' then 
			O_ROM_DATA <= ROM(to_integer(unsigned(I_ROM_ADDR)));
			
		end if;
	end process;
end Behavioral;

