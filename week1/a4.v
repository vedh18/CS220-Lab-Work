module mod10_counter_structural(
    input wire clk,         // Clock input
    input wire reset,       // Active-high reset
    input wire enable,      // Counter enable
    output wire [3:0] count // 4-bit counter output (0-9)
);
    // Internal control signals
    wire reset_to_zero;    // Reset counter when count = 9
    wire count_is_nine;    // Detect when count = 9
    
    // T inputs for each flip-flop
    wire t0, t1, t2, t3;
    
    // Detect when counter reaches 9 (1001 in binary)
    assign count_is_nine = (count[3] & ~count[2] & ~count[1] & count[0]);
    
    // Reset signal for the counter (external reset OR count reaches 9)
    assign reset_to_zero = reset | (count_is_nine & enable);
    
    // T input logic for each flip-flop
    assign t0 = enable;                           // Toggle every clock when enabled
    assign t1 = enable & count[0];                // Toggle when bit 0 is 1 and enabled
    assign t2 = enable & count[0] & count[1];     // Toggle when bits 0 and 1 are 1 and enabled
    assign t3 = (~count[3] & count[2] & count[1] & count[0] & enable) | 
           (count[3] & ~count[2] & ~count[1] & count[0] & enable);

    // T flip-flops for each bit
    t_flip_flop tff0(.clk(clk), .reset(reset_to_zero), .t(t0), .q(count[0]));
    t_flip_flop tff1(.clk(clk), .reset(reset_to_zero), .t(t1), .q(count[1]));
    t_flip_flop tff2(.clk(clk), .reset(reset_to_zero), .t(t2), .q(count[2]));
    t_flip_flop tff3(.clk(clk), .reset(reset_to_zero), .t(t3), .q(count[3]));
    
endmodule

// T flip-flop implementation
module t_flip_flop(
    input wire clk,
    input wire reset,
    input wire t,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (t)
            q <= ~q;  // Toggle when t is high
    end
endmodule
