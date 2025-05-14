module rptr_handler #(
    parameter PTR_WIDTH = 3
)(
    input                       rclk,
    input                       rst_n,
    input                       r_en,
    input       [PTR_WIDTH:0]   g_wptr_sync,
    output reg  [PTR_WIDTH:0]   b_rptr, 
    output reg  [PTR_WIDTH:0]   g_rptr,
    output reg                  empty
);

wire [PTR_WIDTH:0] b_rptr_next;
wire [PTR_WIDTH:0] g_rptr_next;
wire               rempty;

assign b_rptr_next = (r_en & !empty) ? (b_rptr + 'b1) : b_rptr;

// Convert to Gray Code
assign g_rptr_next = (b_rptr_next >>1)^b_rptr_next;

// FIFO empty when write pointer equals next read pointer
assign rempty = (g_wptr_sync == g_rptr_next) ? 'b1  : 'b0;

always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        b_rptr <= 'b0;
        g_rptr <= 'b0;
    end
    else begin
        b_rptr <= b_rptr_next;  // incr binary write pointer
        g_rptr <= g_rptr_next;  // incr gray write pointer
    end
end

always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) 
        empty <= 'b1;
    else
        empty <= rempty;
end
endmodule