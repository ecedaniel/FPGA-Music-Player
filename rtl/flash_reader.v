module flash_reader(
					clk,
					reset_all,
					start,
					is_read,
					waitrequest,
					readdatavalid,
					finish
					);
					
	input clk;
	input reset_all;
	input start;
	input is_read;
	input waitrequest;
	input readdatavalid;
	output finish;
	
	reg [4:0] state;
	
	parameter idle 				= 5'b0000_0; // waiting for start signal
	parameter check_oper 		= 5'b0001_0; // check if read operation
	parameter handle_read_op 	= 5'b0010_0; // handling read operation
	parameter wait_read 			= 5'b0100_0; // wait for read to be complete
 	parameter finished 			= 5'b1000_1; // read completed
	
	assign finish = state[0];
	
	always_ff @(posedge clk or posedge reset_all)
	begin
		if (reset_all)
			state <= idle;
		else
			case(state)
			
			idle: 
			if (start) 
				state <= check_oper;
					
			check_oper:
			if (is_read)
				state <= handle_read_op;
			
			handle_read_op: 
			if (!waitrequest)
				state <= wait_read;
				
			wait_read:
			if (!readdatavalid)
				state <= finished;
			
			finished:
			state <= idle;
			
			endcase
	end
	
endmodule

			
	