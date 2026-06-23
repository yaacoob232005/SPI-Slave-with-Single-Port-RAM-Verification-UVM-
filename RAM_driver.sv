package RAM_driver_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import RAM_config_pkg::*;
  import seq_item_pkg::*;

  class RAM_driver extends uvm_driver #(RAM_seq_item);
    `uvm_component_utils(RAM_driver)

    virtual RAM_if r_if;
    virtual RAM_golden_model_if r_g_if;
    RAM_seq_item r_seq_item; 

    function new(string name = "RAM_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        r_seq_item=RAM_seq_item::type_id::create("r_seq_item");
        seq_item_port.get_next_item(r_seq_item);
        r_if.rst_n    = r_seq_item.rst_n;
        r_if.rx_valid = r_seq_item.rx_valid;
        r_if.din      = r_seq_item.din;
        r_g_if.rst_n    = r_seq_item.rst_n;
        r_g_if.rx_valid = r_seq_item.rx_valid;
        r_g_if.din      = r_seq_item.din;
        @(negedge r_if.clk);

        seq_item_port.item_done();

        `uvm_info("run_phase", r_seq_item.convert2string_stimulus, UVM_HIGH);
      end
    endtask
  endclass
endpackage
