--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:03:36 05/07/2018
-- Design Name:   
-- Module Name:   C:/Users/Mikan/Desktop/Shima Stuff/Swin/EEE20001/TutorialChallenge/PWM_TestBench.vhd
-- Project Name:  TutorialChallenge
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PWM_Module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PWM_TestBench IS
END PWM_TestBench;
 
ARCHITECTURE behavior OF PWM_TestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM_Module
    PORT(
         width : IN  std_logic_vector(7 downto 0);
         clock : IN  std_logic;
         reset : IN  std_logic;
         pwm : OUT  std_logic
			--pwm_clock: OUT STD_LOGIC
			--debugSLV: OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal width : std_logic_vector(7 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal pwm : std_logic;
	--signal pwm_clock: std_logic;
	--signal debugSLV : std_logic_vector(7 downto 0) := (others => '0');

   -- Clock period definitions
   constant clock_period : time := 5 us;
	
	-- Internal
	signal currentTest : string(1 to 10);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM_Module PORT MAP (
          width => width,
          clock => clock,
          reset => reset,
          pwm => pwm
			 --pwm_clock => pwm_clock 
			 --debugSLV => debugSLV
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   tb: process
   begin	

		currentTest <= "Reset     ";
      reset <= '1';  wait until rising_edge(clock);
      reset <= '0';  wait until rising_edge(clock);
		
		currentTest <= "Width: 0  ";
		width <= "00000000";
		wait for 3 ms;
		--wait until rising_edge(pwm_clock);
		
		currentTest <= "Width: 1  ";
		width <= "00000001";
		wait for 3 ms;
		--wait until rising_edge(pwm_clock);
		
		currentTest <= "Width: 100";
		width <= "01100100";
		wait for 8 ms;
		--wait until rising_edge(pwm_clock);
		
		currentTest <= "Width: 255";
		width <= "11111111";
		wait for 3 ms;
		--wait until rising_edge(pwm_clock);
		
		currentTest <= "Reset + W0";
		width <= "00000000";
      reset <= '1';  wait until rising_edge(clock);
		wait until rising_edge(clock);
      reset <= '0';  wait until rising_edge(clock);

   wait;
   end process;

END;
