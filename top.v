// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
// EC413 Project: Top Level Module

module top #(
  parameter ADDRESS_BITS = 16
) (
  input clock,
  input reset,

  output [31:0] wb_data //written back to the regFile
);

/******************************************************************************/
// Fetch Wires, output fetch
wire [ADDRESS_BITS-1:0] PC;

// Decode Wires, output decode
wire next_PC_select; //TO FETCH
wire [ADDRESS_BITS-1:0] target_PC; //TO FETCH
wire [1:0] op_A_sel; //TO ALU MUX
wire op_B_sel;
wire [31:0] imm32;
wire [5:0] ALU_Control;

// Reg File Wires 
wire [31:0] read_data1; //TO ALU A MUX //read data 1 
wire [31:0] read_data2; //TO ALU B MUX //read data 2
//mem write back wires
wire wb_sel;

//To Reg File (added section, added variables)
wire [4:0] read_sel1; //read select 1
wire [4:0] read_sel2; //read select 2
wire wEn;
wire [4:0] write_sel;
wire mem_wEn;
wire branch_op;

// Execute Wires
wire [ADDRESS_BITS-1:0] JALR_target; // Assigned outside of ALU
wire [31:0] ALU_result;
wire branch;
wire [31:0] JALR_target_long;

//wire for writeback to REG
wire [31:0] reg_WB_data;

// Memory Wires, output RAM-instruction
wire [31:0] instruction;
wire [31:0] d_read_data;

//OP A WIRE (added section, added variables)
wire [31:0] operand_A;
wire [31:0] operand_B;


// Writeback wires
//wire [31:0] WB;
//fade into nothingness

//mux A and B (added section, added variables)
assign operand_A = (op_A_sel === 2'b00) ? read_data1:
                     (op_A_sel === 2'b01) ? PC:
                     (op_A_sel === 2'b10) ? PC+4:
                     read_data1;
assign operand_B = (op_B_sel === 1'b0) ? read_data2:
                     (op_B_sel === 1'b1) ? imm32:
                     imm32;

assign reg_WB_data = (wb_sel === 1'b0) ? ALU_result:
                     (wb_sel === 1'b1) ? d_read_data: //only from a load instruction.
                     ALU_result;
                      
assign wb_data = (wb_sel == 1) ? d_read_data : ALU_result;

assign JALR_target = JALR_target_long[15:0];
assign JALR_target_long = imm32 + read_data1;

fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) fetch_inst (
  .clock(clock),
  .reset(reset),
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),
  .PC(PC)
);


decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) decode_unit (

  .PC(PC),
  .instruction(instruction),

  .JALR_target(JALR_target),
  .branch(branch),

  .next_PC_select(next_PC_select),
  .target_PC(target_PC),

  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .wEn(wEn),

  .branch_op(branch_op),
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  .mem_wEn(mem_wEn),

  .wb_sel(wb_sel)

);


regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), //Write Enable
  .write_data(reg_WB_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


ALU alu_inst(
  .branch_op(branch_op),
  .ALU_Control(ALU_Control),
  .operand_A(operand_A),
  .operand_B(operand_B),
  .ALU_result(ALU_result),
  .branch(branch)
);


ram #(
  .ADDR_WIDTH(ADDRESS_BITS)
) main_memory (
  .clock(clock),

//instruction
  .i_address(PC >> 8),
  .i_read_data(instruction), 

//data
  .wEn(mem_wEn),
  .d_address(ALU_result[15:0]),
  .d_write_data(read_data2), 
  .d_read_data(d_read_data)
);

endmodule