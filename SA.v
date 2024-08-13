//Systolic Array Module for M x N matrix
module SystolicArray #(parameter M = 4, paramter K = 4, parameter N = 4, DATA_WIDTH=8)(
    input wire clk,
    input wire reset_n,
    input wire signed [DATA_WIDTH-1:0] A [M-1:0][K-1:0], //Matrix A (MxK)
    input wire signed [DATA_WIDTH-1:0] B [K-1:0][N-1:0], //Matrix B (KxN)
    output wire signed [31:0] C [M-1:0][N-1:0]; // Matrix C (MxN)
); 


//Wires to propogate matrices across Systolic array

wire signed [DATA_WIDTH-1:0] a [M-1:0][K-1:0]; //wire to propogate A across rows
wire signed [DATA_WIDTH-1:0] b [K-1:0][N-1:0]; //wire to propogate B across columns
wire signed [31:0] c [M-1:0][N-1:0]; //wires to hold results of MAC operation and pass to next PE, or output matrix 'C'

genvar i,j; //define iteration variables
generate;
    //for all rows
    for (i=0; i < M; i = i + 1) begin : row
        //for all columns of row
        for (j=0; j < N; j = j+1) begin : column
            if (j < K) begin
                PE #() pe (

                );
             end 0
        end
    end
endgenerate

endmodule 