module shifter #(LENGTH = 16, WIDTH = 32) (
    input clk, rst, load, en, 
    input [WIDTH-1:0] idata,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] shift_data [LENGTH-1:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < LENGTH; i = i + 1) begin
                shift_data[i] <= 0;
            end
        end else if (load) begin
            shift_data[LENGTH-1] <= idata;
            for (i = LENGTH-1; i > 0; i = i - 1) begin
                shift_data[i-1] <= shift_data[i];
            end
        end else if (en) begin
            shift_data[0] <= 0;
            for (i = 1; i < LENGTH; i = i + 1) begin
                shift_data[i] <= shift_data[i-1];
            end
        end
    end

    assign out = shift_data[LENGTH-1];

endmodule