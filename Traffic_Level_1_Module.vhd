----------------------------------------------------------------------------------
-- Traffic_Level_1.vhd
--
-- Traffic light system to control an intersection
--
-- Accepts inputs from two car sensors and two pedestrian call buttons
-- Controls two sets of lights consisting of Red, Amber and Green traffic lights and
-- a pedestrian walk light.
--
-- Written by Jimmy Trac and Tom Kelsall
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Traffic_Level_1_Module is

    Port ( Reset      : in   STD_LOGIC;
           Clock      : in   STD_LOGIC;
           
           -- for debug
           debugLED   : out  std_logic;
           LEDs       : out  std_logic_vector(2 downto 0);

           -- Car and pedestrian buttons
           CarEW      : in   STD_LOGIC; -- Car on EW road
           CarNS      : in   STD_LOGIC; -- Car on NS road
           PedEW      : in   STD_LOGIC; -- Pedestrian moving EW (crossing NS road)
           PedNS      : in   STD_LOGIC; -- Pedestrian moving NS (crossing EW road)
           
           -- Light control
           LightsEW   : out  STD_LOGIC_VECTOR (1 downto 0); -- controls EW lights
           LightsNS   : out  STD_LOGIC_VECTOR (1 downto 0); -- controls NS lights
           
			  -- Counter Control
			  CountRST		 : out STD_LOGIC;
           WalkExpired	 : in  STD_LOGIC;
           AmberExpired	 : in  STD_LOGIC;
           GreenExpired	 : in  STD_LOGIC;
			  
			  AmberKick		 : out STD_LOGIC;
			  
			  -- PedMem (Pedestrian Memory) Control
			  PedRST			 : out STD_LOGIC;
			  PedSet			 : out STD_LOGIC;
			  PedHigh		 : in  STD_LOGIC
			  
           );
			  
end Traffic_Level_1_Module;

architecture Behavioral of Traffic_Level_1_Module is

-- Encoding for lights
constant RED   : std_logic_vector(1 downto 0) := "00";
constant AMBER : std_logic_vector(1 downto 0) := "01";
constant GREEN : std_logic_vector(1 downto 0) := "10";
constant WALK  : std_logic_vector(1 downto 0) := "11"; -- Green + Walk

type   StateType is (NSGreen, NSAmber, EWGreen, EWAmber, NSWalk, EWWalk); 
signal state, nextState : StateType;

begin
   -- Show reset status on FPGA LED
   debugLED <= Reset;
	
	LEDs(0)	<= WalkExpired;
	LEDs(1)	<= GreenExpired;
	LEDs(2)	<= AmberExpired;

	
	SynchronousProcess:
	process (Reset, Clock)
		begin
		   if (reset = '1') then
			  state <= NSGreen;
			elsif (rising_edge(Clock)) then
			  state <= nextState;
			end if;
	end process SynchronousProcess;
	
	CombinationalProcess:
	process (state, CarEW, CarNS, PedEW, PedNS, PedHigh,
				WalkExpired, GreenExpired, AmberExpired)
		begin
			--------------------------------------------------
			--Default values for signals - prevents latches
			--------------------------------------------------
			LightsNS  <= RED;
			LightsEW  <= RED;
			CountRST  <= '0';
			AmberKick <= '0';
			PedRST	 <= '0';
			PedSet	 <= '0';
			nextState <= State;
		
			case state is
			
				-------------------------------------------------------->>
				-- North-South Lights
				-------------------------------------------------------->>
				
				when NSWalk =>
					LightsNS		 <= WALK;
					
					---------------------- Pedestrian Memory Reset Logic
					if (WalkExpired = '1') then 
						nextState	 <= NSGreen;
						PedRST <= '1'; -- Reset Memory module
					else 
						nextState	 <= NSWalk;
					end if;
					
				------------------------------------------------------------ Green

				when NSGreen =>
					LightsNS		 <= GREEN;
					
					---------------------- Counter Reset logic
					
					if (AmberExpired = '1') then
						CountRST <= '1';
						
					---------------------- Pedestrian Memory Logic (opposite side)
					
					elsif (PedHigh = '1') then
						nextState <= NSWalk;
						CountRST		 <= '1';
					
					elsif (PedEW = '1') then
						PedSet <= '1';
						AmberKick <= '1'; -- Shifts the clock to amber
						nextState <= NSAmber;
						
					---------------------- Pedestrian Logic (same side)
					
					elsif (PedNS = '1') then
						CountRST		 <= '1';
						nextState 	 <= NSWalk;
						
					---------------------- Car Logic
						
					elsif (GreenExpired = '1' and CarEW = '1') then
						nextState	 <= NSAmber;
					else
						nextState 	 <= NSGreen;
					end if;
					
				
				------------------------------------------------------------ Amber
				
				when NSAmber =>
					LightsNS		 <= AMBER;
					
					if (AmberExpired = '1') then
						AmberKick <= '1';
						nextState <= EWGreen;
					else
						nextState <= NSAmber;
					end if;
					
				-------------------------------------------------------->>
				-- East-West Lights
				-------------------------------------------------------->>
					
				when EWWalk =>
					LightsEW		 <= WALK;
					
					---------------------- Pedestrian Memory Reset Logic
					if (WalkExpired = '1') then 
						nextState	 <= EWGreen;
						PedRST <= '1';
					else 
						nextState	 <= EWWalk;
					end if;
					
				------------------------------------------------------------ Green
				
				when EWGreen =>
					LightsEW		 <= GREEN;
					
					---------------------- Counter Reset logic
					
					if (AmberExpired = '1') then
						CountRST <= '1';
						
					---------------------- Pedestrian Memory Logic (opposite side)
					
					elsif (PedHigh = '1') then
						nextState <= EWWalk;
						CountRST	 <= '1';
						
					elsif (PedNS = '1') then
						PedSet <= '1';
						AmberKick <= '1';
						nextState <= EWAmber;
						
					---------------------- Pedestrian Logic (same side)
					
					elsif (PedEW = '1') then
						CountRST		 <= '1';
						nextState 	 <= EWWalk;
						
					---------------------- Car Logic
					
					elsif (GreenExpired = '1' and CarNS = '1') then
						AmberKick <= '1';
						nextState	 <= EWAmber;
					else
						nextState 	 <= EWGreen;
					end if;
					
				------------------------------------------------------------ Amber
				
				when EWAmber =>
					LightsEW		 <= AMBER;
					
					if (AmberExpired = '1') then
						nextState <= NSGreen;
					else
						nextState <= EWAmber;
					end if;
					
			end case;
	end process CombinationalProcess;
	
end Behavioral;

