// Name:Ece Sureyya Birol, Ece Ari 
// BU ID: U58913897, U14334375
// EC413 Project: Fetch Module

module fetch #(
  parameter ADDRESS_BITS = 16
) (
  input  clock,
  input  reset,
  input  next_PC_select,
  input  [ADDRESS_BITS-1:0] target_PC,
  output [ADDRESS_BITS-1:0] PC
);

reg [ADDRESS_BITS-1:0] PC_reg;

assign PC = PC_reg;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

always @(posedge clock)
begin
    if(reset==1'b1) //eger reset == 1
        PC_reg <= 16'b0; 
 //stack pointerin adresini 16 bit sifirdan baslattik
        
    if(next_PC_select==1'b1) //eger ==1
        PC_reg <= target_PC; 
//branch yapiyor, yeni adrese gidiyor
 //target_PC input 16 is the target address of a branch, JAL or JALR instruction.
   
    else //reset veya next yoksa eger sadece adress 4 bit artiyor
        PC_reg = PC_reg + 4; //branch olmadigi icin stack pointerin adresi 4 bit artiyor
end

endmodule