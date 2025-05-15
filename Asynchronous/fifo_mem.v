module fifo_mem #(
    parameter DEPTH = 8,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH = 3
)(
    input wire wclk,
    input wire w_en,
    input wire rclk,
    input wire r_en,
    input wire [PTR_WIDTH:0] b_wptr,
    input wire [PTR_WIDTH:0] b_rptr,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire full,
    input wire empty,
    output reg [DATA_WIDTH-1:0] data_out
);
reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];

always@(posedge wclk) begin
    if(w_en & !full) begin
        fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
    end
end

assign data_out = fifo[b_rptr[PTR_WIDTH-1:0]];
endmodule