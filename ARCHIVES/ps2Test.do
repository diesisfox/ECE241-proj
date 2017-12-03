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

#usage: run [ps2Input {PS2_DAT PS2_CLK} period byte0 byte1 ... ]
proc ps2Input args {
	set PS2_DAT_SIG [lindex [lindex $args 0] 0]
	set PS2_CLK_SIG [lindex [lindex $args 0] 1]
	set period [/ [lindex $args 1] 2]
	set args [lrange $args 2 end]
	set ret 0
	force $PS2_DAT_SIG 1 0
	force $PS2_CLK_SIG 1 0
	incr ret $period
	foreach val $args {
		set byte [frombase 16 $val]
		#clock in start bit
		force $PS2_DAT_SIG 0 $ret
		force $PS2_CLK_SIG 0 $ret
		incr ret $period
		force $PS2_DAT_SIG 0 $ret
		force $PS2_CLK_SIG 1 $ret
		incr ret $period
		for {set i 0} {$i < 8} {incr i} {
			#TODO: clock in bits
		}
		#TODO: clock in parity and stop bits
	}
	return ret
}
