//Ece Sureyya Birol
//U58913897
//EC413 Lab 2 Problem 2: ALU

`timescale 1ns / 1ps

module ALU(
    input [5:0] ALU_Control,
    input [31:0] operand_A,
    input [31:0] operand_B,
    input [31:0] immediate,
    output [31:0] ALU_result
);

wire signed [31:0] s_opA, s_opB, s_ALU_res, s_immediate, s_ALU_res_im;
//reg [31:0] us_opA, us_opB, us_ALU_res;


assign s_opA = operand_A;
assign s_opB = operand_B;
assign s_immediate = immediate; //setting immediate
assign s_ALU_res = s_opA < s_opB; //SLT
assign s_ALU_res_im = s_opA < s_immediate; //SLTI

/*always @* begin
if(operand_A[31]==1'b1 || operand_B[31]==1'b1)
    begin 
        assign us_opA = -operand_A;
        assign us_opB = -operand_B;
        
        assign us_ALU_res = us_opA < us_opB;
    end
end*/
assign ALU_result = ALU_Control == 6'b000000 ? operand_A + operand_B : //ADD
                    ALU_Control == 6'b001000 ? operand_A - operand_B : //SUB
                    ALU_Control == 6'b000010 ? s_ALU_res : //SLT smaller than signed
                    
                    //ALU_Control == 6'b000010 ? s_ALU_res : //SLTU smaller than unsigned

                    ALU_Control == 6'b000100 ? operand_A ^ operand_B : //xor
                    ALU_Control == 6'b000111 ? operand_A & operand_B : //and
                    
                    ALU_Control == 6'b000011 ? s_ALU_res : //SLTI smaller than immediate 
                    
                    0;

endmodule
