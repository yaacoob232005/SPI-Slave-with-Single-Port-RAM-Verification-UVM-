import uvm_pkg::*;
import RAM_test_pkg::*;
`include "uvm_macros.svh"

module top();


  bit clk;
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  RAM_if r_if(clk);
  RAM_golden_model_if r_g_if(clk);


    RAM_golden_model DUT0 (
    .clk      (clk),
    .rst_n    (r_g_if.rst_n),
    .rx_valid (r_g_if.rx_valid),
    .din      (r_g_if.din),
    .dout     (r_g_if.dout),
    .tx_valid (r_g_if.tx_valid)
  );


  RAM DUT1 (
    .clk      (clk),
    .rst_n    (r_if.rst_n),
    .rx_valid (r_if.rx_valid),
    .din      (r_if.din),
    .dout     (r_if.dout),
    .tx_valid (r_if.tx_valid)
  );
  bind RAM RAM_sva RAM_sva_inst(r_if.SVA);

  initial begin
    uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_if", r_if);
    uvm_config_db#(virtual RAM_golden_model_if)::set(null, "uvm_test_top", "RAM_golden_model_if", r_g_if);
    run_test("RAM_test");
  end

endmodule
