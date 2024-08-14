// Top module for GEMM
module GEMM #(parameter M = 4, K = 4, N = 4, ADDR_WIDTH = 16)(
    input wire clk,
    input wire reset_n,
    input wire in_valid,
    input wire [7:0] M_dimension, K_dimension, N_dimension, 
    output wire busy
);

    // Signals to control SRAMs and Systolic Array
    wire write_enable_A, write_enable_B, write_enable_C;
    wire read_enable_A, read_enable_B, read_enable_C; 
    wire [ADDR_WIDTH-1:0] address_A, address_B, address_C;
    wire [7:0] data_in_A, data_in_B;
    wire [31:0] data_in_C;
    wire [7:0] data_out_A, data_out_B;
    wire [31:0] data_out_C;
    wire start_compute;
    
    SRAM #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(8), .M(M), .N(K)) BUFFER_A (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(write_enable_A),
        .read_enable(read_enable_A),
        .address(address_A),
        .data_in(A_matrix),    // 2D array input for Buffer A
        .data_out(A_matrix)    // 2D array output from Buffer A
    );

    SRAM #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(8), .M(K), .N(N)) BUFFER_B (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(write_enable_B),
        .read_enable(read_enable_B),
        .address(address_B),
        .data_in(B_matrix),    // 2D array input for Buffer B
        .data_out(B_matrix)    // 2D array output from Buffer B
    );

    SRAM #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(32), .M(M), .N(N)) BUFFER_C (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(write_enable_C),
        .read_enable(read_enable_C),
        .address(address_C),
        .data_in(C_matrix),    // 2D array input for Buffer C
        .data_out(C_matrix)    // 2D array output from Buffer C
    );

    // Instantiate GEMMController
    GEMMController #(
        .M(M),
        .K(K),
        .N(N),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) controller (
        .clk(clk),
        .reset_n(reset_n),
        .in_valid(in_valid),
        .M_dimension(M_dimension),
        .K_dimension(K_dimension),
        .N_dimension(N_dimension),
        .busy(busy),
        .write_enable_A(write_enable_A),
        .write_enable_B(write_enable_B),
        .write_enable_C(write_enable_C),
        .read_enable_A(read_enable_A),
        .read_enable_B(read_enable_B),
        .read_enable_C(read_enable_C),
        .address_A(address_A),
        .address_B(address_B),
        .address_C(address_C),
        .data_in_A(data_in_A),
        .data_in_B(data_in_B),
        .data_in_C(data_in_C),
        .data_out_A(data_out_A),
        .data_out_B(data_out_B),
        .systolic_out_C(data_out_C), // Connect the Systolic Array output to the controller
        .start_compute(start_compute)
    );

    // Instantiate Systolic Array
    SystolicArray #(
        .M(M), 
        .K(K),
        .N(N),
        .DATA_WIDTH(8)
    ) sa (
        .clk(clk),
        .reset_n(reset_n),
        .start_compute(start_compute),
        .A(data_out_A),  // Ensure that data_out_A is properly sized for the Systolic Array
        .B(data_out_B),  // Ensure that data_out_B is properly sized for the Systolic Array
        .C(data_out_C)   // Correct connection to match the output signal from the Systolic Array
    );

endmodule 
