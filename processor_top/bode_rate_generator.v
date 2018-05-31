// operates over 4 clock cycles
// max_tick becomes high on every 4th clock cycle

module bode_rate_generator
 #( parameter  N =2, M =4 ) 
 ( 
  input wire 					clk, reset, 
  output wire 					max_tick, 
  output wire 		[N-1:0] 	q 
  ); 
   
 reg 	[N-1:0] r_reg; 
 wire [N-1:0] r_next; 
  
 always@(posedge clk, posedge reset) 
  if(reset) 
   r_reg<=0; 
  else 
   r_reg<= r_next; 
    
 assign r_next = (r_reg==(M-1)) ? 1'b0 :r_reg +1'b1; 
 assign q = r_reg; 
 assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0; 
  
endmodule