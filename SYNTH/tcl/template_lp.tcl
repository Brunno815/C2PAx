#### Template Script for RTL->Gate-Level Flow (generated from RC GENUS15.22 - 15.20-s024_1) 

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

####################################################################
## Load Design
####################################################################

#### Including setup file (root attributes & setup variables).
include $::env(TCL_ROOT)/setup_template_lp.tcl

#
if {[expr {[info exists ::env(RESYNTHETIZE)] && [string is false -strict $::env(RESYNTHETIZE)]}]} {
    read_hdl -v2001 $::env(CURRENT_HDL_FOLDER)/decision.v

    elaborate $DESIGN
    puts "Runtime & Memory after 'read_hdl'"
    time_info Elaboration

    check_design -unresolved -unloaded -undriven > $_REPORTS_PATH/elab/${DESIGN}_check_design.rpt
} else {
    read_netlist $::env(CURRENT_HDL_FILE)
}


####################################################################
## Constraints Setup
####################################################################

read_sdc "$::env(CONSTR_ROOT)/decision.sdc"

###################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

if {[llength [all::all_seqs]] > 0} {
    define_cost_group -name C2C -design $DESIGN
    path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C
}

foreach cg [find / -cost_group *] {
    report timing -cost_group [list $cg] >> $_REPORTS_PATH/elab/${DESIGN}_pretim_${cg}.rpt
}
report_timing -lint > $_REPORTS_PATH/elab/${DESIGN}_timing_lint.rpt
report_timing -worst 3 > $_REPORTS_PATH/elab/${DESIGN}_timing_nworst_3.rpt

#### Including LOW POWER setup. (Leakage/Dynamic power/Clock Gating setup)
include $::env(TCL_ROOT)/power_template_lp.tcl


if {[expr {[info exists ::env(RESYNTHETIZE)] && [string is true -strict $::env(RESYNTHETIZE)]}]} {
    if {[expr {[info exists ::env(SYNTH_IN_RESYNTH)] && [string is true -strict $::env(SYNTH_IN_RESYNTH)]}]} {
        set_attribute syn_generic_effort $SYN_EFF /
	syn_generic
	puts "Runtime & Memory after 'syn_generic'"
	time_info GENERIC
	
	report datapath > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
	report_timing -lint > $_REPORTS_PATH/generic/${DESIGN}_timing_lint.rpt
	report_timing -worst 3 > $_REPORTS_PATH/generic/${DESIGN}_timing_nworst_3.rpt

	set_attribute syn_map_effort $MAP_EFF /
	syn_map
	puts "Runtime & Memory after 'syn_map'"
	time_info MAPPED
	#write_snapshot -outdir $_REPORTS_PATH -tag map
	#report_summary -outdir $_REPORTS_PATH
        report datapath > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt
        report_timing -lint > $_REPORTS_PATH/map/${DESIGN}_timing_lint.rpt
        report_timing -worst 3 > $_REPORTS_PATH/map/${DESIGN}_timing_nworst_3.rpt

	set_attribute syn_opt_effort $MAP_EFF /
	syn_opt

	puts "Runtime & Memory after incremental synthesis"
	time_info INCREMENTAL

	puts "Fazer incremental"
	syn_opt -incremental
	puts "Fazer snapshot"
	write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_incrementar
	#report_summary -outdir $_REPORTS_PATH
	puts "Runtime & Memory after incremental optimization synthesis"
        time_info INCREMENTAL_POST_SCAN_CHAINS

    }
}

