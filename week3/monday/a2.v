module sequence_detector(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);

    // State encoding using parameters
    parameter S0 = 4'b0000;  // Initial state
    parameter S1 = 4'b0001;  // Seen "1"
    parameter S2 = 4'b0010;  // Seen "11"
    parameter S3 = 4'b0011;  // Seen "110"
    parameter S4 = 4'b0100;  // Seen "10"
    parameter S5 = 4'b0101;  // Seen "101"
    parameter S6 = 4'b0110;  // Seen "100"
    parameter S_FOUND = 4'b1111;  // Pattern found state

    // State registers
    reg [3:0] current_state, next_state;

    // Sequential logic - state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
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
            S0: begin
                // From initial state, move to S1 if input is 1
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            
            S1: begin
                // From "1", move to S2 if input is 1, or S4 if input is 0
                if (in)
                    next_state = S2;
                else
                    next_state = S4;
            end
            
            S2: begin
                // From "11", stay at S2 if input is 1, or move to S3 if input is 0
                if (in)
                    next_state = S2;
                else
                    next_state = S3;
            end
            
            S3: begin
                // From "110", move to S1 if input is 1
                // If input is 0, we've found "1100" - go to found state
                if (in)
                    next_state = S1;
                else
                    next_state = S_FOUND;  // Detected "1100"
            end
            
            S4: begin
                // From "10", move to S5 if input is 1, or S6 if input is 0
                if (in)
                    next_state = S5;
                else
                    next_state = S6;
            end
            
            S5: begin
                // From "101", move to S2 if input is 1
                // If input is 0, we've found "1010" - go to found state
                if (in)
                    next_state = S2;
                else
                    next_state = S_FOUND;  // Detected "1010"
            end
            
            S6: begin
                // From "100", move to initial state if input is 0
                // If input is 1, we've found "1001" - go to found state
                if (in)
                    next_state = S_FOUND;  // Detected "1001"
                else
                    next_state = S0;
            end
            
            S_FOUND: begin
                // Always go back to initial state after detection
                next_state = S0;
            end
            
            default: next_state = S0;
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
    sequence_detector dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Task to apply one bit of input
    task apply_bit;
        input bit_value;
        begin
            @(negedge clk); // Apply input at negative edge
            in = bit_value;
            @(posedge clk); // Check output after positive edge
            #1; // Small delay for signal propagation
            $display("Time=%0t, Input=%b, Output=%b, State=%h", 
                     $time, in, out, dut.current_state);
        end
    endtask
    
    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        in = 0;
        
        // Display header
        $display("=== SEQUENCE DETECTOR TESTBENCH ===");
        
        // Apply reset for 2 clock cycles
        #20 reset = 0;
        $display("Reset released, starting tests");
        
        // Test sequence "1100" (should detect)
        $display("\n--- Testing sequence 1100 ---");
        apply_bit(1);  // Input: 1
        apply_bit(1);  // Input: 1
        apply_bit(0);  // Input: 0
        apply_bit(0);  // Input: 0 - Should transition to FOUND state
        apply_bit(0);  // Extra cycle to see output
        
        // Test sequence "1010" (should detect)
        $display("\n--- Testing sequence 1010 ---");
        apply_bit(1);  // Input: 1
        apply_bit(0);  // Input: 0
        apply_bit(1);  // Input: 1
        apply_bit(0);  // Input: 0 - Should transition to FOUND state
        apply_bit(0);  // Extra cycle to see output
        
        // Test sequence "1001" (should detect)
        $display("\n--- Testing sequence 1001 ---");
        apply_bit(1);  // Input: 1
        apply_bit(0);  // Input: 0
        apply_bit(0);  // Input: 0
        apply_bit(1);  // Input: 1 - Should transition to FOUND state
        apply_bit(0);  // Extra cycle to see output
        
        $display("\n=== Testbench completed ===");
        #20 $finish;
    end
endmodule