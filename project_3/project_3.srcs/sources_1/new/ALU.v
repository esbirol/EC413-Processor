// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
//EC413 Project: ALU

`timescale 1ns / 1ps

module ALU(

    input branch_op,
    input [5:0] ALU_Control,
    input [31:0] operand_A,
    input [31:0] operand_B,
    output [31:0] ALU_result,
    output branch
);

 

wire signed [31:0] s_opA, s_opB;
       

assign ALU_result = ALU_Control == 6'b011111 ? operand_A: // JAL
                    ALU_Control == 6'b111111 ? operand_A: // JALR
                    ALU_Control == 6'b000001 ? operand_A << operand_B: //SLL
                    ALU_Control == 6'b000010 ? ($signed(operand_A)) < ($signed(operand_B))  : //SLT smaller than signed
                    //ALU_Control == 6'b000011 ? ($signed(operand_A)) < ($signed(operand_B))  : //SLTIU, SLTU smaller than immediate
                    ALU_Control == 6'b000011 ? operand_A < operand_B: //SLTIU, SLTU
                    ALU_Control == 6'b000100 ? operand_A ^ operand_B : //XOR
                    ALU_Control == 6'b000101 ? operand_A >> operand_B://SRL
                    ALU_Control == 6'b000110 ? operand_A | operand_B : //OR
                    ALU_Control == 6'b000111 ? operand_A & operand_B : //AND
                    ALU_Control == 6'b001000 ? operand_A - operand_B : //SUB
                    ALU_Control == 6'b000000 ? operand_A + operand_B : //ADD, LUI, SW, ADDI, AUIPC
                    ALU_Control == 6'b010000 ? operand_A == operand_B : //BEQ
                    ALU_Control == 6'b010001 ? operand_A != operand_B : //BNE
                    ALU_Control == 6'b010100 ? ($signed(operand_A)) < ($signed(operand_B)) : //BLT
                    ALU_Control == 6'b010110 ? operand_A < operand_B : //BLTU
                    ALU_Control == 6'b010101 ? ($signed(operand_A)) >= ($signed(operand_B)) : //BGE
                    ALU_Control == 6'b010111 ? operand_A >= operand_B: // BGEU
                    ALU_Control == 6'b001101 ? operand_A >>> operand_B://SRA
                    0;
                    
assign branch = (branch_op == 1 && (ALU_Control == 6'b010100)) ? ($signed(operand_A)) < ($signed(operand_B))  : //BLT
                (branch_op == 1 && (ALU_Control == 6'b010000)) ? operand_A !=operand_B:// BNE
                (branch_op == 1 && (ALU_Control == 6'b010000)) ? operand_A == operand_B : //BEQ
                (branch_op == 1 && (ALU_Control == 6'b010101)) ? ($signed(operand_A)) >= ($signed(operand_B))  : //BGE
                (branch_op == 1 && (ALU_Control == 6'b010110)) ? operand_A < operand_B : //BLTU
                (branch_op == 1 && (ALU_Control == 6'b010111)) ? operand_A >= operand_B: // BGEU
                 0;
endmodule