####################################################################################################
## Synthesizing to generic 
####################################################################################################
if {[expr {[info exists ::env(RESYNTHETIZE)] && [string is false -strict $::env(RESYNTHETIZE)]}]} {
    set_attribute syn_generic_effort $SYN_EFF /
    syn_generic
    puts "Runtime & Memory after 'syn_generic'"
    time_info GENERIC

    #write_snapshot -outdir $_REPORTS_PATH -tag generic
    report datapath > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
    report_timing -lint > $_REPORTS_PATH/generic/${DESIGN}_timing_lint.rpt
    report_timing -worst 3 > $_REPORTS_PATH/generic/${DESIGN}_timing_nworst_3.rpt

    ## Synthesizing to gates
    set_attribute syn_map_effort $MAP_EFF /
    syn_map
    puts "Runtime & Memory after 'syn_map'"
    time_info MAPPED
    #write_snapshot -outdir $_REPORTS_PATH -tag map
    #report_summary -outdir $_REPORTS_PATH
    report datapath > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt
    report_timing -lint > $_REPORTS_PATH/map/${DESIGN}_timing_lint.rpt
    report_timing -worst 3 > $_REPORTS_PATH/map/${DESIGN}_timing_nworst_3.rpt

    #report_power -clock_tree > $_REPORTS_PATH/map/${DESIGN}_clocktree_power.rpt

    ## Opt Synthesis

    set_attribute syn_opt_effort $MAP_EFF /
    syn_opt
    #write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
    #report_summary -outdir $_REPORTS_PATH

    puts "Runtime & Memory after incremental synthesis"
    time_info INCREMENTAL

    ## Incremental Synthesis
     
    puts "Fazer incremental"
    syn_opt -incremental
    puts "Fazer snapshot"
    write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_incrementar
    #report_summary -outdir $_REPORTS_PATH
    puts "Runtime & Memory after incremental optimization synthesis"
    time_info INCREMENTAL_POST_SCAN_CHAINS

    ## QoS Prediction & Optimization.
    #####################################################################################################
    if {[expr {[info exists ::env(USE_INNOVUS)] && [string is true -strict $::env(USE_INNOVUS)]}]} {
        puts "Using Innovus physical flow"
        set_attribute invs_temp_dir ${_OUTPUTS_PATH}/genus_invs_pred /
        set_attribute syn_opt_effort $PHYS_EFF /
        syn_opt -physical
        puts "Runtime & Memory after physical synthesis"
        time_info PHYSICAL
    } else {
        puts "Skipping Innovus physical flow"
    }
}

    #puts "$::env(TCF_ROOT)/SYNTH_$::env(BASE_SIM_FILENAME).tcf"

# Read Activity file after synthesis
puts "Checking for input stimuli file"
if {[catch {set vcd_file_list [glob "$::env(VCD_ROOT)/$::env(BASE_SIM_FILENAME)*.vcd"]} err]} {
    puts "VCD files not present!"
    puts "Testing for TCF files..."
    
    if {[catch {set tcf_file_list [glob "$::env(TCF_ROOT)/$::env(BASE_SIM_FILENAME)*.tcf"]} err]} { 
        puts "TCF files not present!"
    } else {
        puts "Found TCF files!"
    }
}

