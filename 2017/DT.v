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


reg [2:0] state;
reg [2:0] NextState;
reg [3:0] count;




parameter Initialize = 0;
parameter Read_Forward = 1;
parameter Write_Forward = 2;
parameter Read_Backward = 3;
parameter Write_Backward = 4;
parameter Done = 5;



//Sequential Circuit
always@(posedge clk or negedge reset)
begin
	if(!reset)
	begin
		state <= Initialize;
		count <= 0;
		done <= 0;
		sti_rd <= 0;
		sti_addr <= 0;
		res_rd <= 0;
		res_wr <= 0;
		res_addr <= 0;
	end
	else 
	begin
		 state <= NextState;

         case(state)

		 Initialize: begin
                          if(sti_addr == 1023)
						  begin
                            
						  end
						  else
						  begin
							sti_rd <= 1;
							sti_addr <= sti_addr + 1;
						  end

		             end

		 Forward_Pass: begin
			                if(count == 16384)
							begin
								sti_rd <= 0;
							end
							else
							begin
								sti_rd <= 1;
							    sti_addr <= count;
							    count <= count + 1;
							    i <= 0;
							end
		               end

	    Window_Calculate: begin
                              if(i == 15)
							  begin
                                   
							  end
							  else
							  begin
								  if(sti_di[i] == 1)
								  begin
									 
								  end
								  last_pixel <= 
								  i <= i+1;
							  end
		                  end

		Write_Forward:begin
                           
		              end			
		 endcase
	end
end



//State Machine
always@(*)
begin
	case(state)
	Initialize:begin
		             
	           end
    Forward_Pass:begin
                    NextState = Window_Calculate;
	             end

    Window_Calculate: begin
                           NextState = Write_Forward;
		              end				 

    Write_Forward:begin
                         NextState = Forward_Pass;
	               end

    Backward_pass:begin
		              NextState = Backward_pass;
	              end
	endcase
end



endmodule
