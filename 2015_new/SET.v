module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [1:0] state, NextState;
reg [3:0] i,j;
reg signed [3:0] value;
reg [7:0] A,B;
wire [7:0] mul;
reg is_inA, is_inB;
reg [2:0] counter;


assign mul = value * value;


parameter Load_Data = 0;
parameter Multiplication = 1;
parameter Determine = 2;
parameter Finish = 3;


parameter Mode0 = 0;
parameter Mode1 = 1;
parameter Mode2 = 2;


always@(posedge clk or posedge rst)
begin
   if(rst)
   begin
     busy <= 0;
     valid <= 0;
     candidate <= 0;
     i <= 1;
     j <= 1;
     counter <= 0;
     is_inA <= 0;
     is_inB <= 0;
     state <= Load_Data;
   end
   else
   begin
      state <= NextState;

      case(state)
      Load_Data:begin
                   valid <= 0;
                   if(en)
                   begin
                      candidate <= 0;
                      busy <= 1;
                   end
                end

      Multiplication:begin
                        case(counter)
                        0:begin
                             value <= (i - central[23:20]);
                             counter <= 1;
                          end

                        1:begin
                             value <= (j - central[19:16]);
                             A <= mul;
                             counter <= 2;
                          end

                        2:begin
                             value <= (i - central[15:12]);
                             A <= A + mul;
                             counter <= 3;
                          end

                        3:begin
                             value <= (j - central[11:8]);
                             B <= mul;
                             counter <= 4;
                          end

                         4:begin
                             value <= radius[11:8];
                             B <= B + mul;
                             counter <= 5;
                           end

                         5:begin
                              if(A <= mul)
                              begin
                                is_inA <= 1;
                              end
                              else
                              begin
                                is_inA <= 0;
                              end
                              value <= radius[7:4];
                              counter <= 6;
                           end

                         6:begin
                              if(B <= mul)
                              begin
                                is_inB <= 1;
                              end
                              else
                              begin
                                is_inB <= 0;
                              end
                              counter <= 0;
                           end

                        endcase
                     end
      
      Determine:begin
                  case(mode)
                  Mode0:begin
                          if(is_inA)
                          begin
                            candidate <= candidate + 1;
                          end
                        end

                  Mode1:begin
                          if(is_inA & is_inB)
                          begin
                            candidate <= candidate + 1;
                          end                     
                        end

                  Mode2:begin
                          if(is_inA ^ is_inB)
                          begin
                            candidate <= candidate + 1;
                          end                     
                        end

                  endcase
                end

      Finish:begin
                if(i == 8 && j == 8)
                begin
                  i <= 1;
                  j <= 1;
                  busy <= 0;
                  valid <= 1;
                end
                else if(j == 8)
                begin
                  j <= 1;
                  i <= i + 1;
                end
                else
                begin
                  j <= j + 1;
                end
             end

      endcase
   end
end


always@(*)
begin
   case(state)
   Load_Data:begin
               if(en)
                  NextState = Multiplication;
               else
                  NextState = Load_Data; 
             end
   Multiplication:begin
                     if(counter == 6)
                       NextState = Determine;
                     else
                       NextState = Multiplication;
                  end
   Determine:begin
               NextState = Finish;
             end 

   Finish:begin
             if(i == 8 && j == 8)
               NextState = Load_Data;
             else
               NextState = Multiplication;
          end
   endcase
end

endmodule