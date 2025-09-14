# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024 Tiny Tapeout LTD
# Author: Uri Shaked
# Description: This script initializes a new Magic project for an analog design on Tiny Tapeout.

# Important: before running this script, download the the .def file from
# https://raw.githubusercontent.com/TinyTapeout/tt-support-tools/tt08/def/analog/tt_analog_1x2.def

# Change the settings below to match your design:
# ------------------------------------------------
set TOP_LEVEL_CELL     tt_um_rebelmike_register
set TEMPLATE_FILE      tt_block_1x1_pg.def
set POWER_STRIPE_WIDTH 1.7um                 ;# The minimum width is 1.2um

# Power stripes: NET name, x position. You can add additional power stripes for each net, as needed.
set POWER_STRIPES {
    VDPWR 12um
    VGND  15um
}
# If you use the 3v3 template, uncomment the line below:
#lappend POWER_STRIPES VAPWR 7um

# Read in the pin positions
# -------------------------
def read $TEMPLATE_FILE
cellname rename tt_um_template $TOP_LEVEL_CELL

# Draw the power stripes
# --------------------------------
proc draw_power_stripe {name x} {
    global POWER_STRIPE_WIDTH
    box $x 5um $x 109um
    box width $POWER_STRIPE_WIDTH
    paint met4
    label $name FreeSans 0.25u -met4
    port make
    port use [expr {$name eq "VGND" ? "ground" : "power"}]
    port class bidirectional
    port connections n s e w
}

# You can extra power stripes, as you need.
foreach {name x} $POWER_STRIPES {
    puts "Drawing power stripe $name at $x"
    draw_power_stripe $name $x
}

box 1020 1000 1020 1000
getcell register8 child 0 0

proc draw_top_signal_wire {cxl cyl cxt hyl px} {
    box $cxl $cyl $cxt [expr $hyl + 36]
    paint metal4
    box [expr $cxl + 1] $hyl [expr $cxt - 1] [expr $hyl + 32]
    paint via3
    box [expr $cxl - 2] $hyl [expr $px + 21] [expr $hyl + 32]
    paint metal3
    box [expr $px - 18] [expr $hyl - 0] [expr $px + 18] [expr $hyl + 32]
    paint via3
    box [expr $px - 19] [expr $hyl - 1] [expr $px + 19] [expr $hyl + 33]
    paint metal4
    box [expr $px - 15] [expr $hyl + 24] [expr $px + 15] 11052
    paint metal4
}

proc draw_side_signal_wire {cxl cyl px} {
    box $cxl $cyl [expr $cxl + 50] [expr $cyl + 34]
    paint metal2
    box [expr $cxl + 6] [expr $cyl + 3] [expr $cxl + 44] [expr $cyl + 31]
    paint via2
    box $cxl $cyl [expr $px + 23] [expr $cyl + 34]
    paint metal3
    box [expr $px - 18] [expr $cyl + 1] [expr $px + 18] [expr $cyl + 33]
    paint via3
    box [expr $px - 19] [expr $cyl - 4] [expr $px + 19] [expr $cyl + 34]
    paint metal4
    box [expr $px - 15] [expr $cyl + 24] [expr $px + 15] 11052
    paint metal4
}

proc add_via1_to4 {llx lly} {
    box $llx $lly [expr $llx + 32] [expr $lly + 38]
    paint metal1
    box [expr $llx + 3] [expr $lly + 6] [expr $llx + 29] [expr $lly + 32]
    paint via1
    box $llx $lly [expr $llx + 40] [expr $lly + 34]
    paint metal2
    box [expr $llx + 6] [expr $lly + 3] [expr $llx + 34] [expr $lly + 31]
    paint via2
    box $llx $lly [expr $llx + 50] [expr $lly + 48]
    paint metal3
    box [expr $llx + 3] [expr $lly + 1] [expr $llx + 47] [expr $lly + 37]
    paint via3
    box $llx $lly [expr $llx + 50] [expr $lly + 38]
    paint metal4
}

# Save the layout and export GDS/LEF
# ----------------------------------
save ${TOP_LEVEL_CELL}.mag
file mkdir gds
gds write ../gds/${TOP_LEVEL_CELL}.gds
file mkdir lef
lef write ../lef/${TOP_LEVEL_CELL}.lef -hide -pinonly

quit -noprompt
