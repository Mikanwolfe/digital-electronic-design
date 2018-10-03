----------------------------------------------------------------------------------
--  Traffic.vhd
--
-- Traffic light system to control an intersection
--
-- Accepts inputs from two car sensors and two pedestrian call buttons
-- Controls two sets of lights consisting of Red, Amber and Green traffic lights and
-- a pedestrian walk light.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Traffic is
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
           LightsEW   : out STD_LOGIC_VECTOR (1 downto 0); -- controls EW lights
           LightsNS   : out STD_LOGIC_VECTOR (1 downto 0)  -- controls NS lights
           
           );
end Traffic;

architecture Behavioral of Traffic is

-- Encoding for lights
constant RED   : std_logic_vector(1 downto 0) := "00";
constant AMBER : std_logic_vector(1 downto 0) := "01";
constant GREEN : std_logic_vector(1 downto 0) := "10";
constant WALK  : std_logic_vector(1 downto 0) := "11"; -- Green + Walk

type   StateType is (NSGreen, NSAmber, EWGreen, EWAmber); 
signal state, nextState : StateType;
--signal enCarEW, enCarNS, enPedEW, enPedNS : std_logic; -- for input synchronous logic

begin
   -- Show reset status on FPGA LED
   debugLED <= Reset;
   
	
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
	process (state)
		begin
			--Default values for signals - prevents latches
			LightsNS <= RED;
			LightsEW <= RED;
			LEDs     <= "000";
		
			case state is
				when NSGreen =>
					LightsNS <= GREEN;
					nextState <= NSAmber;
					LEDs <="001";
				when NSAmber =>
					LightsNS <= AMBER;
					nextState <= EWGreen;
					LEDs <="010";
				when EWGreen =>
					LightsEW <= GREEN;
					nextState <= EWAmber;
					LEDs <="011";
				when EWAmber =>
					LightsEW <= AMBER;
					nextState <= NSGreen;
					LEDs <="100";
				when Others =>
					LEDs <= "111";
			end case;
	end process CombinationalProcess;
end;