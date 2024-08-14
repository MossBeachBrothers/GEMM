module SRAM #(parameter ADDR_WIDTH = 16, parameter DATA_WIDTH = 8, parameter M = 4, parameter N = 4)(
    input wire clk,
    input wire reset_n,
    input wire write_enable,
    input wire read_enable,
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] data_in [M-1:0][N-1:0], // 2D array input
    output reg [DATA_WIDTH-1:0] data_out [M-1:0][N-1:0] // 2D array output
);

    //SRAM Memory
    reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];

    integer i, j;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset all outputs
            for (i = 0; i < M; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    data_out[i][j] <= 0;
                end
            end
        end else begin
            if (write_enable) begin
                // Flatten before storing
                for (i = 0; i < M; i = i + 1) begin
                    for (j = 0; j < N; j = j + 1) begin
                        memory[address + i * N + j] <= data_in[i][j];
                    end
                end
            end else if (read_enable) begin
                // Reassemble before loading
                for (i = 0; i < M; i = i + 1) begin
                    for (j = 0; j < N; j = j + 1) begin
                        data_out[i][j] <= memory[address + i * N + j];
                    end
                end
            end
        end
    end
endmodule
