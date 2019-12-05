// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
// EC413 Project: Ram Test Bench

module ram_tb();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;

reg  clock;

// Instruction Port
reg  [ADDR_WIDTH-1:0] i_address;
wire [DATA_WIDTH-1:0] i_read_data;

// Data Port
reg  wEn;
reg  [ADDR_WIDTH-1:0] d_address;
reg  [DATA_WIDTH-1:0] d_write_data;
wire [DATA_WIDTH-1:0] d_read_data;


ram #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH)
) uut (
  .clock(clock),

  // Instruction Port
  .i_address(i_address),
  .i_read_data(i_read_data),

  // Data Port
  .wEn(wEn),
  .d_address(d_address),
  .d_write_data(d_write_data),
  .d_read_data(d_read_data)

);

always #5 clock = ~clock;


initial begin
  clock = 1'b1;
  d_address = 16'd0;
  d_write_data = 16'd0;
  wEn = 1'b0;

  #10
  wEn = 1'b1;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  d_write_data = 1;
  d_address = 4;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  d_write_data = 2;
  d_address = 8;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);


  /***************************
  * Add more test cases here *
  ***************************/
  #10
  d_write_data = 4;
  d_address = 5;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  
  wEn = 1'b0;
  #10
  d_write_data = 4;
  d_address = 5;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  
  wEn = 1'b1;
  #10
  d_write_data = 25;
  d_address = 68;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  
  #10
  d_write_data = 4;
  d_address = 5;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  
  #10
  d_address = 6;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  #10 
  d_write_data = 9;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);


  #10 
  i_address = 8;
  $display("Data Address %d: %h", i_address, i_read_data);

  #10 
  i_address = 14;
  $display("Data Address %d: %h", i_address, i_read_data);
  
  #10 
  i_address = 3;
  $display("Data Address %d: %h", i_address, i_read_data);
  
  #100
  $stop();

end

endmodule