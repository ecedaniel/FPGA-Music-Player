module address_control (
							input clk,							
							input clk_synced,					// clock synchronized signal used for timing reads
							input flash_reader_finished,	// signal indicating flash read is done
							input start,						// start address control
							input FWD,							// 1 for forward, 0 for reverse
							input R,								// reset song from keyboard
							input [31:0] data_in,			// input data bus from flash memory
							output start_next_flash,		// start next flash read
							output read,						
							output finish,
							output reg [3:0] byteenable,
							output reg [7:0] data_out,		// 8-bit output data selected from 32-bit input 
							output reg [22:0] address
);
    
	reg [6:0] state;
	
	parameter idle					= 7'b0000_000; // wait for start
	parameter readflash			= 7'b0001_110; // wait for flash reader to be finished
	parameter handle_read1		= 7'b0010_000; // begin storing lower byte of data_in to data_out
	parameter wait_read1 		= 7'b0011_000; // store lower byte of data_in to data_out
	parameter handle_read2		= 7'b0100_000; // begin storing upper byte of data_in to data_out 
	parameter wait_read2			= 7'b0101_000; // store upper byte of data_in to data_out
	parameter check_operation  = 7'b0110_000; // determine whether to increment or decrement
	parameter inc_addr			= 7'b0111_000; // increments address
	parameter dec_addr			= 7'b1000_000; // decrements address
	parameter finished			= 7'b1001_001; // current read cycle is finished
	
	assign read = state[2];
	assign start_next_flash = state[1];
	assign finish = state[0];
	
	always_ff @(posedge clk) begin
	
		case(state)
		
		idle: 
		if (start)
			state <= readflash;
		
		readflash:
		if (flash_reader_finished)
			state <= handle_read1;
			
		handle_read1:
		if (clk_synced)
			state <= wait_read1;
			
		wait_read1:
		state <= handle_read2;
		
		handle_read2:
		if (clk_synced)
			state <= wait_read2;
			
		wait_read2:
		state <= check_operation;
	
		check_operation:
		if (FWD == 1)
			state <= inc_addr;
		else
			state <= dec_addr;
		
		inc_addr:
		state <= finished;
		
		dec_addr:
		state <= finished;
		
		finished:
		state <= idle;
		
		default: state <= idle;
		
		endcase
	end
	
	always_ff @(posedge clk) begin
	
		case(state)
		
		// if FWD, choose the lower byte
		// else choose the upper byte
		wait_read1: 
		if (FWD)
			data_out <= data_in[15:8];
		else
			data_out <= data_in[31:24];
		
		// if FWD, choose the upper byte
		// else choose the lower byte
		wait_read2:
		if (FWD)
			data_out <= data_in[31:24];
		else
			data_out <= data_in[15:8];
		
		// Increments address
		inc_addr:
		if (address > 23'h7FFFF)
			address <= 23'h00000000000000000000000;
		else
			address <= address + 23'h00000000000000000000001;
		
		// Decrements address
		dec_addr:
	   if (address == 23'h00000000000000000000000)
			address <= 23'h7FFFF;
		else
			address <= address - 23'h00000000000000000000001;
			
		endcase
	end
	
endmodule
