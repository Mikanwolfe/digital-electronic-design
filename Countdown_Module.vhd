----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:44 05/13/2018 
-- Design Name: 
-- Module Name:    Countdown_Module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Countdown_Module is
    Port ( Reset : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           CEnabled : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (9 downto 0);
           COUT : out  STD_LOGIC_VECTOR (9 downto 0);
           CountFinished : out  STD_LOGIC);
end Countdown_Module;

architecture Behavioral of Countdown_Module is

signal lCount : unsigned(9 downto 0) := "0000000000";

begin
	
	CountProcess: process(Reset, Clock, CEnabled)
	begin
		CountFinished <= '0';
		
		COUT <= std_logic_vector(lCount);
		
		if (lCount = "0000000000") then 
			CountFinished <= '1';
		end if;
		
		if(rising_edge(Clock)) then 
		
			---------------------
			-- Reset + Decrement
			---------------------
		
			if (Reset = '1') then -- Synchronous Reset
				lCount <= unsigned(Data); 
			elsif ((CEnabled = '1') AND (lCount /= "0000000000" )) then
					lCount <= lCount - 1;
			end if;

		end if;
	
	end process CountProcess;

end Behavioral;

