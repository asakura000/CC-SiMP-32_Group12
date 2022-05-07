library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX32 is
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (31 downto 0);
           I_MUX_1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_MUX_Sel : in STD_LOGIC;
           O_MUX_Out : out STD_LOGIC_VECTOR (31 downto 0));
end MUX32;

architecture Behavioral of MUX32 is
begin
	process(I_MUX_0, I_MUX_1, I_MUX_Sel) is
	begin
		if(I_MUX_Sel = '0') then
			O_MUX_Out <= I_MUX_0;
		end if;
		if(I_MUX_Sel = '1') then
			O_MUX_Out <= I_MUX_1;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5 is
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (4 downto 0);
           I_MUX_1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  I_MUX_Sel : in STD_LOGIC;
           O_MUX_Out : out STD_LOGIC_VECTOR (4 downto 0));
end MUX5;

architecture Behavioral of MUX5 is
begin
	process(I_MUX_0, I_MUX_1, I_MUX_Sel) is
	begin
		if(I_MUX_Sel = '0') then
			O_MUX_Out <= I_MUX_0;
		end if;
		if(I_MUX_Sel = '1') then
			O_MUX_Out <= I_MUX_1;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BranchModule is
    Port ( beq : in  STD_LOGIC;
           bne : in  STD_LOGIC;
			  zero : in STD_LOGIC;
           branch : out STD_LOGIC);
end BranchModule;

architecture Behavioral of BranchModule is
begin
	process(beq, bne, zero) is
	begin
		if((beq = '1') AND (zero = '1')) then
			branch <= '1';
		elsif((bne = '1') AND (zero = '0')) then
			branch <= '1';
		else
			branch <= '0';
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EXT is
    Port ( I_EXT_16 : in  STD_LOGIC_VECTOR (15 downto 0);
           O_EXT_32 : out STD_LOGIC_VECTOR (31 downto 0));
end EXT;

architecture Behavioral of EXT is
begin
	process(I_EXT_16) is
	begin
		O_EXT_32 (15 downto 0)<= I_EXT_16;
		for i in 16 to 31 loop
			O_EXT_32 (i) <= I_EXT_16 (15);
		end loop;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JumpModule is
    Port ( JumpImm : in  STD_LOGIC_VECTOR (25 downto 0);
			  PC : in  STD_LOGIC_VECTOR (31 downto 0);
           JumpAddr : out STD_LOGIC_VECTOR (31 downto 0));
end JumpModule;

architecture Behavioral of JumpModule is
begin
	process(JumpImm, PC) is
	begin
		JumpAddr (1 downto 0)<= "00";
		JumpAddr (27 downto 2)<= JumpImm;
		JumpAddr (31 downto 28) <= PC (31 downto 28);
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADD2 is
    Port ( I_ADD2_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_ADD2_B : in  STD_LOGIC_VECTOR (31 downto 0);
           O_ADD2_Out : out STD_LOGIC_VECTOR (31 downto 0));
end ADD2;

architecture Behavioral of ADD2 is
	signal Shifted_B : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
begin
	process(I_ADD2_A, I_ADD2_B) is
	begin
		Shifted_B (31 downto 2) <= I_ADD2_B (29 downto 0);
		Shifted_B (1 downto 0) <= "00";
		O_ADD2_Out <= std_logic_vector(unsigned(I_ADD2_A) + unsigned(Shifted_B));
		-- For the above line, I_ADD2_B and Shifted_B are signed but I_ADD2_A is unsigned, and I think I need the operands to match in type to add them, so I added them both as unsigned.
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADD1 is
    Port ( I_ADD1_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_ADD1_Out : out  STD_LOGIC_VECTOR (31 downto 0));
end ADD1;

architecture Behavioral of ADD1 is
begin
	process(I_ADD1_A) is
	begin
		O_ADD1_Out <= std_logic_vector(unsigned(I_ADD1_A) + 4);
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    Port ( I_PC_UPDATE : in  STD_LOGIC;
			  I_PC : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_PC : out  STD_LOGIC_VECTOR (31 downto 0));
end PC;

architecture Behavioral of PC is
begin
	process(I_PC_UPDATE, I_PC) is
	begin
		if(I_PC_UPDATE = '1') then
			O_PC <= I_PC;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( I_ALU_EN : in  STD_LOGIC;
			  I_ALU_CTL : in  STD_LOGIC_VECTOR (3 downto 0);
			  I_ALU_A : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_ALU_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  O_ALU_Out : out  STD_LOGIC_VECTOR (31 downto 0);
			  O_ALU_Zero : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
begin
	process(I_ALU_EN, I_ALU_CTL, I_ALU_A, I_ALU_B) is
	begin
		if(I_ALU_EN = '1') then
			case I_ALU_CTL is
				when "0010" =>
					O_ALU_Out <= std_logic_vector(unsigned(I_ALU_A) + unsigned(I_ALU_B));
				when "0110" =>
					O_ALU_Out <= std_logic_vector(unsigned(I_ALU_A) - unsigned(I_ALU_B));
				when others =>
					null; --Do nothing if unexpected input.
			end case;
		end if;
	end process;
end Behavioral;