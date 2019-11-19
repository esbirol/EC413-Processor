// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
//EC413 Project: Register File

`timescale 1ns / 1ps

module regFile(

  input clock,
  input reset,
  input wEn, //Write Enable
  input [31:0] write_data,
  input [4:0] read_sel1,
  input [4:0] read_sel2,
  input [4:0] write_sel,
  output [31:0] read_data1,
  output [31:0] read_data2
  
);

reg [31:0] reg_file[0:31];

integer i; 

always @(posedge clock)
  if (reset == 1) begin
    for (i=0; i<32; i=i+1) begin
        reg_file[i] = 32'b0;
    end
  end else
    if (wEn & write_sel != 0) reg_file[write_sel] <= write_data;
    
assign read_data1 = reg_file[read_sel1];
assign read_data2 = reg_file[read_sel2];

endmodule