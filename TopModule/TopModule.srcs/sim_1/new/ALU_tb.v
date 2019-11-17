//Ece Sureyya Birol
//U58913897
//EC413 Lab 2 Problem 2: ALU Testbench

`timescale 1ns / 1ps

module ALU_tb();

reg [5:0] ctrl;
reg [31:0] opA, opB;

wire[31:0] result;

ALU dut(
    .ALU_Control(ctrl),
    .operand_A(opA),
    .operand_B(opB),
    .ALU_result(result)
);

initial begin

    ctrl = 6'b000000;
    opA = 4;
    opB = 5;

    #10

    $display("Alu res 4 + 5: %d", result);

    #10

    ctrl = 6'b000010;

    #10
        
    $display("Alu res 4 < 5: %d", result);
    
    #10
    
    ctrl = 6'b001000;

    #10
    
    $display("Alu res 4 - 5: %d", $signed(result));

    #10
    ctrl = 6'b000010;
    opB = 32'hffffffff;

    #10

    $display("Alu res 4 < -1: %d", result);
    
    /*#10 //SLTU
    ctrl = 6'b000011;
    opB = 32'hfffffffc;
    opA = 32'hffffffff;
    #10
    $display ("Alu res -4 < -1: %d", result);
    #10
    
    ctrl =*/
    

end

endmodule