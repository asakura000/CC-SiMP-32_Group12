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
