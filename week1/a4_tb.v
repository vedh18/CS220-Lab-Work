module mod10_counter_tb;
    // Inputs to DUT - must be reg to drive values
    reg clk;
    reg reset;
    reg enable;
    
    // Outputs from DUT - must be wire (driven by DUT)
    wire [3:0] count;
    
    // Instantiate the counter
    mod10_counter_behavioral DUT(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );
    
    // Generate clock with 10ns period
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        enable = 0;
        
        // Apply reset, then enable counting
        #20 reset = 0;
        #10 enable = 1;
        
        // Let it count through a full cycle (0 to 9)
        #200;
        
        // End simulation
        $finish;
    end
    
    // Monitor the count
    initial
        $monitor("Time = %0t, Count = %d", $time, count);
        
endmodule