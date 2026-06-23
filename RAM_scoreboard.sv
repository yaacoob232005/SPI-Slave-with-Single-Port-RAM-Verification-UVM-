package scoreboard_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import seq_item_pkg::*;


  class RAM_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(RAM_scoreboard)

    uvm_analysis_export #(RAM_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;

    RAM_seq_item r_seq_item_sb;
    bit [7:0] dataout_ref;             // expected data
    int correct_count, error_count;    // stats counters


    function new(string name = "RAM_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo   = new("sb_fifo", this);
    endfunction


    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_fifo.analysis_export);
    endfunction


    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        sb_fifo.get(r_seq_item_sb);
      if(r_seq_item_sb.dout!=r_seq_item_sb.golden_dout || r_seq_item_sb.golden_tx_valid!=r_seq_item_sb.golden_tx_valid) begin
            error_count++;
        end
        else correct_count++;
      end
    endtask


    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
     `uvm_info("RAM", $sformatf("===== RAM Scoreboard Report ===== \nCorrect Results: %0d \nErrors: %0d",
                 correct_count, error_count), UVM_MEDIUM);
    endfunction

  endclass : RAM_scoreboard

endpackage : scoreboard_pkg
