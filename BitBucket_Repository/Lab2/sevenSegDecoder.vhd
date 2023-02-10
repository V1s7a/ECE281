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
--| FILENAME      : sevenSegDecoder.vhd
--| AUTHOR(S)     : C3C Colton Willits, C3C Alli Thompson
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
entity sevenSegDecoder is 
  port(
	-- Identify input and output bits here
	i_D	: in std_logic_vector(3 downto 0);
	o_S	: out std_logic_vector(6 downto 0)
  );
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is 
	-- include components declarations and signals
	signal c_Sa	: std_logic:= '1';
	signal c_Sb	: std_logic:= '1';
	signal c_Sc	: std_logic:= '1';
	signal c_Sd	: std_logic:= '1';
	signal c_Se	: std_logic:= '1';
	signal c_Sf	: std_logic:= '1';
	signal c_Sg	: std_logic:= '1';
	-- intermediate signals with initial value
	-- typically you would use names that relate to signal (e.g. c_mux_2)
  
begin
	-- CONCURRENT STATEMENTS "MODULES" ------------------

	-- Provide a comment that describes each "module" as appropriate
	-- think of "modules" in this sense as groups of related statements
	
	-- Map all signals to output
	o_S(0) <= c_Sa;
	o_S(1) <= c_Sb;
	o_S(2) <= c_Sc;
	o_S(3) <= c_Sd;
	o_S(4) <= c_Se;
	o_S(5) <= c_Sf;
	o_S(6) <= c_Sg;
	
	-- Implement logic for all signals

	c_Sa <= '1' when (	(i_D = x"1") or
						(i_D = x"4") or
						(i_D = x"B") or
						(i_D = x"C") or
						(i_D = x"D") ) else '0';
						
	c_Sb <= '1' when (	(i_D = x"5") or
						(i_D = x"6") or
						(i_D = x"B") or
						(i_D = x"C") or
						(i_D = x"E") or
						(i_D = x"F") ) else '0';
				
	c_Sc <= '1' when (	(i_D = x"2") or
                        (i_D = x"C") or
                        (i_D = x"E") or
                        (i_D = x"F") ) else '0';
                        
    --c_Sd <= '1' when (	(i_D = x"1") or
    --                    (i_D = x"4") or
    --                    (i_D = x"7") or
    --                    (i_D = x"9") or
    --                    (i_D = x"A") or
    --                    (i_D = x"F") ) else '0';
                        
    c_Se <= '1' when (	(i_D = x"1") or
                        (i_D = x"3") or
                        (i_D = x"4") or
                        (i_D = x"5") or
                        (i_D = x"7") or
                        (i_D = x"9") ) else '0';
    
    --c_Sf <= '1' when (	(i_D = x"1") or
    --                    (i_D = x"2") or
    --                    (i_D = x"3") or
    --                    (i_D = x"7") or
    --                    (i_D = x"C") or
    --                    (i_D = x"D") ) else '0';
                        
    c_Sg <= '1' when (	(i_D = x"0") or
                        (i_D = x"1") or
                        (i_D = x"7") ) else '0';
	
	--c_Sa <= (  NOT i_D(3) AND NOT i_D(2) AND NOT i_D(1) AND i_D(0)) OR (i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR (i_D(3) AND i_D(2) AND NOT i_D(1)) OR (i_D(3) AND NOT i_D(2) AND i_D(1) AND i_D(0));
	--c_Sb <= ( i_D(3) AND i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR (i_D(3) AND i_D(1) AND i_D(0)) OR (i_D(2) AND i_D(1) AND NOT i_D(0));
	--c_Sc <= ( i_D(3) AND i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR ( NOT i_D(3) AND NOT i_D(2) AND i_D(1) AND NOT i_D(0)) OR (i_D(3) AND i_D(2) AND i_D(1));
	c_Sd <= (  NOT i_D(3) AND i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR ( NOT i_D(2) AND NOT i_D(1) AND i_D(0)) OR (i_D(2) AND i_D(1) AND i_D(0)) OR (i_D(3) AND NOT i_D(2) AND i_D(1) AND NOT i_D(0));
	--c_Se <= (  NOT i_D(3) AND i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR ( NOT i_D(3) AND i_D(0)) OR (i_D(3) AND NOT i_D(2) AND NOT i_D(1) AND i_D(0));
	c_Sf <= ( i_D(3) AND i_D(2) AND NOT i_D(1)) OR ( NOT i_D(3) AND NOT i_D(2) AND i_D(0)) OR ( NOT i_D(3) AND NOT i_D(2) AND i_D(1)) OR ( NOT i_D(3) AND i_D(1) AND i_D(0));
	--c_Sg <= (  NOT i_D(3) AND NOT i_D(2) AND NOT i_D(1) AND NOT i_D(0)) OR ( NOT i_D(3) AND i_D(2) AND i_D(1) AND i_D(0));

	
	
	
end sevenSegDecoder_arch;
