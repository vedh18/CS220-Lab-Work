module subtractor_32bit_tb;
    // Test signals
    reg [31:0] A, B;
    wire [31:0] Diff;
    wire Bout;
    
    // Instantiate the 32-bit subtractor
    subtractor_32bit DUT(
        .A(A),
        .B(B),
        .Diff(Diff),
        .Bout(Bout)
    );
    
    // Helper task to display results
    task display_result;
        input [31:0] expected_diff;
        input expected_bout;
        begin
            $display("A = %d, B = %d", A, B);
            $display("Difference = %d (Expected: %d)", Diff, expected_diff);
            $display("Borrow Out = %b (Expected: %b)", Bout, expected_bout);
            
            if (Diff !== expected_diff || Bout !== expected_bout)
                $display("*** TEST FAILED ***");
            else
                $display("Test passed");
                
            $display("----------------------------------");
        end
    endtask
    
    // Test procedure
    initial begin
        // Test Case 1: Simple subtraction (A > B)
        A = 32'd100; B = 32'd50; #20;
        display_result(32'd50, 1'b0);
        
        // Test Case 2: Subtraction resulting in zero
        A = 32'd75; B = 32'd75; #20;
        display_result(32'd0, 1'b0);
        
        // Test Case 3: Subtraction with borrow (A < B)
        A = 32'd30; B = 32'd50; #20;
        display_result(32'hFFFFFFE2, 1'b1); // -20 in two's complement
        
        // Test Case 4: Large numbers
        A = 32'd1000000; B = 32'd500000; #20;
        display_result(32'd500000, 1'b0);
        
        // Test Case 5: Max value minus 1
        A = 32'hFFFFFFFF; B = 32'd1; #20;
        display_result(32'hFFFFFFFE, 1'b0);
        
        // Test Case 6: Zero minus non-zero (underflow)
        A = 32'd0; B = 32'd1; #20;
        display_result(32'hFFFFFFFF, 1'b1);
        
        // Test Case 7: Max value minus max value
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; #20;
        display_result(32'd0, 1'b0);
        
        // Test Case 8: Random values
        A = 32'd123456; B = 32'd78901; #20;
        display_result(32'd44555, 1'b0);
        
        $display("All tests completed");
        $finish;
    end
endmodule