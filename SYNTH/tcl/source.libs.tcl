
# File root
set DK_PATH "/pdk/st/cmos065_421"

# Timing libraries
set lib_lvt_wc_1_00 {/lab215/pdk/st/cmos065_421/CORE65LPLVT_SNPS-AVT-CDS_4.1/libs/CORE65LPLVT_wc_1.00V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPLVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPLVT_wc_1.00V_125C.lib}

set lib_svt_wc_1_00 {/lab215/pdk/st/cmos065_421/CORE65LPSVT_SNPS-AVT-CDS_4.1/libs/CORE65LPSVT_wc_1.00V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPSVT_wc_1.00V_125C.lib}

set lib_hvt_wc_1_00 {/lab215/pdk/st/cmos065_421/CORE65LPHVT_SNPS-AVT-CDS_4.1/libs/CORE65LPHVT_wc_1.00V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPHVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPHVT_wc_1.00V_125C.lib}

set lib_lvt_wc_0_90 {/lab215/pdk/st/cmos065_421/CORE65LPLVT_SNPS-AVT-CDS_4.1/libs/CORE65LPLVT_wc_0.90V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPLVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPLVT_wc_1.00V_125C.lib}

set lib_svt_wc_0_90 {/lab215/pdk/st/cmos065_421/CORE65LPSVT_SNPS-AVT-CDS_4.1/libs/CORE65LPSVT_wc_0.90V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPSVT_wc_1.00V_125C.lib}

set lib_hvt_wc_0_90 {/lab215/pdk/st/cmos065_421/CORE65LPHVT_SNPS-AVT-CDS_4.1/libs/CORE65LPHVT_wc_0.90V_125C.lib \
    /lab215/pdk/st/cmos065_421/CLOCK65LPHVT_SNPS-AVT-CDS_2.1/libs/CLOCK65LPHVT_wc_0.90V_125C.lib}

# LEF Files
set lef_lvt {/lab215/pdk/st/cmos065_421/CORE65LPLVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPLVT_soc.lef \
	/lab215/pdk/st/cmos065_421/CLOCK65LPLVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPLVT_soc.lef}

set lef_svt {/lab215/pdk/st/cmos065_421/CORE65LPSVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPSVT_soc.lef \
	/lab215/pdk/st/cmos065_421/CLOCK65LPSVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPSVT_soc.lef}

set lef_hvt {/lab215/pdk/st/cmos065_421/CORE65LPHVT_SNPS-AVT-CDS_4.1/CADENCE/LEF/CORE65LPHVT_soc.lef \
	/lab215/pdk/st/cmos065_421/CLOCK65LPHVT_SNPS-AVT-CDS_2.1/CADENCE/LEF/CLOCK65LPHVT_soc.lef}

set tech_lef {/lab215/pdk/st/cmos065_421/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Worst.lef \
	/lab215/pdk/st/cmos065_421/PRHS65_SNPS-AVT-CDS_5.0/CADENCE/LEF/PRHS65_soc.lef}

# Captable
set captables "/lab215/pdk/st/cmos065_421/adv_EncounterTechnoKit_cmos065_7m4x0y2z_4.2/TECH/cmos065_7m4x0y2z_Worst.captable"

#
if {[expr {[info exists ::env(SYNTH_VDD)] && [expr {$::env(SYNTH_VDD) == 0.9}]}]} {
    if {[expr {[info exists ::env(ENABLE_MULTI_VT)] && [string is true -strict $::env(ENABLE_MULTI_VT)]}]} {
        set library_set [list {*}$lib_lvt_wc_0_90 {*}$lib_svt_wc_0_90 {*}$lib_hvt_wc_0_90]
        set lef_set [list {*}$tech_lef {*}$lef_lvt {*}$lef_svt {*}$lef_hvt]
    } else {
        set library_set [list {*}$lib_svt_wc_0_90]
        set lef_set [list {*}$tech_lef {*}$lef_svt]
    }
} else {
    if {[expr {[info exists ::env(ENABLE_MULTI_VT)] && [string is true -strict $::env(ENABLE_MULTI_VT)]}]} {
        set library_set [list {*}$lib_lvt_wc_1_00 {*}$lib_svt_wc_1_00 {*}$lib_hvt_wc_1_00]
        set lef_set [list {*}$tech_lef {*}$lef_lvt {*}$lef_svt {*}$lef_hvt]
    } else {
        set library_set [list {*}$lib_svt_wc_1_00]
        set lef_set [list {*}$tech_lef {*}$lef_svt]
    }
}
