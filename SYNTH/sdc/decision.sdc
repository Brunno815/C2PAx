## SDC File Constraints ##
set sdc_version 1.5
set_load_unit -picofarads 1

# Define the circuit clock
create_clock -name "CLK_IN" -add -period $::env(SYNTH_CLK_PERIOD) [dc::get_port {CLK}]
#create_clock -name "CLK_IN" -add -period 5.00 [dc::get_port {clk}]
#create_clock -name "CLK_IN" -add -period 6.70 [dc::get_port {clk}]

# Ignore timing for reset
#set_false_path -from [get_ports reset]

## INPUTS
set_input_delay -clock CLK_IN -max 0.1 [all_inputs]
set_input_transition -min -rise 0.003 [all_inputs]
set_input_transition -max -rise 0.16 [all_inputs]
set_input_transition -min -fall 0.003 [all_inputs]
set_input_transition -max -fall 0.16 [all_inputs]
set_output_delay -clock CLK_IN -max 0.1 [all_outputs]
 
## OUTPUTS
set_load -min 0.0014 [all_outputs]
set_load -max 0.32 [all_outputs]

