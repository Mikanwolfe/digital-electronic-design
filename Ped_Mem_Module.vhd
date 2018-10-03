----------------------------------------------------------------------------------
-- Pedestrian Memory Module
--
--	Acts as an SR Flip Flop
-- "Remembers" when a pedestrian has pressed a walk button
-- Is disabled by the state machine in the "walk" state
--
-- Written by Jimmy Trac and Tom Kelsall
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ped_Mem_Module is
    Port ( Set : in  STD_LOGIC;
           Output : out  STD_LOGIC;
           Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end Ped_Mem_Module;

architecture Behavioral of Ped_Mem_Module is

signal lMemory : STD_LOGIC := '0';

begin

	Output <= lMemory;

	MemoryProcess : Process(Clock, Reset)
	begin
		if (Reset = '1') then 
			lMemory <= '0';
		elsif (rising_edge(Clock)) then
			if (Set = '1') then
				lMemory <= '1';
			end if;
		end if;
	end process MemoryProcess;


end Behavioral;

