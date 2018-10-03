--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:13:41 05/14/2018
-- Design Name:   
-- Module Name:   C:/Users/Mikan/Desktop/Shima Stuff/Swin/EEE20001/Traffic_Level_2/TB_Level_3.vhd
-- Project Name:  Traffic_Level_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Controller_Level_2
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
 
ENTITY TB_Level_3 IS
END TB_Level_3;
 
ARCHITECTURE behavior OF TB_Level_3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Controller_Level_2
    PORT(
         Reset : IN  std_logic;
         Clock : IN  std_logic;
         debugLED : OUT  std_logic;
         LEDs : OUT  std_logic_vector(2 downto 0);
         CarEW : IN  std_logic;
         CarNS : IN  std_logic;
         PedEW : IN  std_logic;
         PedNS : IN  std_logic;
         LightsEW : OUT  std_logic_vector(1 downto 0);
         LightsNS : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Reset : std_logic := '0';
   signal Clock : std_logic := '0';
   signal CarEW : std_logic := '0';
   signal CarNS : std_logic := '0';
   signal PedEW : std_logic := '0';
   signal PedNS : std_logic := '0';

 	--Outputs
   signal debugLED : std_logic;
   signal LEDs : std_logic_vector(2 downto 0);
   signal LightsEW : std_logic_vector(1 downto 0);
   signal LightsNS : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
	
	   -- Internal
   signal complete    : boolean := false;
   signal currentTest : string(1 to 10);

   -- Encoding for lights
   constant RED   : std_logic_vector(1 downto 0) := "00";
   constant AMBER : std_logic_vector(1 downto 0) := "01";
   constant GREEN : std_logic_vector(1 downto 0) := "10";
   constant WALK  : std_logic_vector(1 downto 0) := "11";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Controller_Level_2 PORT MAP (
          Reset => Reset,
          Clock => Clock,
          debugLED => debugLED,
          LEDs => LEDs,
          CarEW => CarEW,
          CarNS => CarNS,
          PedEW => PedEW,
          PedNS => PedNS,
          LightsEW => LightsEW,
          LightsNS => LightsNS
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

      reset <= '0'; CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0';

		-- Stimulus here
		--==========================================
		
      -- Reset circuit
      currentTest <= "Reset     ";
      reset <= '1';  wait until rising_edge(clock);
      reset <= '0';  wait until rising_edge(clock);
      
      -- Simulation assumes lights start green EW after reset but should work either way
      
      -- Lights currently green EW
		-- NS Car arrives & waits for the lights to change 
		-- Lights should change directly to green NS
      currentTest <= "NS Car    ";
      CarEW <= '0'; CarNS <= '1'; PedEW <= '0'; PedNS <= '0'; -- NS car arrives
      if LightsNS /= GREEN then
         wait until LightsNS = GREEN;
      end if;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- NS car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW Car arrives & waits for the lights to change 
		-- Lights should change directly to green EW
      currentTest <= "EW Car    ";
      CarEW <= '1'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car arrives
      if LightsEW /= GREEN then
         wait until LightsEW = GREEN;
      end if;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green EW
		-- NS Car arrives & waits for the lights to change 
		-- Lights should change directly to green NS
      currentTest <= "NS Car    ";
      CarEW <= '0'; CarNS <= '1'; PedEW <= '0'; PedNS <= '0'; -- NS car arrives
      if LightsNS /= GREEN then
         wait until LightsNS = GREEN;
      end if;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- NS car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW Pedestrian briefly presses button 
		-- Lights should change directly to green+walk EW then green EW
      currentTest <= "EW Ped    ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '0'; -- EW ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      if LightsEW /= WALK then
         wait until LightsEW = WALK;
      end if;
      if LightsEW /= GREEN then
         wait until LightsEW = GREEN;
      end if;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green EW
		-- EW Pedestrian briefly presses button 
		-- Lights should change directly to green+walk EW then back to green EW
      currentTest <= "EW Ped #2 ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '0'; -- EW ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      if LightsEW /= WALK then
         wait until LightsEW = WALK;
      end if;
      if LightsEW /= GREEN then
         wait until LightsEW = GREEN;
      end if;
      wait for 1 us; -- not a realistic delay but speeds up simulation
      
      -- Lights currently green EW
      -- NS Pedestrian briefly presses button 
		-- Lights should change directly to green+walk NS then to green NS
      currentTest <= "NS Ped    ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '1'; -- NS ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      if LightsNS /= WALK then
         wait until LightsNS = WALK;
      end if;
      if LightsNS /= GREEN then
         wait until LightsNS = GREEN;
      end if;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- NS Pedestrian briefly presses button 
		-- Lights should change directly to green+walk NS then back to green NS
      currentTest <= "NS Ped #2 ";
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '1'; -- NS ped presses button
      wait until falling_edge(clock);
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- ped releases button
      if LightsNS /= WALK then
         wait until LightsNS = WALK;
      end if;
      if LightsNS /= GREEN then
         wait until LightsNS = GREEN;
      end if;
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW & NS Cars arrive & wait for the lights to change  
		-- Lights should cycle green EW <=> green NS
      currentTest <= "Cycling   ";
      CarEW <= '1'; CarNS <= '1'; PedEW <= '0'; PedNS <= '0'; -- EW & NS cars arrives
      for count in 1 to 5 loop
         if LightsEW /= GREEN then
            wait until LightsEW = GREEN;
         end if;
         if LightsNS /= GREEN then
            wait until LightsNS = GREEN;
         end if;
      end loop;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
            
      -- Lights currently green NS
		-- EW & NS Peds arrive & wait for the lights to change 
		-- Lights should cycle walk+green EW => green EW => walk+green NS => green NS
      currentTest <= "Cycling+W ";
      for count in 1 to 5 loop
         CarEW <= '0'; CarNS <= '0'; PedEW <= '1'; PedNS <= '1'; -- EW & NS peds arrives
         wait until falling_edge(clock);
         if LightsEW /= GREEN then
            wait until LightsEW = GREEN;
         end if;
         if LightsNS /= GREEN then
            wait until LightsNS = GREEN;
         end if;
      end loop;
      CarEW <= '0'; CarNS <= '0'; PedEW <= '0'; PedNS <= '0'; -- EW car leaves
      wait for 1 us; -- not a realistic delay but speeds up simulation
      
      complete <= true; -- end simulation
		wait; -- will wait forever
   end process;

END;
