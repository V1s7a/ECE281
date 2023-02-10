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
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 02/22/2018
--| DESCRIPTION   : This file implements the top level module for a BASYS 3 to 
--|					drive a Thunderbird taillight controller FSM.
--|
--|					Inputs:  clk 	--> 100 MHz clock from FPGA
--|                          sw(15) --> left turn signal
--|                          sw(0)  --> right turn signal
--|                          btnL   --> clk reset
--|                          btnR   --> FSM reset
--|							 
--|					Outputs:  led(15:13) --> left turn signal lights
--|					          led(2:0)   --> right turn signal lights
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : thunderbird_fsm.vhd, clock_divider.vhd
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
	
entity hexDecDecoder is
	port(
		i_hex : in std_logic_vector(3 downto 0);
		o_upper : out std_logic_vector(3 downto 0);
		o_lower : out std_logic_vector(3 downto 0)
	);
end hexDecDecoder;

architecture hexDecDecoder_arch of hexDecDecoder is


begin

	o_lower <= x"0" when ((i_hex = x"0") or (i_hex = x"a")) else
			   x"1" when ((i_hex = x"1") or (i_hex = x"b")) else
			   x"2" when ((i_hex = x"2") or (i_hex = x"c")) else
			   x"3" when ((i_hex = x"3") or (i_hex = x"d")) else
			   x"4" when ((i_hex = x"4") or (i_hex = x"e")) else
			   x"5" when ((i_hex = x"5") or (i_hex = x"f")) else
			   x"6" when ((i_hex = x"6")) else
			   x"7" when ((i_hex = x"7")) else
			   x"8" when ((i_hex = x"8")) else
			   x"9" when ((i_hex = x"9")) else
			   x"0";
			   
	o_upper <= x"0" when ( (i_hex = x"1") or (i_hex = x"2") or (i_hex = x"3") or (i_hex = x"4") or (i_hex = x"5") or (i_hex = x"6") or (i_hex = x"7") or (i_hex = x"8") or (i_hex = x"9")) else
			   x"1" when ( (i_hex = x"a") or (i_hex = x"b") or (i_hex = x"c") or (i_hex = x"d") or (i_hex = x"e") or(i_hex = x"f")) else
			   x"0";

end hexDecDecoder_arch;