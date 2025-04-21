module priority_encoder_structural(
    input wire [3:0] in,
    output wire [1:0] out,
    output wire valid
);
    // Declare intermediate wire for negated input
    wire not_in2;
    
    // Valid is high if any input is high
    or or1(valid, in[0], in[1], in[2], in[3]);
    
    // out[1] = in[3] OR in[2]
    or or2(out[1], in[3], in[2]);
    
    // Create NOT in[2]
    not not1(not_in2, in[2]);
    
    // Intermediate result for (NOT in[2] AND in[1])
    wire and_result;
    and and1(and_result, not_in2, in[1]);
    
    // out[0] = in[3] OR (NOT in[2] AND in[1])
    or or3(out[0], in[3], and_result);
endmodule