if {[info exists vcd_file_list]} {
    puts "Starting accurate power estimation with VCD..."
    foreach current_vcd $vcd_file_list {
        set file_basename [file rootname [file tail $current_vcd]]
        set dataset [lindex [split $file_basename _] end]
        puts "Reading VCD file: ${file_basename}."
        read_vcd -static -vcd_scope $::env(TESTBENCH_INST) $current_vcd
	write_saif decision > ${_REPORTS_PATH}/${DESIGN}_${dataset}.saif
        report_gates -power > ${_REPORTS_PATH}/${DESIGN}_${dataset}_gates_power.rpt
        report_power -verbose > ${_REPORTS_PATH}/${DESIGN}_${dataset}_power.rpt
        report_power -verbose -tcf_summary > ${_REPORTS_PATH}/${DESIGN}_${dataset}_tcf_summary.rpt
        report_qor -power -levels_of_logic > ${_REPORTS_PATH}/${DESIGN}_${dataset}_qor.rpt
        report clock_gating > $_REPORTS_PATH/${DESIGN}_${dataset}_clockgating.rpt
        report_power -clock_tree > $_REPORTS_PATH/${DESIGN}_${dataset}_clocktree_power.rpt
    }
} elseif {[info exists tcf_file_list]} { 
    puts "Starting accurate power estimation with TCF..."
    foreach current_tcf $tcf_file_list {
        set file_basename [file rootname [file tail $current_tcf]]
        #set dataset [lindex [split $file_basename _] end]
	set dataset [join [lrange [split $file_basename _] 12 end] "_"]
        puts "Reading TCF file: ${file_basename}."
        read_tcf $current_tcf
	write_saif decision > ${_REPORTS_PATH}/${DESIGN}_${dataset}.saif
        report_gates -power > ${_REPORTS_PATH}/${DESIGN}_${dataset}_gates_power.rpt
        report_power -verbose > ${_REPORTS_PATH}/${DESIGN}_${dataset}_power.rpt
        report_power -verbose -tcf_summary > ${_REPORTS_PATH}/${DESIGN}_${dataset}_tcf_summary.rpt
        report_qor -power -levels_of_logic > ${_REPORTS_PATH}/${DESIGN}_${dataset}_qor.rpt
        report clock_gating > $_REPORTS_PATH/${DESIGN}_${dataset}_clockgating.rpt
        report_power -clock_tree > $_REPORTS_PATH/${DESIGN}_${dataset}_clocktree_power.rpt
    }
} else {
    puts "Starting tool-based power estimation"
    report_gates -power > ${_REPORTS_PATH}/${DESIGN}_gates_power.rpt
    report_power -verbose > ${_REPORTS_PATH}/${DESIGN}_power.rpt
    report_power -hier -depth 3 -verbose > ${_REPORTS_PATH}/${DESIGN}_power_modules.rpt
    report_power -verbose -tcf_summary > ${_REPORTS_PATH}/${DESIGN}_tcf_summary.rpt
    report_qor -power -levels_of_logic > ${_REPORTS_PATH}/${DESIGN}_qor.rpt
    report clock_gating > $_REPORTS_PATH/${DESIGN}_clockgating.rpt
    #report_power -clock_tree > $_REPORTS_PATH/${DESIGN}_clocktree_power.rpt
}



######################################################################################################
## write backend file set (verilog, SDC, config, etc.)
######################################################################################################

# Timing Report
report_timing -worst 3 > $_REPORTS_PATH/${DESIGN}_timing_nworst_3.rpt
report_timing -lint -verbose > $_REPORTS_PATH/${DESIGN}_timing_lint.rpt
foreach cg [find / -cost_group *] {
  report timing -cost_group [list $cg] >> $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_final.rpt
}

# Report design 
report area -physical -normalize_with_gate HS65_LS_NAND2X2 > $_REPORTS_PATH/${DESIGN}_area_NAND2_eq.rpt
#report area -physical -normalize_with_gate NAND2_X2 > $_REPORTS_PATH/${DESIGN}_area_NAND2_eq.rpt
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
write_snapshot -outdir $_REPORTS_PATH -tag final
#report_summary -outdir $_REPORTS_PATH

write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
write_design  -innovus -base_name ${_OUTPUTS_PATH}/${DESIGN}
#write_do_lec -no_exit -revised_design ${output_path}/${DESIGN}.v -logfile ${log_path}/final.out > $lec_path/${DESIGN}-final.do
#write_sdf -recrem merge_always -setuphold merge_always -edges check_edge > ${_OUTPUTS_PATH}/${DESIGN}.sdf
write_sdf > ${_OUTPUTS_PATH}/${DESIGN}.sdf
#foreach mode [find / -mode *] {
#  write_sdc -mode $mode > ${_OUTPUTS_PATH}/${DESIGN}_m_${mode}.sdc
#}


#################################
### write_do_lec
#################################


#write_do_lec -golden_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
##Uncomment if the RTL is to be compared with the final netlist..
##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

puts "Final Runtime & Memory."
time_info FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

#file copy [get_attribute stdout_log /] ${_LOG_PATH}/.

quit
