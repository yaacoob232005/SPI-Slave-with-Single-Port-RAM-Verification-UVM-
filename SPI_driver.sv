 package spi_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import spi_config_pkg::*;
//import shared_pkg::*;

class spi_driver extends uvm_driver #(spi_seq_item);
`uvm_component_utils(spi_driver)

virtual spi_if spi_vif;
virtual spi_gold_if spi_gold_vif;
spi_seq_item stim_seq_item;

function new(string name = "spi_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  stim_seq_item = spi_seq_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);
    spi_vif.rst_n   = stim_seq_item.rst_n;
    spi_vif.SS_n    = stim_seq_item.SS_n;
    spi_vif.MOSI    = stim_seq_item.MOSI;
    spi_vif.tx_valid = stim_seq_item.tx_valid;
    spi_vif.tx_data  = stim_seq_item.tx_data;
    //gold
    spi_gold_vif.rst_n   = stim_seq_item.rst_n;
    spi_gold_vif.SS_n    = stim_seq_item.SS_n;
    spi_gold_vif.MOSI    = stim_seq_item.MOSI;
    spi_gold_vif.tx_valid = stim_seq_item.tx_valid;
    spi_gold_vif.tx_data  = stim_seq_item.tx_data;

    @(negedge spi_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(), UVM_HIGH);
  end
endtask
endclass
endpackage