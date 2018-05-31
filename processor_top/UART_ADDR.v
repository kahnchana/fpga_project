module UART_ADDR(clk, rx_done_tick, tx_done_tick, data_out, din, address, wea, p_enable); 
 
 input 				clk, rx_done_tick, tx_done_tick; 
 input 	[7:0] 	data_out; 
 output 	[7:0]		din; 
 output 	[15:0] 	address; 
 output 				wea, p_enable; 
 
 reg 		[15:0] 	address=16'd0; 
 reg					wea=1'b1; 
 reg					p_enable=0; 
 reg 		[7:0] 	din; 
 
 always@(posedge clk ) 
  begin 
	if (address==16'd65535 &&rx_done_tick) 
		begin
			wea<=1'b0; 
			address<=16'd0; 
			p_enable<=1'b1; 
			din<=data_out; 
		end 
	else if (rx_done_tick&&wea)
		begin 
			address<=address+16'd1; 
		end 
   else if(tx_done_tick&& address<16'd65535) 
		begin 
			address<=address+16'd1; 
			din<=data_out; 
		end 
	end
	
endmodule 