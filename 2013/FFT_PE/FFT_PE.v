module FFT_PE(
			 clk, 
			 rst, 			 
			 a, 
			 b,
			 power,			 
			 ab_valid, 
			 fft_a, 
			 fft_b,
			 fft_pe_valid
			 );
input clk, rst; 		 
input signed [31:0] a, b;
input [2:0] power;
input ab_valid;		
output [31:0] fft_a, fft_b;
output fft_pe_valid;

endmodule

