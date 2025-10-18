// myclockdivider module gives the output clock by dividing clock count from the input clock

module myclockdivider(input inclk, input [31:0] div_clk_count, input Reset, output reg outclk, output wire outclk_Not);

	reg [31:0] counter = 0;
	
	always @(posedge inclk) begin
	
		if (Reset) begin
			counter <= 0;
			outclk <= 0;
		end
		
		
		else if (counter >= div_clk_count) begin // this section divides the clock 
			counter <= 0;			// reset the counter
			outclk <= ~outclk;	// toggle the output clock
		end
		
		else begin					// if counter is less than div_clk_count, increment the counter
		counter <= counter + 1;
		end
		
	end
	
endmodule
