// reduces the inbuilt clock frequncy by a factor of 5 
// five cycles of inbuilt clock is one cycle of reduced clock

module clock_divider(clock,enable,finish,clk); 
 input 					clock; // input device clock
 input					finish; // 
 input 					enable; // enable bit
 output	reg			clk=1; 
 reg     [31:0]	 	count=0; 
  
 always @(posedge clock) 
   begin
		if(~finish & enable)
			begin 
				if (count == 32'd5) // change to control the new clock period
					begin 
						clk = ~clk; 
						count=0;
					end
				else 
					count = count + 32'd1;
			end
		else
			clk=0; 
	end
	
endmodule 
