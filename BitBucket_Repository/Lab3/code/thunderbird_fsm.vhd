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
--| FILENAME      : thunderbird_fsm.vhd
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
entity thunderbird_fsm is 
  port(
	-- Identify input and output bits here
	i_clk, i_reset : in std_logic;
	i_left, i_right : in std_logic;
	o_lights_L : out std_logic_vector(2 downto 0);
	o_lights_R : out std_logic_vector(2 downto 0)
  );
end thunderbird_fsm;

architecture thunderbird_fsm_arch of thunderbird_fsm is 
	-- include components declarations and signals
	signal S_next : std_logic_vector (7 downto 0);
    signal S : std_logic_vector (7 downto 0);

    
	-- intermediate signals with initial value
	-- typically you would use names that relate to signal (e.g. c_mux_2)
  
begin

    -- Next state logic
        S_next(0) <= (S(0) and not i_left and not i_right) or S(1) or S(4) or S(7);
        S_next(1) <= (S(0) and i_left and i_right);
        S_next(2) <= S(0) and not i_left and i_right;
        S_next(3) <= S(2);
        S_next(4) <= S(3);
        S_next(5) <= S(0) and i_left and not i_right;
        S_next(6) <= S(5);
        S_next(7) <= S(6);
         
        
    -- Output logic
        o_lights_L(0) <= S(1) or S(5) or S(6) or S(7);
        o_lights_L(1) <= S(1) or S(6) or S(7);
        o_lights_L(2) <= S(1) or S(7);
        o_lights_R(0) <= S(1) or S(2) or S(3) or S(4); 
        o_lights_R(1) <= S(1) or S(3) or S(4);
        o_lights_R(2) <= S(1) or S(4);
         
        
        
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instantiations (port mapping is like wiring hardware)


	-- CONCURRENT STATEMENTS "MODULES" ------------------

	-- Provide a comment that describes each "module" as appropriate
	-- think of "modules" in this sense as groups of related statements
		

		-- PROCESSES ----------------------------------------
	register_proc : process (i_clk, i_reset)
            begin
               if i_reset = '1' then
                  S <= "00000001";--Reset state is yellow
               elsif (rising_edge(i_clk)) then
                  S <= S_next;  -- Nest state becomes current state
               end if;
            end process register_proc;
	-- Provide a comment that describes each process
	-- block them off like the modules above and separate with SPACE
	-- Note, the example below is a local oscillator address counter 
	--	not related to other code in this file
	
	
	
end thunderbird_fsm_arch;
