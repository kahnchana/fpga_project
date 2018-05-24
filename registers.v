// define registers modules

// simple register
// load is enable, D_in is data, D_out is output
module regn(Clock, load, D_in, D_out);
  parameter n = 16;
  input 			[n-1:0] 		D_in; // data in
  input 							load; // enable bit
  input 							Clock; // clock 
  output reg 	[n-1:0] 		D_out; // data out

  always @(posedge Clock)
    if (load)
      D_out <= D_in;
endmodule


// registers module with increment
// load is enable, D_in is data, D_out is output
module regn_incr(Clock, load, incr, D_in, D_out);
  parameter n = 16;
  input 			[n-1:0] 		D_in; // data in
  input 							load; // enable bit
  input 							Clock; // clock 
  input 							incr; // increment bit
  output reg 	[n-1:0] 		D_out; // data out

  always @(posedge Clock)
	begin
    if (load)
      D_out <= D_in;
	 if (incr)
		D_out <= D_out + 16'd1 ; 
	end
endmodule
