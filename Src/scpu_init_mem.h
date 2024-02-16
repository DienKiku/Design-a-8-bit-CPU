//===================================================================================
// File name:	scpu_init_mem.h
// Project:	8 bit processor
// Function:
// -- Contain the binary code of the test program
//===================================================================================
cpu.fetch.mem_array[0]   = 8'b1110_0000; //LI R0, haa;
cpu.fetch.mem_array[1]   = 8'b1010_1010; //haa 
cpu.fetch.mem_array[2]   = 8'b1110_0100; //LI R1, h55;
cpu.fetch.mem_array[3]   = 8'b0101_0101; //h55
cpu.fetch.mem_array[4]   = 8'b1110_1000; //LI R2, h88;
cpu.fetch.mem_array[5]   = 8'b1000_1000; //h88 
cpu.fetch.mem_array[6]   = 8'b1110_1100; //LI R3, h99;
cpu.fetch.mem_array[7]   = 8'b1001_1001; //h99

cpu.fetch.mem_array[8]   = 8'b0111_0000; //NOP
cpu.fetch.mem_array[9]   = 8'b0111_0000; //NOP
cpu.fetch.mem_array[10]  = 8'b0111_0000; //NOP

cpu.fetch.mem_array[11]  = 8'b0000_0001; //AND R0, R1 => R0 = h00

cpu.fetch.mem_array[12]  = 8'b0001_1011; //OR R2, R3 => R2 = h99 

cpu.fetch.mem_array[13]  = 8'b0010_0110; //ADD R1, R2 => R1 = hee

cpu.fetch.mem_array[14]  = 8'b0011_1011; //SUB R2, R3 => R2 = h99 - h99 = h00

cpu.fetch.mem_array[15]  = 8'b0100_0000; //LWR R0, R0 => R0 = mem[R0] = mem[h00] = he0

cpu.fetch.mem_array[16]  = 8'b0101_0111; //SW R1, R3 => mem[R3] = mem[h99] = mem[153] = R1 = hee 

cpu.fetch.mem_array[17]  = 8'b0110_1100; //MOV R3, R0 => R3 = R0 = he0
cpu.fetch.mem_array[18]  = 8'b0111_0000; //NOP

cpu.fetch.mem_array[19]  = 8'b1000_0100; //JEQ R1, IMM
cpu.fetch.mem_array[20]  = 8'b1111_0000; //IMM = hf0 => Do not jump because R1 = hee
cpu.fetch.mem_array[21]  = 8'b1110_0100; //LI R1, IMM => R1 = h00
cpu.fetch.mem_array[22]  = 8'b0000_0000; //IMM = h00
cpu.fetch.mem_array[23]  = 8'b1000_0100; //JEQ R1, IMM
cpu.fetch.mem_array[24]  = 8'b0001_1010; //IMM = h1a = 26 => jump to mem[26]
cpu.fetch.mem_array[25]  = 8'b0110_0010; //MOV R0, R2 (do not execute because JEQ)

cpu.fetch.mem_array[26]  = 8'b1001_1000; //JNE R2, IMM => Do not jump because R2 = 0
cpu.fetch.mem_array[27]  = 8'b0001_1111; //IMM = h1f = 31
cpu.fetch.mem_array[28]  = 8'b0000_0010; //AND R0, R1  => R0 = he0 & h00 = h00
cpu.fetch.mem_array[29]  = 8'b1001_1100; //JNE R3, IMM => jump because R3 != 0
cpu.fetch.mem_array[30]  = 8'b0010_0000; //IMM = h1f = 32 => jump to mem[32]
cpu.fetch.mem_array[31]  = 8'b0110_0010; //MOV R0, R2 (do not execute because JEQ)

cpu.fetch.mem_array[32]  = 8'b1010_0010; //JGT R0, IMM => Do not jump because R0 = 0
cpu.fetch.mem_array[33]  = 8'b0010_1101; //IMM = 45
cpu.fetch.mem_array[34]  = 8'b1110_0000; //LI R0, h88;
cpu.fetch.mem_array[35]  = 8'b1000_1000; //R0 = h88
cpu.fetch.mem_array[36]  = 8'b1010_0000; //JGT R0, IMM => jump because R0 = h88 > 0
cpu.fetch.mem_array[37]  = 8'b0010_1101; //IMM = 45

//From [38] to [43], they are executed when jumping from [43] by JLT
cpu.fetch.mem_array[38]  = 8'b1100_1000; //LWI R2, IMM =>R2 = mem[40] = hd8
cpu.fetch.mem_array[39]  = 8'b0010_1000; //IMM = 40 = h28
cpu.fetch.mem_array[40]  = 8'b1101_1000; //SWI R2, IMM => mem[IMM] = mem[h3c] = mem[60] = R2 = hd8
cpu.fetch.mem_array[41]  = 8'b0011_1100; //IMM = h3c
cpu.fetch.mem_array[42]  = 8'b1111_0000; //JMP IMM => Jump to the start of the program [0]
cpu.fetch.mem_array[43]  = 8'b0000_0000; // IMM = 0
//
//
cpu.fetch.mem_array[45]  = 8'b1011_0000; //JLT R0, IMM => Do not jump because R0 = h88 > 0
cpu.fetch.mem_array[46]  = 8'b1111_0000; //IMM = hf0
cpu.fetch.mem_array[47]  = 8'b0011_0100; //SUB R1, R0 => R1 = R1 - R0 = h00 - h88 = -h88 (R1[8] == 1)
cpu.fetch.mem_array[48]  = 8'b0110_0001; //MOV R0, R1 => R0 = R1 = -h88
cpu.fetch.mem_array[49]  = 8'b1011_0000; //JLT R0, IMM => Do not jump because R0 = -h88 < 0
cpu.fetch.mem_array[50]  = 8'b0010_0110; //IMM = 38 => jump to [38]

