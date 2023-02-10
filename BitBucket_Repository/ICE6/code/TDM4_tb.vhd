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
--| FILENAME      : TDM4_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Capt Dan Johnson, **Your Name**
--| CREATED       : 03/2017 Last modified on 06/24/2020
--| DESCRIPTION   : This file tests the 4 to 1 TDM.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : TDM4.vhd
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
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
  
entity TDM4_tb is
end TDM4_tb;

architecture test_bench of TDM4_tb is 	
  
	component TDM4 is
		generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_CLK        : in  STD_LOGIC;
               i_RESET      : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_DATA       : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_SEL        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
	end component TDM4;
	
	signal i_CLK : std_logic;
	constant k_clk_period : time := 20 ns; -- Setup test clk (20 ns --> 50 MHz) and other signals
	signal i_RESET : std_logic ;
	constant k_IO_WIDTH : natural := 4;
	signal i_D3 :  std_logic_vector (k_IO_WIDTH - 1 downto 0);
    signal i_D2 :  std_logic_vector (k_IO_WIDTH - 1 downto 0);
    signal i_D1 : STD_LOGIC_VECTOR (k_IO_WIDTH - 1 downto 0);
    signal i_D0 :  STD_LOGIC_VECTOR (k_IO_WIDTH - 1 downto 0);
    signal o_DATA : STD_LOGIC_VECTOR (k_IO_WIDTH - 1 downto 0);
    signal o_SEL : std_logic_vector (3 downto 0);


	
begin
	-- PORT MAPS ----------------------------------------
	-- map ports for any component instances (port mapping is like wiring hardware)
	uut_inst : TDM4 
	generic map ( k_WIDTH =>  k_IO_WIDTH)
	port map ( i_CLK   => i_CLK,
		       i_RESET => i_RESET,
		       i_D3    => i_D3,
		       i_D2    => i_D2,
		       i_D1    => i_D1,
		       i_D0    => i_D0,
		       o_DATA  => o_DATA,
		       o_SEL   => o_SEL
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
	-----------------------------------------------------	
	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
		-- assign test values to data inputs
        o_SEL => "0111" when f_sel = "11" else
                 "1011" when f_sel = "10"   
                  
				
		-- reset the system first
		i_reset <= '1';
		wait for k_clk_period;		
		i_reset <= '0';
		
		wait; -- let the TDM do its work
	end process;	
	-----------------------------------------------------	
	
end test_bench;
