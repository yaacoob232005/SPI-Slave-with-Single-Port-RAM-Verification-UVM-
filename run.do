vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.spi_top -classdebug -uvmcontrol=all
add wave /spi_top/spi_iff/*
run -all
coverage save spi_top.ucdb;
vcover report spi_top.ucdb -details -annotate -all -output coverage_rpt.txt