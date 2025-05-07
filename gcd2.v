`timescale 1ns / 1ps
module gcd2(
    input clk,
    input rst,
    input start,
    input [15:0] a_in,
    input [15:0] b_in,
    output reg valid,
    output reg [15:0] out
);

    localparam IDLE    = 3'd0;
    localparam COMPARE = 3'd1;
    localparam A_GT_B  = 3'd2;
    localparam B_GT_A  = 3'd3;
    localparam EQUAL   = 3'd4;

    reg [2:0] state, nxt_state;
    reg [15:0] a, b;
    reg signed [16:0] y;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            a <= 0;
            b <= 0;
            valid <= 0;
            out <= 0;
        end else begin
            state <= nxt_state;

            case (state)
                IDLE: begin
                    valid <= 0;
                    if (start) begin
                        a <= a_in;
                        b <= b_in;
                    end
                end

                A_GT_B: begin
                    a <= a - b;
                end

                B_GT_A: begin
                    b <= b - a;
                end

                EQUAL: begin
                    valid <= 1;
                    valid <= 1;
                    if (a == 0 || b == 0)
                        out <= 0;
                    else
                        out <= a;
                end

                default: ;
            endcase
        end
    end

    // next state logic
    always @(*) begin
        nxt_state = state;

        y = $signed({1'b0, a}) - $signed({1'b0, b});

        case (state)
            IDLE: begin
                if (start)
                    nxt_state = COMPARE;
            end

            COMPARE: begin
                if(a == 0 || b == 0) 
                    nxt_state = EQUAL;
                else if (y > 0)
                    nxt_state = A_GT_B;
                else if (y < 0)
                    nxt_state = B_GT_A;
                else
                    nxt_state = EQUAL;
            end

            A_GT_B,
            B_GT_A: begin
                nxt_state = COMPARE;
            end

            EQUAL: begin
                nxt_state = IDLE;
            end

            default: nxt_state = IDLE;
        endcase
    end

endmodule
