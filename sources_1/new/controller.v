module controller #(WIDTH = 16) (
    input clk, rst,
    output [WIDTH-1:0] row_shifter_en,
    output [WIDTH-1:0] col_shifter_en,
    output reg row_en
);
    reg [WIDTH-1:0] shift_en;

    always @(posedge clk) begin
        if (rst) begin
            shift_en <= 1;
            row_en = 0;
        end else begin
            shift_en <= row_en ? shift_en << 1 : shift_en;
            row_en <= ~row_en;
        end
    end

    assign row_shifter_en = {WIDTH{row_en}} & shift_en;
    assign col_shifter_en = ~{WIDTH{row_en}} & shift_en;

    
endmodule