//===================================================================================
// File name:	scpu_decoder.v
// Project:	8 bit processor
// Function:
// -- decode the instruction
//===================================================================================
`include "scpu_define.h"
module scpu_decoder (/*AUTOARG*/
   // Outputs
   dc_load_pc, dc_imm, dc_addr_sel, dc_rs, dc_rd, dc_mem_wr, 
   dc_load_dr, dc_load_ir, dc_op, 
   // Inputs
   clk, rst_n, fetch_ir, fetch_dr, fetch_mem_dout, ex_dout
   );
`include "scpu_parameter.h"
//
//Inputs
//
input clk;
input rst_n;
//from FETCH
input [7:0] fetch_ir;
input [7:0] fetch_dr;
input [7:0] fetch_mem_dout;
//from EXECUTE;
input [8:0] ex_dout;
//
//Outputs
//
output wire dc_load_pc;
output wire dc_imm;
output reg [1:0] dc_addr_sel;
output reg [8:0] dc_rs;
output reg [8:0] dc_rd;
output reg dc_mem_wr;
output reg dc_load_dr;
output wire dc_load_ir;
output wire [1:0] dc_op;
//
//Internal signals
//
wire [3:0] opcode;
wire [1:0] rs_sel;
wire [1:0] rd_sel;
reg [1:0] ctrl_counter;
reg clr_counter;
reg jump_en;
reg [8:0] reg_in;
reg load_reg_en;
reg [3:0] load_reg;
reg [8:0] reg0, reg1, reg2, reg3;

//
//Module body
//
//Operation code
assign opcode[3:0] = fetch_ir[7:4];
assign rd_sel[1:0] = fetch_ir[3:2];
assign rs_sel[1:0] = fetch_ir[1:0];
//Control counter
always @ (posedge clk) begin
  if (~rst_n) ctrl_counter[1:0] <= `DLY 2'd0;
  else if (clr_counter) ctrl_counter[1:0] <= `DLY 2'd0;
  else ctrl_counter[1:0] <= `DLY ctrl_counter[1:0] + 1'b1;
end
always @ (*) begin
  case (opcode[3:0])
    OP_JEQ, OP_JNE, OP_JGT, OP_JLT, OP_LWI, OP_SWI, OP_LI, OP_JMP: clr_counter = ctrl_counter[1];
    OP_NOP: clr_counter = 1'b1;
    default: clr_counter = ctrl_counter[0]; //OP_AND, OP_OR, OP_ADD, OP_SUB, OP_LWR, OP_SWR, OP_MOV
  endcase
end
//
assign dc_load_pc = dc_load_ir | dc_load_dr; //~ctrl_counter[0];
assign dc_load_ir = clr_counter;// ~|ctrl_counter[1:0];
//Select the immediately value
assign dc_imm = jump_en & ctrl_counter[1];
always @ (*) begin
  case (opcode[3:0])
    OP_JEQ: jump_en = (dc_rd[8:0] == 0);
    OP_JNE: jump_en = (dc_rd[8:0] != 0);
    OP_JGT: jump_en = (dc_rd[7:0] != 0 && dc_rd[8] == 0);
    OP_JLT: jump_en = (dc_rd[8] == 1);
    OP_JMP: jump_en = 1'b1;
    default: jump_en = 1'b0;
  endcase
end
//Select the address of memory
always @ (*) begin
  case (opcode[3:0])
    OP_LWI, OP_SWI, OP_LWR, OP_SWR: dc_addr_sel[1:0] = ctrl_counter[1:0];
    default: dc_addr_sel[1:0] = 2'b00;
  endcase
end
//Select the operator
assign dc_op[1:0] = opcode[1:0];
//Load the immediately value from memory to the data register
always @ (*) begin
  case (opcode[3:0])
    OP_JEQ, OP_JNE, OP_JGT, OP_JLT, OP_LWI, OP_SWI, OP_LI, OP_JMP: dc_load_dr = ctrl_counter[0];
    default: dc_load_dr = 1'b0;
  endcase
end
//Store the new value to memory
always @ (*) begin
  case (opcode[3:0])
    OP_SWR: dc_mem_wr = ctrl_counter[0];
    OP_SWI: dc_mem_wr = ctrl_counter[1];
    default: dc_mem_wr = 1'b0;
  endcase
end
//R0, R1, R2, R3
//data input of registers
always @ (*) begin
  case (opcode[3:0])
    OP_AND, OP_OR, OP_ADD, OP_SUB: reg_in[8:0] = ex_dout[8:0];
    OP_MOV: reg_in[8:0] = dc_rs[8:0];
    OP_LI: reg_in[8:0] = {1'b0, fetch_dr[7:0]};
    OP_LWR, OP_LWI: reg_in[8:0] = {1'b0, fetch_mem_dout[7:0]};
    default: reg_in = 9'hxxx;
  endcase
end
//write Control of registers
always @ (*) begin
  case (opcode[3:0])
    OP_AND, OP_OR, OP_ADD, OP_SUB, OP_LWR, OP_MOV: load_reg_en = ctrl_counter[0];
    OP_LWI, OP_LI: load_reg_en = ctrl_counter[1];
    default: load_reg_en = 1'b0;
  endcase
end
//write enable of registers
always @ (*) begin
  load_reg[3:0] = 4'b0000;
  case (rd_sel[1:0])
    2'b00: load_reg[0] = load_reg_en;
    2'b01: load_reg[1] = load_reg_en;
    2'b10: load_reg[2] = load_reg_en;
    2'b11: load_reg[3] = load_reg_en;
  endcase
end
//R0
always @ (posedge clk) begin
  if (load_reg[0]) reg0[8:0] <= `DLY reg_in[8:0];
end
//R1
always @ (posedge clk) begin
  if (load_reg[1]) reg1[8:0] <= `DLY reg_in[8:0];
end
//R2
always @ (posedge clk) begin
  if (load_reg[2]) reg2[8:0] <= `DLY reg_in[8:0];
end
//R3
always @ (posedge clk) begin
  if (load_reg[3]) reg3[8:0] <= `DLY reg_in[8:0];
end
//The destination register - RD 
always @ (*) begin
  case (rd_sel[1:0])
    2'b00: dc_rd[8:0] = reg0[8:0];
    2'b01: dc_rd[8:0] = reg1[8:0];
    2'b10: dc_rd[8:0] = reg2[8:0];
    2'b11: dc_rd[8:0] = reg3[8:0];
  endcase
end
//The source register - RS
always @ (*) begin
  case (rs_sel[1:0])
    2'b00: dc_rs[8:0] = reg0[8:0];
    2'b01: dc_rs[8:0] = reg1[8:0];
    2'b10: dc_rs[8:0] = reg2[8:0];
    2'b11: dc_rs[8:0] = reg3[8:0];
  endcase
end
endmodule