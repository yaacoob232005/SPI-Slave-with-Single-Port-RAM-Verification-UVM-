package spi_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"   
import shared_pkg::*;
class spi_seq_item extends uvm_sequence_item;
`uvm_object_utils(spi_seq_item)
rand bit MOSI, rst_n, SS_n, tx_valid;
rand bit      [7:0] tx_data;
bit      [9:0] rx_data;
bit       rx_valid, MISO;
//gold
bit      [9:0] gold_rx_data;
bit       gold_rx_valid, gold_MISO;

rand logic [10:0] MOSI_arr;
    



function new(string name = "spi_seq_item");
  super.new(name);
endfunction

function string convert2string();
  return $sformatf("%s  MOSI=%0b, rst_n=%0b, SS_n=%0b, tx_valid=%0b, tx_data=%0h, rx_data=%0h, rx_valid=%0b, MISO=%0b",super.convert2string(),
   MOSI, rst_n, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
endfunction

function string convert2string_stimulus();
  return $sformatf("MOSI=%0b, rst_n=%0b, SS_n=%0b, tx_valid=%0b, tx_data=%0h, rx_data=%0h, rx_valid=%0b, MISO=%0b",
   MOSI, rst_n, SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
endfunction

//constraints

        constraint SPI_SLAVE_1 {
            rst_n dist {1 :/ 95, 0 :/ 5};
        }

        constraint SPI_SLAVE_6 {
            if (SS_n == 0) {
                MOSI_arr[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};

                if (!have_address) {
                    MOSI_arr[10:8] != 3'b111;
                }
            }
        }

        constraint SPI_SLAVE_8 {
            if (count > 14) {
                tx_valid == 1;
            } else {
                tx_valid == 0;
            }
        }

        function void post_randomize();
            if (count == 0) begin
                curr_op = MOSI_arr;
            end

            if (curr_op[10:8] == 3'b111) begin
                period = 23;
            end else begin
                period = 13;
            end

            if (count == period) begin
                SS_n = 1;
            end else begin
                SS_n = 0;
            end

            if (curr_op[10:8] == 3'b110) begin
                have_address = 1;
            end

            if (curr_op[10:8] == 3'b111 || !rst_n) begin
                have_address = 0;
            end

            if (count > 0 && count < 12) begin
                MOSI = curr_op[11 - count];
            end else begin
                MOSI = 0;
            end

            if (!rst_n) begin
                count = 0;
            end else begin
                if (count == period) begin
                    count = 0;
                end else begin
                    count++;
                end
            end
        endfunction

endclass
endpackage