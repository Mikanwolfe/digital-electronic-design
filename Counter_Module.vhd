----------------------------------------------------------------------------------
-- Counter Module for the Traffic Controller
--
-- Counts a number of clock edges and produces three outputs: Green, Amber, and Walk Expired.
-- Accepts a special input: AmberKick. If high, the counter will move to just after the GreenExpired state.
-- Used for resetting the amber clock in the traffic controller.
--
-- Written by Jimmy Trac and Tom Kelsall
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter_Module is
    Port ( Reset			 : in  STD_LOGIC;
           Clock			 : in  STD_LOGIC;
           WalkExpired	 : out STD_LOGIC;
           AmberExpired	 : out STD_LOGIC;
           GreenExpired	 : out STD_LOGIC;
			  
			  AmberKick		 : in STD_LOGIC
			  );
end Counter_Module;

architecture Behavioral of Counter_Module is

constant MAXTIME		: Integer := 1023;
constant WalkTime		: Integer := 160;
constant GreenTime	: Integer := 860;
constant AmberTime	: Integer := 1000;

signal lCount : Integer range 0 to MAXTIME := 0;

begin
	
	CountProcess: process(Reset, Clock, lCount)
	begin
		WalkExpired		 <= '0';
		AmberExpired	 <= '0';
		GreenExpired	 <= '0';
		
		----------------------------------
		-- Clocking Logic
		----------------------------------
		if (reset = '1') then
			lCount <= 0;
		elsif (rising_edge(Clock)) then
			if (lCount /= MAXTIME) then
				lCount <= lCount + 1;
			end if;
			
			-- Kicker condition - move the lights to amber in specific cases
			if (AmberKick = '1') then 
				lCount <= GreenTime - 1;
			end if;
			
		end if;
		
		----------------------------------
		-- Checking for Expiry
		----------------------------------
		
		if (lCount > WalkTime) then
			WalkExpired <= '1';
		end if;
		
		if (lCount > GreenTime) then
			GreenExpired <= '1';
		end if;
		
		if (lCount > AmberTime) then
			AmberExpired <= '1';
		end if;
	
	
	end process CountProcess;

end Behavioral;

