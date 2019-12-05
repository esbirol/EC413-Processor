// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
//EC413 Project: ALU Testbench

//`timescale 1ns / 1ps

module ALU_tb();
reg branch_op;
reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;
wire branch;

ALU dut (
  .branch_op(branch_op),
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result),
  .branch(branch)
);

initial begin

  branch_op = 1'b0;
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;
    #10
    $display("Alu res 4 + 5: %d", result);
    #10
    ctrl = 6'b000010;
    #10
    $display("ALU Result 4 < 5: %d",result);
    #10
    opB = 32'hffffffff;
    #10
    $display("ALU Result 4 < -1: %d",result);
    
    branch_op = 1'b1;
    opB = 32'hffffffff;
    opA = 32'hffffffff;
    ctrl = 6'b010_000; // BEQ
    #10
    
    $display("ALU Result (BEQ): %d",result);
    $display("Branch (should be 1): %b", branch);
    
    /**************************
    *                      Add Test Cases Here
    **************************/
  #10
  
  
  
  //SLLI
  ctrl = 6'b000001;
  opA = 2;
  opB = 6; //shift amount
  #10
  $display("Logical shift 2 << 6 = %d",result);
  
  //ADD
  opA = 32'd4;
  opB = 32'hffffffff;
  ctrl = 6'b000000;
  #10
  $display("ALU Result 4 + -1: %d", result);
  #10
  
  //JALR
  ctrl = 6'b111111; 
  opA = 2;
  opB = -50;
  #10
  $display("JALR ALU Result = %d", result);
  
  //XOR
  ctrl = 6'b000100;
  opA = 32'b101;
  opB = 32'b010;
  #10
  $display("xor(0x101,0x010) = %d",result);
  
  //SUB
  ctrl = 6'b001000;
  opA = 74;
  opB = -69;
  #10
  $display("ALU Result 74 - (-69) %d", result);
  
  //BGE
  ctrl = 6'b010101;
  branch_op = 1;
  opA = -17;
  opB = 10;
  #10
  $display("(bge -17,10) -> branch = %d", branch); //should be 0
  branch_op = 0;
  
  //AND
  ctrl = 6'b000111;
  opA = 32'hffffffff;
  opB = 32'd4;
  #10
  $display("and(1,-1) = %d",result);
  
  
  //bne 
  ctrl = 6'b010001;
  branch_op = 1;
  opA = 7;
  opB = 9;
  #10
  $display("(BNE 7,9) -> branch = %d",branch);
  branch_op = 0;
  
  //slt 31 < 69
  ctrl = 6'b000011;
  opA = 31;
  opB = 69;
  #10
  $display("ALU Result 31 < 69: %d",result);
  
  $stop();
    
end
      
endmodule
