module RAM_sva(RAM_if.SVA r_if);

    // 1) reset
    property p_reset;
        @(posedge r_if.clk)
            (!r_if.rst_n) |=> (r_if.dout == 0 && r_if.tx_valid == 0);
    endproperty
    a_reset: assert property (p_reset)
        else $error("Assertion 1 failed");
    c_reset: cover property (p_reset);

    // 2) tx_valid is low 
    property p_tx_low;
        @(posedge r_if.clk) disable iff (!r_if.rst_n)
            (r_if.din[9:8] inside {2'b00, 2'b01, 2'b10}) |=> (r_if.tx_valid == 0);
    endproperty
    a_tx_low: assert property (p_tx_low)
        else $error("Assertion 2 failed");
    c_tx_low: cover property (p_tx_low);

    // 3) tx_valid rises then falls
    property p_tx_high;
        @(posedge r_if.clk) disable iff (!r_if.rst_n)
            (r_if.rx_valid && r_if.din[9:8] == 2'b11) |=> ((r_if.tx_valid));
    endproperty
    a_tx_high: assert property (p_tx_high) 
    else $error("Assertion 3 failed");
    c_tx_high: cover property (p_tx_high);
    
    // 4) write address => write data
    property p_write;
        @(posedge r_if.clk) disable iff (!r_if.rst_n)
            (r_if.din[9:8] == 2'b00) |=>##[0:2] (r_if.din[9:8] inside {2'b00,2'b01});
    endproperty
    a_write: assert property (p_write) else $error("Assertion write failed");
    c_write: cover property (p_write);

    // 5) read address => read data
    property p_read;
        @(posedge r_if.clk) disable iff (!r_if.rst_n)
            (r_if.din[9:8] == 2'b10) |=>##1 ( r_if.din[9:8] inside {2'b10,2'b11});
    endproperty
    a_read: assert property (p_read) else $error("Assertion read failed ");
    c_read: cover property (p_read);

endmodule