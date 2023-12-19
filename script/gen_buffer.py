# 输入 shifter 生成
# wire_str = "wire [31:0]"


# for i in range(16):
#     wire_str += " sa_row_" + str(i) + ", sa_col_" + str(i) + ","
#     print("shifter row_%d(.clk(clk), .rst(rst), .load(row_shifter_en[%d]), .en(!row_en & clk16x), .idata(mab_dout), .out(sa_row_%d));" % (i,i,i))
#     print("shifter col_%d(.clk(clk), .rst(rst), .load(col_shifter_en[%d]), .en(!row_en & clk16x), .idata(mab_dout), .out(sa_col_%d));" % (i,i,i))

# print(wire_str)

# 脉动阵列生成
wire_str = "wire [31:0] "

for r in range(16):
    for c in range(16):
        base = "sa_" + str(r) + "_" + str(c)
        wire_str += base + "_row, "
        wire_str += base + "_col, "
        # wire_str += base + "_out, "

        in_row = "sa_" + str(r) + "_" + str(c-1) + "_row" if c != 0 else "shifter_row_" + str(r)
        in_col = "sa_" + str(r-1) + "_" + str(c) + "_col" if r != 0 else "shifter_col_" + str(c)
        print("\tPE %s(.clk(clk32x), .rst(rst), .in_col(%s), .in_row(%s), .out_col(%s_col), .out_row(%s_row), .out_sum(%s));"
            % (base, in_col, in_row, base, base, "sa_out[%s]" % str(r*16+c)))

        if c %4 == 0:
            wire_str += "\n\t"

print(wire_str)