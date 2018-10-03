----------------------------------------------------------------------------------
-- Traffic Controller (Top Module) : Controller Level 3
--
-- Traffic light system to control an intersection
--
--
-- Accepts inputs from two car sensors and two pedestrian call buttons.
--
-- Controls two sets of lights consisting of Red, Amber and Green traffic lights and
-- 	a pedestrian walk light.
--
--
-- Written by Jimmy Trac and Tom Kelsall
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
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
end TopLevel;

architecture Behavioral of TopLevel is
	
	Component Counter_Module is
    Port ( Reset			 : in  STD_LOGIC;
           Clock			 : in  STD_LOGIC;
           WalkExpired	 : out STD_LOGIC;
           AmberExpired	 : out STD_LOGIC;
           GreenExpired	 : out STD_LOGIC;
			  
			  AmberKick		 : in STD_LOGIC
			  );
	end Component;
	
	Component Ped_Mem_Module is
    Port ( Set : in  STD_LOGIC;
           Output : out  STD_LOGIC;
           Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC
			  );
	end Component;
	
	Component Input_Sync_Module is
	Port(
			Reset			: in   STD_LOGIC; -- Reset Outputs
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
	end component;


	Component Traffic_Level_1_Module is
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
			  
	end Component;

	---------------------------------
	-- Signals denoted by 's' prefix
	---------------------------------

	-- Counter Module
	signal sCountRST	 : STD_LOGIC;
	signal sCWalkExp	 : STD_LOGIC;
	signal sCGreenExp	 : STD_LOGIC;
	signal sCAmberExp	 : STD_LOGIC;
	signal sCAmbKick	 : STD_LOGIC;
	
	-- Pedestrian Memory (Pem Mem) Module
	signal sPSet		 : STD_LOGIC;
	signal sPOutput	 : STD_LOGIC;
	signal sPReset 	 : STD_LOGIC;
	
	-- Sync Output	
	signal sSCarEW: STD_LOGIC; 
	signal sSCarNS: STD_LOGIC; 
	signal sSPedEW: STD_LOGIC; 
	signal sSPedNS: STD_LOGIC; 
	

begin
	
	-----------------------------------------------
	-- Input Sync Module
	-----------------------------------------------
	
	SyncModule : Input_Sync_Module
	PORT MAP (
		Reset 		=> Reset,
		Clock			=> Clock,
		
		ICarEW		=> CarEW,
		ICarNS		=>	CarNS,
		IPedEW		=>	PedEW,
		IPedNS		=>	PedNS,
		
		OCarEW		=> sSCarEW,
		OCarNS		=> sSCarNS,
		OPedEW		=> sSPedEW,
		OPedNS		=> sSPedNS
	);
	
	-----------------------------------------------
	-- Counter Module
	-----------------------------------------------
	
	Counter: Counter_Module
	PORT MAP (
		Reset			 => sCountRST,
		Clock			 => Clock,
		WalkExpired  => sCWalkExp,
		GreenExpired => sCGreenExp,
		AmberExpired => sCAmberExp,
		AmberKick	 => sCAmbKick
	);
	
	-----------------------------------------------
	-- Pedestrian Memory Module
	-----------------------------------------------
	
	PedMemory : Ped_Mem_Module
	PORT MAP (
		Reset 		=> sPReset,
		Clock			=> Clock,
		Output		=> sPOutput,
		Set			=> sPSet		
	);
	
	-----------------------------------------------
	-- Traffic Module (Traffic Level 1 Module)
	-----------------------------------------------

	Model: Traffic_Level_1_Module
	PORT MAP (
		Reset 		 => Reset,
		Clock 		 => Clock,
			
		debugLED 	 => debugLED,
		LEDs 			 => LEDs,
			
		CarEW			 => sSCarEW,
		CarNS			 => sSCarNS,
		PedEW			 => sSPedEW,
		PedNS			 => sSPedNS,
			
		LightsEW		 => LightsEW,
		LightsNS		 => LightsNS,
			
		CountRST 	 => sCountRST,
		WalkExpired  => sCWalkExp,
		GreenExpired => sCGreenExp,
		AmberExpired => sCAmberExp,
		AmberKick	 => sCAmbKick,
		
		PedRST		 => sPReset,
		PedSet		 => sPSet,
		PedHigh		 => sPOutput
		
	
	);


end Behavioral;

