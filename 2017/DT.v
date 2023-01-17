module DT(
	input 			clk, 
	input			reset,
	output	reg		done ,
	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input		[15:0]	sti_di,
	output	reg		res_wr ,
	output	reg		res_rd ,
	output	reg 	[13:0]	res_addr ,
	output	reg 	[7:0]	res_do,
	input		[7:0]	res_di
	);


reg [3:0] state;
reg [3:0] NextState;
reg [3:0] count;
reg [7:0] temp;
reg object;




parameter Initialize_Read = 0;
parameter Initialize_Write = 1;
parameter Initialize_Done = 2;
parameter Forward_Read = 3;
parameter Forward_Write = 4;
parameter Forward_Done = 5;
parameter Backward_Read = 6;
parameter Backward_Write = 7;
parameter Backward_Done = 8;
parameter Finish = 9;


//Sequential Circuit
always@(posedge clk or negedge reset)
begin
	if(!reset)
	begin
		state <= Initialize_Read;
		count <= 15;
		done <= 0;
		sti_rd <= 0;
		sti_addr <= 0;
		res_rd <= 0;
		res_wr <= 0;
		res_addr <= 16383;
		temp <= 0;
		object <= 0;
	end
	else 
	begin
		 state <= NextState;

         case(state)

		 Initialize_Read: begin
                              sti_rd <= 1;
						  end

		 

		 Initialize_Write: begin
			                   if(res_addr == 16382)
							   begin
								   res_addr <= res_addr + 1;
                                   res_do <= sti_di[count];
						           sti_rd <= 0;
                                   count <= 0;
							   end
			                   else if(count == 0)
							   begin
								   res_do <= sti_di[count];
                                   res_addr <= res_addr + 1;
								   sti_addr <= sti_addr + 1;
                                   count <= 15;
							   end
							   else
							   begin
                                    res_wr <= 1;
									res_do <= sti_di[count];
                                    res_addr <= res_addr + 1;
									count <= count - 1;
							   end
		                   end

		Initialize_Done:begin
                           res_wr <= 0;
						   res_rd <= 1;
						   res_addr <= 0;
		                end	

		Forward_Read:begin
                         if(res_di == 1)
						    object <= 1;
						 else
						    object <= 0;
		             end

        Forward_Write:begin
						if(object == 1)
						begin
                            case(count)
							0:begin
							     res_addr <= res_addr - 129;
								 count <= 1;
							  end

							1: begin
                                  temp <= res_di;
								  res_addr <= res_addr + 1;
								  count <= 2;
							   end
							2: begin
                                  temp <= (res_di < temp ? res_di : temp);
								  res_addr <= res_addr + 1;
								  count <= 3;
						       end

							3: begin
                                  temp <= (res_di < temp ? res_di : temp);
								  res_addr <= res_addr + 126;
								  count <= 4;
							   end

							4: begin
                                  temp <= (res_di < temp? res_di : temp);
								  res_addr <= res_addr + 1;
								  count <= 5;
							   end

							5: begin
								  res_wr <= 1;
                                  res_do <= temp + 1;
								  count <= 0;
							   end
							endcase
						end
		              end

		 Forward_Done: begin
			              if(res_addr == 16383)
						  begin
							 res_wr <= 0;
                             res_addr <= 16383;
						  end
						  else
						  begin
			                res_wr <= 0;
						    res_rd <= 1;
			                res_addr <= res_addr + 1;
						  end
		               end

		 Backward_Read: begin
                          if(res_di > 0)
						      object <= 1;
						  else
						      object <= 0;
		                end

		 Backward_Write: begin
						if(object == 1)
						begin
                            case(count)
							0:begin
								 temp <= res_di;
							     res_addr <= res_addr + 129;
								 count <= 1;
							  end

							1: begin
                                  temp <= ((res_di+1) < temp ? (res_di+1) : temp);
								  res_addr <= res_addr - 1;
								  count <= 2;
							   end
							2: begin
                                  temp <= ((res_di+1) < temp ? (res_di+1) : temp);
								  res_addr <= res_addr - 1;
								  count <= 3;
						       end

							3: begin
                                  temp <= ((res_di+1) < temp ? (res_di+1) : temp);
								  res_addr <= res_addr - 126;
								  count <= 4;
							   end

							4: begin
                                  temp <= ((res_di+1) < temp ? (res_di+1) : temp);
								  res_addr <= res_addr - 1;
								  count <= 5;
							   end

							5: begin
								  res_wr <= 1;
                                  res_do <= temp;
								  count <= 0;
							   end
							endcase
						end
		                end

		 Backward_Done: begin
			                res_wr <= 0;
						    res_rd <= 1;
			                res_addr <= res_addr - 1;
		                end

		Finish: begin
                     done <= 1;
		        end
	     endcase
	end
end



//State Machine
always@(*)
begin
	case(state)
	Initialize_Read:begin
		              NextState = Initialize_Write;
	                end

	Initialize_Write:begin
                       if(res_addr == 16382)
					      NextState = Initialize_Done;
					   else
					      NextState = Initialize_Write;
	                 end

	Initialize_Done:begin
                         NextState = Forward_Read;
	                end

    Forward_Read:begin
		             NextState = Forward_Write;
				 end

    Forward_Write:begin
                      if(count == 5 || object == 0)
                        NextState = Forward_Done;
					  else
					    NextState = Forward_Write;
	              end

    Forward_Done:begin
		             if(res_addr == 16383)
					   NextState = Backward_Read;
					 else
		               NextState = Forward_Read;
	             end

    Backward_Read: begin
                       NextState = Backward_Write;
	               end

	Backward_Write: begin
                        if(count == 5 || object == 0)
						  NextState = Backward_Done;
						else
						  NextState = Backward_Write;
	                end

	Backward_Done: begin
                       if(res_addr == 0)
					     NextState = Finish;
					   else
					     NextState = Backward_Read;
	               end

	Finish:begin
		       NextState = Finish;
	       end

	default: begin
                  NextState = NextState;
	         end

	endcase
end



endmodule
