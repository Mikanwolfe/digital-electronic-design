--------------------------------------------------------------------------------
-- Engineer: 		 Jimmy Trac (101624964) and Tom Kelsall (101608706)
-- Module Name:    MSM_StepperMotor - Behavioral
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MSM_StepperMotor is
    Port ( reset : in  std_logic;
           clock : in  std_logic;
           cw  : in  std_logic;
           en  : in  std_logic;
			  debugLED : out std_logic;
           O0 : out std_logic;
           O1 : out std_logic;
           O2 : out std_logic;
           O3 : out std_logic
           );
end MSM_StepperMotor;

architecture Behavioral of MSM_StepperMotor is

	type   StateType is (S0, S1, S2, S3); 
	signal state, nextState : StateType;

begin

	SynchronousProcess:
	process (reset, clock)
		begin
		   if (reset = '1') then
			  state <= S0;
		   elsif (rising_edge(clock)) then
			  state <= nextState;
			end if;
	end process SynchronousProcess;
	

	CombinationalProcess:
	process (reset, clock, state, cw, en)
	begin
	
		--Default states
		
		nextState <= S0;
		O0 <= '0';
		O1 <= '0';
		O2 <= '0';
		O3 <= '0';
		debugLED <= '0';
		
		if (reset = '1') then 
			debugLED <= '1';
		end if;
		
		if (en = '1') then
		
			case state is
			
				when S0 =>
					O0 <= '1'; 		--Moore Machine - Only depends on state;
					if (cw = '1') then 
						nextState <= S1;
					else
						nextState <= S3;
					end if;
				
				when S1 =>
					O2 <= '1'; 		--Moore Machine - Only depends on state;
					if (cw = '1') then 
						nextState <= S2;
					else
						nextState <= S0;
					end if;
				
				when S2 =>
					O1 <= '1'; 		--Moore Machine - Only depends on state;
					if (cw = '1') then 
						nextState <= S3;
					else
						nextState <= S1;
					end if;
					
				when S3 =>
					O3 <= '1'; 		--Moore Machine - Only depends on state;
					if (cw = '1') then 
						nextState <= S0;
					else
						nextState <= S2;
					end if;
				
			end case;
			
		else
			nextState <= state;
		end if;
		
	end process CombinationalProcess;

end Behavioral;