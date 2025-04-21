module gray_code_counter (clk,reset,gray, z);
    input wire clk;
    input wire reset;
    output reg [2:0] gray;
    output reg z;
    
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;
    parameter S5 = 3'b111;
    parameter S6 = 3'b101;
    parameter S7 = 3'b100;

    reg [2:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0; 
        end else begin
            current_state <= next_state; 
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin if (reset) next_state = S0; else next_state = S1; end
            S1: begin if (reset) next_state = S0; else next_state = S2; end
            S2: begin if (reset) next_state = S0; else next_state = S3; end
            S3: begin if (reset) next_state = S0; else next_state = S4; end
            S4: begin if (reset) next_state = S0; else next_state = S5; end
            S5: begin if (reset) next_state = S0; else next_state = S6; end
            S6: begin if (reset) next_state = S0; else next_state = S7; end
            S7: next_state = S0;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        gray = current_state;  
        z = (gray == 3'b100); 
    end

endmodule


module gray_code_counter_tb;
    reg clk;           
    reg reset;         
    wire [2:0] gray;   
    wire z;          

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        #10 reset = 0;

        #100 $finish;
    end

    initial begin
       $monitor("Time: %0dns\t| Counter: %b\t| z: %b\t| Reset: %b", $time, gray, z, reset);

    end
    
    gray_code_counter dut (clk, reset, gray, z);

endmodule