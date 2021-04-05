# Why Doesn't my Code Work?

## Why doesn't my code generate a bitstream?

1. Did you include the constraints file, with the appropriate constraints commented and or uncommented?

   Forgetting to set a property in the constraint file but declaring the port in the top architectural file will make Vivado complain and not generate a bitstream.

2. Do the constraint file property names in `basys3_master.xdc` match exactly with the port names in the `top_basys3.vhd` file?

   For instance, in `basys3_master.xdc`, the led light 0 is uncommented and property assigned to a port array (of 1!), `led[0]`:

   ```vhdl
   set_property PACKAGE_PIN U16 [get_ports {led[0]}]		set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
   ```

   There should be a corresponding name (and type!) matched entry in `top_basys3.vhd`, such as this:

   ```vhdl
   entity top_basys3 is
   	port(
   	   led:out std_logic_vector(0 downto 0);
   ```

3. Another one.

## Why doesn't my testbench simulate?

1. Did you make your test bench a simulation source?

   Adding a testbench as a design source won't work.  it needs to be added as a simulation source, and then set as the top sim source.

2. Did you make your test bench "on top?"  

   Vivado has to know what to simulate.  It will default to whatever simulation source is "on top" (denoted by a block hierarchy icon to the left of the file).  Right click on the desired test bench file and select "Set as Top."

   ![](assets/Set as Top.jpg) 

3. Hey!  I can't see anything useful in my waveforms!

   The timescale for the simulation can be too long and the resolution to coarse to make out your testbed inputs.  Go to "Run" and choose "Restart."  The go to "Run" and choose "Run For..." and pick a reasonable amount of time given the stimulation you put into the testbench.  Finally, right click on the waveforms and pick "Full View."  Don't forget to pick a useful radix (hex, binary) to understand the bus views of the waveforms. 

## Why doesn't my code synthesize?

1. Did you put a semicolon after your last port entry?

2. Is your top level architecture recognized as such by Vivado?

   Go to the "Flow Navigator" and select "Settings" (with the gear next to it).  Ensure that Top module name is `top_basys3` or the appropriate top level architecture file.

