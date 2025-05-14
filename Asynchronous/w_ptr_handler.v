module w_ptr_handler #(
    parameter PTR_WIDTH = 3
) (
    input                       wclk,
    input                       rst_n,
    input                       w_en,
    input       [PTR_WIDTH:0]   g_rptr_sync,
    output  reg [PTR_WIDTH:0]   b_wptr,
    output  reg [PTR_WIDTH:0]   g_wptr,
    output  reg                 full
);
wire [PTR_WIDTH:0] b_wptr_next;
wire [PTR_WIDTH:0] g_wptr_next;
wire               wfull;

assign b_wptr_next = (w_en & !full) ? (b_wptr + 1) : b_wptr;

// Convert to Gray Code
assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;

always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        b_wptr <= 'b0; // set default value
        g_wptr <= 'b0;
    end
    else begin
        b_wptr <= b_wptr_next; // incr binary write pointer
        g_wptr <= g_wptr_next; // incr gray write pointer
    end
end

always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) 
        full <= 'b0;
    else
        full <= wfull;
end

// FIFO is full when next write pointer == read pointer with MSBs inverted (Gray code domain)
assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});
    
endmodule