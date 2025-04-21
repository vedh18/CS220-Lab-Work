module full_subtractor_tb;
    // Test signals
    reg A, B, Bin;       // Inputs are declared as reg (can be assigned values)
    wire D, Bout;        // Outputs are declared as wire (can only be driven by module)
    
    // Instantiate the full subtractor (Design Under Test)
    full_subtractor DUT(
        .A(A),           // Connect testbench signals to module ports
        .B(B),
        .Bin(Bin),
        .D(D),
        .Bout(Bout)
    );
    
    // Test procedure
    initial begin
        // Display header for results table
        $display("Time\tA B Bin | D Bout | Expected D Bout | Description");
        $display("-----------------------------------------------------");
        
        // Test all 8 input combinations (2^3 possibilities)
        
        // Case 0: A=0, B=0, Bin=0
        A = 0; B = 0; Bin = 0; #10;
        $display("%3d\t%b %b %b   | %b %b   | 0 0       | 0-0-0=0, No borrow", $time, A, B, Bin, D, Bout);
        
        // Case 1: A=0, B=0, Bin=1
        A = 0; B = 0; Bin = 1; #10;
        $display("%3d\t%b %b %b   | %b %b   | 1 1       | 0-0-1=1, Borrow needed", $time, A, B, Bin, D, Bout);
        
        // Case 2: A=0, B=1, Bin=0
        A = 0; B = 1; Bin = 0; #10;
        $display("%3d\t%b %b %b   | %b %b   | 1 1       | 0-1-0=1, Borrow needed", $time, A, B, Bin, D, Bout);
        
        // Case 3: A=0, B=1, Bin=1
        A = 0; B = 1; Bin = 1; #10;
        $display("%3d\t%b %b %b   | %b %b   | 0 1       | 0-1-1=0, Borrow needed", $time, A, B, Bin, D, Bout);
        
        // Case 4: A=1, B=0, Bin=0
        A = 1; B = 0; Bin = 0; #10;
        $display("%3d\t%b %b %b   | %b %b   | 1 0       | 1-0-0=1, No borrow", $time, A, B, Bin, D, Bout);
        
        // Case 5: A=1, B=0, Bin=1
        A = 1; B = 0; Bin = 1; #10;
        $display("%3d\t%b %b %b   | %b %b   | 0 0       | 1-0-1=0, No borrow", $time, A, B, Bin, D, Bout);
        
        // Case 6: A=1, B=1, Bin=0
        A = 1; B = 1; Bin = 0; #10;
        $display("%3d\t%b %b %b   | %b %b   | 0 0       | 1-1-0=0, No borrow", $time, A, B, Bin, D, Bout);
        
        // Case 7: A=1, B=1, Bin=1
        A = 1; B = 1; Bin = 1; #10;
        $display("%3d\t%b %b %b   | %b %b   | 1 1       | 1-1-1=1, Borrow needed", $time, A, B, Bin, D, Bout);
        
        // End simulation
        #10 $finish;
    end
endmodule