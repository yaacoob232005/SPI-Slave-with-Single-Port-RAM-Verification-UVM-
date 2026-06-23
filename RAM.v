module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);
input      [9:0] din;
input            clk, rst_n, rx_valid;
output reg [7:0] dout;
output reg       tx_valid;
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
reg [ADDR_SIZE-1:0] MEM [0:MEM_DEPTH-1];
reg [ADDR_SIZE-1:0] Rd_Addr, Wr_Addr;

always @(posedge clk) begin
    if (~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end else if (rx_valid) begin
            case (din[ADDR_SIZE+1:ADDR_SIZE])
                2'b00 : Wr_Addr <= din[ADDR_SIZE-1:0];
                2'b01 : MEM[Wr_Addr] <= din[ADDR_SIZE-1:0];
                2'b10 : Rd_Addr <= din[ADDR_SIZE-1:0];
                2'b11 : dout <= MEM[Rd_Addr];
                default : dout <= 0;
            endcase
            tx_valid <= (din[ADDR_SIZE+1:ADDR_SIZE] == 2'b11);
    end else begin
        tx_valid <= 0;
end
end
endmodule