//Ece Sureyya Birol
//U58913897
//EC413 Lab 2 Problem 2: Top Module

`timescale 1ns / 1ps

module top (
  input clock,
  input reset,

  input [31:0] instruction,
  input [5:0] ALU_Control,
  input op_B_sel,
  input wEn,

  output [31:0] ALU_result
);


wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;

wire [31:0] imm;

assign read_sel1 = instruction[19:15];
assign read_sel2 = instruction[24:20];
assign write_sel = instruction[11:7];

// Sign extension
assign imm = { {20{instruction[31]}}, instruction[31:20]};

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
wire [31:0] read_data1, read_data2, mux_output;

assign mux_output = op_B_sel ? imm : read_data2;

regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(ALU_result),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


// Fill in port connections
ALU alu_inst(
  .ALU_Control(ALU_Control),
  .operand_A(read_data1),
  .operand_B(mux_output),
  .ALU_result(ALU_result)
);


endmodule
