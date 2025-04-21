module subtractor_32bit(
    input [31:0] A,      // 32-bit minuend
    input [31:0] B,      // 32-bit subtrahend
    output [31:0] Diff,  // 32-bit difference
    output Bout          // Final borrow out (indicates underflow)
);
    // Internal wires for connecting the borrow outputs to the next borrow inputs
    wire [32:0] borrows;  // One extra for the initial borrow-in
    
    // Initialize the first borrow-in to 0
    assign borrows[0] = 1'b0;
    
    // Generate 32 full subtractors, one for each bit position
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_subtractors
            full_subtractor fs(
                .A(A[i]),
                .B(B[i]),
                .Bin(borrows[i]),
                .D(Diff[i]),
                .Bout(borrows[i+1])
            );
        end
    endgenerate
    
    // Assign the final borrow out (useful for detecting underflow)
    assign Bout = borrows[32];
    
endmodule