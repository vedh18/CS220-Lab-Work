module priority_encoder_tb;
    // Test signals
    reg [3:0] in;              // Input vector
    wire [1:0] out;            // Encoded output
    wire valid;                // Valid output
    
    // Instantiate the priority encoder
    priority_encoder_structural DUT(
        .in(in),
        .out(out),
        .valid(valid)
    );
    
    // Helper task to check results
    task check_result;
        input [1:0] expected_out;
        input expected_valid;
        begin
            if (out !== expected_out || valid !== expected_valid) begin
                $display("ERROR: For in=%b, got out=%b valid=%b, expected out=%b valid=%b",
                         in, out, valid, expected_out, expected_valid);
            end else begin
                $display("PASS:  For in=%b, got out=%b valid=%b", in, out, valid);
            end
        end
    endtask
    
    // Test procedure
    initial begin
        $display("Starting Priority Encoder Tests");
        $display("==============================");
        
        // Test case 0: No inputs active (0000)
        in = 4'b0000; #10;
        check_result(2'b00, 1'b0);
        
        // Test case 1: Only i0 active (0001)
        in = 4'b0001; #10;
        check_result(2'b00, 1'b1);
        
        // Test case 2: i1 active (0010)
        in = 4'b0010; #10;
        check_result(2'b01, 1'b1);
        
        // Test case 3: i1 and i0 active (0011)
        in = 4'b0011; #10;
        check_result(2'b01, 1'b1);
        
        // Test case 4: i2 active (0100)
        in = 4'b0100; #10;
        check_result(2'b10, 1'b1);
        
        // Test case 5: i2 and i0 active (0101)
        in = 4'b0101; #10;
        check_result(2'b10, 1'b1);
        
        // Test case 6: i2 and i1 active (0110)
        in = 4'b0110; #10;
        check_result(2'b10, 1'b1);
        
        // Test case 7: i2, i1, and i0 active (0111)
        in = 4'b0111; #10;
        check_result(2'b10, 1'b1);
        
        // Test case 8: i3 active (1000)
        in = 4'b1000; #10;
        check_result(2'b11, 1'b1);
        
        // Test cases 9-15: All combinations with i3 active
        // Since i3 has highest priority, these should all have the same output
        in = 4'b1001; #10;
        check_result(2'b11, 1'b1);
        
        in = 4'b1010; #10;
        check_result(2'b11, 1'b1);
        
        in = 4'b1111; #10;
        check_result(2'b11, 1'b1);
        
        $display("==============================");
        $display("Tests completed");
        $finish;
    end
endmodule