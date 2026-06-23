package spi_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_config_pkg::*;
import sequencer_pkg::*;
import spi_driver_pkg::*;
import spi_mon_pkg::*;
import spi_seq_item_pkg::*;

class spi_agent extends uvm_agent;
`uvm_component_utils(spi_agent)

spi_driver driver;
sequencer seqr;
spi_mon mon;
spi_config spi_cfg;
spi_config spi_gold_cfg;
uvm_analysis_port #(spi_seq_item) agt_ap;

function new(string name = "spi_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(spi_config)::get(this,"","CFG",spi_cfg) ) begin
    `uvm_fatal("build_phase","agent - unable to get CFG config object");
  end
  if(!uvm_config_db #(spi_config)::get(this,"","CFG_GOLD",spi_gold_cfg) ) begin
      `uvm_fatal("build_phase","agent - unable to get CFG_GOLD config object");
  end
  driver = spi_driver::type_id::create("driver", this);
  seqr = sequencer::type_id::create("seqr", this);
  mon = spi_mon::type_id::create("mon", this);
  agt_ap = new("agt_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  driver.spi_vif = spi_cfg.spi_config_vif;
  mon.spi_vif = spi_cfg.spi_config_vif;
  driver.spi_gold_vif = spi_gold_cfg.spi_gold_config_vif;
  mon.spi_gold_vif = spi_gold_cfg.spi_gold_config_vif;
  driver.seq_item_port.connect(seqr.seq_item_export);
  mon.mon_ap.connect(agt_ap);
endfunction

endclass
endpackage