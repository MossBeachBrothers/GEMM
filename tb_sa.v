module tb_sa;

    parameter M = 4;
    parameter K = 4;
    parameter N = 4;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg reset_n;
    reg signed [DATA_WIDTH-1:0] A [M-1:0][K-1:0];
    reg signed [DATA_WIDTH-1:0] B [K-1:0][N-1:0];
    wire signed [31:0] C [M-1:0][N-1:0];

    // Expected output matrix C
    reg signed [31:0] C_expected [M-1:0][N-1:0];

    // Instantiate the Systolic Array
    SystolicArray #(M, K, N, DATA_WIDTH) uut (
        .clk(clk),
        .reset_n(reset_n),
        .A(A),
        .B(B),
        .C(C)
    );

    integer i, j; // Loop variables
    integer pass = 1; // Declaration and initialization of pass variable

    // Clock generation
    always #5 clk = ~clk;

    // Test initialization
    initial begin
        clk = 0;
        reset_n = 0;

        // Initialize matrices A and B with test data
        // A[0][0] = 1; A[0][1] = 2; A[0][2] = 3; A[0][3] = 4;
        // A[1][0] = 5; A[1][1] = 6; A[1][2] = 7; A[1][3] = 8;
        // A[2][0] = 9; A[2][1] = 10; A[2][2] = 11; A[2][3] = 12;
        // A[3][0] = 13; A[3][1] = 14; A[3][2] = 15; A[3][3] = 16;

        // B[0][0] = 1; B[0][1] = 2; B[0][2] = 3; B[0][3] = 4;
        // B[1][0] = 5; B[1][1] = 6; B[1][2] = 7; B[1][3] = 8;
        // B[2][0] = 9; B[2][1] = 10; B[2][2] = 11; B[2][3] = 12;
        // B[3][0] = 13; B[3][1] = 14; B[3][2] = 15; B[3][3] = 16;

        // // Calculate expected output matrix C
        // C_expected[0][0] = 1*1 + 2*5 + 3*9 + 4*13;
        // C_expected[0][1] = 1*2 + 2*6 + 3*10 + 4*14;
        // C_expected[0][2] = 1*3 + 2*7 + 3*11 + 4*15;
        // C_expected[0][3] = 1*4 + 2*8 + 3*12 + 4*16;

        // C_expected[1][0] = 5*1 + 6*5 + 7*9 + 8*13;
        // C_expected[1][1] = 5*2 + 6*6 + 7*10 + 8*14;
        // C_expected[1][2] = 5*3 + 6*7 + 7*11 + 8*15;
        // C_expected[1][3] = 5*4 + 6*8 + 7*12 + 8*16;

        // C_expected[2][0] = 9*1 + 10*5 + 11*9 + 12*13;
        // C_expected[2][1] = 9*2 + 10*6 + 11*10 + 12*14;
        // C_expected[2][2] = 9*3 + 10*7 + 11*11 + 12*15;
        // C_expected[2][3] = 9*4 + 10*8 + 11*12 + 12*16;

        // C_expected[3][0] = 13*1 + 14*5 + 15*9 + 16*13;
        // C_expected[3][1] = 13*2 + 14*6 + 15*10 + 16*14;
        // C_expected[3][2] = 13*3 + 14*7 + 15*11 + 16*15;
        // C_expected[3][3] = 13*4 + 14*8 + 15*12 + 16*16;


        // Matrices A/B with new Data
        A[0][0] = 1;  A[0][1] = 0;  A[0][2] = -2; A[0][3] = 3;
        A[1][0] = 4;  A[1][1] = -1; A[1][2] = 5;  A[1][3] = 6;
        A[2][0] = 7;  A[2][1] = 2;  A[2][2] = -3; A[2][3] = 8;
        A[3][0] = -9; A[3][1] = 4;  A[3][2] = 0;  A[3][3] = -7;

        B[0][0] = 2;  B[0][1] = -3; B[0][2] = 1;  B[0][3] = 4;
        B[1][0] = 5;  B[1][1] = 6;  B[1][2] = -2; B[1][3] = -1;
        B[2][0] = -3; B[2][1] = 7;  B[2][2] = 8;  B[2][3] = 0;
        B[3][0] = 0;  B[3][1] = 2;  B[3][2] = -5; B[3][3] = 9;

        // Calculate expected Matrix C
        C_expected[0][0] = 8;   C_expected[0][1] = -11; C_expected[0][2] = -30; C_expected[0][3] = 31;
        C_expected[1][0] = -12; C_expected[1][1] = 29;  C_expected[1][2] = 16;  C_expected[1][3] = 71;
        C_expected[2][0] = 33;  C_expected[2][1] = -14; C_expected[2][2] = -61; C_expected[2][3] = 98;
        C_expected[3][0] = 2;   C_expected[3][1] = 37;  C_expected[3][2] = 18;  C_expected[3][3] = -103;


        // Release reset
        #10 reset_n = 1;

        // Wait for the computation to complete
        #100;

        // Compare the output matrix C with the expected values
        $display("Output Matrix C and Verification:");
        for (i = 0; i < M; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                $display("C[%0d][%0d] = %d (Expected: %d)", i, j, C[i][j], C_expected[i][j]);
                if (C[i][j] != C_expected[i][j]) begin
                    $display("Mismatch at C[%0d][%0d]: Expected %d, Got %d", i, j, C_expected[i][j], C[i][j]);
                    pass = 0;
                end
            end
        end

        // Display final result
        if (pass)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        // End simulation
        $finish;
    end

endmodule
