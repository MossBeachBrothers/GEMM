// Processing Element Module
module PE #(parameter DATA_WIDTH = 8)(
    input wire clk,
    input wire reset_n, // active low 
    input wire start_compute, //input wire to start compute
    input wire signed [DATA_WIDTH-1:0] A_in,  // corrected bit-width declaration
    input wire signed [DATA_WIDTH-1:0] B_in,  // corrected bit-width declaration
    input wire signed [31:0] C_in, // multiply A and B, add product to accumulated sum C
    output reg signed [31:0] C_out, // result from C_in passed to C_out
    output reg signed [DATA_WIDTH-1:0] A_out,  // corrected syntax
    output reg signed [DATA_WIDTH-1:0] B_out   // corrected syntax
);

    // On the rising edge of the clock, or falling edge of reset signal
    always @(posedge clk or negedge reset_n) begin 
        if (!reset_n) begin
            // if reset (active low), set all outputs to zero
            C_out <= 32'd0; 
            A_out <= 0;
            B_out <= 0;
        end else if (start_compute) begin //only compute if start_compute
            C_out <= C_in + A_in * B_in; // multiply input A and B, add to C
            A_out <= A_in;
            B_out <= B_in;
            // Debugging output
            $display("PE Debug: A_in=%d, B_in=%d, C_in=%d, C_out=%d", A_in, B_in, C_in, C_out);
        end  
    end 

endmodule
