//Top module for GEMM
module GEMM #(parameter M = 4, K = 4, N=4, ADDR_WIDTH = 16)(
    input wire clk,
    input wire reset_n,
    input wire in_valid,
    input wire [7:0] M_dimmension, K_dimmension, N_dimmension, 
    output wire busy
);


    wire write_enable_A, write_enable_B, write_enable_C;
    wire read_enable_A, read_enable_B, read_enable_C; 
    wire [ADDR_WIDTH-1:0] address_A, address_B, address_C;
    wire [31:0] data_in_A, data_in_B;
    wire [127:0] data_in_C;
    wire [31:0] data_out_A, data_out_B;
    wire [127:0] data_out_C;


    







endmodule 


