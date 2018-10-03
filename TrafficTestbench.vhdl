--------------------------------------------------------------------------------
-- Testbench for Traffic intersection
--
-- This file assumes the module and port names are as given in the Skeleton file provided
-- If this is not so, then it will be necessary to make appropriate changes to the instantiation of
-- the Traffic module to match your names.
--
--  Note: This is not really a testbench - it doesn't actually 'test' anything!
--     It just exercises the traffic lights - It's up to you
--     to check that the results of the simulation are correct.
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY TrafficTestbench IS
END TrafficTestbench;

ARCHITECTURE behavior OF TrafficTestbench IS 

	-- Inputs
	SIGNAL Reset :  std_logic := '0';
	SIGNAL Clock :  std_logic := '0';
	SIGNAL CarEW :  std_logic := '0';
	SIGNAL CarNS :  std_logic := '0';
	SIGNAL PedEW :  std_logic := '0';
	SIGNAL PedNS :  std_logic := '0';

	-- Outputs
	SIGNAL debugLED :  std_logic;
   SIGNAL LEDs     :  std_logic_vector(2 downto 0);
	SIGNAL LightsEW :  std_logic_vector(1 downto 0);
	SIGNAL LightsNS :  std_logic_vector(1 downto 0);
   
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
   -- The module and port names may need to be changed as appropriate.
	uut: ENTITY work.Traffic 
   PORT MAP(
		Reset    => Reset,
		Clock    => Clock,
		debugLED => debugLED,
      LEDs     => LEDs,
		CarEW    => CarEW,
		CarNS    => CarNS,
		PedEW    => PedEW,
		PedNS    => PedNS,
		LightsEW => LightsEW,
		LightsNS => LightsNS
	);

   clkProcess:
   process
   begin
      while not complete loop
         clock <= '1'; wait for 500 ns;
         clock <= '0'; wait for 500 ns;
      end loop;
      
      wait;
   end process clkProcess;
   
   
	tb : PROCESS
	BEGIN

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
	END PROCESS;

END;
