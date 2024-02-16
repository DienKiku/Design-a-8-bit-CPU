//===================================================================================
// File name:	tb_scpu_top.v
// Project:	8 bit processor
// Function:
// -- The top of testcase
//===================================================================================
`include "scpu_define.h"
module tb_scpu_top;
`include "scpu_parameter.h"
parameter END_SIM_TIME = 2000;
/*AUTOREGINPUT*/
// Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
reg			clk;			// To cpu of scpu_top.v
reg			rst_n;			// To cpu of scpu_top.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics

scpu_top cpu (/*AUTOINST*/
	      // Inputs
	      .clk			(clk),
	      .rst_n			(rst_n));

//Load the binary code to SRAM of the FETCH block
initial begin
  `include "scpu_init_mem.h"
end

//Generate the reset and limit the simulation time
initial begin
  clk = 1'b0;
  rst_n = 1'b0;
  #51
  rst_n = 1'b1;
  #END_SIM_TIME
  $stop;
end

//Generate the clock
always #10 clk = ~clk;

//Create the instruction name to view on the waveform
reg [31:0] inst_name;
always @ (*) begin
  case (cpu.dec.opcode[3:0])
    OP_AND: inst_name = "AND";
    OP_OR : inst_name = "OR";
    OP_ADD: inst_name = "ADD";
    OP_SUB: inst_name = "SUB";
    OP_LWR: inst_name = "LWR";
    OP_SWR: inst_name = "SWR";
    OP_MOV: inst_name = "MOV";
    OP_NOP: inst_name = "NOP";
    OP_JEQ: inst_name = "JEQ";
    OP_JNE: inst_name = "JNE";
    OP_JGT: inst_name = "JGT";
    OP_JLT: inst_name = "JLT";
    OP_LWI: inst_name = "LWI";
    OP_SWI: inst_name = "SWI";
    OP_LI : inst_name = "LI";
    OP_JMP: inst_name = "JMP";
  endcase
end

endmodule