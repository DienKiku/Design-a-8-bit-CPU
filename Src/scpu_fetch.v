//===================================================================================
// File name:	scpu_fetch.v
// Project:	8 bit processor
// Function:
// -- Fetch the instructrion code from the RAM
// -- Fetch the data from the RAM
// -- Store the program code and data in RAM
//===================================================================================
`include "scpu_define.h"
module scpu_fetch (/*AUTOARG*/
   // Outputs
   fetch_ir, fetch_dr, fetch_mem_dout, 
   // Inputs
   clk, rst_n, dc_load_pc, dc_imm, dc_addr_sel, dc_rs, dc_rd, 
   dc_mem_wr, dc_load_dr, dc_load_ir
   );
`include "scpu_parameter.h"
//
//Inputs
//
input clk;
input rst_n;
//from DECODER
input       dc_load_pc;
input       dc_imm;
input [1:0] dc_addr_sel;
input [7:0] dc_rs;
input [7:0] dc_rd;
input       dc_mem_wr;
input       dc_load_dr;
input       dc_load_ir;
//
//Outputs
//
output reg [7:0] fetch_ir;
output reg [7:0] fetch_dr;
output wire [7:0] fetch_mem_dout;
//
//Internal signals
//
reg  [7:0] mem_array[255:0];
wire [7:0] mem_out;
reg  [7:0] mem_addr;
reg  [7:0] pc;
//
//Module Body
//
//Instruction register - IR
always @ (posedge clk) begin
  if (~rst_n) fetch_ir[7:0] <= `DLY 8'b0111_0000;
  else if (dc_load_ir)
    fetch_ir[7:0] <= `DLY mem_out[7:0];
end
//Data register - DR
always @ (posedge clk) begin
  if (dc_load_dr)
    fetch_dr[7:0] <= `DLY mem_out[7:0];
end
//Instruction and Data memory - RAM
//Write decoder
always @ (posedge clk) begin
  if (dc_mem_wr)
    mem_array[mem_addr[7:0]] <= `DLY dc_rd[7:0];
end
//Read decoder 
assign mem_out[7:0] = dc_imm? mem_array[fetch_dr[7:0]]: mem_array[pc[7:0]];
assign fetch_mem_dout[7:0] = mem_array[mem_addr[7:0]];
//RAM address
always @ (*) begin
  case (dc_addr_sel[1:0])
    2'b01:   mem_addr[7:0] = dc_rs[7:0];
    2'b10:   mem_addr[7:0] = fetch_dr[7:0];
    default: mem_addr[7:0] = pc[7:0];
  endcase
end
//Program counter - PC
always @ (posedge clk) begin
  if (~rst_n) pc[7:0] <= `DLY 8'd0;
  else if (dc_load_pc) begin
    pc[7:0] <= `DLY (dc_imm? fetch_dr[7:0]: pc[7:0]) + 1'b1;
  end
end

endmodule
