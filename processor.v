
//=======================================================
//  Written by Kanchana Ranasinghe 
//=======================================================

// Processor (proc)
// Data can be obtained from registers, or the data input from DIn
// Data can be written to registers, or obtained from BusWires by other module
// Addition and Substraction operations can be performed

// Note: only MUX can load values to Bus
// Also, all registers' outputs are connected to Mux (except IR and A)
// Register A connected to ALU and IR to CU directly

// Includes only move, obtain data, add, subtract micro-instructions
// Can add upto 16 micro instructions

module processor (clock, enable, ram_out, iram_out, finish, clock_out, dram_wr_en, dram_addr, dram_din, iram_addr); 
 input								clock; // connect internal clock of FPGA
 input 								enable; // enable bit for processor
 input 			[7:0] 			ram_out; // input from DRAM
 input 			[7:0] 			iram_out; // input from IRAM
 output								finish; // end of process flag
 output 								clock_out; // frequency reduced clock
 output								dram_wr_en; // write enable for DRAM
 output 			[15:0] 			dram_addr; // address for DRAM
 output 			[7:0] 			dram_din; // data to write to DRAM
 output 			[7:0]				iram_addr; // IRAM address
  
 wire clk; // reduced frequency clock 
 wire z; // ALU output AC zero flag
 wire pcinc; // increase program counter 
 wire r1inc, r2inc, r3inc; // increase general purpose registers
 wire acinc; // increase ALU output accumulator
 wire fetch; // load data to instruction register (IR)
 wire [2:0] MUXSel; // select mux output on B_bus
 wire [2:0] aluop; // select ALU operation (state_machine to ALU) 
 wire [7:0] IR; // load instruction from IR to state_machine
 wire [7:0] cflag; // load data to the all registers (except IR): state_machine to registers
 wire [15:0] bus; // MUX output to registers input(main bus)
 wire [15:0] PC, R1, R2, R3, R; // program counter and GP registers output to MUX
 wire [15:0] AC; // ALU output accumulator to MUX
 wire [15:0] C_bus; // ALU output to accumulator
  
 assign 	clock_out = clk; 
 assign	dram_wr_en = cflag[0]; 
 assign 	dram_din = bus[7:0]; 
 assign	iram_addr = PC[7:0]; 
  
 ///module instances 
 clock_divider clock_divider1(clock, enable, finish, clk); // clock frequency reducer
 state_machine state_machine1(clk, z, IR, pcinc, r1inc, r2inc, r3inc, acinc, MUXSel, aluop, fetch, cflag, finish); // state_machine
 mux mux1(MUXSel, ram_out, PC, R1, R2, R3, R, AC, iram_out, bus); // multiplexer
 alu alu16(AC, bus, aluop, C_bus, z); // ALU
 
 regn ar(clk, cflag[7], bus, dram_addr); // address register
 regn r(clk, cflag[2], bus, R); // r register
 regn ir(clk, fetch, bus[7:0], IR);  // instruction register
 defparam ir.n = 8;
 regn_incr pc(clk, cflag[6], pcinc, bus, PC); // program counter
 regn_incr r1(clk,cflag[5],r1inc,bus,R1); // register R1
 regn_incr r2(clk,cflag[4],r2inc,bus,R2); // register R2
 regn_incr r3(clk,cflag[3],r3inc,bus,R3); // register R3
 regn_incr ac(clk,cflag[1],acinc,C_bus,AC); // ALU output accumulator
  
endmodule 
