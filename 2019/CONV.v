
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output	reg	busy,	
	input		ready,	
			
	output	reg [11:0]	iaddr,
	input	[19:0]	idata,	
	
	output	reg	cwr,
	output	reg [11:0] caddr_wr,
	output	reg [19:0] cdata_wr,
	
	output	reg crd,
	output	reg [11:0] caddr_rd,
	input	[19:0] 	cdata_rd,
	
	output	reg [2:0] csel
	);


reg [2:0] state;
reg [2:0] Nextstate;
reg [19:0] cur;
reg [11:0] cpos;
reg [3:0] count;
reg [19:0] temp;
reg has;
reg [39:0] result;
wire up,down,left,right;
wire [39:0] mul;
reg [10:0] count2;

parameter Load = 0;
parameter Convolutional = 1;
parameter Pooling = 2;
parameter Write = 3;
parameter Reset = 4;

assign mul = cur*temp;
assign up = (cpos < 64);
assign down = (cpos > 4031);
assign left = (cpos[5:0] == 0);
assign right = (cpos[5:0] == 63);

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		state <= Load;
		busy <= 0;
		crd <= 0;
		cwr <= 0;
		csel <= 0;
		count <= 0;
		count2 <= 0;
		has <= 0;
		cpos <= 0;
	end
	else
	begin
		state <= Nextstate;

		case(state)
        Load:begin
                  if(ready)
				  begin
					  busy <= 1;
				  end
				  else
				  begin 
                       case(count)
                       0:begin
					  			if(up||left)
					  			begin
									has <= 0;
					  			end
					  			else
					  			begin
						  			iaddr <= cpos - 65;
									has <= 1;
					  			end
								count <= count + 1;                               
					     end
                       1:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;

					  			if(up)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos - 64;
						  			has <= 1;
					  			end  
								  temp <= 20'h0A89E; 
								  count <= count + 1;                            
					   end

                       2:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;

					  			if(up||right)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos - 63;
						  			has <= 1;
					  			end  
								result <= result + mul; 
								temp <= 20'h092D5;  
								count <= count + 1;                          
					     end
                       3:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;

					  			if(left)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos - 1;
						  			has <= 1;
					  			end    
								result <= result + mul;
								temp <= 20'h06D43;
								count <= count + 1;                          
					     end
                       4:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;
                                has <= 1;
					  			iaddr <= cpos;
								result <= result + mul;
								temp <= 20'h01004;  
								count <= count + 1;                          
					     end
                       5:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;
					  			if(right)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos + 1;
						  			has <= 1;
					  			end         
								result <= result + mul;
								temp <= 20'h0708F;  
								count <= count + 1;                
					     end
                       6:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;
					  			if(down||left)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos + 63;
						  			has <= 1;
					  			end          
								result <= result - mul; 
								temp <= 20'h091AC;   
								count <= count + 1;             
					     end
                       7:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;
					  			if(down)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos + 64;
						  			has <= 1;
					  			end          
								result <= result - mul;
								temp <= 20'h05929;    
								count <= count + 1;             
					     end
                       8:begin
						        if(has)
						        	cur <= idata;
								else
								    cur <= 0;
					  			if(down||right)
					  			begin
                                     has <= 0;
					  			end
					  			else
					  			begin
									iaddr <= cpos + 65;
						  			has <= 1;
					  			end             
								result <= result - mul;
								temp <= 20'h037CC;  
								count <= count + 1;            
					     end
					   9:begin
                             	if(has)
						        	cur <= idata;
								else
								    cur <= 0;
								result <= result - mul;
								temp <= 20'h053E7;
								count <= count + 1;
					     end
					   10:begin
                                result <= result - mul + 40'h13100000;
					      end
					   endcase
				  end
		     end

		Convolutional:begin
			                csel <= 1;
			                cwr <= 1;
							caddr_wr <= cpos;
                            if(result[39] == 1'b0 && result != 0)
							begin
								if(result[15] == 1)
								   cdata_wr <= result[38:16]+1;
								else
								   cdata_wr <= result[38:16];
							end
							else
							begin
								cdata_wr <= 0;
							end
							result <= 0;
							count <= 0;
							if(cpos == 4095)
							begin
							   cpos <= 1;
							end
							else
                              cpos <= cpos + 1;
					  end


		Pooling:begin
			         cwr <= 0;
					 crd <= 1;
					 csel <= 1;
                     case(count)
                     0:begin
                            caddr_rd <= cpos - 1;
							count <= count + 1;
					   end
                     1:begin
                            caddr_rd <= cpos;
							temp <= cdata_rd;
							count <= count + 1;
					   end
                     2:begin
                            caddr_rd <= cpos + 63;
							temp <= (cdata_rd > temp) ? cdata_rd:temp;
							count <= count + 1;
					 end
                     3:begin
                            caddr_rd <= cpos + 64;
							temp <= (cdata_rd > temp) ? cdata_rd:temp;
							count <= count + 1;
					   end
					 4:begin
                            temp <= (cdata_rd > temp) ? cdata_rd:temp;
							count <= 0;
					   end
					 endcase
		        end


		Write:begin
                  crd <= 0;
				  cwr <= 1;
				  csel <= 3;
				  caddr_wr <= count2;
                  cdata_wr <= temp;
				  if(cpos == 4032)
				  begin
					  cpos <= 0;
				  end
				  else
				  begin
					  if(cpos[5:0] == 63)
                      cpos <= cpos + 66;
					  else
                      cpos <= cpos + 2;
				  end
                  count2 <= count2 + 1;
		      end

		Reset: begin
                    busy <= 0;
					crd <= 0;
					cwr <= 0;
					csel <= 0;
					count2 <= 0;
					cpos <= 0;
		       end

		
        
		

		endcase
	end
end


always@(*)
begin
	case(state)       
	 Load:begin
			   if(count == 10)
			   begin
				   Nextstate = Convolutional;
			   end
			   else
			   begin
				   Nextstate = Load;
			   end
		  end
	Convolutional: begin
                        if(cpos == 4095)
						begin
							Nextstate = Pooling;
						end
						else
						begin
							Nextstate = Load;
						end
	               end
	Pooling: begin
                   if(count == 4)
				   begin
					   Nextstate = Write;
				   end
				   else
				   begin
					   Nextstate = Pooling;
				   end
	         end

    Write: begin
                if(count2 == 1023)
				begin
					Nextstate = Reset;
				end
				else
				begin
					Nextstate = Pooling;
				end
	       end


	Reset: begin
		      Nextstate = Load;
	       end
	endcase
end


endmodule




