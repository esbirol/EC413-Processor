// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
// EC413 Project: Decode Module

`timescale 1ns / 1ps


module decode #(
  parameter ADDRESS_BITS = 16
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC,
  input [31:0] instruction,

  // Inputs from Execute/ALU
  input [ADDRESS_BITS-1:0] JALR_target,
  input branch,

  // Outputs to Fetch
  output next_PC_select, //select = 0 then PC+4, select = 1 target_PC
  output [ADDRESS_BITS-1:0] target_PC,

  // Outputs to Reg File
  output [4:0] read_sel1, //read add1 rs1
  output [4:0] read_sel2, //read add2 rs2
  output [4:0] write_sel, //writing address
  output wEn,

  // Outputs to Execute/ALU
  output branch_op, // Tells ALU if this is a branch instruction
  output [31:0] imm32,
  output [1:0] op_A_sel, //00 = read_data_1, 01 = PC, 10 = PC+4
  output op_B_sel,
  output [5:0] ALU_Control,

  // Outputs to Memory
  output mem_wEn, //memory write

  // Outputs to Writeback
  output wb_sel //0 if read from ALU 1 if read from mem

);

localparam [6:0]R_TYPE  = 7'b0110011, //data2, wEn 1
                I_TYPE  = 7'b0010011, //imm32, wEn 1
                STORE   = 7'b0100011, //imm32, memWrite, wEn 0
                LOAD    = 7'b0000011, //imm32, wEn 1
                BRANCH  = 7'b1100011, //data2 wEn 0
                JALR    = 7'b1100111, //imm32, wEn 1
                JAL     = 7'b1101111, //wEn 1
                AUIPC   = 7'b0010111, //wEn 1
                LUI     = 7'b0110111; //wEn 1


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.

wire[6:0]  s_imm_msb;
wire[4:0]  s_imm_lsb;

wire[19:0] u_imm;
wire[11:0] i_imm_orig;
wire[19:0] uj_imm;
wire[11:0] s_imm_orig;
wire[12:0] sb_imm_orig;

wire[31:0] sb_imm_32;
wire[31:0] u_imm_32;
wire[31:0] i_imm_32;
wire[31:0] s_imm_32;
wire[31:0] uj_imm_32;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target;
wire [ADDRESS_BITS-1:0] JAL_target;


// Read registers
assign read_sel2  = instruction[24:20];
//assign read_sel1  = (opcode == LUI) ? 5'b0 : instruction[19:15]; 
//Adding x0 to upper instruction in ALU, in order to writeback the lui_imm_32

assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];

/* our code */

// branch_op
assign branch_op = (opcode == BRANCH);

//I-type
assign i_imm_orig = instruction[31:20];
assign i_imm_32 = {{20{i_imm_orig[11]}},i_imm_orig};


//U-type
assign u_imm = instruction[31:12];
assign u_imm_32 = { {12{u_imm[19]}},u_imm };

//imm for JAL
assign uj_imm_32 = { {11{u_imm[19]}},{u_imm[19]},{u_imm[7:0]},{u_imm[8]},{u_imm[18:9]},1'b0 };

//Branch
assign sb_imm_orig = { instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 }; //shift left 1
assign sb_imm_32 = { {19{sb_imm_orig[11]}}, sb_imm_orig }; 

//S-type
assign s_imm_msb = instruction[31:25];
assign s_imm_lsb = instruction[11:7];
assign s_imm_orig = {s_imm_msb, s_imm_lsb};
assign s_imm_32 = {{20{s_imm_orig[11]}},s_imm_orig};

//initiating PC for the jumps, if there is a jump then nex_PC_select is 1

assign next_PC_select = (branch==1) ? 1'b1:
                        (opcode==JAL) ? 1'b1:
                        (opcode==JALR) ? 1'b1:
                        1'b0;
                        
assign target_PC = (opcode == JALR) ? JALR_target: 
                   (opcode == BRANCH) ? sb_imm_32 + PC :
                    imm32 + (PC+4);
                    
assign wEn = (opcode == R_TYPE)? 1'b1:
             (opcode == I_TYPE)? 1'b1:
             (opcode == LOAD) ? 1'b1:
             (opcode == LUI) ? 1'b1:
             (opcode == AUIPC) ? 1'b1:
             (opcode == JAL) ? 1'b1:
             (opcode == JALR) ? 1'b1:
             (opcode == STORE) ? 1'b0:
             (opcode == BRANCH) ? 1'b0:
             1'b0;
//2 bits          
assign op_A_sel = (opcode == AUIPC) ? 2'b00:
                  (opcode == JAL) ? 2'b10:
                  (opcode == JALR) ? 2'b10:
                  (opcode == R_TYPE) ? 2'b10:
                  (opcode == I_TYPE) ? 2'b10:
                  (opcode == LOAD) ? 2'b10:
                  (opcode == STORE) ? 2'b10:
                  (opcode == BRANCH) ? 2'b10:
                  (opcode == LUI) ? 2'b10:
                  2'b00;

//1 bit
assign op_B_sel = (opcode == JALR) ? 1'b1:
                  (opcode == JAL) ? 1'b1:
                  (opcode == I_TYPE) ? 1'b1:
                  (opcode == BRANCH) ? 1'b1:
                  (opcode == STORE) ? 1'b1:
                  (opcode == LOAD) ? 1'b1:
                  (opcode == AUIPC) ? 1'b1:
                  (opcode == LUI) ? 1'b1:
                  1'b0;

//the memory enable only 1 when it is storing                         
assign mem_wEn = (opcode === STORE) ? 1'b1: 
                  1'b0;          
                    
//the write back select is 1 onlu when load is being used                  
assign wb_sel = (opcode == LOAD) ? 1'b1:
                1'b0;
                
assign imm32 = (opcode == I_TYPE) ? i_imm_32:
               (opcode === STORE) ? s_imm_32:
               (opcode === LOAD) ?  i_imm_32:
               (opcode === JAL) ? uj_imm_32:
               (opcode === JALR) ? i_imm_32:
               (opcode === LUI) ? u_imm_32:
               (opcode === AUIPC) ? u_imm_32:
               (opcode == BRANCH) ? sb_imm_32:
                32'b0;
                           
assign ALU_Control = (opcode === R_TYPE & funct3 === 3'b000 & funct7 === 7'b0100000) ? 6'b001000: //SUB
                     (opcode === R_TYPE & funct3 === 3'b000 & funct7 === 7'b0000000) ? 6'b000000: //ADD
                     (opcode === R_TYPE & funct3 === 3'b111) ? 6'b000111:  //AND
                     (opcode === R_TYPE & funct3 === 3'b110) ? 6'b000110: //OR
                     (opcode === R_TYPE & funct3 === 3'b101) ? 6'b000101: //SRL
                     (opcode === R_TYPE & funct3 === 3'b100) ? 6'b000100: //XOR
                     (opcode === R_TYPE & funct3 === 3'b011) ? 6'b000010: //SLTU
                     (opcode === R_TYPE & funct3 === 3'b010) ? 6'b000010: // SLT
                     (opcode === I_TYPE & funct3 === 3'b000) ? 6'b000000: //ADDI
                     (opcode === I_TYPE & funct3 === 3'b111) ? 6'b000111: //ANDI
                     (opcode === I_TYPE & funct3 === 3'b110) ? 6'b000110: //ORI
                     (opcode === I_TYPE & funct3 === 3'b101) ? 6'b000101: // SRLI
                     (opcode === I_TYPE & funct3 === 3'b100) ? 6'b000100: //XORI
                     (opcode === I_TYPE & funct3 === 3'b011) ? 6'b000010: //SLTIU
                     (opcode === I_TYPE & funct3 === 3'b010) ? 6'b000010: //SLTI
                     (opcode === BRANCH & funct3 === 3'b000) ? 6'b010000: //BEQ
                     (opcode === BRANCH & funct3 === 3'b001) ? 6'b010001: //BNE
                     (opcode === BRANCH & funct3 === 3'b100) ? 6'b010100: //BLT
                     (opcode === BRANCH & funct3 === 3'b101) ? 6'b010101: //BGE
                     (opcode === BRANCH & funct3 === 3'b110) ? 6'b010110: //BLTU
                     (opcode === BRANCH & funct3 === 3'b111) ? 6'b010111: //BGEU
                     opcode === LOAD ? 6'b000000: //load is just an add
                     opcode === STORE ? 6'b000000: //store is just an add
                     opcode === LUI ? 6'b000000:   //Load upper imm is just an add
                     opcode === AUIPC ? 6'b000000: //AUIPC is just an add
                     opcode === JALR ? 6'b111111:  //pass data A through
                     opcode === JAL ? 6'b011111:   //pass data A through
                     6'b000000;           
           
endmodule