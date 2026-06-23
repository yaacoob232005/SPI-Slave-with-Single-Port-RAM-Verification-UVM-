package seq_item_pkg;
    typedef enum bit [1:0] {
      WRITE_ADDR = 2'b00,
      WRITE_DATA = 2'b01,
      READ_ADDR  = 2'b10,
      READ_DATA  = 2'b11
    } ram_op_e;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class RAM_seq_item extends uvm_sequence_item;
    `uvm_object_utils(RAM_seq_item)


    rand bit [9:0] din;        
    rand bit       rx_valid;  
    rand bit       rst_n;      
    bit [7:0] dout;          
    bit       tx_valid;
    bit [7:0] golden_dout;          
    bit       golden_tx_valid;
    bit [1:0] prev_op = 2'b00;
    bit read_op = 1'b1;    


    function new(string name = "RAM_seq_item");
      super.new(name);
    endfunction

    constraint c_reset {
      rst_n dist {1 := 90, 0 := 10};
    }
    constraint c_rx_valid {
      rx_valid dist {1 := 70, 0 := 30};
    }



        constraint c_rst {rst_n dist {1 := 99 , 0 := 1};};
        constraint c_rx {rx_valid dist {1 := 98 , 0 := 2};};
        constraint c_write_only {din[9:8] dist { [2'b00:2'b01] := 100, [2'b10:2'b11] := 0};};
        constraint c_read_only {din[9:8] inside {2'b10, 2'b11};}; 
        constraint c_read_write {din[9:8] inside {2'b00, 2'b01, 2'b10, 2'b11};};


    function string convert2string();
      return $sformatf(
        "din=0x%03h rx_valid=%0b rst_n=%0b dout=0x%02h tx_valid=%0b",
        din, rx_valid, rst_n, dout, tx_valid
      );
    endfunction

    function string convert2string_stimulus();
      return $sformatf("din=0x%03h rx_valid=%0b rst_n=%0b", din, rx_valid, rst_n);
    endfunction

    function void post_randomize();
      prev_op = din[9:8];
      read_op = din[8];
    endfunction

  endclass : RAM_seq_item

endpackage : seq_item_pkg
