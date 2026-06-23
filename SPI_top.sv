import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_test_pkg::*;

module spi_top();
  bit clk;
  initial begin
    clk =0;
    forever #1 clk =~clk;
  end

  spi_if spi_iff(clk);
  spi_gold_if spi_gold_iff(clk);

  SLAVE slave (
    .clk(clk),
    .rst_n(spi_iff.rst_n),
    .MOSI(spi_iff.MOSI),
    .SS_n(spi_iff.SS_n),
    .tx_valid(spi_iff.tx_valid),
    .tx_data(spi_iff.tx_data),
    .MISO(spi_iff.MISO),
    .rx_data(spi_iff.rx_data),
    .rx_valid(spi_iff.rx_valid)
  ); 
  spi_gold gold (
    .clk(clk),
    .rst_n(spi_gold_iff.rst_n),
    .MOSI(spi_gold_iff.MOSI),
    .SS_n(spi_gold_iff.SS_n),
    .tx_valid(spi_gold_iff.tx_valid),
    .tx_data(spi_gold_iff.tx_data),
    .MISO(spi_gold_iff.MISO),
    .rx_data(spi_gold_iff.rx_data),
    .rx_valid(spi_gold_iff.rx_valid)
  );
  SPI_sva spi_sva (.clk(clk),
   .MOSI(spi_iff.MOSI),
    .MISO(spi_iff.MISO),
     .SS_n(spi_iff.SS_n),
    .rst_n(spi_iff.rst_n),
     .rx_data(spi_iff.rx_data), 
     .rx_valid(spi_iff.rx_valid),
    .tx_data(spi_iff.tx_data),
     .tx_valid(spi_iff.tx_valid));
  
  bind SLAVE SPI_sva sv_assert (.clk(clk),
   .MOSI(spi_iff.MOSI),
    .MISO(spi_iff.MISO),
     .SS_n(spi_iff.SS_n),
    .rst_n(spi_iff.rst_n),
     .rx_data(spi_iff.rx_data), 
     .rx_valid(spi_iff.rx_valid),
    .tx_data(spi_iff.tx_data),
     .tx_valid(spi_iff.tx_valid));

 initial begin 
    uvm_config_db#(virtual spi_if)::set(null,"uvm_test_top","SPI_IF",spi_iff);
    uvm_config_db#(virtual spi_gold_if)::set(null,"uvm_test_top","SPI_GOLD_IF",spi_gold_iff);
    run_test("spi_test");
  end

endmodule