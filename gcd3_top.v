`timescale 1ns / 1ps

module gcd3_top (
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [15:0] C,
    output reg valid,
    output reg [15:0] D
);

    reg s;
    reg start_gcd;
    wire valid_gcd;
    wire [15:0] gcd_out;

    reg [15:0] in1, in2;
    reg [15:0] result_ab;

    always @(*) begin
        if (s == 0) begin
            in1 = A;
            in2 = B;
        end else begin
            in1 = result_ab;
            in2 = C;
        end
    end

    localparam IDLE = 2'd0,
               FIRST_PASS = 2'd1,
               SECOND_PASS = 2'd2,
               DONE = 2'd3;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_gcd <= 0;
            s <= 0;
            result_ab <= 0;
            valid <= 0;
            D <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid <= 0;
                    if (start) begin
                        start_gcd <= 1;
                        s <= 0;
                    end
                end

                FIRST_PASS: begin
                    start_gcd <= 0;
                    if (valid_gcd) begin
                        result_ab <= gcd_out;
                        start_gcd <= 1;
                        s <= 1;
                    end
                end

                SECOND_PASS: begin
                    start_gcd <= 0;
                    if (valid_gcd) begin
                        D <= gcd_out;
                        valid <= 1;
                    end
                end

                DONE: begin
                    start_gcd <= 0;
                    s <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = FIRST_PASS;
            FIRST_PASS: if (valid_gcd) next_state = SECOND_PASS;
            SECOND_PASS: if (valid_gcd) next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end

    gcd2 cal(
        .clk(clk),
        .rst(reset),
        .start(start_gcd),
        .a_in(in1),
        .b_in(in2),
        .valid(valid_gcd),
        .out(gcd_out)
    );

endmodule
