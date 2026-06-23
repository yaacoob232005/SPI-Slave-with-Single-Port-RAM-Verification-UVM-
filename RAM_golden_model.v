
module RAM_golden_model #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
    input  wire [9:0] din,
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx_valid,
    output reg  [ADDR_SIZE-1:0] dout,
    output reg                  tx_valid
);
    reg [ADDR_SIZE-1:0] addr_rd;
    reg [ADDR_SIZE-1:0] addr_wr;
    reg [ADDR_SIZE-1:0] mem [0:MEM_DEPTH-1];

    always @(posedge clk) begin
        if (!rst_n) begin
            addr_wr  <= 0;
            addr_rd  <= 0;
            dout     <= 0;
            tx_valid <= 0;
        end else begin
        if (rx_valid) begin
            case (din[9:8])
                2'b00: begin
                    addr_wr  <= din[7:0];      // Set write address
                    tx_valid <= 0;
                end
                2'b01: begin
                    mem[addr_wr] <= din[7:0];  // Write data to memory
                    tx_valid     <= 0;
                end
                2'b10: begin
                    addr_rd  <= din[7:0];      // Set read address
                    tx_valid <= 0;
                end
                default: begin
                    dout     <= mem[addr_rd];  // Read data from memory
                    tx_valid <= 1;
                end
            endcase
        end
        end
    end

endmodule


