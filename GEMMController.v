// GEMM Controller Module

module GEMMController #(parameter M = 4, K = 4, N = 4, ADDR_WIDTH = 16)(
  input wire clk,
  input wire reset_n,
  input wire in_valid,
  input wire [7:0] M_dimmension, K_dimmension, N_dimmension, // Dimensions of Matrices
  output reg busy,
  output reg write_enable_A, write_enable_B, write_enable_C, // Write enable signals
  output reg read_enable_A, read_enable_B, read_enable_C, // Read enable signals
  output reg [ADDR_WIDTH-1:0] address_A, address_B, address_C, // Write addresses
  output reg [31:0] data_in_A, data_in_B, // Inputs for A, B
  output reg [127:0] data_in_C, // Data input for C
  input wire [31:0] data_out_A, data_out_B, // Data outputs from SRAM
  input wire [127:0] systolic_out_C, // Output from Systolic Array to be written to C
  output reg start_compute // Signal to start computation in Systolic Array
);

// Current State, Next State
reg [2:0] state, next_state;
reg [15:0] cycle_count; // Count cycles

// State machine with different states
localparam IDLE = 3'b000,
           LOAD_A = 3'b001,
           LOAD_B = 3'b010,
           COMPUTE = 3'b011,
           STORE_C = 3'b100,
           DONE = 3'b101;

// Next State Logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        busy <= 0;
        cycle_count <= 0;
    end else begin 
        state <= next_state;
        if (state != IDLE) begin 
            cycle_count <= cycle_count + 1;
        end 
    end  
end 

// FSM Logic
always @(*) begin 
    // Default values
    next_state = state;
    write_enable_A = 0; read_enable_A = 0;
    write_enable_B = 0; read_enable_B = 0;
    write_enable_C = 0; read_enable_C = 0;
    busy = 1;
    data_in_A = 32'd0;
    data_in_B = 32'd0;
    data_in_C = 128'd0;
    start_compute = 0;

    case (state)
        IDLE: begin 
            busy = 0;
            if (in_valid) begin
                next_state = LOAD_A;
                address_A = 0;
                address_B = 0;
                address_C = 0;
                cycle_count = 0;
            end 
        end

        LOAD_A: begin
            read_enable_A = 1; // Enable reading from A SRAM
            address_A = cycle_count; 
            if (cycle_count == M_dimmension * K_dimmension - 1) begin
                next_state = LOAD_B;
                cycle_count = 0;
            end 
        end

        LOAD_B: begin
            read_enable_B = 1; // Enable reading from B SRAM
            address_B = cycle_count; 
            if (cycle_count == K_dimmension * N_dimmension - 1) begin
                next_state = COMPUTE;
                cycle_count = 0;
            end 
        end

        COMPUTE: begin
            start_compute = 1; // Start computation in the Systolic Array
            if (cycle_count == M_dimmension * N_dimmension - 1) begin
                next_state = STORE_C;
                cycle_count = 0;
            end 
        end  

        STORE_C: begin
            write_enable_C = 1; // Enable writing to C SRAM
            address_C = cycle_count;
            data_in_C = systolic_out_C; // Connect Systolic Array output to SRAM C 
            if (cycle_count == M_dimmension * N_dimmension - 1) begin 
                next_state = DONE;
                cycle_count = 0;
            end 
        end 

        DONE: begin
            busy = 0;
            next_state = IDLE; // Return to IDLE 
        end 
    endcase 
end 

endmodule
