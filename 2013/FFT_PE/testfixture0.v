`timescale 1ns/10ps
`define CYCLE     10                 // Modify your clock period here
//`define SDFFILE    ""    // Modify your sdf file name
`define End_CYCLE  100000          // Modify cycle times once your design need more cycle times!


`define fft_fail_limit 3



module testfixture0;

reg   clk ;
reg   reset ;
reg [31:0] fir_a, fir_b; 
reg ab_valid;

wire [31:0] fft_a, fft_b;

wire fft_ab_valid;

reg [2:0] power;



reg en;

reg [15:0] ab_real [0:15];
initial $readmemh("./dat/PE_FFT_PATTERN_real.dat", ab_real);

reg [15:0] ab_imag [0:15];
initial $readmemh("./dat/PE_FFT_PATTERN_imag.dat", ab_imag);



reg [15:0] fftr_mem [0:15];
initial $readmemh("./dat/PE_FFT_EXPECTED_real.dat", fftr_mem);
reg [15:0] ffti_mem [0:15];
initial $readmemh("./dat/PE_FFT_EXPECTED_imag.dat", ffti_mem);

integer i, j ,k, l;
integer fir_fail, fft_fail;


FFT_PE PE(.a(fir_a), .b(fir_b), .ab_valid(ab_valid), .clk(clk), .rst(reset),
.fft_a(fft_a), .fft_b(fft_b), .fft_pe_valid(fft_pe_valid), .power(power));

`ifdef SDFFILE
initial $sdf_annotate(`SDFFILE, PE);
`endif


//initial begin
//$fsdbDumpfile("FFT_PE.fsdb");
//$fsdbDumpvars;
//end



initial begin
#0;
   clk         = 1'b0;
   reset       = 1'b0; 
   i = 0;   
   j = 0;  
   k = 1;
   l = 0;
   fir_fail = 0;
   fft_fail = 0;
   
end

initial power = 0;

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	ab_valid = 0;
   #(`CYCLE*0.5)   reset = 1'b1; 
   #(`CYCLE*2); #0.5;   reset = 1'b0; ab_valid = 1;
end

// data input & ready
always@(negedge clk ) begin
	if (ab_valid) begin
		fir_a <= {ab_real[2*i], ab_imag[2*i]};
		fir_b <= {ab_real[2*i+1], ab_imag[2*i+1]};
		i <= i + 1;
	end
end

//============================================================================================================
//============================================================================================================
//============================================================================================================
wire [15:0] test1 = fftr_mem[10];

// FIR data output verify
reg fft_verify, fft_a_verify , fft_b_verify;
reg [31:0] fft_a_ver, fft_b_ver;
reg [15:0] fftr_a_reg, ffti_a_reg, fftr_b_reg, ffti_b_reg;
always@(posedge clk) begin
	if (fft_pe_valid) begin	
		fftr_a_reg = fftr_mem[2*j]; ffti_a_reg = ffti_mem[2*j];
		fftr_b_reg = fftr_mem[2*j+1]; ffti_b_reg = ffti_mem[2*j+1];
		fft_a_ver = {fftr_a_reg,ffti_a_reg};
		fft_b_ver = {fftr_b_reg, ffti_b_reg};
		
		fft_a_verify = ((fft_a_ver == fft_a+1) || (fft_a_ver == fft_a) || (fft_a_ver == fft_a-1) || (fft_a_ver == fft_a+16'h0100) || (fft_a_ver == fft_a-16'h0100));
		fft_b_verify = ((fft_b_ver == fft_b+1) || (fft_b_ver == fft_b) || (fft_b_ver == fft_b-1) || (fft_b_ver == fft_b+16'h0100) || (fft_b_ver == fft_b-16'h0100));
		
		fft_verify = fft_a_verify & fft_b_verify;
		if ( (!fft_verify) || (fft_a === 16'bx) || (fft_a === 16'bz)  || (fft_b === 16'bx) || (fft_b === 16'bz) ) begin
			$display("----- ERROR at FFT cycle %3d !! -------", j);
			$display("The expected a's response output of real part is %h, The imag part is %h !" ,fftr_a_reg, ffti_a_reg);
			$display("The expected b's response output of real part is %h, The imag part is %h !" ,fftr_b_reg, ffti_b_reg);
			$display("The real response output of a is %h, The b is %h !" ,fft_a, fft_b);
			$display("---------------------------------------------------------------------------------------------");
			fft_fail <= fft_fail + 1;
		end
		j=j+1;
	end
end

//============================================================================================================
//============================================================================================================
//============================================================================================================




//============================================================================================================
//============================================================================================================
//============================================================================================================
// Final result verify

// Terminate the simulation, FAIL
initial  begin
 #(`CYCLE * `End_CYCLE);
 $display("-----------------------------------------------------");
 $display("Error!!! Somethings' wrong with your code ...!!");
 $display("-------------------------FAIL------------------------");
 $display("-----------------------------------------------------");
 $finish;
end



always@(*) begin
	if (fft_fail >= `fft_fail_limit) begin
		$display("-----------------------------------------------------\n");
 		$display("Error!!! There are more than %d errors for FFT output !", `fft_fail_limit);
 		$display("-------------------------FAIL------------------------\n");
		$finish;
	end	
end


// Terminate the simulation, PASS
initial begin
      wait(fft_pe_valid);
      wait(j==7)
      if (fft_fail == 0) begin	 
      #(`CYCLE);      
         $display("-----------------------------------------------------\n");
         $display("Congratulations! All data have been generated successfully!\n");
         $display("-------------------------PASS------------------------\n");
      #(`CYCLE/2); $finish;
      end
end








endmodule
