module S2(clk,
	  rst,
	  S2_done,
	  RB2_RW,
	  RB2_A,
	  RB2_D,
	  RB2_Q,
	  sen,
	  sd);

input clk, rst;
output reg S2_done, RB2_RW;
output reg [2:0] RB2_A;
output reg [17:0] RB2_D;
input [17:0] RB2_Q;
input sen, sd;

reg [1:0] state, NextState;
reg [4:0] counter;


parameter Load_Package = 0;
parameter Next_Package = 1;
parameter Finish = 2;


always @(posedge clk or posedge rst)
begin
    if(rst)
	begin
       RB2_RW <= 1;
	   RB2_A <= 0;
	   RB2_D <= 0;
	   S2_done <= 0;
	   counter <= 20;
	   state <= Load_Package;
	end
	else
	begin
       state <= NextState;

	   case(state)
       Load_Package: begin
                        if(sen == 0)
						begin
						   if(counter < 18)
						   begin
							  RB2_RW <= 0;
							  RB2_D[counter] <= sd;
							  counter <= counter - 1;
						   end
						   else
						   begin
                              counter <= counter - 1;
						   end
						end
	                 end
		
		Next_Package: begin
			             counter <= 20;
			             RB2_RW <= 1;
			             if(RB2_A == 7)
						 begin
                            RB2_A <= 0;
						 end
						 else
						 begin
			                RB2_A <= RB2_A + 1;
						 end
		              end
		
		Finish: begin
                   S2_done <= 1;
		        end
	   endcase
	end
end

always@(*)
begin
    case(state)
    Load_Package: begin
                     if(counter == 0)
					   NextState = Next_Package;
					 else
					   NextState = Load_Package;
	              end

    Next_Package: begin
		             if(RB2_A == 7)
                       NextState = Finish;
					 else
					   NextState = Load_Package; 
	              end

	Finish: begin
                NextState = Finish;
	        end

	endcase
end

endmodule
