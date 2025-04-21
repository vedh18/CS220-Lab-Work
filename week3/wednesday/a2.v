module sequence_detector(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);

    // State encoding
    parameter S_IDLE  = 4'b0000;  // Initial state
    parameter S_0     = 4'b0001;  // Seen "0"
    parameter S_00    = 4'b0010;  // Seen "00"
    parameter S_1     = 4'b0011;  // Seen "1"
    parameter S_11    = 4'b0100;  // Seen "11"
    parameter S_FOUND = 4'b1111;  // Pattern found state
    
    // State registers
    reg [3:0] current_state, next_state;
    
    // Sequential logic - state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end
    
    // Output logic - only high in the FOUND state (Moore machine style)
    always @(*) begin
        out = (current_state == S_FOUND) ? 1'b1 : 1'b0;
    end
    
    // Next state logic
    always @(*) begin
        // Default assignment
        next_state = current_state;
        
        case (current_state)
            S_IDLE: begin
                if (in)
                    next_state = S_1;   // First "1" seen
                else
                    next_state = S_0;   // First "0" seen
            end
            
            S_0: begin
                if (in)
                    next_state = S_1;   // Start new "1" sequence
                else
                    next_state = S_00;  // Second "0" seen
            end
            
            S_00: begin
                if (in)
                    next_state = S_1;   // Start new "1" sequence
                else
                    next_state = S_FOUND; // Third "0" seen - sequence detected
            end
            
            S_1: begin
                if (in)
                    next_state = S_11;  // Second "1" seen
                else
                    next_state = S_0;   // Start new "0" sequence
            end
            
            S_11: begin
                if (in)
                    next_state = S_FOUND; // Third "1" seen - sequence detected
                else
                    next_state = S_0;   // Start new "0" sequence
            end
            
            S_FOUND: begin
                // Start tracking new potential sequences immediately
                if (in)
                    next_state = S_1;   // First "1" seen
                else
                    next_state = S_0;   // First "0" seen
            end
            
            default: next_state = S_IDLE;
        endcase
    end

endmodule

module sequence_detector_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg in;
    wire out;
    
    // Instantiate the sequence detector
    sequence_detector dut(
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Main test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        in = 0;
        
        // Display simulation header
        $display("=== SEQUENCE DETECTOR SIMULATION ===");
        $display("Detecting sequences: '111' or '000'");
        $display("Time\tInput\tState\tOutput");
        $display("--------------------------------");
        
        // Apply reset
        #20 reset = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tIDLE\t%b", $time, in, out);
        
        // Test sequence "000"
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS0\t%b", $time, in, out);
        
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS00\t%b", $time, in, out);
        
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tFOUND\t%b", $time, in, out);
        
        // Test sequence "111"
        @(negedge clk); in = 1;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS1\t%b", $time, in, out);
        
        @(negedge clk); in = 1;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS11\t%b", $time, in, out);
        
        @(negedge clk); in = 1;
        @(posedge clk); #1; 
        $display("%0t\t%b\tFOUND\t%b", $time, in, out);
        
        // Add more test cases to verify overlapping sequences
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS0\t%b", $time, in, out);
        
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS00\t%b", $time, in, out);
        
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tFOUND\t%b", $time, in, out);
        
        // Test non-matching sequence "101"
        @(negedge clk); in = 1;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS1\t%b", $time, in, out);
        
        @(negedge clk); in = 0;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS0\t%b", $time, in, out);
        
        @(negedge clk); in = 1;
        @(posedge clk); #1; 
        $display("%0t\t%b\tS1\t%b", $time, in, out);
        
        // End simulation
        $display("\n=== Simulation complete ===");
        #20 $finish;
    end
endmodule