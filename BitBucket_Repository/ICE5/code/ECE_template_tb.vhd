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
--| FILENAME      : ECE_template_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : C9C John Doe, C8C Jane Day
--| CREATED       : 01/01/2017
--| DESCRIPTION   : This file simply provides a template for all VHDL assignments
--| 				- Be sure to include your Documentation Statement below!
--|
--| DOCUMENTATION : Include all documentation statements in main .vhd file
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : LIST ANY DEPENDENCIES
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

library unisim;
  use UNISIM.Vcomponents.ALL;
  
entity ECE_template_tb is
end ECE_template_tb;

architecture test_bench of ECE_template_tb is 
	
  -- declare the component of your top-level design unit under test (UUT)
  component ECE_template is
    port(
	-- Identify input and output bits here
    );	
  end component;

  -- declare any additional components required
  
  -- declare signals needed to stimulate the UUT inputs

  -- also need signals for the outputs of the UUT

  
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : ECE_template port map (
	  -- use comma (not a semicolon)
	  -- no comma on last line
	);


	-- CONCURRENT STATEMENTS ----------------------------

	
	-- PROCESSES ----------------------------------------
	
	-- Provide a comment that describes each process
	-- block them off like the modules above and separate with SPACE
	-- You will at least have a test process
	
	
	-- Test Plan Process --------------------------------
	-- Implement the test plan here.  Body of process is continuous from time = 0  
	test_process : process 
	begin
		-- ex: assign '0' for first 100 ns, then '1' for next 100 ns, then '0'
		c_input <= '0', '1' after 10 ns, '0' after 20 ns;
		
		--or
		
		c_input <= '0'; wait for 10 ns;
        c_input <= '1'; wait for 10 ns;
        c_input <= '0'; wait for 10 ns;
		
	end process;	
	-----------------------------------------------------	
	
end test_bench;
