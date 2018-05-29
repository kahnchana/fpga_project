module processor_tb;

reg 				clock, enable;
reg 	[7:0]		ram_out, iram_out;
wire				finish, clock_out, dram_wr_en; 

 output 			[15:0] 			dram_addr; // address for DRAM
 output 			[7:0] 			dram_din; // data to write to DRAM
 output 			[7:0]				iram_addr; // IRAM address


module processor (clock, enable, ram_out, iram_out, finish, clock_out, dram_wr_en, dram_addr, dram_din, iram_addr); 