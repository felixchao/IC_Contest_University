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
output reg [31:0] fft_a, fft_b;
output reg fft_pe_valid;


reg signed [31:0] W_real, W_imag;
wire signed [31:0] a_real, a_imag, b_real, b_imag;
wire signed [31:0] r_temp, i_temp;

assign a_real = $signed(a[31:16]);
assign b_real = $signed(b[31:16]);
assign a_imag = $signed(a[15:0]);
assign b_imag = $signed(b[15:0]);
assign r_temp = (a_real - b_real) * W_real + (b_imag - a_imag) * W_imag;
assign i_temp = (a_real - b_real) * W_imag + (a_imag - b_imag) * W_real;


//valid output
always @(posedge clk or posedge rst) 
begin
	if(rst)
	begin
      fft_pe_valid <= 0;
	end
	else
	begin
	   if(ab_valid)
	   begin
         fft_pe_valid <= 1;
	   end
	   else
	   begin
         fft_pe_valid <= 0;
	   end
	end
end

always @(negedge clk or posedge rst)
begin
	if(rst)
	begin
       // do nothing
	end
	else
	begin
       fft_b[31:16] = r_temp[31:16];
       fft_b[15:0] = i_temp[31:16];
       fft_a[31:16] = a_real + b_real;
       fft_a[15:0] = a_imag + b_imag;
	end
end


//Decoder
always @(*)
begin
    case(power)
    0:{W_real,W_imag} = {32'h00010000,32'h00000000};
	1:{W_real,W_imag} = {32'h0000EC83,32'hFFFF9E09};
	2:{W_real,W_imag} = {32'h0000B504,32'hFFFF4AFC};
	3:{W_real,W_imag} = {32'h000061F7,32'hFFFF137D};
	4:{W_real,W_imag} = {32'h00000000,32'hFFFF0000};
	5:{W_real,W_imag} = {32'hFFFF9E09,32'hFFFF137D};
	6:{W_real,W_imag} = {32'hFFFF4AFC,32'hFFFF4AFC};
	7:{W_real,W_imag} = {32'hFFFF137D,32'hFFFF9E09};
	endcase
end


endmodule

