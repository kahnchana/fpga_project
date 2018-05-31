module Selection(p_enable, p_finish, clock, p_clk, u_wr, p_wr, u_addr, p_addr, u_din, p_din, tx_start, r_clk, r_wr, r_addr, r_din); 
 input 					clock, p_clk, u_wr, p_wr, p_enable, p_finish; 
 input 		[15:0]	u_addr,p_addr; 
 input 		[7:0] 	u_din,p_din; 
 output reg 			tx_start=0; 
 output reg 			r_clk,r_wr; 
 output reg [15:0] 	r_addr; 
 output reg [7:0] 	r_din; 
   
 
 reg [1:0] PS=2'b11; 
  
 always@(*) begin 
  if(~p_enable&& ~p_finish) PS<=2'b00;//receiving data 
  if(p_enable&& ~p_finish) PS<=2'b01;//processing data 
  if(p_enable&&p_finish) PS<=2'b10;//transmitting data 
 end 
 always@(*) 
  case(PS) 
   2'b00:begin 
     tx_start<=0; 
     r_clk<=clock; 
     r_wr<=u_wr; 
     r_addr<=u_addr; 
     r_din<=u_din; 
      
    end 
   2'b01:begin 
     tx_start<=0; 
     r_clk<=p_clk; 
     r_wr<=p_wr; 
     r_addr<=p_addr; 
     r_din<=p_din; 
	  end 
   2'b10:begin 
     tx_start<=1; 
     r_clk<=clock; 
     r_wr<=u_wr; 
     r_addr<=u_addr; 
     r_din<=u_din; 
      
    end 
     
  endcase 
 
endmodule
