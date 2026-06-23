package main_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
//import shared_pkg::*;

class main_seq extends uvm_sequence #(spi_seq_item);
`uvm_object_utils(main_seq)

spi_seq_item main_item;

function new(string name = "main_seq");
  super.new(name);
endfunction

task body();
  repeat (20000) begin
      main_item = spi_seq_item::type_id::create("main_item");
    start_item(main_item);
    assert(main_item.randomize());
    finish_item(main_item);
  end
endtask
endclass
endpackage