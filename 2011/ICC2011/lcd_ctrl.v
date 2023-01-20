module LCD_CTRL(clk, reset, IROM_Q, cmd, cmd_valid, IROM_EN, IROM_A, IRB_RW, IRB_D, IRB_A, busy, done);
input clk;
input reset;
input [7:0] IROM_Q;
input [2:0] cmd;
input cmd_valid;
output reg IROM_EN;
output reg [5:0] IROM_A;
output reg IRB_RW;
output reg [7:0] IRB_D;
output reg [5:0] IRB_A;
output reg busy;
output reg done;


reg [2:0] state, NextState;
reg [9:0] map [63:0];
reg [6:0] count, count2;
reg [2:0] origin_x, origin_y;
wire [5:0] up , down, left, right;
wire [7:0] average;

assign up = {origin_y,origin_x};
assign down = {origin_y,origin_x} - 1;
assign left = {origin_y,origin_x} - 8;
assign right = {origin_y,origin_x} - 9;
assign average = (map[up]+map[down]+map[left]+map[right])>>2;


//States
parameter Load_Data = 0;
parameter Decoder = 1;
parameter Finish = 2;
parameter Store_Data = 3;

//cmd
parameter Write = 0;
parameter Shift_Up = 1;
parameter Shift_Down = 2;
parameter Shift_Left = 3;
parameter Shift_Right = 4;
parameter Average = 5;
parameter Mirror_X = 6;
parameter Mirror_Y = 7;



//Sequential Circuit
always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
        state <= Load_Data;
        IROM_EN <= 1;
        done <= 0;
        busy <= 1;
        count <= 0;
        origin_x <= 4;
        origin_y <= 4;
    end
    else
    begin
        state <= NextState;

        case(state)
        Load_Data:begin
                    if(count == 64)
                    begin
                        map[count - 1] <= IROM_Q;
                        IROM_EN <= 1;
                        count <= 0;
                        busy <= 0;
                    end
                    else
                    begin
                       map[count - 1] <= IROM_Q;
                       IROM_EN <= 0;
                       IROM_A <= count;
                       count <= count + 1;
                    end
                  end

        Store_Data:begin
                       count <= count;
                   end

        Decoder:begin
                    if(cmd_valid)
                    begin
                    busy <= 1;
                    case(cmd)
                    Shift_Up:begin
                                if(origin_y == 1)
                                begin
                                   origin_y <= 1;
                                end
                                else
                                begin
                                   origin_y <= origin_y - 1;
                                end
                             end

                    Shift_Down:begin
                                if(origin_y == 7)
                                begin
                                   origin_y <= 7;
                                end
                                else
                                begin
                                   origin_y <= origin_y + 1;
                                end
                               end

                    Shift_Left:begin
                                if(origin_x == 1)
                                begin
                                   origin_x <= 1;
                                end
                                else
                                begin
                                   origin_x <= origin_x - 1;
                                end                               
                               end

                    Shift_Right:begin
                                if(origin_x == 7)
                                begin
                                   origin_x <= 7;
                                end
                                else
                                begin
                                   origin_x <= origin_x + 1;
                                end                                
                                end
                    
                    Average:begin
                               map[up] <= average;
                               map[down] <= average;
                               map[left] <= average;
                               map[right] <= average;
                            end

                    Mirror_X:begin
                                map[up] <= map[left];
                                map[down] <= map[right];
                                map[right] <= map[down];
                                map[left] <= map[up];
                             end

                    Mirror_Y:begin
                                map[up] <= map[down];
                                map[down] <= map[up];
                                map[right] <= map[left];
                                map[left] <= map[right];
                             end
                    endcase
                    end
                    else
                    begin
                        busy <= 0;
                    end
                end

        Finish:begin
                    done <= 1;
               end

        endcase
    end
end

//Writing in IRB
always@(negedge clk or posedge reset)
begin
    if(reset)
    begin
        IRB_RW <= 1;
        count2 <= 0;
    end
    else
    begin
       case(state)
       Decoder:begin
                    if(cmd == Write || count2 > 0)
                    begin  
                           if(count2 == 64)
                           begin
                               IRB_RW <= 1;
                               count2 <= 0;
                           end
                           else
                           begin
                               IRB_RW <= 0;
                               IRB_A <= count2; 
                               IRB_D <= map[count2];
                               count2 <= count2 + 1;
                           end                       
                    end
               end
       endcase
    end
end

//State Machine
always @(*)
begin
    case(state)
    Load_Data:begin
                 if(count == 64)
                   NextState = Decoder;
                 else
                   NextState = Store_Data;
              end
    
    Store_Data:begin
                 NextState = Load_Data;
               end

    Decoder:begin
               if(count2 == 64)
                 NextState = Finish;
               else
                 NextState = Decoder;
            end

    Finish:begin
               NextState = Finish;
           end

    endcase
end


endmodule

