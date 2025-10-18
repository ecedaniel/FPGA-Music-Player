module synchronizer (input async_sig, input outclk, output out_sync_sig);

	wire FDC_left_Q, FDC_middle_Q, FDC_1_Q;
	
	FDC FDC_left(.D(1'b1), .C(async_sig), .CLR(FDC_1_Q), .Q(FDC_left_Q));
	FDC FDC_middle(.D(FDC_left_Q), .C(outclk), .CLR(1'b0), .Q(FDC_middle_Q));
	FDC FDC_right(.D(FDC_middle_Q), .C(outclk), .CLR(1'b0), .Q(out_sync_sig));
	FDC FDC_1(.D(out_sync_sig), .C(~outclk), .CLR(1'b0), .Q(FDC_1_Q));	
	
endmodule
