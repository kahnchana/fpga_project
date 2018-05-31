module top_module( 
  input clk,
  input reset,
  input rx, 
  output tx 
 ); 
   
  wire 	[7:0] data_out; 
  wire			s_tick; 
  wire	 		tx_done_tick, p_finish, p_clk, p_wr, tx_start, r_clk;
  wire 			r_wr, wea, p_enable; 
   
  wire 	[7:0] dout, p_din, r_din, im_addr, iram_out, din; 
  wire 	[15:0] p_addr, r_addr, address; 
  
  dram ram64K( 
  	.address(r_addr),
	.clock(r_clk),
	.data(r_din),
	.wren(r_wr),
	.q(data_out)
	);
 
 bode_rate_generator bdg(
		.clk(clk), 
		.reset(reset), 
		.max_tick(s_tick)
	); 
 
 UART_RX rcx(
	.clk(clk),
	.reset(reset),
	.rx(rx),
	.s_tick(s_tick),
	.dout(dout),
	.rx_done_tick(rx_done_tick)
	); 
 
 UART_TX uut ( 
   .clk(clk),  
   .reset(reset),  
   .tx_start(tx_start),  
   .s_tick(s_tick),  
   .din(din),  
   .tx_done_tick(tx_done_tick),  
   .tx(tx) 
  ); 
   
 iram iram ( 
  	.address(im_addr),
	.clock(p_clk),
	.q(iram_out)
	);

 UART_ADDR uaddr(
	.clk(clk),
	.rx_done_tick(rx_done_tick),
	.tx_done_tick(tx_done_tick),
	.data_out(data_out),
	.din(din),
	.address(address),
	.wea(wea),
	.p_enable(p_enable)
	);  
	
 Selection sel(
	.p_enable(p_enable),
	.p_finish(p_finish),
	.clock(clk),
	.p_clk(p_clk),
	.u_wr(wea),
	.p_wr(p_wr),
	.u_addr(address),
	.p_addr(p_addr),
	.u_din(dout),
	.p_din(p_din),
	.tx_start(tx_start),
	.r_clk(r_clk),
	.r_wr(r_wr),
	.r_addr(r_addr),
	.r_din(r_din)
	); 
 
 processor processor(
	.clock(clk),
	.enable(p_enable),
	.ram_out(data_out),
	.iram_out(iram_out),
	.finish(p_finish),
	.clock_out(p_clk),
	.dram_wr_en(p_wr),
	.dram_addr(p_addr),
	.dram_din(p_din),
	.iram_addr(im_addr)
	); 

 
endmodule 
