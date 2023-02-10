--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : MooreElevatorController.vhd
--| AUTHOR(S)     : Capt Phillip Warner, Capt Dan Johnson, C3C Colton Willits
--| CREATED       : 03/2018 Last Modified on 06/24/2020
--| DESCRIPTION   : This file implements the ICE5 Basic elevator controller (Moore Machine)
--|
--|  The system is specified as follows:
--|   - The elevator controller will traverse four floors (numbered 1 to 4).
--|   - It has two external inputs, i_up_down and i_stop.
--|   - When i_up_down is active and i_stop is inactive, the elevator will move up 
--|			until it reaches the top floor (one floor per clock, of course).
--|   - When i_up_down is inactive and i_stop is inactive, the elevator will move down 
--|			until it reaches the bottom floor (one floor per clock).
--|   - When i_stop is active, the system stops at the current floor.  
--|   - When the elevator is at the top floor, it will stay there until i_up_down 
--|			goes inactive while i_stop is inactive.  Likewise, it will remain at the bottom 
--|			until told to go up and i_stop is inactive.  
--|   - The system should output the floor it is on (1 – 4) as a four-bit binary number.
--|
--|		Inputs:   i_clk     --> elevator clk
--|				  i_reset   --> reset signal
--|				  i_stop	--> signal tells elevator to stop moving
--|				  i_up_down	--> signal controls elavotor 1=up, 0=down
--|
--|		Outputs:  o_floor (3:0)	--> 4-bit signal  indicating elevator's floor
--|  
--| DOCUMENTATION : ***YOUR DOC STATEMENT HERE***
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MooreElevatorController is
    Port ( i_clk     : in  STD_LOGIC;
           i_reset   : in  STD_LOGIC;
           i_stop    : in  STD_LOGIC;
           i_up_down : in  STD_LOGIC;
           o_floor   : out STD_LOGIC_VECTOR (3 downto 0);
           o_up : out std_logic;
           o_down : out std_logic	   
		 );
end MooreElevatorController;


-- Write the code in a similar style as the Lesson 19 ICE (stoplight FSM version 2)
architecture Behavioral of MooreElevatorController is

    -- Below you create a new variable type! You also define what values that 
    -- variable type can take on. Now you can assign a signal as 
    -- "sm_floor" the same way you'd assign a signal as std_logic
	-- how would you modify this to go up to 15 floors?
	type sm_floor is (s_floor1, s_floor2, s_floor3, s_floor4, s_floor5, s_floor6, s_floor7, s_floor8, s_floor9, s_floor10, s_floor11, s_floor12, s_floor13, s_floor14, s_floor15);
	
	-- Here you create variables that can take on the values
	-- defined above. Neat!	
	signal f_current_state, f_next_state : sm_floor;

begin

	-- CONCURRENT STATEMENTS ------------------------------------------------------------------------------
	-- Next State Logic
	-- You may also use case statements here if you would prefer that implemintation.
	f_next_state <= s_floor1 when (f_current_state = s_floor2 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor1 and i_up_down = '0') or (f_current_state = s_floor1 and i_stop = '1') else
				    s_floor2 when (f_current_state = s_floor1 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor3 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor2 and i_stop = '1') else
					s_floor3 when (f_current_state = s_floor2 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor4 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor3 and i_stop = '1') else
				    s_floor4 when (f_current_state = s_floor3 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor5 and i_up_down = '0' and i_stop = '0') or(f_current_state = s_floor4 and i_stop = '1') else
					s_floor5 when (f_current_state = s_floor4 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor6 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor5 and i_stop = '1') else
					s_floor6 when (f_current_state = s_floor5 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor7 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor6 and i_stop = '1') else
					s_floor7 when (f_current_state = s_floor6 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor8 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor7 and i_stop = '1') else
					s_floor8 when (f_current_state = s_floor7 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor9 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor8 and i_stop = '1') else
					s_floor9 when (f_current_state = s_floor8 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor10 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor9 and i_stop = '1') else
					s_floor10 when (f_current_state = s_floor9 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor11 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor10 and i_stop = '1') else
					s_floor11 when (f_current_state = s_floor10 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor12 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor11 and i_stop = '1') else
					s_floor12 when (f_current_state = s_floor11 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor13 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor12 and i_stop = '1') else
					s_floor13 when (f_current_state = s_floor12 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor14 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor13 and i_stop = '1') else
					s_floor14 when (f_current_state = s_floor13 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor15 and i_up_down = '0' and i_stop = '0') or (f_current_state = s_floor14 and i_stop = '1') else
					s_floor15 when (f_current_state = s_floor14 and i_up_down = '1' and i_stop = '0') or (f_current_state = s_floor15 and i_up_down = '1') or (f_current_state = s_floor15 and i_stop = '0');
					--continue until you have defined all states
    o_up <= '0' when f_current_state = f_next_state else
            '0' when i_up_down = '0' else
            '1';
    o_down <= '0' when f_current_state = f_next_state else
              '0' when i_up_down = '1' else
              '1';
              
	-- Output logic
	-- default is floor1
	-- you may also use the "with SEL select" signal assignment here instead of when/else
	o_floor <= "0001" when f_current_state = s_floor1 else
			 "0010" when f_current_state = s_floor2 else
			 "0011" when f_current_state = s_floor3 else
			 "0100" when f_current_state = s_floor4 else
			 "0101" when f_current_state = s_floor5 else 
			 "0110" when f_current_state = s_floor6 else 
			 "0111" when f_current_state = s_floor7 else 
			 "1000" when f_current_state = s_floor8 else 
			 "1001" when f_current_state = s_floor9 else 
			 "1010" when f_current_state = s_floor10 else 
			 "1011" when f_current_state = s_floor11 else 
			 "1100" when f_current_state = s_floor12 else 
			 "1101" when f_current_state = s_floor13 else 
			 "1110" when f_current_state = s_floor14 else 
			 "1111" when f_current_state = s_floor15 else 
			 "0001";
			 --Fill in all possible outputs here	
	-------------------------------------------------------------------------------------------------------
	
	-- PROCESSES ------------------------------------------------------------------------------------------	
	-- State memory ------------
	register_proc : process (i_clk, i_reset)
	begin
		if i_reset = '1' then
			f_current_state <= s_floor1;  --Reset state is floor 1
		elsif (rising_edge(i_clk)) then
			f_current_state <= f_next_state; --Next state becomes current state
		end if;
	end process register_proc;	
	-- i_reset is active high and will return elevator to floor1
	-------------------------------------------------------------------------------------------------------
	
	



end Behavioral;

