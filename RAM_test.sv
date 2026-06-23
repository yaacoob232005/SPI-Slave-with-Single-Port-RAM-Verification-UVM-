package RAM_test_pkg;
  import RAM_env_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import RAM_config_pkg::*;
  import RAM_seqs::*;

  class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)

    RAM_env         env;
    RAM_config      RAM_cfg;
    RAM_config      RAM_golden_model_cfg;

    RAM_reset_seq      reset_seq;
    RAM_write_only_seq write_only_seq;
    RAM_read_only_seq  read_only_seq;
    RAM_read_write_seq read_write_seq;


    function new(string name = "RAM_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      env          = RAM_env::type_id::create("env", this);
      RAM_cfg      = RAM_config::type_id::create("RAM_cfg");
      RAM_golden_model_cfg      = RAM_config::type_id::create("RAM_golden_model_cfg");
      reset_seq    = RAM_reset_seq::type_id::create("reset_seq");
      write_only_seq = RAM_write_only_seq::type_id::create("write_only_seq");
      read_only_seq  = RAM_read_only_seq::type_id::create("read_only_seq");
      read_write_seq = RAM_read_write_seq::type_id::create("read_write_seq");


  
      if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_if", RAM_cfg.r_vif))
        `uvm_fatal("build_phase", "Failed to get virtual interface from config DB");
      
      if (!uvm_config_db#(virtual RAM_golden_model_if)::get(this, "", "RAM_golden_model_if", RAM_golden_model_cfg.r_g_vif))
        `uvm_fatal("build_phase", "Failed to get virtual interface from config DB");

     
      uvm_config_db#(RAM_config)::set(this, "*", "CFG", RAM_cfg);
      uvm_config_db#(RAM_config)::set(this, "*", "CFGG", RAM_golden_model_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      reset_seq.start(env.agt.sqrs);
      write_only_seq.start(env.agt.sqrs);
      read_only_seq.start(env.agt.sqrs);
      read_write_seq.start(env.agt.sqrs);
      phase.drop_objection(this);
    endtask

  endclass : RAM_test

endpackage : RAM_test_pkg
