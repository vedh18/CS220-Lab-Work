module full_subtractor(
    input A, B, Bin,     // A: Minuend, B: Subtrahend, Bin: Borrow in
    output D, Bout       // D: Difference, Bout: Borrow out
);
    // Internal wires for connections between gates
    wire not_A;          // NOT of input A
    wire xor_AB;         // A XOR B
    wire and_notA_B;     // (NOT A) AND B
    wire and_notA_Bin;   // (NOT A) AND Bin
    wire and_B_Bin;      // B AND Bin
    wire or_temp;        // Intermediate OR result
    
    // Gate instantiations in structural style
    not not1(not_A, A);                    // not_A = NOT A
    
    // Difference calculation: D = A XOR B XOR Bin
    xor xor1(xor_AB, A, B);                // xor_AB = A XOR B
    xor xor2(D, xor_AB, Bin);              // D = (A XOR B) XOR Bin
    
    // Borrow out calculation: Bout = (NOT A AND B) OR (NOT A AND Bin) OR (B AND Bin)
    and and1(and_notA_B, not_A, B);        // and_notA_B = NOT A AND B
    and and2(and_notA_Bin, not_A, Bin);    // and_notA_Bin = NOT A AND Bin
    and and3(and_B_Bin, B, Bin);           // and_B_Bin = B AND Bin
    
    or or1(or_temp, and_notA_B, and_notA_Bin);  // or_temp = (NOT A AND B) OR (NOT A AND Bin)
    or or2(Bout, or_temp, and_B_Bin);           // Bout = or_temp OR (B AND Bin)
endmodule