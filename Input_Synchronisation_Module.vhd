----------------------------------------------------------------------------------
-- Input Synchronisation Module for the Traffic Controller
--
-- Synchronises outside input to the click edge.
-- Essentially acts as four d-flip-flops that seperate external inputs to internal signals
--
-- Written by Jimmy Trac and Tom Kelsall
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Input_Sync_Module is
			
	port( reset			: in   STD_LOGIC; -- Reset Outputs
			Clock			: in	 STD_LOGIC;
			
			ICarEW      : in   STD_LOGIC; -- Car on EW road
         ICarNS      : in   STD_LOGIC; -- Car on NS road
         IPedEW      : in   STD_LOGIC; -- Pedestrian moving EW (crossing NS road)
         IPedNS      : in   STD_LOGIC; -- Pedestrian moving NS (crossing EW road)
			
			OCarEW      : out   STD_LOGIC;
         OCarNS      : out   STD_LOGIC;
         OPedEW      : out   STD_LOGIC;
         OPedNS      : out   STD_LOGIC
			);

end Input_Sync_Module;

architecture Behavioral of Input_Sync_Module is

begin
	
	SynchronousProcess : process(reset, Clock)
		
		begin
			if( reset = '1') then
	
				OCarEW <= '0';
				OCarNS <= '0';
				OPedEW <= '0';
				OPedNS <= '0';
	
			elsif(rising_edge(clock)) then
		
				OCarEW <= ICarEW;
				OCarNS <= ICarNS;
				OPedEW <= IPedEW;
				OPedNS <= IPedNS;
		
			end if;
	
		end process SynchronousProcess;

end Behavioral;

