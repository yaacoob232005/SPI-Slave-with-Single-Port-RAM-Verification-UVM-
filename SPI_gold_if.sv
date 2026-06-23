interface spi_gold_if (clk);
 input clk;
 logic rst_n, SS_n, MOSI, MISO, tx_valid, rx_valid;
 logic [7:0] tx_data;
 logic [9:0] rx_data;

 /*modport DUT (input clk, rst_n, SS_n, MOSI, tx_valid, tx_data,
   output MISO, rx_valid, rx_data);
 modport TEST  (input clk, MISO, rx_valid, rx_data,
    output rst_n, SS_n, MOSI, tx_valid, tx_data);
*/

endinterface 