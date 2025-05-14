module synchronizer #(
    parameter WIDTH = 2
)(
    input                   clk,
    input                   rst_n,
    input      [WIDTH-1:0]  data_in,
    output reg [WIDTH-1:0]  data_out
);
reg [WIDTH-1:0] sync_reg;

always @(posedge clk) begin
    if(!rst_n) begin
        data_out    <=  'b0;
        sync_reg    <=  'b0;
    end
    else begin
        sync_reg    <=  data_in;
        data_out    <= sync_reg;
    end
end

endmodule