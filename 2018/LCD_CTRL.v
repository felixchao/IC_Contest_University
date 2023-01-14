module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output reg IROM_rd;
output reg [5:0] IROM_A;
output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;
output reg busy;
output reg done;

reg [3:0] state;
reg [3:0] NextState;
reg [9:0] map [63:0];
reg [6:0] count;
reg [2:0] origin_x;
reg [2:0] origin_y;
wire [7:0] average;
wire [5:0] up;
wire [5:0] down;
wire [5:0] left;
wire [5:0] right;

assign up = {origin_y,origin_x};
assign down = {origin_y,origin_x} - 1;
assign left = {origin_y,origin_x} - 8;
assign right = {origin_y,origin_x} - 9;
assign average = (map[up]+map[down]+map[left]+map[right])>>2;


parameter  Write = 0;
parameter  Shift_Up = 1;
parameter  Shift_Down = 2;
parameter  Shift_Left = 3;
parameter  Shift_Right = 4;
parameter  Max = 5;
parameter  Min = 6;
parameter Average = 7;
parameter Counterclockwise = 8;
parameter Clockwise = 9;
parameter Mirror_X = 10;
parameter Mirror_Y = 11;
parameter Initialize = 12;
parameter Command = 13;


// Sequential Circuit
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        IROM_rd <= 1;
        count <= 0;
        busy <= 1;
        done <= 0;
        origin_x <= 4;
        origin_y <= 4;
        state <= Initialize;
    end
    else
    begin
        state <= NextState;

        case(state)
        Initialize: begin
                         if(count == 64)
                         begin
                            map[count - 1] <= IROM_Q;
                            IROM_rd <= 0;
                            count <= 0;
                            busy <= 0;
                         end
                         else
                         begin
                            IROM_A <= count;
                            map[count - 1] <= IROM_Q;
                            count <= count + 1;
                         end
                    end
        Command: begin
                     busy <= 1;
                 end

        Write: begin
                    if(count == 64)
                    begin
                        IRAM_valid <= 0;
                        busy <= 0;
                        done <= 1;
                    end
                    else
                    begin
                        IRAM_valid <= 1;
                        IRAM_A <= count;
                        IRAM_D <= map[count];
                        count <= count + 1;
                    end
               end

        Shift_Up: begin
                       if(origin_y == 1)
                       begin
                            origin_y <= 1;
                            busy <= 0;
                       end
                       else
                       begin
                            origin_y <= origin_y - 1;
                            busy <= 0;
                       end
                  end

        Shift_Down: begin
                       if(origin_y == 7)
                       begin
                            origin_y <= 7;
                            busy <= 0;
                       end
                       else
                       begin
                            origin_y <= origin_y + 1;
                            busy <= 0;
                       end
                    end 

        Shift_Left: begin
                       if(origin_x == 1)
                       begin
                            origin_x <= 1;
                            busy <= 0;
                       end
                       else
                       begin
                            origin_x <= origin_x - 1;
                            busy <= 0;
                       end
                    end

        Shift_Right: begin
                       if(origin_x == 7)
                       begin
                            origin_x <= 7;
                            busy <= 0;
                       end
                       else
                       begin
                            origin_x <= origin_x + 1;
                            busy <= 0;
                       end
                     end

        Max: begin
                 if(map[up] >= map[down] && map[up] >= map[left] && map[up] >= map[right])
                 begin
                      map[down] <= map[up];
                      map[left] <= map[up];
                      map[right] <= map[up];
                 end
                 else if(map[down] >= map[up] && map[down] >= map[left] && map[down] >= map[right])
                 begin
                      map[up] <= map[down];
                      map[left] <= map[down];
                      map[right] <= map[down];
                 end

                 else if(map[left] >= map[down] && map[left] >= map[up] && map[left] >= map[right])
                 begin
                      map[up] <= map[left];
                      map[down] <= map[left];
                      map[right] <= map[left];
                 end

                 else
                 begin
                      map[up] <= map[right];
                      map[down] <= map[right];
                      map[left] <= map[right];
                 end
                 busy <= 0;
             end

        Min: begin
                 if(map[up] <= map[down] && map[up] <= map[left] && map[up] <= map[right])
                 begin
                      map[down] <= map[up];
                      map[left] <= map[up];
                      map[right] <= map[up];
                 end
                 else if(map[down] <= map[up] && map[down] <= map[left] && map[down] <= map[right])
                 begin
                      map[up] <= map[down];
                      map[left] <= map[down];
                      map[right] <= map[down];
                 end

                 else if(map[left] <= map[down] && map[left] <= map[up] && map[left] <= map[right])
                 begin
                      map[up] <= map[left];
                      map[down] <= map[left];
                      map[right] <= map[left];
                 end

                 else
                 begin
                      map[up] <= map[right];
                      map[down] <= map[right];
                      map[left] <= map[right];
                 end
                 busy <= 0;
             end

        Average: begin
                      map[up] <= average;
                      map[down] <= average;
                      map[left] <= average;
                      map[right] <= average;
                      busy <= 0;
                 end

        Counterclockwise: begin
                               map[up] <= map[down];
                               map[down] <= map[right];
                               map[right] <= map[left];
                               map[left] <= map[up];
                               busy <= 0;
                          end

        Clockwise: begin
                          map[up] <= map[left];
                          map[down] <= map[up];
                          map[right] <= map[down];
                          map[left] <= map[right];
                          busy <= 0;
                   end

        Mirror_X: begin
                      map[up] <= map[left];
                      map[down] <= map[right];
                      map[right] <= map[down];
                      map[left] <= map[up];
                      busy <= 0;
                  end

        Mirror_Y: begin
                    map[up] <= map[down];
                    map[down] <= map[up];
                    map[right] <= map[left];
                    map[left] <= map[right];
                    busy <= 0;
                  end

        endcase
    end
end

//state machine
always@(*)
begin
    case(state)
    Initialize: begin
                    if(count == 64)
                       NextState = Command;
                    else
                       NextState = Initialize;
                end
    
    Command:begin
                 if(cmd_valid)
                    NextState = cmd;
                 else
                    NextState = NextState;
            end

     Write:begin
                    if(count == 64)
                       NextState = Command;
                    else
                       NextState = Write;
           end

    default: begin
                 NextState = Command;
             end
    endcase
end


endmodule



