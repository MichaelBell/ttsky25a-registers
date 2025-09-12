set ROW_HEIGHT 544
set ROW_HALF_HEIGHT 272

box 0 0 0 0
getcell register4 child 0 0
box 0 [expr 9 * $ROW_HEIGHT] 0 [expr 9 * $ROW_HEIGHT]
getcell register4 child 0 0 v

box -414 [expr 4 * $ROW_HEIGHT] -414 [expr 4 * $ROW_HEIGHT]
getcell sky130_fd_sc_hd__clkbuf_4 v
for {set i 0} {$i < 4} {incr i} {
    box [expr -138 + $i * 414] [expr 4 * $ROW_HEIGHT] [expr -138 + $i * 414] [expr 4 * $ROW_HEIGHT]
    getcell sky130_fd_sc_hd__mux2_2 180
}


proc add_via1 {llx lly} {
    box [expr $llx + 4] [expr $lly + 4] [expr $llx + 30] [expr $lly + 30]
    paint via1
    #box $llx $lly [expr $llx + 34] [expr $lly + 34]
    #paint metal2
}

proc add_via2 {llx lly} {
    box [expr $llx + 4] [expr $lly + 4] [expr $llx + 30] [expr $lly + 30]
    paint via1
    box $llx [expr $lly - 2] [expr $llx + 34] [expr $lly + 36]
    paint metal2
    box [expr $llx + 3] [expr $lly + 3] [expr $llx + 31] [expr $lly + 31]
    paint via2
}



# Power
box 180 -50 350 [expr 9*$ROW_HEIGHT + 50]
label VPWR FreeSans 0.25u -met4
port make
port use power
port class bidirectional
port connections n s e w

# Ground
box 480 -50 650 [expr 9*$ROW_HEIGHT + 50]
label VGND FreeSans 0.25u -met4
port make
port use ground
port class bidirectional
port connections n s e w

box -414 -50 [expr 4 * 736 + 46] [expr 9*$ROW_HEIGHT + 50]
save register8.mag
quit -noprompt
