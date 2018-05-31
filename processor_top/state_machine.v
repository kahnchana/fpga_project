module state_machine(
	clk,
	z,
	ir,
	pcinc,
	r1inc,
	r2inc,
	r3inc,
	acinc,
	bflag,
	alu,
	fetch,
	cflag,
	finish);
	
 input clk; // clock
 input z;  // ALU zero or not
 input [7:0] ir; // instruction register
 output reg pcinc; // increase program counter by one
 output reg r1inc; // increase register1 by one
 output reg r2inc; // increase register2 by one
 output reg r3inc; // increase register3 by one
 output reg acinc; // increase accumulator register by one
 output reg fetch; // enable data write from bus to IR 
 output reg finish=0; // indicates end of processing state
 output reg [2:0] alu; // operator to the ALU
 output reg [2:0] bflag; // controls output to B bus through mux
 output reg [7:0] cflag; // write data to each of eight registers (AR,PC,R1,R2,R3,R,AC,M)
  
 reg [5:0] PS, NS = FETCH1; // PS: present state, NS: next state
  
 parameter 
 FETCH1  =6'd0, 
 FETCH2  =6'd1, 
 FETCH3  =6'd2, 
 FETCH4  =6'd57, 
 CLAC1   =6'd3, 
 MVACAR1  =6'd59, 
 STAC1   =6'd4, 
 STAC2   =6'd53, 
 MVACRI1  =6'd6, 
 MVACRII1  =6'd7, 
 MVACRIII1 =6'd8, 
 MVACR1  =6'd9, 
 MVRIAC1  =6'd10, 
 MVRIIAC1  =6'd11, 
 MVRIIIAC1 =6'd12, 
 MVRAC1  =6'd13, 
 INAC1     =6'd14, 
 INCR1   =6'd40, 
 INCR2   =6'd41, 
 INCR3   =6'd42,  
 LDAC1     =6'd15, 
 LDAC2     =6'd16, 
 LDAC3     =6'd56, 
 SUB1      =6'd17, 
 DECAC1   =6'd18, 
 ADD1    =6'd19, 
 DIV21    =6'd20, 
 MULT4  =6'd21, 
 JUMPNZ1     =6'd22, 
 JUMPNZY1    =6'd23, 
 JUMPNZN1    =6'd24, 
 JUMPNZN2    =6'd25, 
 JUMPNZN3    =6'd26, 
 JUMPNZNSKIP =6'd55, 
 ADDM1       =6'd27, 
 ADDM2       =6'd28, 
 ADDMPC  =6'd54, 
 NOP   =6'd58, 
 END   =6'd60; 
  
 always@(negedge clk) PS<=NS; 
 
 always@(PS or z or ir) 
  case(PS)
   FETCH1:begin // instruction loaded to bus from IRAM
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd7; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    NS<=FETCH2; 
   end 
   FETCH2:begin // bus value written to IR, program counter increased
    pcinc<=1; 
    r1inc<=0; 
    r2inc<=0; 
	 r3inc<=0; 
    acinc<=0; 
    fetch<=1; 
    finish<=0; 
    bflag<=3'd7; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    NS<=FETCH3; 
   end 
   FETCH3:begin // IR value loaded to state machine
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0;  
	 finish<=0; 
    bflag<=3'd7; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    NS<=ir[5:0]; 
   end 
   CLAC1:begin // clears accumulator
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd3; 
    cflag<=8'b00000010;
    NS<=FETCH1;
   end 
   STAC1:begin // load AC to BUS, enable write to DRAM
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00000001; 
    NS<=FETCH1; 
   end
   MVACAR1:begin // move accumulator to AR
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
	 cflag<=8'b10000000; 
    NS<=FETCH1; 
   end 
	MVACRI1:begin // move accumulator to R1
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00100000; 
    NS<=FETCH1; 
   end 
   MVACRII1:begin // move accumulator to R2
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00010000; 
    NS<=FETCH1; 
   end 
   MVACRIII1:begin // move accumulator to R3
    pcinc<=0; 
    r1inc<=0; 
	 r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00001000; 
    NS<=FETCH1; 
   end 
   MVACR1:begin // move accumulator to R
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00000100; 
    NS<=FETCH1; 
   end 
   MVRIAC1:begin // move R1 to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
	 fetch<=0; 
    finish<=0; 
    bflag<=3'd2; 
    alu<=3'd2; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   MVRIIAC1:begin // move R2 to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd3; 
    alu<=3'd2; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   MVRIIIAC1:begin // move R3 to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd4; 
	 alu<=3'd2; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   MVRAC1:begin // move R to AC 
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd5; 
    alu<=3'd2; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   INAC1:begin // increase AC and push to BUS
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=1; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
	 end 
   INCR1:begin // increase R1 and push to bus
    pcinc<=0; 
    r1inc<=1; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd2; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
   end 
   INCR2:begin // increase R2 and push to bus
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=1; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd3; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
   end 
   INCR3:begin // increase R3 and push to BUS
    pcinc<=0; 
	 r1inc<=0; 
    r2inc<=0; 
    r3inc<=1; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd4; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
   end 
   DECAC1:begin // decrease AC and push to bus
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd4; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   LDAC1:begin // load AC to AR
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b10000000; 
    NS<=LDAC2; 
   end 
   LDAC2:begin // load DRAM to BUS and write to AC (wait for read)
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
	 acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd0; 
    cflag<=8'b00000010; 
    NS<=LDAC3; 
   end 
   LDAC3:begin // write to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd2; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   SUB1:begin // subtract value in R from AC and store to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0;  
    fetch<=0; 
	 finish<=0; 
    bflag<=3'd5; 
    alu<=3'd1; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   ADD1:begin // Add value in R to AC and store to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd5; 
    alu<=3'd0; 
	 cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   DIV21:begin // divide value in AC by 2 and store to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd6; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
   MULT4:begin // multiply value in AC by 4 and store to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd5; 
    cflag<=8'b00000010; 
    NS<=FETCH1; 
   end 
	JUMPNZ1:begin // check value of z
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    if(z)NS<=JUMPNZY1; 
    else NS<=JUMPNZN1; 
   end 
   JUMPNZY1:begin // for z=1, increase PC and go to next instruction
    pcinc<=1; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
   end 
   JUMPNZN1:begin // for z=0, load instruction from IRAM to bus
    pcinc<=0; 
	 r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd7; 
    alu<=3'd2; 
    cflag<=8'b00000000; 
    NS<=JUMPNZN2; 
   end 
