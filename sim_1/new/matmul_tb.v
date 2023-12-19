`timescale 1ns / 1ps

module matmul_tb;

    reg             clk;
    reg             rst;

    // matrix A & B access port
    wire            mab_en;      // memory enable
    wire            mab_we;      // memory write enable
    wire    [ 8:0]  mab_addr;    // memory address
    wire    [31:0]  mab_dout;    // memory read data
    wire    [31:0]  mab_din;     // memory write data

    // matrix C access port
    wire            mc_en;      // memory enable
    wire            mc_we;      // memory write enable
    wire    [ 7:0]  mc_addr;    // memory address
    wire    [31:0]  mc_dout;    // memory read data
    wire    [31:0]  mc_din;     // memory write data

    wire ready;

    // instantiation of user module
    matmul u_matmul (
        .clk        (clk),
        .rst        (rst),
        
        .mab_en     (mab_en),
        .mab_we     (mab_we),
        .mab_addr   (mab_addr),
        .mab_dout   (mab_dout),
        .mab_din    (mab_din),
        
        .mc_en      (mc_en),
        .mc_we      (mc_we),
        .mc_addr    (mc_addr),
        .mc_dout    (mc_dout),
        .mc_din     (mc_din),

        .ready      (ready)
    );

    // instantiation of bram
    blk_mem_gen_0 u_mab (
        .clka       (!clk),      // input wire clka
        .ena        (mab_en),   // input wire ena
        .wea        (mab_we),   // input wire [0 : 0] wea
        .addra      (mab_addr), // input wire [8 : 0] addra
        .dina       (mab_din),  // input wire [31 : 0] dina
        .douta      (mab_dout)  // output wire [31 : 0] douta
    );
    blk_mem_gen_1 u_mc (
        .clka       (!clk),      // input wire clka
        .ena        (mc_en),    // input wire ena
        .wea        (mc_we),    // input wire [0 : 0] wea
        .addra      (mc_addr),  // input wire [7 : 0] addra
        .dina       (mc_din),   // input wire [31 : 0] dina
        .douta      (mc_dout)   // output wire [31 : 0] douta
    );

    real CYCLE = 10;

    // clock signal generation
    always begin
        clk = 0; #(CYCLE/2);
        clk = 1; #(CYCLE/2);
    end

    // reset signal generation
    initial begin
        rst = 0; #3;
        rst = 1; #80;
        rst = 0;
    end

    // fetch ready
    reg ready_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            ready_reg <= 0;
        else if (ready)
            ready_reg <= 1;
    end

    // trace user data
    reg [31:0] user_trace [255:0];
    always @(posedge clk) begin
        if (!rst & mc_en & mc_we)
            user_trace[mc_addr] <= mc_din;
    end

    // read answer from file
    reg [31:0] golden_trace [255:0];
    initial begin
        $readmemh("ans.dat", golden_trace);
    end

    // compare user data with answer
    integer i;
    reg [8:0] err_cnt;
    reg [31:0] cyc_cnt;
    reg [7:0] index;
    wire [31:0] u = user_trace[index];
    wire [31:0] g = golden_trace[index];
    initial begin
        index = 0;
        wait(ready_reg);
        #(CYCLE);
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge clk);
            index = i;
            if (u != g) begin
                $display("[FAULT]   index: %8d,   user_data: %8d,   reference_data: %8d", index, u, g);
            end
        end
        #(CYCLE);
        if (err_cnt != 'b0) begin
            $display("======================================================================");
            $display("FAILED, total error: %d, elapsed cycle: %d.", err_cnt, cyc_cnt);
            $display("======================================================================");
        end
        else begin
            $display("======================================================================");
            $display("PASSED, elapsed cycle: %d.", cyc_cnt);
            $display("======================================================================");
            $finish;
        end
    end

    // error counter
    always @(posedge clk or rst) begin
        if (rst)
            err_cnt <= 'b0;
        else if (ready_reg)
            if (u != g)
                err_cnt <= err_cnt + 'b1;
    end

    // cycle counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            cyc_cnt <= 'b0;
        else if (!ready_reg)
            cyc_cnt <= cyc_cnt + 'b1;
    end

endmodule
