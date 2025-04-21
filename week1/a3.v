module decoder_3to8_structural(
    input [2:0] opcode,      // 3-bit input
    output [7:0] operation   // 8-bit output (one-hot encoding)
);
    // Internal wires for the inverted inputs
    wire not_opcode0, not_opcode1, not_opcode2;
    
    // Create inverted versions of each input bit
    not not0(not_opcode0, opcode[0]);
    not not1(not_opcode1, opcode[1]);
    not not2(not_opcode2, opcode[2]);
    
    // Each output is an AND of specific combinations of input bits or their inversions
    // operation[0] = ~opcode[2] & ~opcode[1] & ~opcode[0]  (000)
    and and0(operation[0], not_opcode2, not_opcode1, not_opcode0);
    
    // operation[1] = ~opcode[2] & ~opcode[1] & opcode[0]   (001)
    and and1(operation[1], not_opcode2, not_opcode1, opcode[0]);
    
    // operation[2] = ~opcode[2] & opcode[1] & ~opcode[0]   (010)
    and and2(operation[2], not_opcode2, opcode[1], not_opcode0);
    
    // operation[3] = ~opcode[2] & opcode[1] & opcode[0]    (011)
    and and3(operation[3], not_opcode2, opcode[1], opcode[0]);
    
    // operation[4] = opcode[2] & ~opcode[1] & ~opcode[0]   (100)
    and and4(operation[4], opcode[2], not_opcode1, not_opcode0);
    
    // operation[5] = opcode[2] & ~opcode[1] & opcode[0]    (101)
    and and5(operation[5], opcode[2], not_opcode1, opcode[0]);
    
    // operation[6] = opcode[2] & opcode[1] & ~opcode[0]    (110)
    and and6(operation[6], opcode[2], opcode[1], not_opcode0);
    
    // operation[7] = opcode[2] & opcode[1] & opcode[0]     (111)
    and and7(operation[7], opcode[2], opcode[1], opcode[0]);
    
endmodule