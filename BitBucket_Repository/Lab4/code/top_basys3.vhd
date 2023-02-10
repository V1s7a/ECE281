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
--| -------------------------------------------------asdf--------------------------
--|
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 3/9/2018  MOdified by Capt Dan Johnson (3/30/2020)
--| DESCRIPTION   : This file implements the top level module for a BASYS 3 to 
--|					drive the Lab 4 Design Project (Advanced Elevator Controller).
--|
--|					Inputs: clk       --> 100 MHz clock from FPGA
--|							btnL      --> Rst Clk
--|							btnR      --> Rst FSM
--|							btnU      --> Rst Master
--|							btnC      --> GO (request floor)
--|							sw(15:12) --> Passenger location (floor select bits)
--| 						sw(3:0)   --> Desired location (floor select bits)
--| 						 - Minumum FUNCTIONALITY ONLY: sw(1) --> up_down, sw(0) --> stop
--|							 
--|					Outputs: led --> indicates elevator movement with sweeping pattern (additional functionality)
--|							   - led(10) --> led(15) = MOVING UP
--|							   - led(5)  --> led(0)  = MOVING DOWN
--|							   - ALL OFF		     = NOT MOVING
--|							 an(3:0)    --> seven-segment display anode active-low enable (AN3 ... AN0)
--|							 seg(6:0)	--> seven-segment display cathodes (CG ... CA.  DP unused)
--|
--| DOCUMENTATION : Recieved help from C3C Stearns about logic issues when wiring.
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : MooreElevatorController.vhd, clock_divider.vhd, sevenSegDecoder.vhd
--|				   thunderbird_fsm.vhd, sevenSegDecoder, TDM4.vhd, OTHERS???
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


