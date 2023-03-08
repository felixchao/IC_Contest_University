
module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;


reg [1:0] state,NextState;
reg [3:0] i,j;
reg is_inA,is_inB,is_inC;
reg signed [4:0] temp1;
reg [3:0] counter;
reg [7:0] result;
wire [7:0] mul;


assign mul = temp1 * temp1;


parameter Load = 0;
parameter Determine = 1;
parameter Decoder = 2;
parameter Finish = 3;


always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
       is_inA <= 0;
       is_inB <= 0;
       is_inC <= 0;
       i <= 1;
       j <= 1;
       busy <= 0;
       counter <= 0;
       result <= 0;
       candidate <= 0;
       valid <= 0;
       state <= Load;
    end
    else
    begin
       state <= NextState;
       case(state)
       Load:begin
              if(en)
              begin
                 candidate <=0;
                 busy <= 1;
              end
              valid <= 0;
            end
       Determine:begin
                    case(counter)
                    0:begin
                         temp1 <= (i - central[23:20]);
                         counter <= 1;
                      end

                    1:begin
                         result <= mul;
                         temp1 <= (j - central[19:16]);
                         counter <= 2;      
                      end

                    2:begin
                         result <= result + mul;
                         temp1 <= radius[11:8];
                         counter <= 3;   
                      end

                    3:begin
                         if(result <= mul)
                         begin 
                            is_inA <= 1;
                         end
                         else
                         begin
                            is_inA <= 0;
                         end
                         temp1 <= (i - central[15:12]);
                         counter <= 4; 
                      end

                    4:begin
                         result <= mul;
                         temp1 <= (j - central[11:8]);
                         counter <= 5; 
                      end

                    5:begin
                         result <= result + mul;
                         temp1 <= radius[7:4];
                         counter <= 6; 
                      end

                    6:begin
                         if(result <= mul)
                         begin 
                            is_inB <= 1;
                         end
                         else
                         begin
                            is_inB <= 0;
                         end
                         temp1 <= (i - central[7:4]);
                         counter <= 7; 
                      end

                    7:begin
                         result <= mul;
                         temp1 <= (j - central[3:0]);
                         counter <= 8; 
                      end

                    8:begin
                         result <= result + mul;
                         temp1 <= radius[3:0];
                         counter <= 9; 
                      end

                    9:begin
                         if(result <= mul)
                         begin 
                            is_inC <= 1;
                         end
                         else
                         begin
                            is_inC <= 0;
                         end
                         counter <= 0;
                      end
                    endcase
                 end

       Decoder:begin
                  case(mode)
                  0:begin
                       if(is_inA)
                       begin
                          candidate <= candidate + 1;
                       end
                    end

                  1:begin
                       if(is_inA && is_inB)
                       begin
                          candidate <= candidate + 1;
                       end
                    end

                  2:begin
                       if(is_inA ^ is_inB)
                       begin
                          candidate <= candidate + 1;
                       end
                    end

                  3:begin
                       if(((is_inA && is_inB) || (is_inB && is_inC) || (is_inC && is_inA)) && !(is_inA && is_inB && is_inC) )
                       begin
                          candidate <= candidate + 1;
                       end                    
                    end
                  endcase
               end

      Finish: begin
                 if(i == 8 && j == 8)
                 begin
                    i <= 1;
                    j <= 1;
                    valid <= 1;
                    busy <= 0;
                 end
                 else if(j == 8)
                 begin
                    i <= i + 1;
                    j <= 1;
                 end
                 else
                 begin
                    j <= j+1;
                 end

              end
      
       endcase
    end
end


always@(*)
begin
   case(state)
   Load:begin
           if(en)
              NextState = Determine;
           else
              NextState = Load;
        end
  Determine:begin
               if(counter == 9)
                 NextState = Decoder;
               else
                 NextState = Determine;
            end

  Decoder:begin
             NextState = Finish;
          end

  Finish:begin
            if(i == 8 && j == 8)
               NextState = Load;
            else
               NextState = Determine;
         end

  default:begin
               NextState = Finish;
          end
   endcase
end



endmodule


