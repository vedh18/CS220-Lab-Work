`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2025 20:16:02
// Design Name: 
// Module Name: test_modular_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_modular_adder(

    );
parameter W=255;
reg [W-1:0] a,b;
reg clk,rst;
wire [W-1:0] out;
reg [W-1:0] p;

initial begin 
    clk=1'b0;
    forever begin
    #10 clk = ~clk;
    end end


//carry_chain_sum_new_for_256 adder(mode,a,b,sum,c_out);

simple_modular_adder adder(a,b,p,clk,rst,out,done);

//carry64lookup lookahead(a,b,c_in,sum,c_out1,g,p);

initial begin
    //c_in=1'b1;
    rst=1'b1; 
//    a=64'd18446744073709551606;
//    b=64'd18446744073709551604;
    a=255'h3fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec;
    b=255'h3fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec;
    p=255'h7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed;
    #100 rst=1'b0;
    // mod output: 6322e973ec7ee058b8cc396fde97386591f02e41fb01fcc99663861135d0c41c
end
endmodule
