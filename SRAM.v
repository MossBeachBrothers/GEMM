module SRAM #(parameter ADDR_WIDTH = 16, DATA_WIDTH =32)(
  input wire clk,
  input wire reset_n,
  input wire write_enable,
  input wire read_enable,
  input wire [ADDR_WIDTH-1:0] address,
  input wire [DATA_WIDTH-1:0] data_in, 
  output reg [DATA_WIDTH-1:0] data_out
);


  reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        data_out <= 0;
    else if (write_enable)
        memory[address] <= data_in;
    else if (read_enable)
        data_out <= memory[address]
   end 

endmodule 

