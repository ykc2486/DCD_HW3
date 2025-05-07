`timescale 1ns / 1ps

module gcd3_tb();
    parameter CLK_PERIOD = 10;

    reg clk, reset, start;
    reg [15:0] A, B, C;
    wire valid;
    wire [15:0] D;

    gcd3_top uut (
        .clk(clk), .reset(reset), .start(start),
        .A(A), .B(B), .C(C), .valid(valid), .D(D)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        reset = 1; start = 0; A = 0; B = 0; C = 0;
        #(CLK_PERIOD*2); reset = 0; #(CLK_PERIOD*2);

        run_test(24, 36, 48);
        run_test(15, 25, 35);
        run_test(100, 125, 150);
        run_test(17, 19, 23);
        run_test(0, 36, 48);

        #(CLK_PERIOD*10);
        $finish;
    end

    task run_test(input [15:0] a, b, c);
        begin
            A = a; B = b; C = c;
            start = 1; #(CLK_PERIOD); start = 0;
            wait(valid); #(CLK_PERIOD);
            $display("Result = %d", D);
            reset = 1; #(CLK_PERIOD*2); reset = 0; #(CLK_PERIOD*2);
        end
    endtask
endmodule
