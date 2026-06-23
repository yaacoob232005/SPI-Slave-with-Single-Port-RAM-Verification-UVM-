package rst_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
//import shared_pkg::*;
import spi_seq_item_pkg::*;

class rst_seq extends uvm_sequence #(spi_seq_item);
`uvm_object_utils(rst_seq)

spi_seq_item rst_item;

function new(string name = "rst_seq");
  super.new(name);
endfunction

task body();
  rst_item = spi_seq_item::type_id::create("rst_item");
 start_item(rst_item);
    rst_item.rst_n = 0;
    rst_item.SS_n = 1;
    rst_item.MOSI = 0;
    rst_item.tx_valid = 0;
    rst_item.tx_data = 0;
    finish_item(rst_item);
    endtask
endclass
endpackage