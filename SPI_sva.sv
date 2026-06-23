module SPI_sva(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
input MOSI, SS_n, clk, rst_n, tx_valid;
input [7:0] tx_data;
input [9:0] rx_data;
input rx_valid;
input MISO;



        property rst_MISO;
            @(posedge clk) (!rst_n) |=> MISO == 0;
        endproperty

        property rst_rx_valid;
            @(posedge clk) (!rst_n) |=> rx_valid == 0;
        endproperty

        property rst_rx_data;
            @(posedge clk) (!rst_n) |=> rx_data == 0;
        endproperty

        property rx_valid_write_address;
            @(posedge clk) disable iff (!rst_n) ($fell(SS_n)) ##1 (MOSI == 0) ##1 (MOSI == 0) ##1 (MOSI == 0) |-> ##9 ((rx_valid));
        endproperty

        property rx_valid_write_data;
            @(posedge clk) disable iff (!rst_n) ($fell(SS_n)) ##1 (MOSI == 0) ##1 (MOSI == 0) ##1 (MOSI == 1) |=> ##9 ((rx_valid));
        endproperty

        property rx_valid_read_address;
            @(posedge clk) disable iff (!rst_n) ($fell(SS_n)) ##1 (MOSI == 1) ##1 (MOSI == 1) ##1 (MOSI == 0) |-> ##10 ((rx_valid));
        endproperty

        property rx_valid_read_data;
            @(posedge clk) disable iff (!rst_n) ($fell(SS_n)) ##1 (MOSI == 1) ##1 (MOSI == 1) ##1 (MOSI == 1) |=> ##10 ((rx_valid));
        endproperty

    // Assertions
    rst_MISO_assert: assert property (rst_MISO);
    rst_rx_valid_assert: assert property (rst_rx_valid);
    rst_rx_data_assert: assert property (rst_rx_data);
    rx_valid_write_address_assert: assert property (rx_valid_write_address);
    rx_valid_write_data_assert: assert property (rx_valid_write_data);
    rx_valid_read_address_assert: assert property (rx_valid_read_address);
    rx_valid_read_data_assert: assert property (rx_valid_read_data);
    // Cover properties
    rst_MISO_cover: cover property (rst_MISO);
    rst_rx_valid_cover: cover property (rst_rx_valid);
    rst_rx_data_cover: cover property (rst_rx_data);
    rx_valid_write_address_cover: cover property (rx_valid_write_address);
    rx_valid_write_data_cover: cover property (rx_valid_write_data);
    rx_valid_read_address_cover: cover property (rx_valid_read_address);
    rx_valid_read_data_cover: cover property (rx_valid_read_data);

endmodule