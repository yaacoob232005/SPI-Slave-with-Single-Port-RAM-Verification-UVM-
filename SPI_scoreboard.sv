package spi_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import shared_pkg::*;

class spi_scoreboard extends uvm_scoreboard;
`uvm_component_utils(spi_scoreboard)

uvm_analysis_export #(spi_seq_item) sb_ap;
uvm_tlm_analysis_fifo #(spi_seq_item) sb_fifo;
spi_seq_item seq_item_sb;

int correct_count, error_count;

function new(string name = "spi_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  sb_ap = new("sb_ap", this);
  sb_fifo = new("sb_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  sb_ap.connect(sb_fifo.analysis_export);
endfunction

 task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            if(seq_item_sb.MISO != seq_item_sb.gold_MISO ||
             seq_item_sb.rx_data != seq_item_sb.gold_rx_data || seq_item_sb.rx_data != seq_item_sb.gold_rx_data) begin
                `uvm_error("Scoreboard","The output is incorrect!");
                `uvm_info("Scoreboard",$sformatf("Expected rx_data=%0b, got rx_data=%0b",seq_item_sb.gold_rx_data, seq_item_sb.rx_data),UVM_MEDIUM);
                `uvm_info("Scoreboard",$sformatf("Expected rx_valid=%0b, got rx_valid=%0b",seq_item_sb.gold_rx_valid, seq_item_sb.rx_valid),UVM_MEDIUM);
                `uvm_info("Scoreboard",$sformatf("Expected MISO=%0b, got MISO=%0b",seq_item_sb.gold_MISO, seq_item_sb.MISO),UVM_MEDIUM);
                error_count++;
            end
            else begin
                `uvm_info("Scoreboard","The output is correct!",UVM_HIGH);
                correct_count++;
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf(" correct count :%d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf(" error count :%d",error_count),UVM_MEDIUM);
    endfunction

endclass
endpackage