module mod10_gray_counter(
    input clk,
    input reset,
    output [3:0] count
);
    wire [3:0] q;
    wire [3:0] t;
    
    assign count = q;
    
    wire t0_term1, t0_term2, t0_term3, t0_term4, t0_term5, t0_term6;
    wire t0_or1, t0_or2;
    wire t1_term1, t1_term2;
    wire t2_term1, t2_term2;
    wire t3_term1, t3_term2;
    
    // T0 logic
    and and_t0_1(t0_term1, ~q[3], ~q[2], ~q[1], ~q[0]);
    and and_t0_2(t0_term2, ~q[3], ~q[2], q[1], q[0]);
    and and_t0_3(t0_term3, ~q[3], q[2], q[1], ~q[0]);
    and and_t0_4(t0_term4, ~q[3], q[2], ~q[1], q[0]);
    and and_t0_5(t0_term5, q[3], q[2], ~q[1], ~q[0]);
    and and_t0_6(t0_term6, q[3], q[2], ~q[1], q[0]);
    
    or or_t0_1(t0_or1, t0_term1, t0_term2, t0_term3);
    or or_t0_2(t0_or2, t0_term4, t0_term5, t0_term6);
    or or_t0_3(t[0], t0_or1, t0_or2);
    
    // T1 logic
    and and_t1_1(t1_term1, ~q[3], ~q[2], ~q[1], q[0]);
    and and_t1_2(t1_term2, ~q[3], q[2], q[1], q[0]);
    or or_t1(t[1], t1_term1, t1_term2);
    
    // T2 logic
    and and_t2_1(t2_term1, ~q[3], ~q[2], q[1], ~q[0]);
    and and_t2_2(t2_term2, q[3], q[2], ~q[1], q[0]);
    or or_t2(t[2], t2_term1, t2_term2);
    
    // T3 logic
    and and_t3_1(t3_term1, ~q[3], q[2], ~q[1], ~q[0]);
    and and_t3_2(t3_term2, q[3], q[2], ~q[1], q[0]);
    or or_t3(t[3], t3_term1, t3_term2);
    
    // T flip-flops
    tff tff0(clk, reset, t[0], q[0]);
    tff tff1(clk, reset, t[1], q[1]);
    tff tff2(clk, reset, t[2], q[2]);
    tff tff3(clk, reset, t[3], q[3]);
endmodule

module tff(
    input clk,
    input reset,
    input t,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule