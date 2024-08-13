//Systolic Array Module for M x N matrix
module SystolicArray #(parameter M = 4, paramter K = 4, parameter N = 4, DATA_WIDTH=8)(
    input wire clk,
    input wire reset_n,
    input wire signed [DATA_WIDTH-1:0] A [M-1:0][K-1:0], //Matrix A
    input wire signed [DATA_WIDTH-1:0] B [K-1:0][N-1:0], //Matrix B
    output wire signed [31:0] C [M-1:0][N-1:0];
); 




endmodule 