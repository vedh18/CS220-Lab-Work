module mod7_updown_counter_tb;
    // Test signals
    reg clk;
    reg reset;
    reg mode;
    wire [2:0] count;
    
    // Test variables
    integer i;
    reg [2:0] expected;
    
    // Instantiate the counter
    mod7_updown_counter DUT(
        .clk(clk),
        .reset(reset),
        .mode(mode),
        .count(count)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        mode = 0; // Start in up counting mode
        expected = 0;
        
        // Display header
        $display("Time\tMode\tCount\tExpected\tResult");
        $display("--------------------------------------");
        
        // Apply reset for 20ns
        #20 reset = 0;
        
        // Check initial state (should be 0 after reset)
        #1;
        $display("%0t\tInit\t%d\t%d\t\t%s", $time, count, 0, 
                (count === 0) ? "PASS" : "FAIL");
        
        // Test up counting (0 to 6)
        for (i = 1; i <= 7; i = i + 1) begin
            @(posedge clk); #1;
            
            if (i <= 6) begin
                expected = i;
            end else begin
                expected = 0; // Wrap from 6 to 0
            end
            
            $display("%0t\tUp\t%d\t%d\t\t%s", $time, count, expected, 
                    (count === expected) ? "PASS" : "FAIL");
        end
        
        // Switch to down counting mode
        mode = 1;
        
        // Counter should now count down from 0
        @(posedge clk); #1;
        expected = 6; // First down count from 0 wraps to 6
        $display("%0t\tDown\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        // Test down counting (6 to 0)
        for (i = 5; i >= 0; i = i - 1) begin
            @(posedge clk); #1;
            expected = i;
            $display("%0t\tDown\t%d\t%d\t\t%s", $time, count, expected, 
                    (count === expected) ? "PASS" : "FAIL");
        end
        
        // Test mode switching - now at count=0, switch to up
        mode = 0;
        @(posedge clk); #1;
        expected = 1;
        $display("%0t\tUp\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        // Count up to 3
        @(posedge clk); #1;
        expected = 2;
        $display("%0t\tUp\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        @(posedge clk); #1;
        expected = 3;
        $display("%0t\tUp\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        // Switch to down mode at count=3
        mode = 1;
        @(posedge clk); #1;
        expected = 2;
        $display("%0t\tDown\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        // Switch back to up mode
        mode = 0;
        @(posedge clk); #1;
        expected = 3;
        $display("%0t\tUp\t%d\t%d\t\t%s", $time, count, expected, 
                (count === expected) ? "PASS" : "FAIL");
        
        $display("--------------------------------------");
        $display("Test completed");
        #10 $finish;
    end
    
    // Additional monitoring for debugging
    initial begin
        $monitor("Time: %0t, Reset: %b, Mode: %b, Count: %d", $time, reset, mode, count);
    end
endmodule