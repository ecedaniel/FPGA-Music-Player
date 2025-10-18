// LED_ping_pong module shifts the LED from LED[0] to LED[7] and back and forth.

module LED_ping_pong(input clk, output reg [7:0] LED);

	reg direction = 1'b0; // direction flag; 1'b0 for left and 1'b1 for right
	reg start 	  = 1'b0; // start flag; 1'b0 for not-started and 1'b1 for started
	
	always @(posedge clk) begin
		
		if(start!=1'b1) begin
		LED <= 8'b00000001; // set a initial value
		start <= 1'b1;		  // start flag is enabled
		end
		
		else if(LED == 8'b00000001) begin // if LED[0] is on, shifts LED to the left
			direction <= 1'b0; 
			LED <= 8'b00000010;
		end
		
		else if (LED == 8'b10000000) begin // if LED[7] is on, shifts LED to the right
			direction <= 1'b1;
			LED <= 8'b01000000;
		end
		
		else if (direction == 1'b0) begin // if direction is left, left-shift the LED
			LED <= LED << 1;
		end
		
		else if (direction == 1'b1) begin // if direction is right, right-shift the LED
			LED <= LED >> 1;
		end
		
		
	end
	 
endmodule