entity top_basys3 is
	port(

		clk     :   in std_logic; -- native 100MHz FPGA clock
		
		-- Switches (16 total)
		sw  	:   in std_logic_vector(15 downto 0) := (others => '0');
		
		-- Buttons (5 total)
		btnC	:	in	std_logic;					  -- GO
		btnU	:	in	std_logic;					  -- master_reset
		btnL	:	in	std_logic;                    -- clk_reset
		btnR	:	in	std_logic;	                  -- fsm_reset
		--btnD	:	in	std_logic;			
		
		-- LEDs (16 total)
		led 	:   out std_logic_vector(15 downto 0);

		-- 7-segment display segments (active-low cathodes)
		seg		:	out std_logic_vector(6 downto 0);

		-- 7-segment display active-low enables (anodes)
		an      :	out std_logic_vector(3 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	component sevenSegDecoder is
		port(
			i_D	: in std_logic_vector(3 downto 0);
			o_S	: out std_logic_vector(6 downto 0)
		);
	end component sevenSegDecoder;
	
	component MooreElevatorController is
		Port ( i_clk 	 : in  STD_LOGIC;
			   i_reset 	 : in  STD_LOGIC; -- synchronous
			   i_stop 	 : in  STD_LOGIC;
			   i_up_down : in  STD_LOGIC;
			   o_floor 	 : out STD_LOGIC_VECTOR (3 downto 0);
			   o_up : out std_logic;
			   o_down : out std_logic );
	end component MooreElevatorController;
	
	component hexDecDecoder is
        port(
            i_hex : in std_logic_vector(3 downto 0);
            o_upper : out std_logic_vector(3 downto 0);
            o_lower : out std_logic_vector(3 downto 0)
        );
    end component hexDecDecoder;
	
	component clock_divider is
		generic ( constant k_DIV : natural := 2	);
		port ( 	i_clk    : in std_logic;		   -- basys3 clk
				i_reset  : in std_logic;		   -- asynchronous
				o_clk    : out std_logic		   -- divided (slow) clock
		);
	end component clock_divider;
	
	component thunderbird_fsm is 
      port(
        -- Identify input and output bits here
        i_clk, i_reset : in std_logic;
        i_left, i_right : in std_logic;
        o_lights_L : out std_logic_vector(2 downto 0);
        o_lights_R : out std_logic_vector(2 downto 0)
      );
    end component thunderbird_fsm;
    
    component  TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_CLK         : in  STD_LOGIC;
               i_RESET         : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_DATA        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_SEL        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;

    signal w_clk_tdm : std_logic;
    signal w_clk_thunderbird : std_logic;
	signal w_clk : std_logic;
	signal w_floor : std_logic_vector (3 downto 0);
	signal w_reset_moore : std_logic;
	signal w_reset_clk : std_logic;
	
	signal o_lights_L : std_logic_vector(2 downto 0);
	signal o_lights_R : std_logic_vector(2 downto 0);
	
	signal w_up : std_logic;
	signal w_down : std_logic;
	
	signal w_an : std_logic_vector(3 downto 0);
	
	signal w_seg_upper : std_logic_vector(6 downto 0);
	signal w_seg_lower : std_logic_vector (6 downto 0);
	
	signal w_hex_upper : std_logic_vector(3 downto 0);
	signal w_hex_lower : std_logic_vector (3 downto 0);
	
	
	
  
begin
	-- PORT MAPS ----------------------------------------

	sevenSegDecoder_inst_upper: sevenSegDecoder
		port map(
			i_D => w_hex_upper,
			o_S => w_seg_upper
		);

	sevenSegDecoder_inst_lower: sevenSegDecoder
		port map(
			i_D => w_hex_lower,
			o_S => w_seg_lower
		);
	
	uut_inst : MooreElevatorController
		port map (
			i_clk     => w_clk,
			i_reset   => w_reset_moore,
			i_stop    => sw(0),
			i_up_down => sw(1),
			o_up => w_up,
			o_down => w_down,
			o_floor   => w_floor
		);
	
	hexDecDecoder_inst : hexDecDecoder
	   port map (
	       i_hex => w_floor,
	       o_upper => w_hex_upper,
	       o_lower => w_hex_lower
	   );
	
	
	clkdiv_inst : clock_divider 		--instantiation of clock_divider to take 
        generic map ( k_DIV => 25000000 ) -- 2 Hz clock from 100 MHz
        port map (						  
            i_clk   => clk,
            i_reset => w_reset_clk,
            o_clk   => w_clk
        );    
	clkdiv_inst_thunderbird : clock_divider
	   generic map (k_DIV => 5000000 )
	   port map(
	       i_clk => clk,
	       i_reset => w_reset_clk,
	       o_clk => w_clk_thunderbird
	   );
	   
	 clkdiv_inst_tdm : clock_divider
	   generic map (k_DIV => 200000)
	   port map (
	       i_clk => clk,
	       i_reset => w_reset_clk,
	       o_clk => w_clk_tdm
	   );
	   

	   
	 thunderbird_fsm_inst : thunderbird_fsm
	    port map (
         i_left  => w_up,
         i_right => w_down,
         i_reset => btnU,
         i_clk   => w_clk_thunderbird,
         o_lights_L(0)  => o_lights_L(0),
         o_lights_L(1)  => o_lights_L(1),
         o_lights_L(2)  => o_lights_L(2),
         o_lights_R(0)  => o_lights_R(0),
         o_lights_R(1)  => o_lights_R(1),
         o_lights_R(2)  => o_lights_R(2)
           );
	TDM4_inst : TDM4
	   generic map (k_WIDTH => 7)
       port map (
           i_CLK => w_clk_tdm,
           i_RESET => w_reset_clk,
           i_D3 => w_seg_upper,
           i_D2 => w_seg_lower,
           i_D1 => "1111111",
           i_D0 => "1111111",       
           o_SEL => an,
           o_DATA => seg
       );
	-- CONCURRENT STATEMENTS ----------------------------
	led(9 downto 6) <= (others => '0');
	
	led(5)<= o_lights_R(0);
	led(4)<= o_lights_R(0);
	led(3)<= o_lights_R(1);
	led(2)<= o_lights_R(1);
	led(1)<= o_lights_R(2);
	led(0)<= o_lights_R(2);
	led(10)<= o_lights_L(0);
	led(11)<= o_lights_L(0);
	led(12)<= o_lights_L(1);
	led(13)<= o_lights_l(1);
	led(14)<= o_lights_L(2);
	led(15)<= o_lights_L(2);
	
	
	
	--an <= "1110";

	-- leave unused switches UNCONNECTED
	
	-- Ignore the warnings associated with these signals
	-- Alternatively, you can create a different board implementation, 
	--   or make additional adjustments to the constraints file
	
	-- wire up active-low 7SD anodes (an) as required
	-- Tie any unused anodes to power ('1') to keep them off
	
	w_reset_moore <= btnU or btnR;
	w_reset_clk <= btnU or btnL;
	
	
	
end top_basys3_arch;
