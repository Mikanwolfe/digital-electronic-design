library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gameCircuit is
    Port ( C1 : in  STD_LOGIC;
           C2 : in  STD_LOGIC;
           C3 : in  STD_LOGIC;
           Adj : in  STD_LOGIC;
			  Reset : in STD_LOGIC;
			  
           Winner : out  STD_LOGIC_VECTOR (1 downto 0);
           Unfair : out  STD_LOGIC;
			  debugLED : out STD_LOGIC
			  );
end gameCircuit;

architecture Model of gameCircuit is
signal A, B, C, D, E : STD_LOGIC;
signal G : STD_LOGIC_VECTOR (1 downto 0);
signal F : STD_LOGIC_VECTOR (2 downto 0);
begin
	process(Reset, Adj, C1, C2, C3)
		begin
		
		Unfair <= '0';
		Winner <= "00";
		
		A <= '0';
		B <= '0';
		C <= '0';
		D <= '0';
		E <= '0';
		F <= "000";
		G <= "00";
		
		A <= C1 and C2;
		B <= C2 and C3;
		C <= C3 and C1;
		D <= A or C or B; -- If D=0, No two inputs are the same.
		
		E <= C1 or C2 or C3; -- If E=1 then there is 1 or more input
									-- If E=1, D=0, only one input is active.
		G <= E&D;				-- This is the signal that tests the above condition
		
		if (Adj = '1') then
		
			Winner <= "00";
			Unfair <= '1';
			
		elsif ( G = "10") then -- Only one input is active
		
			F <= C1&C2&C3;
			Unfair <= '0';
			case F is 
			
				when "100"  => Winner <= "01";
				when "010"  => Winner <= "10";
				when "001"  => Winner <= "11";
				when others => Winner <= "00";

			end case;
			
		else
		Winner <= "00";
		Unfair <= '1';
		end if;
		
		F <= C1&C2&C3;
		if ( F = "000" ) then
			Unfair <= '0';
		end if;
		
		
	end process;
	
	debugLED <= '1' when Reset = '1' else
					'0' when Reset = '0';
	
end Model;


