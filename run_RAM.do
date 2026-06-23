vlib work
vlog RAM_agt.sv RAM_config.sv RAM_cov.sv RAM_driver.sv RAM_env.sv RAM_golden_model_if.sv RAM_golden_model.v RAM_if.sv RAM_mon.sv RAM_scoreboard.sv RAM_seq_item.sv RAM_sequencer.sv RAM_sequences.sv RAM_sva.sv RAM_test.sv RAM.v top.sv +cover -covercells

vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover -do "
    run -all;
    coverage save top.ucdb;
    coverage exclude -src RAM.v -scope /top/DUT1 -line 23 -code s
    coverage exclude -src RAM.v -scope /top/DUT1 -line 23 -code b
    quit -sim;
    "
    vcover report top.ucdb -details -annotate -all -output coverage_rpt.txt
