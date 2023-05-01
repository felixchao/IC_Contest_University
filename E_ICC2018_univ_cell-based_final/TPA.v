module TPA(clk, reset_n, 
	   SCL, SDA, 
	   cfg_req, cfg_rdy, cfg_cmd, cfg_addr, cfg_wdata, cfg_rdata);
input 		clk; 
input 		reset_n;
// Two-Wire Protocol slave interface 
input 		SCL;  
inout		SDA;

// Register Protocal Master interface 
input		cfg_req;
output	reg	cfg_rdy;
input		cfg_cmd;
input	[7:0]	cfg_addr;
input	[15:0]	cfg_wdata;
output	reg [15:0]  cfg_rdata;

reg	[15:0] Register_Spaces	[0:255];

reg [1:0] rim_state, rim_nextstate; 
reg [2:0] twm_state, twm_nextstate;
reg rim_cmd, twm_cmd;
reg [3:0] counter;
reg [7:0] twm_addr;
reg [2:0] twm_step;
reg rim_work, both_work, twm_first;



parameter Load_cmd = 0;
parameter Rim_Decode = 1, Twm_Decode = 1;
parameter Finish_rim = 2;
parameter Twm_addr = 2;
parameter Twm_Write_data = 3;
parameter Twm_Read_data = 4;
parameter Finish_twm = 5;


// ===== Coding your RTL below here ================================= 

assign SDA = (twm_step == 2 || twm_step == 5)?1:((twm_step == 3)?0:((twm_step == 4)?Register_Spaces[twm_addr][counter]:1'bz));

//State Machine for rim and twm
always @(posedge clk or negedge reset_n) 
begin
	if(!reset_n)
	begin
       rim_state <= Load_cmd;
	   twm_state <= Load_cmd;
	end
	else
	begin
       rim_state <= rim_nextstate;
	   twm_state <= twm_nextstate;
	end
end

//Sequential Circuit for rim
always @(posedge clk or negedge reset_n) 
begin
	if(!reset_n)
	begin
       cfg_rdy <= 0;
	   rim_work <= 0;
	end
	else
	begin
	    case(rim_state)
        Load_cmd:begin
                    if(cfg_req)
					begin
					   cfg_rdy <= 1;
                       rim_cmd <= cfg_cmd;
					   if(cfg_cmd)
					   begin
                          rim_work <= 1;
					   end
					end
		         end

		Rim_Decode:begin
			          rim_work <= 0;
					  if(!rim_cmd)
					  begin
                         cfg_rdata <= Register_Spaces[cfg_addr]; 
					  end
		           end

		Finish_rim:begin
			      cfg_rdy <= 0;
		       end
	    endcase
	end
end

//Sequential Circuit for twm
always @(posedge SCL or negedge reset_n) 
begin
	if(!reset_n)
	begin
       counter <= 0;
	   twm_step <= 0;
	   both_work <= 0;
	   twm_first <= 0;
	end
	else
	begin
	    case(twm_state)
        Load_cmd:begin
                     //Do nothing
		         end

		Twm_Decode:begin
                      twm_cmd <= SDA;
					  if(SDA && rim_work)
					     both_work <= 1;
					  else if(SDA && rim_state < Rim_Decode)
					     twm_first <= 1;
		           end

		Twm_addr:begin
			         if(counter == 7)
					 begin
                        twm_addr[counter] <= SDA;
                        counter <= 0;
					 end
					 else
					 begin
                        twm_addr[counter] <= SDA;
					    counter <= counter + 1;
					 end
		          end

		Twm_Write_data:begin
			         if(counter == 15)
					 begin
                        counter <= 0;
					 end
					 else
					 begin
					    counter <= counter + 1;
					 end			
		             end

	    Twm_Read_data:begin
                         case(twm_step)
                         0:begin
							 twm_step <= 1;
						   end

						 1:begin
							 twm_step <= 2;
						   end

						 2:begin
                             twm_step <= 3;							 
						   end
						
						3:begin
                             twm_step <= 4;	
						  end

						4:begin
							if(counter == 15)
							begin
                                twm_step <= 5;
								counter <= 0;
							end
							 else
							   counter <= counter + 1;
						  end
						
						5:begin
                            twm_step <= 0;
						  end
						 endcase
		              end

		Finish_twm:begin
			      both_work <= 0;
				  twm_first <= 0;
		       end
	    endcase
	end
end


always@(posedge clk or negedge reset_n)
begin
    if(!reset_n)
	begin
       // do nothing
	end
	else
	begin
        if(rim_state == Rim_Decode && rim_cmd)
		begin
            Register_Spaces[cfg_addr] <= cfg_wdata;
		end
	    else if(twm_state == Twm_Write_data && !(both_work && twm_addr == cfg_addr) && !(twm_first && twm_addr == cfg_addr))
		begin
            Register_Spaces[twm_addr][counter] <= SDA;
		end
	end
end

//Combinational Circuit for rim
always @(*) 
begin
	case(rim_state)
    Load_cmd:begin
		        if(cfg_req)
                   rim_nextstate = Rim_Decode;
				else
				   rim_nextstate = Load_cmd;
	         end

	Rim_Decode:begin
                 rim_nextstate = Finish_rim;
	           end

	Finish_rim:begin
              rim_nextstate = Load_cmd;
 	       end

	default:begin
              rim_nextstate = Load_cmd;
	        end

	endcase
end

//Combinational Circuit for twm
always @(*) 
begin
	case(twm_state)
    Load_cmd:begin
                if(SDA)
                     twm_nextstate = Load_cmd;  
                else
				     twm_nextstate = Twm_Decode;
	         end

	Twm_Decode:begin
		          twm_nextstate = Twm_addr;
	           end

	Twm_addr:begin
                    if(counter == 7)
					     if(twm_cmd)
					       twm_nextstate = Twm_Write_data;
						 else
                           twm_nextstate = Twm_Read_data;
					else
					     twm_nextstate = Twm_addr;
	        end

	Twm_Write_data:begin
                       if(counter == 15)
					     twm_nextstate = Finish_twm;
					   else
					     twm_nextstate = Twm_Write_data;
	               end

	Twm_Read_data:begin
                     if(twm_step == 5)
					    twm_nextstate = Finish_twm;
					 else 
					    twm_nextstate = Twm_Read_data;
	              end
    
	Finish_twm:begin
              twm_nextstate = Load_cmd;
	       end

	default:begin
              twm_nextstate = Load_cmd;
	        end
	endcase
end






endmodule
