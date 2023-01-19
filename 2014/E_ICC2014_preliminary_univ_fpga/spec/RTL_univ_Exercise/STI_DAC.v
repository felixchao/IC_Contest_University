module STI_DAC(clk ,reset, load, pi_data, pi_length, pi_fill, pi_msb, pi_low, pi_end,
	       so_data, so_valid,
	       pixel_finish, pixel_dataout, pixel_addr,
	       pixel_wr);

input		clk, reset;
input		load, pi_msb, pi_low, pi_end; 
input	[15:0]	pi_data;
input	[1:0]	pi_length;
input		pi_fill;
output reg	so_data, so_valid;

output reg pixel_finish, pixel_wr;
output reg [7:0] pixel_addr;
output reg [7:0] pixel_dataout;


reg [2:0] state, NextState;
reg [31:0] buffer;
reg [4:0] start, counter;
reg [2:0] counter_8bits;



parameter Load_Data = 0;
parameter Decoder = 1;
parameter Sequential_Output = 2;
parameter Finish = 3;


//==============================================================================


//Sequential Circuit
always@(posedge clk or posedge reset)
begin
     if(reset)
	 begin
        pixel_finish <= 0;
		pixel_wr <= 0;
		so_valid <= 0;
		pixel_addr <= 255;
		state <= Load_Data;
		counter_8bits <= 7;
	 end
	 else
	 begin
         state <= NextState;

		 case(state)
		 Load_Data: begin
			           so_valid <= 0;
					   pixel_wr <= 0;
			           if(load)
					   begin
                           if(pi_fill && (pi_length == 2'b10 || pi_length == 2'b11))
						   begin
							   if(pi_length == 2'b10)
							   begin
                                    buffer [7:0] <= 0; 
							        buffer [31:8] <= pi_data;  
							   end
							   else if(pi_length == 2'b11)
							   begin
                                    buffer [15:0] <= 0; 
							        buffer [31:16] <= pi_data;  
							   end
						   end
						   else
						   begin
                                buffer [15:0] <= pi_data;
								buffer [31:16] <= 0;
						   end
					   end
		            end

         Decoder: begin
                       case(pi_length)
                             2'b00: begin
                                        if(!pi_low)
                                        begin
                                           if(!pi_msb)
										   begin
                                               start <= 0;
										       counter <= 7;
										   end
										   else
										   begin
                                               start <= 7;
										       counter <= 7;
										   end
										end
										else
										begin
                                           if(!pi_msb)
										   begin
                                               start <= 8;
										       counter <= 7;
										   end
										   else
										   begin
                                               start <= 15;
										       counter <= 7;
										   end
										end
							        end


							 2'b01: begin
                                        if(!pi_msb)
										begin
                                            start <= 0;
										    counter <= 15;
										end
										else
										begin
                                           start <= 15;
										   counter <= 15;
										end
							        end


							 2'b10: begin
                                       if(!pi_msb)
										begin
											start <= 0;
										    counter <= 23;
										end
									    else
										begin
											start <= 23;
										    counter <= 23;
										end
							        end


							 2'b11: begin
                                       if(!pi_msb)
										begin
											start <= 0;
										    counter <= 31;
										end
									    else
										begin
											start <= 31;
										    counter <= 31;
										end
							        end
									
					endcase
					end

		Sequential_Output: begin
			                    if(counter_8bits == 0)
								begin
									 pixel_wr <= 1;
                                     pixel_addr <= pixel_addr + 1;
								end
								else
								begin
                                     pixel_wr <= 0;
								end

                                so_valid <= 1;
								so_data <= buffer[start];

								pixel_dataout[counter_8bits] <= buffer[start];

                                if(!pi_msb)
								begin
                                    start <= start + 1;
								end
								else
								begin
                                    start <= start - 1;
								end

								counter <= counter - 1;
								counter_8bits <= counter_8bits - 1;
		                   end

		Finish: begin
			        if(pixel_addr == 255)
					begin
			           pixel_finish <= 1;
					   pixel_wr <= 0;
					end
					else
					begin
					   pixel_wr <= 1;
					   pixel_addr <= pixel_addr + 1;
					   pixel_dataout <= 0;
					end
                end
		endcase

	 end
end


//State Machine
always@(*)
begin
     case(state)
     Load_Data: begin
	                  if(pi_end)
		                 NextState = Finish;
					  else if(load)
					     NextState = Decoder;
					  else
					     NextState = Load_Data;
            	end

	 Decoder: begin
                 NextState = Sequential_Output;
	          end

	 Sequential_Output: begin
		                     if(counter == 0)
							   NextState = Load_Data;
							 else
							   NextState = Sequential_Output;
	                    end
     Finish: begin
		          if(pixel_addr == 255)
                    NextState = Finish;
				  else 
				    NextState = Load_Data;
	         end

	 endcase
end




endmodule
