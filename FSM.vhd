library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.Common.all;

entity FSM is
    Port ( I_FSM_CLK : in  STD_LOGIC;
           I_FSM_EN : in  STD_LOGIC;
           I_FSM_INST : in  STD_LOGIC_VECTOR (31 downto 0);
           O_FSM_IF : out  STD_LOGIC;
           O_FSM_ID : out  STD_LOGIC;
           O_FSM_EX : out  STD_LOGIC;
           O_FSM_ME : out  STD_LOGIC;
           O_FSM_WB : out  STD_LOGIC);
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


