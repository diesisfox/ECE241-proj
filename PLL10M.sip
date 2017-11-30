set_global_assignment -entity "PLL10M" -library "lib_PLL10M" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL10M" -library "lib_PLL10M" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL10M" -library "lib_PLL10M" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL10M" -name SPD_FILE [file join $::quartus(sip_path) "PLL10M.spd"]

set_global_assignment -library "lib_PLL10M" -name MISC_FILE [file join $::quartus(sip_path) "PLL10M_sim/PLL10M.vo"]
