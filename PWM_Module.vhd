----------------------------------------------------------------------------------
-- Engineer: 		 Jimmy Trac (101624964)
-- 
-- Create Date:    21:18:44 05/07/2018 
-- Design Name: 	 PWM Waveform Generator
-- Module Name:    PWM_Module - Behavioral 
-- Description: 	 Generates a PWM waveform frequency INPUT/255
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_Module is
    Port ( width : in  STD_LOGIC_VECTOR (7 downto 0);
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pwm : out  STD_LOGIC
			  );
end PWM_Module;

architecture Behavioral of PWM_Module is

signal dutyCycle : Integer range 0 to 255 := 0; -- 0 to 255
signal pulseCounter : Integer range -2 to 255  := 1;
signal syncCounter : Integer range -2 to 255  := 1;

signal pwmWasHigh: Boolean := false;
signal syncWasHigh: Boolean := false;

begin
	PWMProcess: process(reset, clock, width)
	begin
		if (rising_edge(clock)) then
		
			if (reset = '1') then -- Synchronous reset
				pulseCounter <= 0;
				syncCounter <= 0;
				pwmWasHigh <= false;
				syncWasHigh <= false;
				
				dutyCycle <= to_integer(unsigned(width)); -- Check for new Width
				
			else
		
				pulseCounter <= pulseCounter - 1; -- Decrement both clocks
				syncCounter <= syncCounter - 1;
				
				----------------------------
				-- Synchronous Clock
				--
				-- Keeps the 'pulse clock' synchronised to 200/255kHz,
				-- as pulse clock may sometimes miscount.
				----------------------------
				
				if (syncCounter <= 0) then
				
					dutyCycle <= to_integer(unsigned(width)); -- Check for new Width
				
					syncCounter <= 255; 								--Reset clocks
					pulseCounter <= 0;
					
				end if;
				
				----------------------------
				-- Pulse Clock
				--
				-- Keeps track of the time since HIGH or LOW
				----------------------------

				if (pulseCounter <= 0) then			    -- Check of numnber of clock edges has been reached
					
					if (pwmWasHigh = true) then 
		 				pulseCounter <= 255 - dutyCycle;  -- Set the number of LOW clock edges 
						
						if (dutyCycle /= 255) then 		 -- Prevent the static-1 hazard when the duty cycle is 255/255
							pwm <= '0';
						end if;
						
						pwmWasHigh <= false;
					else
						pulseCounter <= dutyCycle;			 -- Set the number of HIGH clock edges 
						
						if (dutyCycle /= 0) then 			 -- Prevent the static-0 hazard when the duty cycle is 0/255
							pwm <= '1';
						end if;
						pwmWasHigh <= true;
					end if;
				end if;
			end if;
		end if;
	end process PWMProcess;
end Behavioral;

