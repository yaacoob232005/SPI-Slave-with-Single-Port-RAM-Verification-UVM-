package coverage_collector_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import seq_item_pkg::*;

  class RAM_coverage_collector extends uvm_component;
    `uvm_component_utils(RAM_coverage_collector)

    uvm_analysis_export #(RAM_seq_item) cov_export;
    uvm_tlm_analysis_fifo#(RAM_seq_item) cov_fifo;
    RAM_seq_item RAM_seq_item_cov;

    covergroup ram_cg;
      option.per_instance = 1;

      cp_din_98: coverpoint RAM_seq_item_cov.din[9:8] {
        bins write_addr = {2'b00};
        bins write_data = {2'b01};
        bins read_addr  = {2'b10};
        bins read_data  = {2'b11};
      }
      rx_valid_cp: coverpoint RAM_seq_item_cov.rx_valid{
        bins rx_valid_1 = {1};
        bins rx_valid_0 = {0};
      }
      tx_valid_cp: coverpoint RAM_seq_item_cov.tx_valid{
        bins tx_valid_1 = {1};
        bins tx_valid_0 = {0};
      }


      seq_write_addr_write_data: coverpoint RAM_seq_item_cov.din[9:8] {
        bins wa_wd_seq[] = (2'b00 => 2'b01);
      }

      seq_read_addr_read_data: coverpoint RAM_seq_item_cov.din[9:8] {
        bins ra_rd_seq[] = (2'b10 => 2'b11);
      }

      seq_full_order: coverpoint RAM_seq_item_cov.din[9:8] {
        bins wa_wd_ra_rd_seq[] = (2'b00 => 2'b01 => 2'b10 => 2'b11);
      }
      cross_din_rxvalid: cross cp_din_98, rx_valid_cp{}

      cross_readdata_txvalid: cross cp_din_98, tx_valid_cp {
        option.cross_auto_bin_max = 0;
        bins rd_tx_high = binsof(cp_din_98.read_data) &&
                          binsof(tx_valid_cp.tx_valid_1);
      }

    endgroup : ram_cg

    function new(string name = "RAM_coverage_collector", uvm_component parent = null);
      super.new(name, parent);
      ram_cg=new();
    endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      cov_export = new("cov_export", this);
      cov_fifo   = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cov_fifo.get(RAM_seq_item_cov);
        ram_cg.sample();
      end
    endtask

  endclass : RAM_coverage_collector
endpackage : coverage_collector_pkg
