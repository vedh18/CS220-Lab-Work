module custom_counter(
    input wire clk,
    input wire reset,
    output reg [2:0] out
);

// 0 → 2 → 5 → 3 → 4 → 0 
parameter S1 = 3'b000;
parameter S2 = 3'b010;
parameter S3 = 3'b101;
parameter S4 = 3'b011;
parameter S5 = 3'b100;

reg [2:0] current_state, next_state;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= S1;
    end else begin  
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state) 
        S1: next_state <= S2;
        S2: next_state <= S3;
        S3: next_state <= S4;
        S4: next_state <= S5;
        S5: next_state <= S1;
        default: next_state <= S1;
    endcase
end
always @(*) begin
    out <= current_state;
end

endmodule

module custom_counter_tb();

reg clk, reset;
wire [2:0] out;

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #20 reset = 0;

    #200;

    $finish;
end

custom_counter dut(clk, reset, out);

initial begin 
    $monitor("%dns\t | %b", $time, out);
end

endmodule
