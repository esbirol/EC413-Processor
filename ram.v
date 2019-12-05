// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
// EC413 Project: Ram Module

module ram #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
) (
  input  clock,

  // Instruction Port
  input  [ADDR_WIDTH-1:0] i_address, 
  //16 bit //The address of the current instruction.

  output [DATA_WIDTH-1:0] i_read_data, 
  //32 bit //The instruction at the given address.

  // Data Port
  input  wEn, 
  /*A write enable signal for the data side. When this is
  1, d write data should be written to the memory location
  specified by d address.*/

  input  [ADDR_WIDTH-1:0] d_address, 
  //16 bit //The address for load and store operations.

  input  [DATA_WIDTH-1:0] d_write_data, 
  //32 bit //The store data to be written when wEn is high.

  output [DATA_WIDTH-1:0] d_read_data 
  //32 bit //The load data read from the memory
);

localparam RAM_DEPTH = 1 << ADDR_WIDTH; //<< is a binary shift, shifting 1 to the left 16 places (ADDR_WIDTH is initialized to 16).


reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
//combinational logic
assign i_read_data = ram[i_address[ADDR_WIDTH-1:2]];
assign d_read_data = ram[d_address[ADDR_WIDTH-1:2]];

//sequential logic
always @(posedge clock)
begin
    if(wEn)
        ram[d_address[ADDR_WIDTH-1:2]] <= d_write_data;

end


endmodule