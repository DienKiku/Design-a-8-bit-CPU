//===================================================================================
// File name:	scpu_top.v
// Project:	8 bit processor
// Function:
// -- The top module
//===================================================================================
`include "scpu_define.h"
module scpu_top (/*AUTOARG*/
   // Inputs
   rst_n, clk
   );
`include "scpu_parameter.h"
//
//inputs
//
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			clk;			// To fetch of scpu_fetch.v, ...
input			rst_n;			// To fetch of scpu_fetch.v, ...
// End of automatics

//
//outputs
//
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
// End of automatics

//
//Internal signals
//
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [1:0]		dc_addr_sel;		// From dec of scpu_decoder.v
wire			dc_imm;			// From dec of scpu_decoder.v
wire			dc_load_dr;		// From dec of scpu_decoder.v
wire			dc_load_ir;		// From dec of scpu_decoder.v
wire			dc_load_pc;		// From dec of scpu_decoder.v
wire			dc_mem_wr;		// From dec of scpu_decoder.v
wire [1:0]		dc_op;			// From dec of scpu_decoder.v
wire [8:0]		dc_rd;			// From dec of scpu_decoder.v
wire [8:0]		dc_rs;			// From dec of scpu_decoder.v
wire [8:0]		ex_dout;		// From ex of scpu_execute.v
wire [7:0]		fetch_dr;		// From fetch of scpu_fetch.v
wire [7:0]		fetch_ir;		// From fetch of scpu_fetch.v
wire [7:0]		fetch_mem_dout;		// From fetch of scpu_fetch.v
// End of automatics

//
//Instances
//
scpu_fetch fetch (/*AUTOINST*/
		  // Outputs
		  .fetch_ir		(fetch_ir[7:0]),
		  .fetch_dr		(fetch_dr[7:0]),
		  .fetch_mem_dout	(fetch_mem_dout[7:0]),
		  // Inputs
		  .clk			(clk),
		  .rst_n		(rst_n),
		  .dc_load_pc		(dc_load_pc),
		  .dc_imm		(dc_imm),
		  .dc_addr_sel		(dc_addr_sel[1:0]),
		  .dc_rs		(dc_rs[7:0]),
		  .dc_rd		(dc_rd[7:0]),
		  .dc_mem_wr		(dc_mem_wr),
		  .dc_load_dr		(dc_load_dr),
		  .dc_load_ir		(dc_load_ir));

scpu_decoder dec (/*AUTOINST*/
		  // Outputs
		  .dc_load_pc		(dc_load_pc),
		  .dc_imm		(dc_imm),
		  .dc_addr_sel		(dc_addr_sel[1:0]),
		  .dc_rs		(dc_rs[8:0]),
		  .dc_rd		(dc_rd[8:0]),
		  .dc_mem_wr		(dc_mem_wr),
		  .dc_load_dr		(dc_load_dr),
		  .dc_load_ir		(dc_load_ir),
		  .dc_op		(dc_op[1:0]),
		  // Inputs
		  .clk			(clk),
		  .rst_n		(rst_n),
		  .fetch_ir		(fetch_ir[7:0]),
		  .fetch_dr		(fetch_dr[7:0]),
		  .fetch_mem_dout	(fetch_mem_dout[7:0]),
		  .ex_dout		(ex_dout[8:0]));

scpu_execute ex (/*AUTOINST*/
		 // Outputs
		 .ex_dout		(ex_dout[8:0]),
		 // Inputs
		 .dc_op			(dc_op[1:0]),
		 .dc_rs			(dc_rs[8:0]),
		 .dc_rd			(dc_rd[8:0]));

endmodule