module speed_control (
					clk,
					speed_up_event,
					speed_down_event,
					speed_reset_event,
					clk_div_out
);

	input clk;
	input speed_up_event;
	input speed_down_event;
	input speed_reset_event;
	output reg [31:0] clk_div_out = 32'h266;
	
	always_ff @(posedge clk) begin
	
		if(speed_up_event)
			clk_div_out <= clk_div_out - 32'h1;
		
		else if(speed_down_event)
			clk_div_out <= clk_div_out + 32'h1;
		
		else if(speed_reset_event)
			clk_div_out <= 32'h266;
		
	end

endmodule
	
			