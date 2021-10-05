####################################################################################
#             MAIN SETUP (root attributes & setup variables)                       #
####################################################################################

##############################################################################
## Library INFO
##############################################################################

set_attribute script_search_path {. ../../tcl} /
set_attribute init_hdl_search_path {. ../../rtl} /
set_attribute qos_report_power true /
set_attribute invs_gzip_interface_files true /

include source.libs.tcl

#create_library_domain { ST_WC_1_0V }
#set_attribute library $library_set ST_WC_1_0V
set_attribute library $library_set /
set_attribute lef_library $lef_set /

# Provide either cap_table_file or the qrc_tech_file
set_attribute cap_table_file ${captables} /
#set_attribute qrc_tech_file <file> /
#set_attribute wireload_mode <value> /

##############################################################################
## Preset global variables and attributes
##############################################################################
set DESIGN "$::env(DESIGN_NAME)"
set SYN_EFF "$::env(GENERIC_EFFORT)"
set MAP_EFF "$::env(MAP_EFFORT)"
set PHYS_EFF "$::env(OPT_EFFORT)"
set DATE [regsub -all ":" [clock format [clock seconds] -format "%b%d-%T"] "_"]
# set _OUTPUTS_PATH outputs/_${DATE}
# set _REPORTS_PATH reports/_${DATE}
# set _LOG_PATH logs/_${DATE}
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs

set_attribute information_level 7 /
set_attribute hdl_track_filename_row_col true
set_attribute interconnect_mode ple 

##############################################################################
## Create folders and set dirs
##############################################################################

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}

if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}

##set ET_WORKDIR <ET work directory>

##############################################################################
## Multithreading configuration
##############################################################################

##Uncomment and specify machine names to enable super-threading.
set_attribute super_thread_servers {localhost localhost localhost localhost localhost localhost localhost localhost} /
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
set_attribute max_cpus_per_server 8 /

##############################################################################
## Optimization attributes
##############################################################################

##Default undriven/unconnected setting is 'none'.  
##set_attribute hdl_unconnected_input_port_value 0 | 1 | x | none /
##set_attribute hdl_undriven_output_port_value   0 | 1 | x | none /
##set_attribute hdl_undriven_signal_value        0 | 1 | x | none /
set_attribute tns_opto true /
set_attr optimize_constant_0_flops "$::env(OPTIMIZE_CONSTANT_FLOPS)" /
set_attr optimize_constant_1_flops "$::env(OPTIMIZE_CONSTANT_FLOPS)" /
set_attr delete_unloaded_seqs "$::env(DELETE_UNLOADED_SEQS)"  /

##############################################################################
## Set power configs
##############################################################################

#read_power_intent -module hevc -cpf hevc.cpf
#check_library

## Power root attributes
if {[expr {[info exists ::env(ENABLE_CLOCK_GATING)] && [string is true -strict $::env(ENABLE_CLOCK_GATING)]}]} {
    set_attribute lp_insert_clock_gating true /
    set_attribute lp_clock_gating_exceptions_aware true /
}
set_attribute lp_power_analysis_effort high /
set_attribute lp_power_unit uW /

##################################################
# Avoid CLK_BUF
##################################################
if {[expr {[info exists ::env(ENABLE_CLK_BUF)] && [string is false -strict $::env(ENABLE_CLK_BUF)]}]} {
	set_attribute avoid true BUF_X1
	set_attribute avoid true BUF_X2
	set_attribute avoid true BUF_X4
	set_attribute avoid true BUF_X8
        set_attribute avoid true BUF_X12
        set_attribute avoid true BUF_X16
	set_attribute avoid true CLKBUF_X1
        set_attribute avoid true CLKBUF_X2
        set_attribute avoid true CLKBUF_X4
        set_attribute avoid true CLKBUF_X8
        set_attribute avoid true CLKBUF_X12
        set_attribute avoid true CLKBUF_X16

}

##################################################
# Avoid FA and HA
##################################################
if {[expr {[info exists ::env(ENABLE_HA_FA)] && [string is false -strict $::env(ENABLE_HA_FA)]}]} {
    # Disabling SVT FA and HA
    set_attribute avoid true HS65_LS_FA1X4
    set_attribute avoid true HS65_LS_FA1X9
    set_attribute avoid true HS65_LS_FA1X18
    set_attribute avoid true HS65_LS_FA1X27
    set_attribute avoid true HS65_LS_FA1X35
    set_attribute avoid true HS65_LS_HA1X4
    set_attribute avoid true HS65_LS_HA1X9
    set_attribute avoid true HS65_LS_HA1X18
    set_attribute avoid true HS65_LS_HA1X27
    set_attribute avoid true HS65_LS_HA1X35
    
    if {[expr {[info exists ::env(ENABLE_MULTI_VT)] && [string is true -strict $::env(ENABLE_MULTI_VT)]}]} {
        # Disabling LVT FA and HA
        set_attribute avoid true HS65_LL_FA1X4
        set_attribute avoid true HS65_LL_FA1X9
        set_attribute avoid true HS65_LL_FA1X18
        set_attribute avoid true HS65_LL_FA1X27
        set_attribute avoid true HS65_LL_FA1X35
        set_attribute avoid true HS65_LL_HA1X4
        set_attribute avoid true HS65_LL_HA1X9
        set_attribute avoid true HS65_LL_HA1X18
        set_attribute avoid true HS65_LL_HA1X27
        set_attribute avoid true HS65_LL_HA1X35

        # Disabling HVT FA and HA
        set_attribute avoid true HS65_LH_FA1X4
        set_attribute avoid true HS65_LH_FA1X9
        set_attribute avoid true HS65_LH_FA1X18
        set_attribute avoid true HS65_LH_FA1X27
        set_attribute avoid true HS65_LH_FA1X35
        set_attribute avoid true HS65_LH_HA1X4
        set_attribute avoid true HS65_LH_HA1X9
        set_attribute avoid true HS65_LH_HA1X18
        set_attribute avoid true HS65_LH_HA1X27
        set_attribute avoid true HS65_LH_HA1X35
    }
}


##############################################################################
## Set Innovus configuration
##############################################################################

set env(ENCOUNTER) /lab215/tools/cadence/GENUS171/bin/innovus
set_attribute innovus_executable /lab215/tools/cadence/GENUS171/bin/innovus /               ;# Set path to innovus executable to used by synth -to_placed
regexp \[0-9\]+(\.\[0-9\]+) [get_attribute program_version /] exe_ver exe_sub_ver
puts "Executable Version: $exe_ver"
set_attribute time_recovery_arcs true /
set_attribute timing_use_ecsm_pin_capacitance true /

