package spi_env_pkg;
import uvm_pkg::*;
import spi_driver_pkg::*;
`include "uvm_macros.svh"
import spi_agent_pkg::*;
import spi_scoreboard_pkg::*;
import spi_seq_item_pkg::*;
import spi_coverage_pkg::*;


class spi_env extends uvm_env;
`uvm_component_utils(spi_env)

spi_agent agt;
spi_scoreboard sb;
spi_coverage cov;

function new(string name = "spi_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt = spi_agent::type_id::create("agt", this);
  sb  = spi_scoreboard::type_id::create("sb", this);
  cov = spi_coverage::type_id::create("cov", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_ap);
  agt.agt_ap.connect(cov.cov_ap);
endfunction

endclass
endpackage