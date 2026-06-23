interface RAM_golden_model_if(clk);
  input clk;
  logic rst_n;
  logic rx_valid;
  logic [9:0] din;
  logic [7:0] dout;
  logic tx_valid;
endinterface
