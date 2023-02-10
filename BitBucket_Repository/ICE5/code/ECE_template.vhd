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
--| FILENAME      : ECE_template.vhd
--| AUTHOR(S)     : C9C John Doe, C8C Jane Day
--| CREATED       : 01/01/2017
--| DESCRIPTION   : This file simply provides a template for all VHDL assignments
--| 				- Be sure to include your Documentation Statement below!
--|
--| DOCUMENTATION : 
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

-- entity name should match filename  
entity ECE_template is 
  port(
	-- Identify input and output bits here
  );
end ECE_template;

architecture ECE_template_arch of ECE_template is 
	-- include components declarations and signals
	
	-- intermediate signals with initial value
	-- typically you would use names that relate to signal (e.g. c_mux_2)
  
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instantiations (port mapping is like wiring hardware)


	-- CONCURRENT STATEMENTS "MODULES" ------------------

	-- Provide a comment that describes each "module" as appropriate
	-- think of "modules" in this sense as groups of related statements
		

		-- PROCESSES ----------------------------------------
	
	-- Provide a comment that describes each process
	-- block them off like the modules above and separate with SPACE
	-- Note, the example below is a local oscillator address counter 
	--	not related to other code in this file
	
	
	
end ECE_template_arch;
