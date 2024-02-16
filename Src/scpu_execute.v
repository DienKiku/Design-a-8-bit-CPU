//===================================================================================
// File name:	scpu_execute.v
// Project:	8 bit processor
// Function:
// -- Contain the ALU
//===================================================================================
`include "scpu_define.h"
module scpu_execute (/*AUTOARG*/
   // Outputs
   ex_dout, 
   // Inputs
   dc_op, dc_rs, dc_rd
   );
`include "scpu_parameter.h"
//
//Inputs
//
input [1:0] dc_op;
input [8:0] dc_rs;
input [8:0] dc_rd;
//
//Outputs
//
output reg [8:0] ex_dout;
//
//Internal signals
//

//
//Module body
//
always @ (*) begin
  case (dc_op[1:0])
    2'b00: ex_dout[8:0] = dc_rd[8:0] & dc_rs[8:0];
    2'b01: ex_dout[8:0] = dc_rd[8:0] | dc_rs[8:0];
    2'b10: ex_dout[8:0] = dc_rd[8:0] + dc_rs[8:0];
    2'b11: ex_dout[8:0] = dc_rd[8:0] - dc_rs[8:0];
  endcase
end
endmodule