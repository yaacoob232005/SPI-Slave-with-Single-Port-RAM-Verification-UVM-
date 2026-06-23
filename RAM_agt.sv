package agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import monitor_pkg::*;
  import RAM_driver_pkg::*;
  import sequencer_pkg::*;
  import seq_item_pkg::*;
  import RAM_config_pkg::*;

  class RAM_agent extends uvm_agent;
    `uvm_component_utils(RAM_agent)

    RAM_sequencer sqrs;
    RAM_driver    driv;
    RAM_monitor   mon;
    RAM_config    RAM_cfg;
    RAM_config    RAM_golden_model_cfg;

    uvm_analysis_port#(RAM_seq_item) agt_ap;

    function new(string name = "RAM_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(RAM_config)::get(this, "", "CFG", RAM_cfg)) begin
      `uvm_fatal("CFG_ERROR", "Failed to get RAM_cfg from config DB")
    end

    if (!uvm_config_db#(RAM_config)::get(this, "", "CFGG", RAM_golden_model_cfg)) begin
      `uvm_fatal("CFG_ERROR", "Failed to get RAM_golden_model_cfg from config DB")
    end


      sqrs = RAM_sequencer::type_id::create("sqrs", this);
      driv = RAM_driver::type_id::create("driv", this);
      mon  = RAM_monitor::type_id::create("mon", this);
      agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      driv.r_if = RAM_cfg.r_vif;
      mon.r_if  = RAM_cfg.r_vif;
      driv.r_g_if = RAM_golden_model_cfg.r_g_vif;
      mon.r_g_if  = RAM_golden_model_cfg.r_g_vif;
      driv.seq_item_port.connect(sqrs.seq_item_export);
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass : RAM_agent

endpackage : agent_pkg
