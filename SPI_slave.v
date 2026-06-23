module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0 && !rx_valid) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end

`ifdef SIM

        property IDLE_to_CHK_CMD;
            @(posedge clk) disable iff (!rst_n) (cs == IDLE && SS_n == 0) |=> cs == CHK_CMD;
        endproperty

        property CHK_CMD_to_WRITE;
            @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && SS_n == 0 && MOSI == 0) |=> cs == WRITE;
        endproperty

        property CHK_CMD_to_READ_ADD;
            @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && SS_n == 0 && MOSI == 1 && received_address == 0) |=> cs == READ_ADD;
        endproperty

        property CHK_CMD_to_READ_DATA;
            @(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && SS_n == 0 && MOSI == 1 && received_address == 1) |=> cs == READ_DATA;
        endproperty

        property WRITE_to_IDLE;
            @(posedge clk) disable iff (!rst_n) (cs == WRITE && SS_n == 1) |=> cs == IDLE;
        endproperty

        property READ_ADD_to_IDLE;
            @(posedge clk) disable iff (!rst_n) (cs == READ_ADD && SS_n == 1) |=> cs == IDLE;
        endproperty

        property READ_DATA_to_IDLE;
            @(posedge clk) disable iff (!rst_n) (cs == READ_DATA && SS_n == 1) |=> cs == IDLE;
        endproperty

       
       //assertions
       a_IDLE_to_CHK_CMD: assert property (IDLE_to_CHK_CMD);
       a_CHK_CMD_to_WRITE: assert property (CHK_CMD_to_WRITE);
       a_CHK_CMD_to_READ_ADD: assert property (CHK_CMD_to_READ_ADD);
       a_CHK_CMD_to_READ_DATA: assert property (CHK_CMD_to_READ_DATA);
       a_WRITE_to_IDLE: assert property (WRITE_to_IDLE);
       a_READ_ADD_to_IDLE: assert property (READ_ADD_to_IDLE);
       a_READ_DATA_to_IDLE: assert property (READ_DATA_to_IDLE);
       //cover properties
       c_IDLE_to_CHK_CMD: cover property (IDLE_to_CHK_CMD);
       c_CHK_CMD_to_WRITE: cover property (CHK_CMD_to_WRITE);
       c_CHK_CMD_to_READ_ADD: cover property (CHK_CMD_to_READ_ADD);
       c_CHK_CMD_to_READ_DATA: cover property (CHK_CMD_to_READ_DATA);
       c_WRITE_to_IDLE: cover property (WRITE_to_IDLE);
       c_READ_ADD_to_IDLE: cover property (READ_ADD_to_IDLE);
       c_READ_DATA_to_IDLE: cover property (READ_DATA_to_IDLE);

`endif

endmodule