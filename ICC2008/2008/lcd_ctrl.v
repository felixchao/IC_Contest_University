
module LCD_CTRL(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);
input           clk;
input           reset;
input   [7:0]   datain;
input   [2:0]   cmd;
input           cmd_valid;
output reg [7:0]   dataout;
output reg         output_valid;
output reg        busy;

reg [2:0] state;
reg [2:0] NextState;
reg [6:0] count;
reg [7:0] buffer [107:0];
reg [7:0] origin_x;
reg [7:0] origin_y;
reg zoom_in;

wire [7:0] zoom_fit_id;

assign zoom_fit_id = (origin_y << 3)+(origin_y << 2)+ origin_x - 26;

parameter Load_Data = 0;
parameter Zoom_In = 1;
parameter Zoom_Fit = 2;
parameter Shift_Right = 3;
parameter Shift_Left = 4;
parameter Shift_Up = 5;
parameter Shift_Down = 6;
parameter Decoder = 7;


always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
        state <= Decoder;
        origin_x <= 6;
        origin_y <= 5;
        busy <= 0;
        output_valid <= 0;
        count <= 0;
        zoom_in <= 0;
    end

    else
    begin
         state <= NextState;

         case(state)

         Decoder:begin
                    busy <= 1;
                 end
         
         Load_Data:begin
                       if(count == 108)
                       begin
                          count <= 0;
                       end
                       else
                       begin
                          buffer[count] <= datain;
                          count <= count + 1;
                       end
                   end

         Zoom_Fit:begin
                      if(count == 16)
                      begin
                         busy <= 0;
                         count <= 0;
                         output_valid <= 0;
                         origin_x <= 6;
                         origin_y <= 5;
                      end
                      else
                      begin
                          dataout <= buffer[13 + (count[1:0] + (count[1:0] << 1)) + ((count[6:2] << 3) + (count[6:2] << 4))];
                          output_valid <= 1;
                          count <= count + 1;
                          zoom_in <= 0;
                      end
                  end
         
         Zoom_In:begin
                     zoom_in <= 1;
                     case(count)
                         0: begin
                            output_valid <= 1;
                            dataout <= buffer[zoom_fit_id];
                            count <= 1;
                            end
                        
                         1: begin
                            dataout <= buffer[zoom_fit_id+1];
                            count <= 2;
                            end
 
                         2: begin
                            dataout <= buffer[zoom_fit_id+2];
                            count <= 3;
                            end

                         3: begin
                            dataout <= buffer[zoom_fit_id+3];
                            count <= 4;
                            end

                         4: begin
                            dataout <= buffer[zoom_fit_id+12];
                            count <= 5;
                            end

                         5: begin
                            dataout <= buffer[zoom_fit_id+13];
                            count <= 6;
                            end

                         6: begin
                            dataout <= buffer[zoom_fit_id+14];
                            count <= 7;
                            end

                         7: begin
                            dataout <= buffer[zoom_fit_id+15];
                            count <= 8;
                            end

                         8: begin
                            dataout <= buffer[zoom_fit_id+24];
                            count <= 9;
                            end


                         9: begin
                            dataout <= buffer[zoom_fit_id+25];
                            count <= 10;
                            end

                         10: begin
                             dataout <= buffer[zoom_fit_id+26];
                             count <= 11;
                             end

                         11:begin
                            dataout <= buffer[zoom_fit_id+27];
                            count <= 12;
                            end

                         12: begin
                            dataout <= buffer[zoom_fit_id+36];
                            count <= 13;
                            end

                         13: begin
                            dataout <= buffer[zoom_fit_id+37];
                            count <= 14;  
                            end      

                         14: begin
                             dataout <= buffer[zoom_fit_id+38];
                            count <= 15;
                            end

                         15: begin
                            dataout <= buffer[zoom_fit_id+39];
                            count <= 16;
                            end

                         16: begin
                                 output_valid <= 0;
                                 busy <= 0;
                                 count <= 0;
                             end

                     endcase
                  end

            Shift_Down: begin
                              if(origin_y == 7)
                              begin
                                    origin_y <= 7;
                              end
                              else
                              begin                                          
                                     origin_y <= origin_y + 1;
                              end
                        end

            Shift_Left: begin
                           if(origin_x == 2)
                           begin
                                 origin_x <= 2;
                           end
                           else
                           begin                                          
                                 origin_x <= origin_x - 1;
                           end
                        end

            Shift_Right: begin
                           if(origin_x == 10)
                           begin
                                 origin_x <= 10;
                           end
                           else
                           begin                                          
                                 origin_x <= origin_x + 1;
                           end
                        end

            Shift_Up: begin
                           if(origin_y == 2)
                           begin
                              origin_y <= 2;
                           end
                           else
                           begin                                          
                                 origin_y <= origin_y - 1;
                           end
                      end

         endcase
   end
end


always @(*)
begin
      case(state)

      Decoder:begin
                  if(cmd_valid)
                  begin
                     if(cmd >= 3 && cmd <= 6 && zoom_in == 0)
                        NextState = Zoom_Fit;
                     else
                        NextState = cmd;
                  end
                  else
                     NextState = NextState;
              end
      
      Load_Data:begin
                     if(count == 108)
                        NextState = Zoom_Fit;
                     else
                        NextState = Load_Data;                
                end

      Zoom_Fit:begin
                    if(count == 16)
                       NextState = Decoder;
                    else
                       NextState = Zoom_Fit;
               end

      Zoom_In:begin
                    if(count == 16)
                       NextState = Decoder;
                    else
                       NextState = Zoom_In;
              end

      default:begin
                   NextState = Zoom_In;
              end

      endcase

end

endmodule
