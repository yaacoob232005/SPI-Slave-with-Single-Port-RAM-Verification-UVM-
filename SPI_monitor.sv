package spi_mon_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import shared_pkg::*;

class spi_mon extends uvm_monitor;
`uvm_component_utils(spi_mon)

virtual spi_if spi_vif;
virtual spi_gold_if spi_gold_vif;
spi_seq_item mon_item;
uvm_analysis_port #(spi_seq_item) mon_ap;

function new(string name = "spi_mon", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon_ap = new("mon_ap",this);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    mon_item = spi_seq_item::type_id::create("mon_item");
    @(negedge spi_vif.clk);
    mon_item.rst_n = spi_vif.rst_n;
    mon_item.SS_n = spi_vif.SS_n;
    mon_item.MOSI = spi_vif.MOSI;
    mon_item.MISO = spi_vif.MISO;
    mon_item.tx_valid = spi_vif.tx_valid;
    mon_item.rx_valid = spi_vif.rx_valid;
    mon_item.rx_data = spi_vif.rx_data;
    mon_item.tx_data = spi_vif.tx_data;
    //gold
    mon_item.gold_MISO = spi_gold_vif.MISO;
    mon_item.gold_rx_valid = spi_gold_vif.rx_valid;
    mon_item.gold_rx_data = spi_gold_vif.rx_data;
    mon_ap.write(mon_item);
    `uvm_info("run_phase",mon_item.convert2string(), UVM_HIGH);
  end

endtask
endclass
endpackage
