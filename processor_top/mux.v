module mux(
	MUXsel,
	DRAM,
	PC,
	R1,
	R2,
	R3,
	R,
	AC,
	IRAM,
	B_bus);

	input 		[2:0]			 	MUXsel;  // selects multiplexer output
	input 		[15:0] 			PC; // Program Counter
	input 		[15:0] 			AC; // ALU output
	input 		[15:0] 			R1, R2, R3, R; // general purpose registers
	input 		[7:0] 			DRAM,IRAM; // inputs from RAM
	output reg 	[15:0] 			B_bus;  // outputs values on B_bus wires

	always @(MUXsel or DRAM or PC or R1 or R2 or R3 or R or AC or IRAM)  
		begin 
			case(MUXsel) 
				3'd0:B_bus={8'b00000000, DRAM}; // update from DRAM
				3'd1:B_bus=PC; // update from PC
				3'd2:B_bus=R1; // update from General Purpose Registers
				3'd3:B_bus=R2; 
				3'd4:B_bus=R3; 
				3'd5:B_bus=R; 
				3'd6:B_bus=AC; // update from ALU output
				3'd7:B_bus={8'b00000000, IRAM}; // update from internal RAM
			endcase 
		end 
		
endmodule