`timescale 1ns/1ps
`include "synchronous_fifo.v"

module tb_synchronous_fifo;

    // Parameters
    parameter DEPTH = 10;
    parameter DATA_WIDTH = 32;

    // DUT signals
    reg clk, rst_n;
    reg w_en, r_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;

    // Instantiate the DUT
    synchronous_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task: Reset FIFO
    task reset_fifo;
    begin
        rst_n = 0;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        #20;
        rst_n = 1;
        #10;
    end
    endtask

    // Task: Write a single data word to FIFO
    task write_fifo(input [DATA_WIDTH-1:0] data);
    begin
        @(posedge clk);
        if (!full) begin
            data_in = data;
            w_en = 1;
        end
        
    end
    endtask

    // Task: Read a single data word from FIFO
    task read_fifo;
    begin
        @(posedge clk);
        if (!empty) begin
            r_en = 1;
        end
        
    end
    endtask

    // Task: Write multiple values
    task write_multiple(input integer n);
    integer i;
    begin
        for (i = 0; i < n; i = i + 1) begin
            write_fifo(i + 100);
            @(posedge clk);
            w_en = 0;
            // data_in = 0;
        end
    end
    endtask

    // Task: Read multiple values
    task read_multiple(input integer n);
    integer j;
    begin
        for (j = 0; j < n; j = j + 1) begin
            read_fifo();
            // @(posedge clk); // Wait for data_out to be valid
            @(posedge clk);
            r_en = 0;
            $display("Read [%0d]: %0d", j, data_out);
        end
    end
    endtask

    // Initial block to run the test
    initial begin
        $dumpfile("fifo_dump.vcd");
        $dumpvars(0, tb_synchronous_fifo);
        $display("Starting FIFO Testbench...");
        clk = 0;
        reset_fifo();

        $display("Filling FIFO...");
        write_multiple(DEPTH);  // Fill FIFO

        $display("Reading FIFO...");
        read_multiple(DEPTH);   // Empty FIFO

        $display("Testing simultaneous write/read...");
        @(posedge clk);
        w_en = 1;
        r_en = 1;
        data_in = 999;
        @(posedge clk);
        w_en = 0;
        r_en = 0;

        $display("Final read...");
        read_fifo();

        #50;
        $finish;
    end

endmodule
