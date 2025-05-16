`include "synchronizer.v"
`include "w_ptr_handler.v"
`include "r_ptr_handler.v"
`include "fifo_mem.v"

module asynchronous_fifo #(
    parameter DEPTH = 8,
    parameter DATA_WIDTH = 8
)(
    input  wire                  wclk,
    input  wire                  rclk,
    input  wire                  rst_n,
    input  wire                  w_en,
    input  wire                  r_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);

    // Local parameter for pointer width
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Internal pointer signals
    wire [PTR_WIDTH:0] b_wptr, g_wptr;
    wire [PTR_WIDTH:0] b_rptr, g_rptr;
    wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;

    // ===============================
    // Pointer Synchronizers
    // ===============================

    synchronizer #(PTR_WIDTH+1) sync_wptr (
        .clk(rclk),
        .rst_n(rst_n),
        .data_in(g_wptr),
        .data_out(g_wptr_sync)
    );

    synchronizer #(PTR_WIDTH+1) sync_rptr (
        .clk(wclk),
        .rst_n(rst_n),
        .data_in(g_rptr),
        .data_out(g_rptr_sync)
    );

    // ===============================
    // Write Pointer Handler
    // ===============================

    w_ptr_handler #(PTR_WIDTH) wptr_h (
        .wclk(wclk),
        .rst_n(rst_n),
        .w_en(w_en),
        .g_rptr_sync(g_rptr_sync),
        .b_wptr(b_wptr),
        .g_wptr(g_wptr),
        .full(full)
    );

    // ===============================
    // Read Pointer Handler
    // ===============================

    rptr_handler #(PTR_WIDTH) rptr_h (
        .rclk(rclk),
        .rst_n(rst_n),
        .r_en(r_en),
        .g_wptr_sync(g_wptr_sync),
        .b_rptr(b_rptr),
        .g_rptr(g_rptr),
        .empty(empty)
    );

    // ===============================
    // FIFO Memory Module
    // ===============================

    fifo_mem #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .PTR_WIDTH(PTR_WIDTH)
    ) fifom (
        .wclk(wclk),
        .w_en(w_en),
        .rclk(rclk),
        .r_en(r_en),
        .b_wptr(b_wptr),
        .b_rptr(b_rptr),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

endmodule
