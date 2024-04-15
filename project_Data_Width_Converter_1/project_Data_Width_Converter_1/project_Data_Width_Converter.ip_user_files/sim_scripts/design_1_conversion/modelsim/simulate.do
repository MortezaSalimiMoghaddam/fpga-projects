onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L xlconstant_v1_1_6 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.design_1_conversion xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {design_1_conversion.udo}

run -all

quit -force
