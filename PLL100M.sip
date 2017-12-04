set_global_assignment -entity "PLL100M" -library "lib_PLL100M" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL100M" -library "lib_PLL100M" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL100M" -library "lib_PLL100M" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL100M" -name SPD_FILE [file join $::quartus(sip_path) "PLL100M.spd"]

set_global_assignment -library "lib_PLL100M" -name MISC_FILE [file join $::quartus(sip_path) "PLL100M_sim/PLL100M.vo"]
