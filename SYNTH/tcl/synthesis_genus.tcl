
# Load library configuration
include $::env(MULT_ROOT)/tcl/config_st.tcl

# Set the design name
set design_name "multiplier_arch"

# Synthesis level efforts
set GENERIC_EFF "high"
set MAP_EFF     "high"
set OPT_EFF     "high"

##################################################
# Set design elaboration parameters
##################################################
set_db hdl_track_filename_row_col true
set_db interconnect_mode ple 
read_hdl -vhdl $::env(CURRENT_HDL_FILE)
elaborate ${design_name}
check_design -unresolved -unloaded -undriven

# Read SDC constraints
read_sdc "$::env(MULT_ROOT)/sdc/functional_constraints.sdc"

##################################################
# Timing Analysis before synthesis
##################################################
report timing -lint -verbose

##################################################
# Start synthesis
##################################################
set_db syn_generic_effort ${GENERIC_EFF}
set_db syn_map_effort ${MAP_EFF}
set_db syn_opt_effort ${OPT_EFF}
syn_generic $design_name
syn_map $design_name
set_db common_ui false
set_attr preserve size_ok ${design_name}
set_attribute common_ui true
syn_opt $design_name

# Read VCD files if present
#if {[file exists $::env(VCD_FILE)]} {
#    puts "VCD file present! Starting accurate power estimation..."
#    puts "Reading VCD file: $::env(VCD_FILE)"
#    read_vcd -static -vcd_scope i_multiplier_arch $::env(VCD_FILE)
#} else {
#    puts "VCD file not present! Starting tool-based power estimation..."
#}

# Read TCF files if present
if {[file exists $::env(VCD_FILE)]} {
    puts "TCF file present! Starting accurate power estimation..."
    puts "Reading VCD file: $::env(VCD_FILE)"
    #read_vcd -static -vcd_scope i_multiplier_arch $::env(VCD_FILE)
    read_tcf $::env(VCD_FILE)
} else {
    puts "VCD file not present! Starting tool-based power estimation..."
}

report_gates -power > ${reports_path}/${design_name}_gates_power.rpt
report_power -verbose > ${reports_path}/${design_name}_power.rpt
report_power -verbose -tcf_summary > ${reports_path}/${design_name}_tcf_summary.rpt
report_qor -power -levels_of_logic > ${reports_path}/${design_name}_qor.rpt

##################################################
# Write common reports
##################################################
report_area > ${reports_path}/${design_name}_area.rpt
report_clocks > ${reports_path}/${design_name}_clocks.rpt
report_gates > ${reports_path}/${design_name}_gates.rpt
report_nets > ${reports_path}/${design_name}_nets.rpt
report_timing -lint -verbose > ${reports_path}/${design_name}_timing_lint.rpt
report_timing -nworst 4 > ${reports_path}/${design_name}_timing_nworst.rpt

write_design  -innovus -base_name ${output_path}/${design_name}
#write_do_lec -no_exit -revised_design ${output_path}/${design_name}.v -logfile ${log_path}/final.out > $lec_path/${design_name}-final.do
write_sdf -recrem merge_always -setuphold merge_always -edges check_edge > ${output_path}/${design_name}.sdf
exit
