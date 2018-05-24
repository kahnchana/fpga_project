module alu (
	A_bus,
	B_bus,
	operator,
	C_bus,
	Z); 

 input 			[15:0] 	A_bus; // input data
 input 			[15:0] 	B_bus; // input data
 input 			[2:0]  	operator; // select ALU operation
 output reg		[15:0] 	C_bus; // output data
 output reg   				Z=0; // high if output is zero: NOTE change occurs in following clock cycle

  
 parameter 	ADD=3'd0, // C = A+B
				SUB=3'd1, // C = A-B 
				PASS=3'd2, // C = B
				ZER=3'd3,  // C = 0
				DECA=3'd4, // C = A-1
				MUL2=3'd5, // C = B*2
				DIV2=3'd6;  // C = B/2
  
 always@(operator or A_bus or B_bus) 
 begin
	case (operator)
		ADD: 
			begin 
				C_bus = A_bus + B_bus; 
				Z = (C_bus==16'd0); 
			end 
		SUB: 
			begin 
				C_bus = A_bus - B_bus; 
				Z = (C_bus==16'd0);
			end
		PASS: 
			begin 
				C_bus = B_bus; 
				Z = (C_bus==16'd0);
			end
		ZER: 
			begin 
				C_bus = 0; 
				Z = 0;
			end 
		DECA:
			begin 
				C_bus = A_bus-16'd1;
				Z = (C_bus==16'd0);
			end 
		MUL2:
			begin
				C_bus = B_bus << 1;
				Z = 0;
			end
		DIV2:
			begin
				C_bus = B_bus >> 1; 
				Z = (C_bus==16'd0);
			end 
    
	endcase 
 end 
endmodule 