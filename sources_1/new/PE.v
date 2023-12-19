module PE #( WIDTH = 32) (
    input clk, rst,
    input [WIDTH-1:0] in_col, 
    input [WIDTH-1:0] in_row,
    output reg [WIDTH-1:0] out_col,
    output reg [WIDTH-1:0] out_row,
    output reg [WIDTH-1:0] out_sum
);
    
    always @(posedge clk) begin
        if (rst) begin
            out_col <= 0;
            out_row <= 0;
            out_sum <= 0;
        end else begin
            out_col <= in_col;
            out_row <= in_row;
            out_sum <= in_col*in_row + out_sum;
        end
    end
endmodule