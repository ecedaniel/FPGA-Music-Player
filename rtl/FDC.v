module FDC(input D, input C, input CLR, output reg Q);
	
	always_ff @(posedge C, posedge CLR) begin
		if(CLR) Q <= 1'b0;
		else Q <= D;
	end
	
endmodule

