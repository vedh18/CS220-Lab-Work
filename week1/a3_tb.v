module decoder_3to8_tb_explicit;
    // Test signals
    reg [2:0] opcode;
    wire [7:0] operation;
    
    // Instantiate the decoder module
    decoder_3to8_structural DUT(
        .opcode(opcode),
        .operation(operation)
    );
    
    // Verification task
    task verify_output;
        input [7:0] expected;
        begin
            if (operation !== expected) begin
                $display("ERROR: For opcode %b, got %b, expected %b", opcode, operation, expected);
            end else begin
                $display("SUCCESS: For opcode %b, output = %b", opcode, operation);
            end
        end
    endtask
    
    // Test procedure
    initial begin
        $display("Starting 3-to-8 Decoder Test (Explicit)");
        
        // Test case 0: opcode = 000
        opcode = 3'b000; #10;
        verify_output(8'b00000001);
        
        // Test case 1: opcode = 001
        opcode = 3'b001; #10;
        verify_output(8'b00000010);
        
        // Test case 2: opcode = 010
        opcode = 3'b010; #10;
        verify_output(8'b00000100);
        
        // Test case 3: opcode = 011
        opcode = 3'b011; #10;
        verify_output(8'b00001000);
        
        // Test case 4: opcode = 100
        opcode = 3'b100; #10;
        verify_output(8'b00010000);
        
        // Test case 5: opcode = 101
        opcode = 3'b101; #10;
        verify_output(8'b00100000);
        
        // Test case 6: opcode = 110
        opcode = 3'b110; #10;
        verify_output(8'b01000000);
        
        // Test case 7: opcode = 111
        opcode = 3'b111; #10;
        verify_output(8'b10000000);
        
        $display("Test completed");
        $finish;
    end
endmodule