module mod7_updown_counter(
    input clk,
    input reset,
    input mode,         // 0: up counting, 1: down counting
    output [2:0] count
);
    wire [2:0] q;       // Current state 
    wire [2:0] t;       // Toggle inputs for T flip-flops
    
    assign count = q;
    
    // Detect special states
    wire is_count_6, is_count_0;
    and and_count_6(is_count_6, q[2], q[1], ~q[0]);      // Count = 6 (110)
    nor nor_count_0(is_count_0, q[2], q[1], q[0]);       // Count = 0 (000)
    
    // Special case transitions
    wire special_6_to_0, special_0_to_6;
    and and_6_to_0(special_6_to_0, ~mode, is_count_6);   // At 6 and going up
    and and_0_to_6(special_0_to_6, mode, is_count_0);    // At 0 and going down
    
    // T0 logic (LSB)
    // For regular counting (both up and down): always toggle
    // For special transitions: toggle based on current and next states
    wire t0_normal;
    nor nor_special(t0_normal, special_6_to_0, special_0_to_6);
    assign t[0] = t0_normal;
    
    // T1 logic (middle bit)
    // Up mode: toggle when count[0] is 1
    wire t1_up;
    and and_t1_up(t1_up, ~mode, q[0], ~is_count_6);
    
    // Down mode: toggle when count[0] is 0
    wire t1_down;
    and and_t1_down(t1_down, mode, ~q[0], ~is_count_0);
    
    // Special case 6→0: Must toggle bit 1 (1→0)
    // Special case 0→6: Must toggle bit 1 (0→1)
    wire t1_special;
    or or_t1_special(t1_special, special_6_to_0, special_0_to_6);
    
    or or_t1(t[1], t1_up, t1_down, t1_special);
    
    // T2 logic (MSB)
    // Up mode: toggle when bits 1,0 = 11
    wire t2_up;
    and and_t2_up(t2_up, ~mode, q[1], q[0], ~is_count_6);
    
    // Down mode: toggle when bits 1,0 = 00
    wire t2_down;
    and and_t2_down(t2_down, mode, ~q[1], ~q[0], ~is_count_0);
    
    // Special case 6→0: Must toggle bit 2 (1→0)
    // Special case 0→6: Must toggle bit 2 (0→1)
    wire t2_special;
    or or_t2_special(t2_special, special_6_to_0, special_0_to_6);
    
    or or_t2(t[2], t2_up, t2_down, t2_special);
    
    // T flip-flops
    tff tff0(clk, reset, t[0], q[0]);
    tff tff1(clk, reset, t[1], q[1]);
    tff tff2(clk, reset, t[2], q[2]);
    
endmodule

// T flip-flop implementation
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
            q <= ~q;  // Toggle when t is high
    end
endmodule