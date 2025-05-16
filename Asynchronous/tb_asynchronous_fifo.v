`timescale 1ns/1ps
`include "asynchronous_fifo.v"

module tb_asynchronous_fifo;

    // Parameters
    parameter DEPTH = 8;
    parameter DATA_WIDTH = 8;

    // DUT signals
    reg wclk, rclk, rst_n;
    reg w_en, r_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;

    // Instantiate the DUT
    asynchronous_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .wclk(wclk),
        .rclk(rclk),
        .rst_n(rst_n),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 wclk = ~wclk;  // Write clock (asynchronous)
    always #7 rclk = ~rclk;  // Read clock (asynchronous)

    // Reset Task
    task reset_fifo;
    begin
        rst_n = 0;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        #20;
        rst_n = 1;
        #20;
    end
    endtask

    // Task: Write a single data word
    task write_fifo(input [DATA_WIDTH-1:0] data);
    begin
        @(posedge wclk);
        if (!full) begin
            w_en = 1;
            data_in = data;
        end
        @(posedge wclk);
        w_en = 0;
    end
    endtask

    // Task: Read a single data word
    task read_fifo;
    begin
        @(posedge rclk);
        if (!empty) begin
            r_en = 1;
        end
        @(posedge rclk);
        r_en = 0;
        $display("Time %t: Read Data = %0d", $time, data_out);
    end
    endtask

    // Task: Write multiple values
    task write_multiple(input integer n);
    integer i;
    begin
        for (i = 0; i < n; i = i + 1) begin
            write_fifo(i + 10);
        end
    end
    endtask

    // Task: Read multiple values
    task read_multiple(input integer n);
    integer j;
    begin
        for (j = 0; j < n; j = j + 1) begin
            read_fifo();
        end
    end
    endtask

    // Initial block to run the test
    initial begin
        $dumpfile("async_fifo_dump.vcd");
        $dumpvars(0, tb_asynchronous_fifo);
        $display("Starting Asynchronous FIFO Testbench...");

        // Initialize signals
        wclk = 0;
        rclk = 0;
        reset_fifo();

        $display("Writing to FIFO...");
        write_multiple(DEPTH);  // Fill FIFO

        #50;

        $display("Reading from FIFO...");
        read_multiple(DEPTH);   // Empty FIFO

        #50;

        $display("Simultaneous Write and Read Test...");
        @(posedge wclk);
        @(posedge rclk);
        w_en = 1;
        r_en = 1;
        data_in = 'd30;
        repeat (2) @(posedge wclk);
        w_en = 0;
        @(posedge rclk);
        r_en = 0;

        #50;
        $display("Final Read...");
        read_fifo();

        #100;
        $finish;
    end

endmodule
