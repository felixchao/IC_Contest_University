module S1(clk,
	  rst,
	  RB1_RW,
	  RB1_A,
	  RB1_D,
	  RB1_Q,
	  sen,
	  sd);

  input clk, rst;
  output reg RB1_RW;      // control signal for RB1: Read/Write
  output reg [4:0] RB1_A; // control signal for RB1: address
  output reg [7:0] RB1_D; // data path for RB1: input port
  input [7:0] RB1_Q;  // data path for RB1: output port
  output reg sen, sd;

reg [1:0] state, NextState;
reg [20:0] buffer;

 
parameter Load_Data = 0;
parameter Send_Package = 1;
parameter Finish = 2;


always @(negedge clk or posedge rst) 
begin
	if(rst)
	begin
	   sen <= 1;
	   RB1_RW <= 1;
	   RB1_A <= 0;
	   RB1_D <= 0;
	   sd <= 0;
	   state <= Load_Data;
	   buffer <= 0;
	end
	else
	begin
        state <= NextState;
		case(state)
        Load_Data: begin
			          if(RB1_A == 17)
					  begin
                        buffer[RB1_A] <= RB1_Q[7 - buffer[20:18]]; 
						RB1_A <= 20;
					  end
					  else
					  begin
			            RB1_RW <= 1;
                        RB1_A <= RB1_A + 1;
					    buffer[RB1_A] <= RB1_Q[7 - buffer[20:18]]; 
					  end
		           end

		Send_Package: begin
                         if(RB1_A == 31)
						 begin
							sen <= 1;
							RB1_A <= 0;
							buffer[20:18] <= buffer[20:18] + 1;
						 end
						 else
						 begin
                            sen <= 0;
                            sd <= buffer[RB1_A];
							RB1_A <= RB1_A - 1;
						 end
		              end

		Finish: begin
                   sen <= 1;
		        end
	    endcase
	end
end


always @(*)
begin
    case(state)
    Load_Data: begin
                  if(RB1_A == 17)
				    NextState = Send_Package;
				  else
				    NextState = Load_Data;
	           end

	Send_Package: begin
                      if(RB1_A == 31)
					    NextState = Finish;
					  else 
					    NextState = Send_Package;
	              end

	Finish: begin
		        if(buffer[20:18] == 0)
                   NextState = Finish;
				else
				   NextState = Load_Data;
	        end

	endcase
end
  

endmodule
