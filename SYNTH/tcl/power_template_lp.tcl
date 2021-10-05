##########################################################################################
#            LOW POWER setup (Leakage/Dynamic power/Clock Gating setup)                  #
##########################################################################################
#######################################################################################
## Leakage/Dynamic power/Clock Gating setup.
#######################################################################################
#
if {[expr {[info exists ::env(ENABLE_CLOCK_GATING)] && [string is true -strict $::env(ENABLE_CLOCK_GATING)]}]} {
    set_attribute lp_clock_gating_style latch "/designs/$DESIGN"
    set_attribute lp_clock_gating_min_flops 4 "/designs/$DESIGN"
    set_attribute lp_clock_gating_max_flops 32 "/designs/$DESIGN"
    set_attribute lp_insert_discrete_clock_gating_logic true /
    #set_attribute lp_clock_gating_cell [find /lib* -libcell <cg_libcell_name>] "/designs/$DESIGN"
}

set_attr lp_power_optimization_weight 0.95 "/designs/$DESIGN"
### The attribute has been set to default value "medium"
### you can try setting it to high to explore MVT QoR for low power optimization
set_attribute leakage_power_effort medium /
if {[expr {[info exists ::env(ENABLE_MULTI_VT)] && [string is true -strict $::env(ENABLE_MULTI_VT)]}]} {
	set_attribute lp_multi_vt_optimization_effort high /
}
set_attribute max_leakage_power 0.0 "/designs/$DESIGN"
set_attribute max_dynamic_power 0.0 "/designs/$DESIGN"
set_attribute lp_optimize_dynamic_power_first true "/designs/$DESIGN"


## read_tcf <TCF file name>
## read_saif <SAIF file name>
## read_vcd <VCD file name>

