module addr_gen #(ADDRLEN = 9) (
    input clk, rst, row_en,
    output [ADDRLEN-1:0] addr 
);
    reg [3:0] row;
    reg [3:0] col;
    reg [3:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            row <= 0;
            col <= 0;
            cnt <= 0;
        end else begin
            if (cnt == 15) begin
                row <= row + row_en;
                col <= col + !row_en;
                cnt <= 0;                
            end
            else
                cnt <= cnt + 1;
        end
    end
    
    assign addr = row_en ? ((row << 4) | cnt) : (9'h100 | col | (cnt << 4));
endmodule