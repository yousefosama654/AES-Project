transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/SubBytes.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/AES.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/ShiftRows.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/MixColumns.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/AddRoundKey.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/GenerateKey4.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/GenerateKey6.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/GenerateKey8.v}
vlog -vlog01compat -work work +incdir+E:/AESV3 {E:/AESV3/test_bench.v}


vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  test_bench

add wave *
view structure
view signals
run -all
