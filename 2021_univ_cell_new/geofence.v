module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output reg is_inside;

reg [1:0] state, NextState;
reg [9:0] fence_x[6:0];
reg [9:0] fence_y[6:0];
reg [2:0] counter, j, sort_state;
wire signed [20:0] mul;
reg signed [20:0] result;
reg signed [10:0] temp_x, temp_y;

assign mul = temp_x * temp_y;

parameter Load = 0;
parameter Sort = 1;
parameter Determine = 2;
parameter Finish = 3;

always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
       valid <= 0;
       is_inside <= 1;
       counter <= 0;
       sort_state <= 0;
       state <= Load;
    end
    else
    begin
        state <= NextState;

        case(state)
        Load:begin
               if(counter == 6)
               begin
                  fence_x[counter] <= X;
                  fence_y[counter] <= Y;
                  counter <= 2;
                  j <= 2;
               end
               else
               begin
                 fence_x[counter] <= X;
                 fence_y[counter] <= Y;
                 counter <= counter + 1;
               end
             end
        
        Sort:begin
                case(sort_state)
                0:begin
                     temp_x <= fence_x[counter] - fence_x[1]; 
                     temp_y <= fence_y[j] - fence_y[1];
                     sort_state <= 1;
                  end

                1:begin
                     result <= mul;
                     temp_x <= fence_x[j] - fence_x[1]; 
                     temp_y <= fence_y[counter] - fence_y[1];
                     sort_state <= 2;
                  end 

                2:begin
                     result <= result - mul;
                     sort_state <= 3;
                  end

                3:begin
                     if(result >= 0)
                     begin
                        fence_x[counter] <= fence_x[j];
                        fence_x[j] <= fence_x[counter];
                        fence_y[counter] <= fence_y[j];
                        fence_y[j] <= fence_y[counter];
                     end

                     if(counter == 6)
                     begin
                        counter <= 1;
                        j <= 2;
                     end
                     else if(j == 6)
                     begin
                        j <= counter + 1;
                        counter <= counter + 1;
                     end
                     else
                     begin
                        j <= j + 1;
                     end
                     sort_state <= 0;
                  end
                endcase
             end

        Determine:begin
                      case(sort_state)
                      0:begin
                           temp_x <= fence_x[counter] - fence_x[0];
                           temp_y <= fence_y[j] - fence_y[counter];
                           sort_state <= 1;
                        end

                      1:begin
                           result <= mul;
                           temp_x <= fence_x[j] - fence_x[counter];
                           temp_y <= fence_y[counter] - fence_y[0];
                           sort_state <= 2;
                        end

                      2:begin
                           result <= result - mul;
                           sort_state <= 3;
                        end

                      3:begin
                           if(result >= 0)
                           begin
                              is_inside <= 0;
                           end

                           counter <= j;
                           if(j == 6)
                           begin
                              j <= 1;
                           end
                           else
                           begin
                              j <= j + 1;
                           end
                           
                           if(counter == 6)
                              sort_state <= 4;
                           else
                              sort_state <= 0;
                        end

                     4:begin
                          valid <= 1;
                       end
                      endcase
                  end


         Finish:begin
                   is_inside <= 1;
                   valid <= 0;
                   counter <= 0;
                   sort_state <= 0;
                end
        endcase
    end
end


always@(*)
begin
   case(state)
   Load:begin
          if(counter == 6)
             NextState = Sort;
          else
             NextState = Load;
        end

    Sort:begin
            if(counter == 6 && sort_state == 3)
              NextState = Determine;
            else
              NextState = Sort;
         end

    Determine:begin
                 if(sort_state == 4)
                   NextState = Finish;
                 else
                   NextState = Determine;
              end

    Finish:begin
              NextState = Load;
           end

    default:begin
               NextState = Finish;
            end
   endcase
end

endmodule

