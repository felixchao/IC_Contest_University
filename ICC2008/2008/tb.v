`timescale 1ns/10ps
`define CYCLE    100           	        // Modify your clock period here
`define SDFFILE  "./LCD_CTRL.sdf"	      // Modify your sdf file name
`define IMAGE    "./image2.dat"         // Modify your test image file: image1.dat or image2.dat
`define CMD      "./cmd2.dat"           // Modify your test cmd file: cmd1.dat or cmd2.dat
`define EXPECT   "./out_golden2.dat"    // Modify your output golden file: out_golden1.dat or out_golden2.dat

module tb;
parameter IMAGE_N_PAT = 108;
parameter CMD_N_PAT = 22;
parameter OUT_LENGTH= 352;
parameter t_reset = `CYCLE*2;

reg           clk;
reg           reset;
reg   [7:0]   datain;
reg   [2:0]   cmd;
reg           cmd_valid;
wire  [7:0]   dataout;
wire          output_valid;
wire          busy;

reg   [7:0]   image_mem [0:IMAGE_N_PAT-1];
reg   [2:0]   cmd_mem   [0:CMD_N_PAT-1];
reg   [7:0]   out_mem   [0:OUT_LENGTH-1];
reg   [7:0]   out_temp;

reg           pass_2a, pass_2b;
reg           show1, show3, show4, show5;
reg   [4:0]   verify;
integer       i, j, out_f, err, pass, pattern_num;
reg           over;

   LCD_CTRL top(.clk(clk), .reset(reset), .datain(datain), 
                .cmd(cmd), .cmd_valid(cmd_valid), .dataout(dataout), 
                .output_valid(output_valid), .busy(busy));          
   


//initial $sdf_annotate(`SDFFILE, top);

initial	$readmemh (`IMAGE,  image_mem);
initial	$readmemh (`CMD,    cmd_mem);
initial	$readmemh (`EXPECT, out_mem);

initial begin
   clk         = 1'b0;
   reset       = 1'b0;
   cmd_valid   = 1'b0;
   over        = 1'b0;
   pattern_num = 0;
   err         = 0;
   pass        = 0;    
   pass_2a     = 1;    
   pass_2b     = 1;          
   show1       = 1;
   show3       = 1;
   show4       = 1;   
   show5       = 1;   
   verify      = 5'b0;
end

always begin #(`CYCLE/2) clk = ~clk; end



initial begin
   out_f = $fopen("out.dat");
   if (out_f == 0) begin
        $display("Output file open error !");
        $finish;
   end
end

initial begin
   @(negedge clk)  reset = 1'b1;
   #t_reset        reset = 1'b0;
   
   @(negedge clk)    i=0;
   while (i <= CMD_N_PAT) begin               
      if(!busy) begin
        cmd = cmd_mem[i];
        cmd_valid = 1'b1;  
        
        if(cmd_mem[i] === 'd0) begin    //cmd: Load data        
           for(j=0; j<=IMAGE_N_PAT; j=j+1)begin
              @(negedge clk) datain = image_mem[j];
                             cmd = 'hz; cmd_valid = 1'b0;
           end
           i = i+1;
        end
        else begin                      //cmd: other command
           @(negedge clk) datain='hz; cmd_valid = 1'b0; i = i+1;
        end       
      end 
      else begin
         datain='hz; cmd = 'hz;  cmd_valid = 0;
         @(negedge clk);
      end               
    end                                       
end


always @(posedge clk)begin
   out_temp = out_mem[pattern_num];
   if(output_valid)begin
      $fdisplay(out_f,"%h", dataout);      
      if(dataout !== out_temp) begin
         $display("ERROR at %d:output %h !=expect %h ",pattern_num, dataout, out_temp);
         err = err + 1 ;
//         if(i=='d1) begin pass_2a=0; pass_2b=0; end
//         if(i>='d2 && i<='d6)   pass_2a=0;           
//         if(i>='d7 && i<='d11)  pass_2b=0;           
      end            
      else if(dataout === out_temp)begin      
         pass = pass + 1 ;
      end      
      #1 pattern_num = pattern_num + 1;
   end
   if(pattern_num === OUT_LENGTH)  over = 1'b1;      

/*   
   if(show1==1 && pass=='d16   && i=='d1)begin
     show1=0;  verify[0]=1'b1;
     $display("-----------------------------------------------------\n");
     $display("Congratulations! The first  test you have passed!\n");   
     $display("-----------------------------------------------------\n");
   end
   if((pass_2a || pass_2b )&& i=='d12 && pass>=5)begin
     pass_2a=0; pass_2b=0; verify[1]=1'b1;
     $display("-----------------------------------------------------\n");
     $display("Congratulations! The second test you have passed!\n");   
     $display("-----------------------------------------------------\n");
   end
   if(show3==1 && pass=='d368  && i=='d23)begin
     show3=0; verify[2]=1'b1;
     $display("-----------------------------------------------------\n");
     $display("Congratulations! The third  test you have passed!\n");   
     $display("-----------------------------------------------------\n");     
   end
   if(show4==1 && pass=='d1968  && i=='d123)begin
     show4=0; verify[3]=1'b1;
     $display("-----------------------------------------------------\n");   
     $display("Congratulations! The fourth test you have passed!\n");   
     $display("-----------------------------------------------------\n");     
   end
   if(show5==1 && pass=='d2080  && i=='d130)begin
     show5=0; verify[4]=1'b1;
     $display("-----------------------------------------------------\n");   
     $display("Congratulations! The fifth  test you have passed!\n");   
     $display("-----------------------------------------------------\n");     
   end
*/

end


initial begin
      @(posedge over)      
      if(pass === 'd352) begin
         $display("-----------------------------------------------------\n");
         $display("Congratulations! All data have been generated successfully!\n");
         $display("-------------------------PASS------------------------\n");
      end
      else begin
            $display("-----------------------------------------------------\n");
            $display("There are %d errors!\n", err);
            $display("-----------------------------------------------------\n");

/*
            $display("---------------------SUMMARY-------------------------\n");
            if(!(|verify))   $display("All test you have no passed!\n");
            else begin
               if(verify[0]) $display("Congratulations! The first  test you have passed!\n");
               if(verify[1]) $display("Congratulations! The second test you have passed!\n"); 
               if(verify[2]) $display("Congratulations! The third  test you have passed!\n"); 
               if(verify[3]) $display("Congratulations! The fourth test you have passed!\n"); 
               if(verify[4]) $display("Congratulations! The fifth  test you have passed!\n"); 
            end
            $display("-----------------------------------------------------\n");
*/
      end
      $finish;
end


   
endmodule
