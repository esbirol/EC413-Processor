// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
//EC413 Project: Register File Test Bench 

`timescale 1ns / 1ps

module regFile_tb();

reg clock, reset;

reg wEn;
reg [31:0] write_data;
reg [4:0] read_sel1;
reg [4:0] read_sel2;
reg [4:0] write_sel;

wire [31:0] read_data1;
wire [31:0] read_data2;

regFile uut(
  .clock(clock),
  .reset(reset),
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);

always #5 clock= ~clock;

initial begin 
  clock = 1'b1;
  reset = 1'b1;
  wEn = 1'b0;
  write_data = 32'h00000000;
  read_sel1 = 5'd0;
  read_sel2 = 5'd0;
  write_sel = 5'd0;
  
  #20
  
  reset = 1'b0;
  wEn = 1'b1;
  write_sel = 5'd0;
  write_data = 32'hffffffff;
  
  #10
  write_sel = 5'd1;
  #10
  $display("Reg 0; %h", uut.reg_file[0]); 
  $display("Reg 1; %h", uut.reg_file[1]);
  $display("Reg Data 1: %h", read_data1);
  $display("Reg Data 2; %h", read_data2);

  $stop();
end 

endmodule