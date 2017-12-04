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
vlog WS2812B_Bit_Encoder.v
#vsim -L altera_mf_ver -L lpm_ver l7p2
vsim WS2812B_Bit_Encoder
log -r {/*}
add wave -divider "clks"
add wave -color #aaaaaa clk
add wave -divider "inputs"
add wave -color #ff6666 reset -color #ff9866 d -color #ffcb66 r
add wave -divider "signals"
add wave -color #c0ff66 -hex -unsigned -hex state nextState
#add wave -color #8eff66 dr dr_n dr_c
add wave -divider "outputs"
add wave -color #66cdff next -color #66a3ff out

#setup test config
force -deposit next 0
force -deposit out 0
force -deposit counter 0
force -deposit nextCounter 0
force -deposit nextState 0
force -deposit comp 0
force -deposit state 0
force clk 0
force d 0
force r 1
force reset 1
run 1

#start clock
forceClock clk 2 4
run 1

#send reset
force reset 0
run 5

#wait r, send 1
force d 1
force r 0
run 1400

#wait 1, send 0
force d 0
run 260

#wait 0, send 1
force d 1
run 200

#wait 1, send 0
force d 0
run 260

#wait 0, send r
force r 1
run 200

#wait r, send 0
force r 0
force d 0
run 1400

#wait 0
run 200
