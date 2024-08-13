// Systolic Array Module for M x N matrix
module SystolicArray #(parameter M = 4, parameter K = 4, parameter N = 4, DATA_WIDTH = 8)(
    input wire clk,
    input wire reset_n,
    input wire signed [DATA_WIDTH-1:0] A [M-1:0][K-1:0], // Matrix A (MxK)
    input wire signed [DATA_WIDTH-1:0] B [K-1:0][N-1:0], // Matrix B (KxN)
    output wire signed [31:0] C [M-1:0][N-1:0] // Matrix C (MxN)
);

    // Wires to propagate matrices across the Systolic array
    wire signed [DATA_WIDTH-1:0] a [M-1:0][K-1:0]; // wire to propagate A across rows
    wire signed [DATA_WIDTH-1:0] b [K-1:0][N-1:0]; // wire to propagate B across columns
    wire signed [31:0] c [M-1:0][N-1:0]; // wires to hold results of MAC operation and pass to next PE, or output matrix 'C'

    genvar i, j; // define iteration variables
    generate
        for (i = 0; i < M; i = i + 1) begin : row
            for (j = 0; j < N; j = j + 1) begin : column
                PE #(.DATA_WIDTH(DATA_WIDTH)) pe (
                    .clk(clk),
                    .reset_n(reset_n),
                    .A_in((j == 0) ? A[i][j] : a[i][j-1]), // if first element in the row, use input A, else use propagated value
                    .B_in((i == 0) ? B[j][i] : b[i-1][j]), // if first element in the column, use input B, else use propagated value
                    .C_in((i == 0 || j == 0) ? 32'd0 : c[i-1][j-1]), // initialize C_in to 0 for the first row or column
                    .C_out(c[i][j]),
                    .A_out(a[i][j]),
                    .B_out(b[i][j])
                );
            end
        end
    endgenerate

endmodule
