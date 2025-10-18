module keyboard_control (
								clk,
								finish,
								key,
								kbd_data_ready,
								start,
								restart,
								FWD
);

	input clk, finish, kbd_data_ready;
	input [7:0] key;
	output start, restart, FWD;
	
	reg [5:0] state;

	//Uppercase Letters
	parameter character_A =8'h41;
	parameter character_B =8'h42;
	parameter character_C =8'h43;
	parameter character_D =8'h44;
	parameter character_E =8'h45;
	parameter character_F =8'h46;
	parameter character_G =8'h47;
	parameter character_H =8'h48;
	parameter character_I =8'h49;
	parameter character_J =8'h4A;
	parameter character_K =8'h4B;
	parameter character_L =8'h4C;
	parameter character_M =8'h4D;
	parameter character_N =8'h4E;
	parameter character_O =8'h4F;
	parameter character_P =8'h50;
	parameter character_Q =8'h51;
	parameter character_R =8'h52;
	parameter character_S =8'h53;
	parameter character_T =8'h54;
	parameter character_U =8'h55;
	parameter character_V =8'h56;
	parameter character_W =8'h57;
	parameter character_X =8'h58;
	parameter character_Y =8'h59;
	parameter character_Z =8'h5A;

	//Lowercase Letters
	parameter character_lowercase_a= 8'h61;
	parameter character_lowercase_b= 8'h62;
	parameter character_lowercase_c= 8'h63;
	parameter character_lowercase_d= 8'h64;
	parameter character_lowercase_e= 8'h65;
	parameter character_lowercase_f= 8'h66;
	parameter character_lowercase_g= 8'h67;
	parameter character_lowercase_h= 8'h68;
	parameter character_lowercase_i= 8'h69;
	parameter character_lowercase_j= 8'h6A;
	parameter character_lowercase_k= 8'h6B;
	parameter character_lowercase_l= 8'h6C;
	parameter character_lowercase_m= 8'h6D;
	parameter character_lowercase_n= 8'h6E;
	parameter character_lowercase_o= 8'h6F;
	parameter character_lowercase_p= 8'h70;
	parameter character_lowercase_q= 8'h71;
	parameter character_lowercase_r= 8'h72;
	parameter character_lowercase_s= 8'h73;
	parameter character_lowercase_t= 8'h74;
	parameter character_lowercase_u= 8'h75;
	parameter character_lowercase_v= 8'h76;
	parameter character_lowercase_w= 8'h77;
	parameter character_lowercase_x= 8'h78;
	parameter character_lowercase_y= 8'h79;
	parameter character_lowercase_z= 8'h7A;
	
	parameter idle 				= 6'b000_000;	// wait for begin
	parameter forward				= 6'b001_101;	// forward play mode 
	parameter forward_reset		= 6'b010_111;	// reset 
	parameter forward_pause    = 6'b011_001;	// pause
	parameter backward			= 6'b100_100;	// backward play mode
	parameter backward_reset	= 6'b101_110;	// reset
	parameter backward_pause 	= 6'b110_000;	// pause
	
	assign start = state[2];
	assign restart = state[1];
	assign FWD = state[0];
	
	always_ff @(posedge clk) begin
		
		case(state)
		
		// idle: check for begin(e) or backward(b)
		idle: 
		if ((key == character_E) || (key == character_lowercase_e))
			state <= forward;
		else if ((key == character_B) || (key == character_lowercase_b))
			state <= backward;
		else
			state <= idle;
		
		
		// forward: check for pause(d), reset(r), or backward(b)
		forward:
		if ((key == character_D) || (key == character_lowercase_d))
			state <= forward_pause;
		else if ((key == character_R) || (key == character_lowercase_r))
			state <= forward_reset;
		else if ((key == character_B) || (key == character_lowercase_b))
			state <= backward;
		else
			state <= forward;
			
		// forward_reset: check for finish then restarts
		forward_reset:
		if (finish)
			state <= forward;
		else
			state <= forward_reset;
		
		// forward_pause: checks for resume(e), restart(r), or backward(b)
		forward_pause:
		if ((key == character_E) || (key == character_lowercase_e))
			state <= forward;
		else if ((key == character_R) || (key == character_lowercase_r))
			state <= forward_reset;
		else if ((key == character_B) || (key == character_lowercase_b))
			state <= backward_pause;
		else
			state <= forward_pause;
			
		// backward: checks for forward(f), pause(d), or reset(r)	
		backward:
		if ((key == character_F) || (key == character_lowercase_f))
			state <= forward;
		else if ((key == character_D) || (key == character_lowercase_d))
			state <= backward_pause;
		else if ((key == character_R) || (key == character_lowercase_r))
			state <= backward_reset;
		else
			state <= backward;
		
		// backward_reset: checks for finish then restarts
		backward_reset:
		if (finish)
			state <= backward;
		else
			state <= backward_reset;
		
		// backward_pause: checks for forward(f), restart(r) or resume(e)
		backward_pause:
		if ((key == character_F) || (key == character_lowercase_f))
			state <= forward_pause;
		else if ((key == character_R) || (key == character_lowercase_r))
			state <= backward_reset;
		else if ((key == character_E) || (key == character_lowercase_e))
			state <= backward;
		else
			state <= backward_pause;
			
		default: state <= idle;
		
		endcase
		
	end
	
endmodule
	