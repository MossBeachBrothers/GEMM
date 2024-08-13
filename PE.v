//Processing Element Module

module PE #(parameter DATA_WIDTH = 8)(
    input wire clk,
    input wire reset_n, //active low 
    input wire signed [] A_in
    input wire signed [] B_in, 
    input wire signed [31:0] C_in, //multiply a and b, add product to accumulated sum C
    output reg signed [31:0] C_out, //result from C_in passed to C_out
    //inputs Ain, Bin passed directly to outputs Aout, Bout for neighboring PEs
    output reg signed [DATA_WIDTH-1:0] A_out
    output reg signed [DATA_WIDTH-1:0] B_out

); 

    //on up tick of clock, or down tick of reset signal
    always @(posedge clk or negedge reset_n) begin 
        if (!reset_n) begin
            //if reset (active low), set all to zero
            C_out <= 32'd0; 
            A_out <= 0;
            B_out <= 0;
        end else begin 
            C_out <= C_in + A_in * B_in; //multiply input A and B, add to C
            A_out <= A_in;
            B_out <= B_in;
        end  
    end 


endmodule 