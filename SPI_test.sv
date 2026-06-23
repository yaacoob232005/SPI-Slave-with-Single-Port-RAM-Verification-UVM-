package spi_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_env_pkg::*;
import spi_config_pkg::*;
import spi_seq_item_pkg::*;
//import shared_pkg::*;
import sequencer_pkg::*;
import rst_seq_pkg::*;
import main_seq_pkg::*;

class spi_test extends uvm_test;
`uvm_component_utils(spi_test)

spi_env env;
main_seq main_sequence;
rst_seq rst_sequence;
virtual spi_if spi_vif;
spi_config spi_cfg;
spi_config spi_gold_cfg;

function new(string name = "spi_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = spi_env::type_id::create("env", this);
  main_sequence = main_seq::type_id::create("main_sequence", this);
  rst_sequence = rst_seq::type_id::create("rst_sequence", this);
  spi_cfg = spi_config::type_id::create("spi_cfg");
  spi_gold_cfg = spi_config::type_id::create("spi_gold_cfg");
  if(!uvm_config_db #(virtual spi_if)::get(this,"","SPI_IF",spi_cfg.spi_config_vif) ) begin
    `uvm_fatal("build_phase","test - unable to get VIF");
  end
  if(!uvm_config_db #(virtual spi_gold_if)::get(this,"","SPI_GOLD_IF",spi_gold_cfg.spi_gold_config_vif) ) begin
    `uvm_fatal("build_phase","test - unable to get GOLD VIF");
  end
  uvm_config_db #(spi_config)::set(this,"*","CFG",spi_cfg);
  uvm_config_db #(spi_config)::set(this,"*","CFG_GOLD",spi_gold_cfg);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","Reset asserted", UVM_LOW);
rst_sequence.start(env.agt.seqr);
`uvm_info("run_phase","Reset de-asserted", UVM_LOW);
`uvm_info("run_phase","Main sequence started", UVM_LOW);
main_sequence.start(env.agt.seqr);
phase.drop_objection(this);
`uvm_info("run_phase","Main sequence finished", UVM_LOW); 
endtask

endclass

endpackage

