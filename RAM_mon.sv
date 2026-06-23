package monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import seq_item_pkg::*;

  class RAM_monitor extends uvm_monitor;
    `uvm_component_utils(RAM_monitor)

  
    virtual RAM_if r_if;
    virtual RAM_golden_model_if r_g_if;

    RAM_seq_item r_seq_item;

    uvm_analysis_port#(RAM_seq_item) mon_ap;

    function new(string name = "RAM_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        @(negedge r_if.clk);
          r_seq_item.din      = r_if.din;
          r_seq_item.rx_valid = r_if.rx_valid;
          r_seq_item.rst_n    = r_if.rst_n;
          r_seq_item.dout     = r_if.dout;
          r_seq_item.tx_valid = r_if.tx_valid;
          r_seq_item.golden_dout     = r_g_if.dout;
          r_seq_item.golden_tx_valid = r_g_if.tx_valid;
          mon_ap.write(r_seq_item);
          `uvm_info("run_phase",r_seq_item.convert2string(),UVM_HIGH);
      end
    endtask

  endclass : RAM_monitor
endpackage : monitor_pkg
