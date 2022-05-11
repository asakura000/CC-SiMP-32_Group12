library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX32 is
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           I_MUX_1 : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  I_MUX_Sel : in STD_LOGIC := '0';
           O_MUX_Out : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
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
    Port ( I_MUX_0 : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           I_MUX_1 : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
			  I_MUX_Sel : in STD_LOGIC := '0';
           O_MUX_Out : out STD_LOGIC_VECTOR (4 downto 0) := (others => '0'));
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
    Port ( beq : in  STD_LOGIC := '0';
           bne : in  STD_LOGIC := '0';
			  zero : in STD_LOGIC := '0';
           branch : out STD_LOGIC := '0');
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
    Port ( I_EXT_16 : in  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
           O_EXT_32 : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
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
    Port ( JumpImm : in  STD_LOGIC_VECTOR (25 downto 0) := (others => '0');
			  PC : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           JumpAddr : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
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

entity ADD2 is --Includes shift left by 2
    Port ( I_ADD2_A : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); --PC+4 goes to this one
			  I_ADD2_B : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); --Immediate goes to this one
           O_ADD2_Out : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end ADD2;

architecture Behavioral of ADD2 is
begin
	process(I_ADD2_A, I_ADD2_B) is
	begin
		O_ADD2_Out <= std_logic_vector(unsigned(I_ADD2_A) + unsigned((I_ADD2_B (29 downto 0))&"00"));
		-- For the above line, I_ADD2_B and Shifted_B are signed but I_ADD2_A is unsigned, and I think I need the operands to match in type to add them, so I added them both as unsigned.
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADD1 is
    Port ( I_ADD1_A : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  O_ADD1_Out : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
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
    Port ( I_PC_UPDATE : in  STD_LOGIC := '0';
			  I_PC : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  O_PC : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end PC;

architecture Behavioral of PC is
begin
	process(I_PC_UPDATE, I_PC) is
	begin
		if rising_edge(I_PC_UPDATE) then
			if(I_PC_UPDATE = '1') then
				O_PC <= I_PC;
			end if;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( I_ALU_EN : in  STD_LOGIC := '0';
			  I_ALU_CTL : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  I_ALU_A : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  I_ALU_B : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  O_ALU_Out : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
			  O_ALU_Zero : out  STD_LOGIC := '0');
end ALU;

architecture Behavioral of ALU is
begin
	process(I_ALU_EN, I_ALU_CTL, I_ALU_A, I_ALU_B) is
	begin
	if rising_edge(I_ALU_EN) then
		if(I_ALU_EN = '1') then
			case I_ALU_CTL is
				when "0010" =>
					O_ALU_Out <= std_logic_vector(unsigned(I_ALU_A) + unsigned(I_ALU_B));
					if(std_logic_vector(unsigned(I_ALU_A) + unsigned(I_ALU_B)) = x"00000000") then
				O_ALU_Zero <= '1';
			else
				O_ALU_Zero <= '0';
			end if;
				when "0110" =>
					O_ALU_Out <= std_logic_vector(unsigned(I_ALU_A) - unsigned(I_ALU_B));
					if(std_logic_vector(unsigned(I_ALU_A) - unsigned(I_ALU_B)) = x"00000000") then
				O_ALU_Zero <= '1';
			else
				O_ALU_Zero <= '0';
			end if;
				when others =>
					null; --Do nothing if unexpected input.
			end case;
		end if;
	end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR1bit is
    Port ( I_Left : in  STD_LOGIC := '0';
			  I_Right : in  STD_LOGIC := '0';
			  O_OR_GATE : out STD_LOGIC := '0');
end OR1bit;

architecture Behavioral of OR1bit is
begin
	process(I_Left, I_Right) is
	begin
		O_OR_GATE <= I_Left OR I_Right;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND1bit is
    Port ( I_Left : in  STD_LOGIC := '0';
			  I_Right : in  STD_LOGIC := '0';
			  O_AND_GATE : out STD_LOGIC := '0');
end AND1bit;

architecture Behavioral of AND1bit is
begin
	process(I_Left, I_Right) is
	begin
		O_AND_GATE <= I_Left AND I_Right;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Common is
type processor_state is (S_INIT, S_IF, S_ID, S_EX, S_ME, S_WB, S_STOP); 
end Common;

package body Common is
 
end Common;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.Common.all;

entity FSM is
    Port ( I_FSM_CLK : in  STD_LOGIC := '0';
           I_FSM_EN : in  STD_LOGIC := '0';
           I_FSM_INST : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           O_FSM_IF : out  STD_LOGIC := '0';
           O_FSM_ID : out  STD_LOGIC := '0';
           O_FSM_EX : out  STD_LOGIC := '0';
           O_FSM_ME : out  STD_LOGIC := '0';
           O_FSM_WB : out  STD_LOGIC := '0');
end FSM;

architecture Behavioral of FSM is
	signal state : processor_state := S_INIT; 
begin
	process(I_FSM_CLK)
	begin
		if rising_edge(I_FSM_CLK) then
			if I_FSM_EN = '1' then
					if I_FSM_INST = X"0000000c" then
						state <= S_STOP;
					else
						if state = S_INIT then state <= S_IF;
						elsif state = S_IF then state <= S_ID;
						elsif state = S_ID then state <= S_EX;
						elsif state = S_EX then state <= S_ME;
						elsif state = S_ME then state <= S_WB;
						elsif state = S_WB then state <= S_IF;
						end if;
					end if;
			else 
				if state = S_INIT then state <= S_INIT;
				else state <= S_STOP;
				end if;
			end if;
		end if;
	end process;
	
	process(state)
	begin
		if state = S_IF then
			O_FSM_IF <= '1';
			O_FSM_ID <= '0';
			O_FSM_EX <= '0';
			O_FSM_ME <= '0';
			O_FSM_WB <= '0';
		elsif state = S_ID then
			O_FSM_IF <= '0';
			O_FSM_ID <= '1';
			O_FSM_EX <= '0';
			O_FSM_ME <= '0';
			O_FSM_WB <= '0';
		elsif state = S_EX then
			O_FSM_IF <= '0';
			O_FSM_ID <= '0';
			O_FSM_EX <= '1';
			O_FSM_ME <= '0';
			O_FSM_WB <= '0';
		elsif state = S_ME then
			O_FSM_IF <= '0';
			O_FSM_ID <= '0';
			O_FSM_EX <= '0';
			O_FSM_ME <= '1';
			O_FSM_WB <= '0';
		elsif state = S_WB then
			O_FSM_IF <= '0';
			O_FSM_ID <= '0';
			O_FSM_EX <= '0';
			O_FSM_ME <= '0';
			O_FSM_WB <= '1';
		else
			O_FSM_IF <= '0';
			O_FSM_ID <= '0';
			O_FSM_EX <= '0';
			O_FSM_ME <= '0';
			O_FSM_WB <= '0';
		end if;
	end process;

end Behavioral;