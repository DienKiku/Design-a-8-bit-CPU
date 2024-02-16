//===================================================================================
// File name:	scpu_parameter.v
// Project:	8 bit processor
// Function:
// -- All global parameters
//===================================================================================
//
//Operation code - OPCODE
//
parameter OP_AND  = 4'b0000;
parameter OP_OR   = 4'b0001;
parameter OP_ADD  = 4'b0010;
parameter OP_SUB  = 4'b0011;
parameter OP_LWR  = 4'b0100;
parameter OP_SWR  = 4'b0101;
parameter OP_MOV  = 4'b0110;
parameter OP_NOP  = 4'b0111;
parameter OP_JEQ  = 4'b1000;
parameter OP_JNE  = 4'b1001;
parameter OP_JGT  = 4'b1010;
parameter OP_JLT  = 4'b1011;
parameter OP_LWI  = 4'b1100;
parameter OP_SWI  = 4'b1101;
parameter OP_LI   = 4'b1110;
parameter OP_JMP  = 4'b1111;
