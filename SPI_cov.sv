package spi_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import shared_pkg::*;

class spi_coverage extends uvm_component;
`uvm_component_utils(spi_coverage)

uvm_analysis_export #(spi_seq_item) cov_ap;
uvm_tlm_analysis_fifo #(spi_seq_item) cov_fifo;
spi_seq_item cov_item;

      covergroup  cvr_gp ;
        rst_c : coverpoint cov_item.rst_n {
          bins rst_n_0 = {0};
          bins rst_n_1 = {1};
        }
       
        MOSI_c : coverpoint cov_item.MOSI {
          bins MOSI_0 = {0};
          bins MOSI_1 = {1};
          bins transition_000 = (0 => 0 => 0);
          bins transition_001 = (0 => 0 => 1);
          bins transition_110 = (1 => 1 => 0);
          bins transition_111 = (1 => 1 => 1);
        }

         cp_rx_data: coverpoint cov_item.rx_data[9:8] iff (cov_item.rst_n) {
                bins all_values[] = {2'b00, 2'b01, 2'b10, 2'b11};

                bins write_address_write_data = (2'b00 => 2'b01);
                bins write_address_read_address = (2'b00 => 2'b10);

                bins write_data_write_address = (2'b01 => 2'b00);
                bins write_data_read_data = (2'b01 => 2'b11);

                bins read_address_write_address = (2'b10 => 2'b00);
                bins read_address_read_data = (2'b10 => 2'b11);

                bins read_data_write_data = (2'b11 => 2'b01);
                bins read_data_read_address = (2'b11 => 2'b10);
                bins read_data_write_address = (2'b11 => 2'b00);
            }


    SS_n_c : coverpoint cov_item.SS_n iff (cov_item.rst_n) {
        bins SS_n_0 = {0};
        bins SS_n_1 = {1};
        bins normal_transaction = (1 => 0[*13] => 1);
        bins read_transaction   = (1 => 0[*23] => 1);
  }
  cr_SS_n_MOSI: cross SS_n_c, MOSI_c iff (cov_item.rst_n) {
                option.cross_auto_bin_max = 0;
                bins SS_n_0_MOSI_0 = binsof(MOSI_c.MOSI_0) && binsof(SS_n_c.SS_n_0);
                bins SS_n_0_MOSI_1 = binsof(MOSI_c.MOSI_1) && binsof(SS_n_c.SS_n_0);
                bins SS_n_1_MOSI_0 = binsof(MOSI_c.MOSI_0) && binsof(SS_n_c.SS_n_1);
                bins SS_n_1_MOSI_1 = binsof(MOSI_c.MOSI_1) && binsof(SS_n_c.SS_n_1);
            }



 endgroup

function new(string name = "spi_coverage", uvm_component parent = null);
  super.new(name, parent);
  cvr_gp = new();
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  cov_ap = new("cov_ap", this);
  cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  cov_ap.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  cov_fifo.get(cov_item);
  cvr_gp.sample();
end
endtask
endclass
endpackage
