//Ece Sureyya Birol
//U58913897
//EC413 Lab 2 Problem 2: ALU

`timescale 1ns / 1ps

module ALU(
    input [5:0] ALU_Control,
    input [31:0] operand_A,
    input [31:0] operand_B,
    output [31:0] ALU_result
);

wire signed [31:0] s_opA, s_opB, s_ALU_res;

assign s_opA = operand_A;
assign s_opB = operand_B;

assign s_ALU_res = s_opA < s_opB;

assign ALU_result = ALU_Control == 6'b000000 ? operand_A + operand_B :
                    ALU_Control == 6'b001000 ? operand_A - operand_B :
                    ALU_Control == 6'b000010 ? s_ALU_res :
                    ALU_Control == 6'b000100 ? operand_A ^ operand_B :
                    ALU_Control == 6'b000111 ? operand_A & operand_B :
                    0;

endmodule
