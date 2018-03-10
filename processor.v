
//=======================================================
//  Written by Kanchana Ranasinghe 
//=======================================================

// Simple Processor (proc)
// Data can be obtained from registers, or the data input from DIn
// Data can be written to registers, or obtained from BusWires by other module
// Addition and Substraction operations can be performed

// Note: only MUX can load values to Bus
// Also, all registers' outputs are connected to Mux (except IR and A)
// Register A connected to ALU and IR to CU directly

// Includes only move, obtain data, add, subtract micro-instructions
// Can add upto 16 micro instructions

module processor (DIN, Resetn, Clock, Run, Done, BusWires);
  input 			[15:0] 			DIN;  // data in to processor (from memory)
  input 								Resetn;  // resets counter in middle of instruction
  input 								Clock;  // clock input for register
  input 								Run;  // should be high for processor to run
  output reg 						Done;  // indicates end of instruction 
  output reg 	[15:0] 			BusWires;  // outputs values on bus wires

  //declare registers and wires
  reg 				IRin, DINout, Ain, Gout, Gin;  // enable bits for registers
  reg					AddSub;  //enable bit for subtraction in ALU 
  reg 	[7:0] 	Rout;  // selection register for MUX (to pick GP register) 
  reg 	[7:0] 	Rin;  // enable bits for 8 general purpose registors
  reg 	[9:0] 	MUXsel;  // multiplexer output
  wire 	[7:0] 	Xreg, Yreg;  // one-hot value for data registers of instruction
  wire 	[1:9] 	IR;  // instruction regiser
  wire 	[1:3] 	I;  // instruction part of instruction
  wire 	[15:0] 	R0, R1, R2, R3, R4, R5, R6, R7;  //general purpose registers
  wire 	[15:0] 	A, G;  //output of ALU input and output registers
  wire 	[15:0]	result;  //ALU out to G connection
  wire 	[1:0] 	Tstep_Q;  // counter for instructions taking multiple clock cycles

  wire Clear = Done || ~Resetn;  // clear resets the counter
  upcount Tstep (Clear, Clock, Tstep_Q);  // instantiates the counter 
  
  assign I = IR[1:3];  //obtains instruction part from IR
  dec3to8 decX (IR[4:6], 1'b1, Xreg);  // converts register addresses to one-hot
  dec3to8 decY (IR[7:9], 1'b1, Yreg);  // converts register addresses to one-hot
  
  // obtain inputs and define Control Units (CU) logic
  always @(Tstep_Q or I or Xreg or Yreg)
  begin
    // specify initial values (all set to zero)
    IRin = 1'b0;
    Rout[7:0] = 8'b00000000;
    Rin[7:0] = 8'b00000000;
    DINout = 1'b0;
    Ain = 1'b0;
    Gout = 1'b0;
    Gin = 1'b0;
    AddSub = 1'b0;

    Done = 1'b0;

    case (Tstep_Q)
      2'b00: // store DIN in IR in time step 0
      begin
			if (Run) IRin = 1'b1;  // setting enable bit to one activates register
			else Done = 1'b1;
      end
      2'b01: // define signals in time step 1
        case (I)
          3'b000:  // mv 
          begin
            Rout = Yreg;  // mux selects register Yreg to output to bus
            Rin = Xreg;  // register Xreg is enabled (stores data on bus)
            Done = 1'b1;  //resets clock & indicates end of instruction cycle
          end
          3'b001:  // mvi
          begin
            DINout = 1'b1; // mux selects DIn to output to bus
            Rin = Xreg;  // register Xreg is enabled (stores data on bus)
            Done = 1'b1;
          end
          3'b010:  //add
          begin
            Rout = Xreg;  // Xreg loaded to bus
            Ain = 1'b1;  // bus data stored to A
          end
          3'b011:  //subtract
          begin
            Rout = Xreg; // Xreg loaded to bus
            Ain = 1'b1;  // bus data stored to A
          end
        endcase
      2'b10: // define signals in time step 2
        case (I)
          3'b010:  // add
          begin
            Rout = Yreg;  // Yreg loaded to bus
            Gin = 1'b1;  // ALU output loaded to G 
          end
          3'b011:  // subtract
          begin
            Rout = Yreg;  // Yreg loaded to bus
				AddSub = 1'b1;  // Substraction activated on ALU 
            Gin = 1'b1;  // ALU output loaded to G             
          end
        endcase
      2'b11: //define signals in time step 3
        case (I)
          3'b010:  //add
          begin
            Gout = 1'b1;  // G loaded to bus
            Rin = Xreg;  // Bus value stored in Xreg
            Done = 1'b1;
          end
          3'b011:
          begin
            Gout = 1'b1;  // G loaded to bus
            Rin = Xreg;  // Bus value stored in Xreg
            Done = 1'b1;
          end
        endcase
    endcase
  end

  // create general purpose registers 
  regn reg_0 (BusWires, Rin[0], Clock, R0);
  regn reg_1 (BusWires, Rin[1], Clock, R1);
  regn reg_2 (BusWires, Rin[2], Clock, R2);
  regn reg_3 (BusWires, Rin[3], Clock, R3);
  regn reg_4 (BusWires, Rin[4], Clock, R4);
  regn reg_5 (BusWires, Rin[5], Clock, R5);
  regn reg_6 (BusWires, Rin[6], Clock, R6);
  regn reg_7 (BusWires, Rin[7], Clock, R7);

  // create instruction register
  regn reg_IR (DIN[8:0], IRin, Clock, IR);
  defparam reg_IR.n = 9;
  
  // create ALU registers
  regn reg_A (BusWires, Ain, Clock, A);
  regn reg_G (result, Gin, Clock, G);

  // create ALU (using IP core)
  addsub AS (~AddSub, A, BusWires, result);

  //define the bus
  // input for MUX is in one hot encoding
  always @ (MUXsel or Rout or Gout or DINout)
  begin
    MUXsel[9:2] = Rout;
    MUXsel[1] = Gout;
    MUXsel[0] = DINout;
    
    case (MUXsel)
      10'b0000000001: BusWires = DIN;
      10'b0000000010: BusWires = G;
      10'b0000000100: BusWires = R0;
      10'b0000001000: BusWires = R1;
      10'b0000010000: BusWires = R2;
      10'b0000100000: BusWires = R3;
      10'b0001000000: BusWires = R4;
      10'b0010000000: BusWires = R5;
      10'b0100000000: BusWires = R6;
      10'b1000000000: BusWires = R7;
    endcase
  end

endmodule


// create a timer for instructions taking multiple clock cycles
module upcount(Clear, Clock, Q);
  input Clear, Clock;
  output [1:0] Q;
  reg [1:0] Q;

  always @(posedge Clock)
    if (Clear)
      Q <= 2'b0;
    else
      Q <= Q + 1'b1;
endmodule


// turn 3 bit binary values to one hot encoding
module dec3to8(W, En, Y);
  input [2:0] W;
  input En;
  output [0:7] Y;
  reg [0:7] Y;

  always @(W or En)
  begin
    if (En == 1)
      case (W)
        3'b000: Y = 8'b10000000;
        3'b001: Y = 8'b01000000;
        3'b010: Y = 8'b00100000;
        3'b011: Y = 8'b00010000;
        3'b100: Y = 8'b00001000;
        3'b101: Y = 8'b00000100;
        3'b110: Y = 8'b00000010;
        3'b111: Y = 8'b00000001;
      endcase
    else
      Y = 8'b00000000;
  end
endmodule


// define registers module
// Rin is enable, R is data, Q is output
module regn(R, Rin, Clock, Q);
  parameter n = 16;
  input [n-1:0] R;
  input Rin, Clock;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge Clock)
    if (Rin)
      Q <= R;
endmodule