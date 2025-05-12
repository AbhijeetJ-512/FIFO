module synchronous_fifo #(
    parameter DEPTH = 10,
    parameter DATA_WIDTH = 32
) (
    input                           clk,
    input                           rst_n,
    input                           w_en,
    input                           r_en,
    input       [DATA_WIDTH-1:0]    data_in,
    output reg  [DATA_WIDTH-1:0]    data_out,
    output                          full,
    output                          empty
);

localparam  DEPTH_NUM = $clog2(DEPTH) ;
// FIFO Memory 
reg [DATA_WIDTH-1 : 0] FIFO [0 : DEPTH-1]; 
reg [DEPTH_NUM-1:0] w_ptr,r_ptr;
reg [DEPTH_NUM-1:0]  count;

always @(posedge clk) begin
    if(!rst_n) begin
        data_out    <=  'b0;
        w_ptr       <=  'b0;
        r_ptr       <=  'b0;
        count       <=  'b0;
    end
    else begin
        case({r_en,w_en}) 
            2'b00, 2'b11 : count <= count;
            2'b01 : count <= count + 1'b1;
            2'b10 : count <= count - 1'b1;
        endcase
    end
end

always @(posedge clk ) begin
    if(r_en & !empty ) begin
        data_out <= FIFO[r_ptr];
        r_ptr <= r_ptr + 1'b1;
    end
end

always @(posedge clk) begin
    if(w_en & !full) begin
        FIFO[w_ptr] <= data_in;
        w_ptr <= w_ptr + 1'b1;
    end 
end

assign full = (count == DEPTH);
assign empty = (count == 0);
    
endmodule