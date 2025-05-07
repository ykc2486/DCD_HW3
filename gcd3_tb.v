module gcd3_tb;
    // Clock and reset
    reg clk;
    reg reset;

    // DUT inputs
    reg start;
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;

    // DUT outputs
    wire valid;
    wire [15:0] D;

    // Instantiate DUT
    gcd3_top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .C(C),
        .valid(valid),
        .D(D)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        start = 0;
        A = 0;
        B = 0;
        C = 0;

        // Apply reset
        #20;
        reset = 0;

        // Test vector 1: gcd(48, 18, 30) = 6
        A = 16'd48;
        B = 16'd18;
        C = 16'd30;
        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for valid
        wait(valid);
        $display("Time=%0t : gcd(48,18,30) = %d", $time, D);

        // Test vector 2: gcd(21, 14, 28) = 7
        #10;
        A = 16'd21;
        B = 16'd14;
        C = 16'd28;
        #10;
        start = 1;
        #10;
        start = 0;

        wait(valid);
        $display("Time=%0t : gcd(21,14,28) = %d", $time, D);

        // Test vector 3: gcd(7, 13, 29) = 1
        #10;
        A = 16'd7;
        B = 16'd13;
        C = 16'd29;
        #10;
        start = 1;
        #10;
        start = 0;

        wait(valid);
        $display("Time=%0t : gcd(7,13,29) = %d", $time, D);

        // Finish simulation
        #20;
        $finish;
    end

endmodule
