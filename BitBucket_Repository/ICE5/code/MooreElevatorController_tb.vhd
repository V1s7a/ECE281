--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : MooreElevatorController_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Capt Dan Johnson, C3C Colton Willits
--| CREATED       : 03/2017 Last modified on 06/24/2020
--| DESCRIPTION   : This file tests the Moore elevator controller module
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : MooreElevatorController.vhd
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity MooreElevatorController_tb is
end MooreElevatorController_tb;

architecture test_bench of MooreElevatorController_tb is 
	
	component MooreElevatorController is
		Port ( i_clk 	 : in  STD_LOGIC;
			   i_reset 	 : in  STD_LOGIC; -- synchronous
			   i_stop 	 : in  STD_LOGIC;
			   i_up_down : in  STD_LOGIC;
			   o_floor 	 : out STD_LOGIC_VECTOR (3 downto 0));
	end component MooreElevatorController;
	
	-- test signals
	signal i_clk, i_reset, i_stop, i_up_down : std_logic := '0';
	signal o_floor : std_logic_vector(3 downto 0) := (others => '0');
  
	-- 50 MHz clock
	constant k_clk_period : time := 20 ns;
	
begin
	-- PORT MAPS ----------------------------------------

	uut_inst : MooreElevatorController port map (
		i_clk     => i_clk,
		i_reset   => i_reset,
		i_stop    => i_stop,
		i_up_down => i_up_down,
		o_floor   => o_floor
	);
	-----------------------------------------------------
	
	-- PROCESSES ----------------------------------------
	
	-- Clock Process ------------------------------------
	clk_process : process
	begin
		i_clk <= '0';
		wait for k_clk_period/2;
		
		i_clk <= '1';
		wait for k_clk_period/2;
	end process clk_process;
	
	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
		-- i_reset into initial state (o_floor 1)
		i_reset <= '1';  wait for k_clk_period; i_reset <= '0';
		
		-- active UP signal
		i_up_down <= '1';
		
		-- stay on each o_floor for 2 cycles and then move up to the next o_floor
		i_stop <= '1';  wait for k_clk_period * 2;	-- what do I need here to wait two cycles?
		i_stop <= '0';  wait for k_clk_period;
		--fill in the rest of the test bench here to go up to o_floor 4
		i_up_down <= '1';
		i_stop <= '1';  wait for k_clk_period * 2;	
        i_stop <= '0';  wait for k_clk_period;
        
        i_up_down <= '1';
        i_stop <= '1';  wait for k_clk_period * 2;    
        i_stop <= '0';  wait for k_clk_period;
							-- wait on o_floor 4 (i_stop should NOT matter)
        wait for k_clk_period * 2;
        
		-- from top o_floor, return to first o_floor without stopping
		i_up_down <= '0';
		i_up_down <= '0';
		i_up_down <= '0';
		wait for k_clk_period;
		
		-- wait one more i_clk period just to prove that you will stay at first o_floor
		
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;
