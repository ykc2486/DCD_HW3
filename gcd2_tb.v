`timescale 1ns / 1ps

module gcd2_tb;
    // Testbench 信號
    reg clk;
    reg rst;
    reg start;
    reg [15:0] a_in;
    reg [15:0] b_in;
    wire valid;
    wire [15:0] out;

    // 例化 GCD 模組
    gcd2 uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a_in(a_in),
        .b_in(b_in),
        .valid(valid),
        .out(out)
    );

    // 產生時鐘 (週期 10ns => 頻率 100MHz)
    always #5 clk = ~clk;

    initial begin
        // 初始化訊號
        clk = 0;
        rst = 1;
        start = 0;
        a_in = 0;
        b_in = 0;

        // 釋放重置
        #20;
        rst = 0;
        
        // 測試用例 1: GCD(48, 18) = 6
        #10;
        start = 1;
        a_in = 48;
        b_in = 18;
        #10;
        start = 0; // 拉低 start 信號
        
        // 等待 valid 信號變高
        wait(valid);
        #10;
        $display("Test 1: GCD(%d, %d) = %d", 48, 18, out);

        // 測試用例 2: GCD(56, 98) = 14
        #50;
        start = 1;
        a_in = 56;
        b_in = 98;
        #10;
        start = 0;
        
        wait(valid);
        #10;
        $display("Test 2: GCD(%d, %d) = %d", 56, 98, out);

        // 測試用例 3: GCD(101, 103) = 1 (互質數)
        #50;
        start = 1;
        a_in = 101;
        b_in = 103;
        #10;
        start = 0;
        
        wait(valid);
        #10;
        $display("Test 3: GCD(%d, %d) = %d", 101, 103, out);

        // 測試用例 4: GCD(0, 25) = 25
        #50;
        start = 1;
        a_in = 0;
        b_in = 25;
        #10;
        start = 0;
        
        wait(valid);
        #10;
        $display("Test 4: GCD(%d, %d) = %d", 0, 25, out);

        // 測試用例 5: GCD(120, 0) = 120
        #50;
        start = 1;
        a_in = 120;
        b_in = 0;
        #10;
        start = 0;
        
        wait(valid);
        #10;
        $display("Test 5: GCD(%d, %d) = %d", 120, 0, out);

        // 結束模擬
        #50;
        $finish;
    end

endmodule
