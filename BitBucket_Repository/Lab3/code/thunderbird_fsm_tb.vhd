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
--| FILENAME      : thunderbird_fsm_tb.vhd (TEST BENCH)
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
  
entity thunderbird_fsm_tb is
end thunderbird_fsm_tb;

architecture test_bench of thunderbird_fsm_tb is 
	
  -- declare the component of your top-level design unit under test (UUT)
  component thunderbird_fsm is
    port(
	    i_clk : in std_logic;
	    i_reset : in std_logic;
        i_left : in std_logic;
        i_right : in std_logic;
        o_lights_L : out std_logic_vector(2 downto 0);
        o_lights_R : out std_logic_vector(2 downto 0)-- Identify input and output bits here
    );	
  end component;

  -- declare any additional components required
  
  -- declare signals needed to stimulate the UUT inputs
  signal i_clk : std_logic  := '0';
  signal i_reset : std_logic  := '0';
  signal  i_left : std_logic  := '0';
  signal i_right : std_logic  := '0';

  -- also need signals for the outputs of the UUT
  signal o_lights_L : std_logic_vector (2 downto 0) ;
  signal o_lights_R : std_logic_vector (2 downto  0);

  constant k_clk_period : time := 10 ns;
  
begin
	-- PORT MAPS ----------------------------------------

	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : thunderbird_fsm port map (
              i_left  => i_left,
              i_right => i_right,
              i_reset => i_reset,
              i_clk   => i_clk,
              o_lights_L  => o_lights_L,
              o_lights_R  => o_lights_R
	);


	-- CONCURRENT STATEMENTS ----------------------------
    clk_proc : process
            begin
                i_clk <= '0';
                wait for k_clk_period/2;
                i_clk <= '1';
                wait for k_clk_period/2;
            end process;
        
        -- Simulation process
        -- Use 220 ns for simulation
        sim_proc: process
            begin
                -- sequential timing        
                i_reset <= '1';
                wait for k_clk_period*1;
                
                i_reset <= '0';
                wait for k_clk_period*1;
                
                -- alternative way of implementing Finite State Machine Inputs
                -- starts after "wait for" statements
                -- statements after this one start in paralell to this one
                i_left  <= '1';
                i_right <= '0';
                wait for k_clk_period * 4;
                i_reset <= '1';
                wait for k_clk_period*1;
                i_reset <= '0';
                wait for k_clk_period*1;
                
                
                i_left  <= '0';
                i_right <= '1';
                wait for k_clk_period * 4;
                i_reset <= '1';
                i_reset <= '1';
                wait for k_clk_period*1;
                i_reset <= '0';
                wait for k_clk_period*1;
                        
                i_left  <= '1';
                i_right <= '1';
                wait for k_clk_period * 4;
                i_reset <= '1';
                i_reset <= '1';
                wait for k_clk_period*1;
                i_reset <= '0';
                wait for k_clk_period*1;
              
                i_left  <= '0';
                i_right <= '0';
                wait for k_clk_period * 4;
                i_reset <= '1';
                i_reset <= '1';
                wait for k_clk_period*1;
                i_reset <= '0';
                wait for k_clk_period*1;
                      
                wait for k_clk_period*19;
                i_reset <= '1';
            
                wait;
            end process;
	
	-- PROCESSES ----------------------------------------
	
	-- Provide a comment that describes each process
	-- block them off like the modules above and separate with SPACE
	-- You will at least have a test process
	
	
	-- Test Plan Process --------------------------------
	-- Implement the test plan here.  Body of process is continuous from time = 0  
	-----------------------------------------------------	
	
end test_bench;
