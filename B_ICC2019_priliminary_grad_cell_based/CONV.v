
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


reg [2:0] state, NextState;
reg [3:0] counter;
reg signed [39:0] result;
reg signed [19:0] kernel,temp;
reg k_type;
reg up,down,left,right;
reg [19:0] local_max;
wire signed [39:0] mul;

assign mul = kernel * temp;


parameter Convolutional = 0;
parameter ReLU = 1;
parameter MaxPooling = 2;
parameter Flatten = 3;
parameter Finish = 4;

//Sequential circuit
always @(posedge clk or posedge reset) 
begin
	if(reset)
	begin
       iaddr <= 0;
	   busy <= 0;
	   result <= 0;
	   k_type <= 0;
	   cwr <= 0;
	   crd <= 0;
	   csel <= 0;
	   counter <= 0;
	   caddr_rd <= 0;
       local_max <= 0;
	   state <= Convolutional;
	end
	else
	begin
		state <= NextState;
	    case(state)
        Convolutional:begin
			           if(ready)
					   begin
					   	  busy <= 1;
					   end
					   else
					   begin
                        case(counter)
                        0:begin
							 if(k_type)
							 begin
							   result <= 40'hFF72950000;
                               kernel <= 20'h02F20;
							 end
							 else
							 begin
							   result <= 40'h0013100000;
							   kernel <= 20'hF8F71;
							 end
							 up <= (iaddr < 64);
							 left <= (iaddr[5:0] == 0);
							 right <= (iaddr[5:0] == 63);
							 down <= (iaddr > 4031);
							 temp <= idata;
							 iaddr <= iaddr + 1;
                             counter <= 1;
						  end

						1:begin
							 if(k_type)
                               kernel <= 20'h0202D;
							 else
							   kernel <= 20'hF6E54;
							 temp <= idata;
							 result <= result + mul;
							 iaddr <= iaddr + 62;
							 counter <= 2;
						  end

						2:begin
							 if(right)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'h03BD7;
							 else
							   kernel <= 20'hFA6D7;
							 temp <= idata;
							 iaddr <= iaddr + 1;
							 counter <= 3;
						  end

						3:begin
							 if(left || down)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'hFD369;
							 else
							   kernel <= 20'hFC834;
							 temp <= idata;
							 iaddr <= iaddr + 1;
							 counter <= 4;
						  end

						4:begin
							 if(down)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'h05E68;
							 else
							   kernel <= 20'hFAC19;
							 temp <= idata;
							 iaddr <= iaddr - 130;
							 counter <= 5;
						  end

						5:begin
							 if(down || right)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'hFDB55;
							 else
							   kernel <= 20'h0A89E;
							 temp <= idata;
							 iaddr <= iaddr + 1;
							 counter <= 6;
						  end

						6:begin
							 if(up || left)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'h02992;
							 else
							   kernel <= 20'h092D5;
							 temp <= idata;
							 iaddr <= iaddr + 1;
							 counter <= 7;
						  end

						7:begin
							 if(up)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'hFC994;
							 else
							   kernel <= 20'h06D43;
							 temp <= idata;
							 iaddr <= iaddr + 62;
							 counter <= 8;
						  end

						8:begin
							 if(up || right)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
							 if(k_type)
                               kernel <= 20'h050FD;
							 else
							   kernel <= 20'h01004;
							 temp <= idata;
							 iaddr <= iaddr + 1;
							 counter <= 9;
						  end
						
						9:begin
							 if(left)
							 begin
							 end
							 else
							 begin
								result <= result + mul;
							 end
                             counter <= 0;
						  end
						endcase
		              end
		           end

		ReLU:begin
			    if(k_type)
				begin
                    csel <= 2;
					iaddr <= iaddr + 1;
					k_type <= 0;
				end
				else
				begin
				    csel <= 1;
					k_type <= 1;
				end

                cwr <= 1;
				caddr_wr <= iaddr;
			    if(result > 0)
				begin
				  cdata_wr <= result[35:16] + (result[15] == 1);
				end
				else
				begin
				  cdata_wr <= 0;
				end
		     end

		MaxPooling:begin
                      case(counter)
                      0:begin						  
			              cwr <= 0;
					      crd <= 1;
						  if(k_type)
					      begin
                             csel <= 2;
					      end
					      else
					      begin
                             csel <= 1;
					      end					  
						  local_max <= 0;
						  counter <= 1;
					    end

					  1:begin
                           local_max <= (cdata_rd > local_max)?cdata_rd:local_max;
						   caddr_rd <= caddr_rd + 1;
						   counter <= 2;
					    end

					  2:begin
						   local_max <= (cdata_rd > local_max)?cdata_rd:local_max;
						   caddr_rd <= caddr_rd + 63;
                           counter <= 3;
					    end

                      3:begin
						   local_max <= (cdata_rd > local_max)?cdata_rd:local_max;
						   caddr_rd <= caddr_rd + 1;
                           counter <= 4;
					    end

                      4:begin
                           local_max <= (cdata_rd > local_max)?cdata_rd:local_max;
						   caddr_rd <= caddr_rd - 65;
                           counter <= 5;
					    end

					  5:begin
						   cwr <= 1;
						   cdata_wr <= local_max;
						   if(k_type)
					       begin
							 if(caddr_rd[5:0] == 62)
						     begin
                                caddr_rd <= caddr_rd + 66;
						     end
						     else
						     begin
                               caddr_rd <= caddr_rd + 2;
						     end
                             csel <= 4;
						     k_type <= 0;
					       end
					       else
					       begin
                             caddr_wr <= caddr_wr + 1;
                             csel <= 3;
						     k_type <= 1;
					       end
                           counter <= 0;
					    end
					  endcase
		           end
		
		Flatten:begin
                    case(counter)
					0:begin
                        cwr <= 0;
                        caddr_wr <= 4095;
						caddr_rd <= 4095;
						counter <= 1;
						k_type <= 0;
					  end

                    1:begin
						cwr <= 0;
						crd <= 1;
                        if(k_type)
						begin
                          csel <= 4;
						  k_type <= 0;
						end
                        else
						begin
						   caddr_rd <= caddr_rd + 1;
                           csel <= 3;
						   k_type <= 1;
						end
                        counter <= 2;
					  end

					2:begin
						cwr <= 1;
                        csel <= 5;
						cdata_wr <= cdata_rd;
						caddr_wr <= caddr_wr + 1;
                        counter <= 1;
					  end

					endcase
		        end

        Finish:begin
			     caddr_rd <= 0;
				 caddr_wr <= 0;
				 iaddr <= 0;
				 cwr <= 0;
				 crd <= 0;
			     busy <= 0;
				 counter <= 0;
				 k_type <= 0;
				 csel <= 0;
		       end
	
		endcase
	end
end

//State Machine
always@(*)
begin
    case(state)
    Convolutional:begin
		            if(counter == 9)
		              NextState = ReLU;
					else
					  NextState = Convolutional;
	              end

    ReLU:begin
		    if(k_type && iaddr == 4095)
			  NextState = MaxPooling;
			else
			  NextState = Convolutional;
	     end

    MaxPooling:begin
		         if(counter == 5 && k_type == 1 && caddr_wr == 1023)
				   NextState = Flatten;
				 else
				   NextState = MaxPooling;
	           end
	
	Flatten:begin
		       if(k_type && caddr_wr == 2047)
		          NextState = Finish;
			   else
			      NextState = Flatten;
	        end

    Finish:begin
	         NextState = Convolutional;
	       end

	default:begin
              NextState = Finish;
	        end

	endcase
end



endmodule




