library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity ACU is
    Port ( I_ACU_ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           I_ACU_Funct : in  STD_LOGIC_VECTOR (5 downto 0);
           O_ACU_CTL : out  STD_LOGIC_VECTOR (3 downto 0));
end ACU;

architecture Behavioral of ACU is

begin

ACU_process: process(I_ACU_ALUOp, I_ACU_Funct)
begin
	case I_ACU_ALUOp is
		when "00" =>	-- lw, sw, addiu, j
			O_ACU_CTL <= "0010";
		when "01" =>	-- beq, bne
			O_ACU_CTL <= "0110";
		when "10" =>	-- R-type
			case I_ACU_Funct is
				when "100001" =>	-- addu
					O_ACU_CTL <= "0010";
				when others =>		-- addu is only "valid" funct in our design
					O_ACU_CTL <= "0000";
			end case;
		when others => -- any other ALU Op code (basically just "11")
			O_ACU_CTL <= "0000";
	end case;
end process;
							
end Behavioral;