//   JUMPNZN2:begin // for z=0, load bus to AC through ALU
//    pcinc<=0; 
//    r1inc<=0; 
//    r2inc<=0; 
//    r3inc<=0; 
//    acinc<=0; 
//    fetch<=0; 
//    finish<=0; 
//    bflag<=3'd7; 
//    alu<=3'd2; 
//    cflag<=8'b00000010; 
//    NS<=JUMPNZN3; 
//   end 
   JUMPNZN2:begin // for z=0, load instruction to PC 
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
	 acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd6; 
    alu<=3'd0; 
    cflag<=8'b01000000; 
    NS<=FETCH1; 
   end 
   ADDM1:begin // IRAM value loaded to bus 
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd7; 
    alu<=3'd0; 
    cflag<=8'b00000010; 
    NS<=ADDM2; 
   end 	
   ADDM2:begin // Write IRAM value to AC
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd7; 
    alu<=3'd0; 
    cflag<=8'b00000010; 
    NS<=ADDMPC; 
   end 
   ADDMPC:begin // increase program counter
    pcinc<=1; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
	 bflag<=3'd3; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=FETCH1; 
   end 
   NOP:begin // blank operation doing nothing
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=0; 
    bflag<=3'd0; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
	 NS<=FETCH1; 
   end 
   END:begin // stop the clock and end processing
    pcinc<=0; 
    r1inc<=0; 
    r2inc<=0; 
    r3inc<=0; 
    acinc<=0; 
    fetch<=0; 
    finish<=1; 
    bflag<=3'd0; 
    alu<=3'd0; 
    cflag<=8'b00000000; 
    NS<=END; 
   end    
    
  endcase 
endmodule 