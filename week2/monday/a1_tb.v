module mod10_gray_counter_tb;
    // Test signals
    reg clk;
    reg reset;
    wire [3:0] count;
    
    // Expected Gray code sequence
    reg [3:0] expected_sequence[0:9];
    integer i;
    
    // Instantiate the counter module
    mod10_gray_counter DUT(
        .clk(clk),
        .reset(reset),
        .count(count)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        
        // Apply reset for 2 clock cycles
        #15 reset = 0;
        #100
        $finish;
    end
    
    // Additional monitoring for easier verification
    initial begin
        $monitor("Time = %0t, Reset = %b, Count = %b", $time, reset, count);
    end
endmodule