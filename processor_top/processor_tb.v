module processor_tb;

reg 				clock, enable;
reg 	[7:0]		ram_out, iram_out;
wire				finish, clock_out, dram_wr_en; 

wire 			[15:0] 			dram_addr; // address for DRAM
wire 			[7:0] 			dram_din; // data to write to DRAM
wire 			[7:0]				iram_addr; // IRAM address


processor proc1(clock, enable, ram_out, iram_out, finish, clock_out, dram_wr_en, dram_addr, dram_din, iram_addr); 

endmodule
