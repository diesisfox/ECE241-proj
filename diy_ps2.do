#setup Tcl goodies
namespace path {::tcl::mathop ::tcl::mathfunc}

proc base {base number} {
	set negative [regexp ^-(.+) $number -> number] ;# (1)
	set digits {0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N
		O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p
		q r s t u v w x y z}
	set res {}
	while {$number} {
		set digit [expr {$number % $base}]
		set res [lindex $digits $digit]$res
		set number [expr {$number / $base}]
	}
	if $negative {set res -$res}
	set res
}
proc frombase {base number} {
	set digits {0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N
		O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p
		q r s t u v w x y z}
	set negative [regexp ^-(.+) $number -> number]
	set res 0
	foreach digit [split $number ""] {
		set decimalvalue [lsearch $digits $digit]
		if {$decimalvalue<0 || $decimalvalue >= $base} {
			error "bad digit $decimalvalue for base $base"
		}
		set res [expr {$res*$base + $decimalvalue}]
	}
	if $negative {set res -$res}
	set res
}

proc forcePulse {key dur} {
	force $key 1 0, 0 $dur
}

proc forceSequence args {
	set sig [lindex $args 0]
	set dur [lindex $args 1]
	set radix [lindex $args 2]
	set tim 0
	set args [lrange $args 3 end]
	foreach val $args {
		force $sig $radix#$val $tim
		set tim [+ $tim $dur]
	}
}

proc forceClock {key edge period} {
	force $key 0 0, 1 $edge -r $period
}

proc forceIncVal {sig dur radix start inc end} {
	set tim 0
	set start [frombase $radix $start]
	set inc [frombase $radix $inc]
	set end [frombase $radix $end]
	for {} {$start<=$end} {incr start $inc} {
		force $sig $radix#[base $radix $start] $tim
		set tim [+ $tim $dur]
	}
}

#initialize simulation
vlib work
vlog better_PS2_controller.v
#vsim -L altera_mf_ver -L lpm_ver l7p2
vsim Better_PS2_controller
log -r {/*}
add wave -divider "clks"
add wave -color #aaaaaa clk ps2Clk
add wave -divider "inputs"
#add wave -color #ff6666 -label reset {resetn}
add wave -color #ff9866 ps2Dat
add wave -divider "signals"
add wave -color #c0ff66 -hex -unsigned -hex buffer nextBuf nextData
add wave -color #8eff66 dr dr_n dr_c
add wave -divider "outputs"
add wave -color #ffd066 -hex -unsigned -hex data
add wave -color #f7ff66 ready

#setup test config
force -deposit dr 0
force -deposit dr_n 0
force -deposit dr_c 0
force -deposit nextData 0
force -deposit buffer 11'b11111111111
force -deposit data 0
force -deposit ready 0
force ps2Dat 1
force ps2Clk 1
force clk 0
run 1

#start clock
forceClock clk 2 4
run 1
forceClock ps2Clk 4 8
run 2


#send Q
forceSequence ps2Dat 8 2  1  0 1 0 1 0 1 0 0 0 0 1  1 1
run 152

#send up arrow E0 75
forceSequence ps2Dat 8 2  1  0 0 0 0 0 0 1 1 1 0 1  0 1 0 1 0 1 1 1 0 0 1  1 1
run 304
