
module LCD_CTRL(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);
input           clk;
input           reset;
input   [7:0]   datain;
input   [3:0]   cmd;
input           cmd_valid;
output reg [7:0]   dataout;
output reg         output_valid;
output reg        busy;

reg [7:0] map[107:0];
reg [3:0] originx;
reg [3:0] originy;
reg zoom;
reg [1:0] rot;
reg state;
reg [6:0] cnt;
reg [4:0] discnt;

always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
       state <= 1;
        busy <= 0;
        output_valid <= 0;
        rot <= 0;
        originx <= 4;
        originy <= 3;
        cnt <= 0;
        zoom <= 0;
        discnt <= 0;
    end


    else
    begin
        if((cmd_valid == 1 && busy == 0 && cmd == 0) || state == 0)  //load
        begin
            
            if(state == 1)
            begin
                state = 0;
                cnt = 0;
            end

            else if(cnt == 108)
            begin
                rot = 0;
                cnt = 0;
                state = 1;
            end
            
            else
            begin
                busy = 1;
                map[cnt] = datain;
                cnt = cnt + 1;
                state = 0;
            end

        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 1)  //rotate left
        begin
            if(zoom == 0)
            rot = rot - 1;

            state = 1;
            busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 2) //rotate right
        begin
            if(zoom == 0)
            rot = rot + 1;

            state = 1;
            busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 3)  //zoom in
        begin
           originx = 4;
           originy = 3;
           zoom = 1;
           state = 1;
           busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 4) //zoom fit
        begin
           zoom = 0;
           state = 1;
           busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 5) //shift right
        begin
           if(zoom == 1)
           begin
           if(rot == 0 || rot == 2)
           begin
               if(originx >= 8)
               originx = 8;
               else
               originx = originx + 1;
           end
           else if(rot == 3)
           begin
                if(originy >= 5)
                originy = 5;
                else
                originy = originy + 1;
           end
           else if(rot == 1)
            begin
                if(originy <= 0)
                originy = 0;
                else
                originy = originy - 1;
            end
           end
           state = 1;
           busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 6) 
        begin
         if(zoom == 1)
         begin
           if(rot == 0 || rot == 2)
           begin
               if(originx <= 0)
               originx = 0;
               else
               originx = originx - 1;
           end
           else if(rot == 3)
           begin
                if(originy <= 0)
                originy = 0;
                else
                originy = originy - 1;
           end
           else if(rot == 1)
            begin
                if(originy >= 5)
                originy = 5;
                else
                originy = originy + 1;
            end
         end
           state = 1;
           busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 7) 
        begin
        if(zoom == 1)
        begin
           if(rot == 0 || rot == 2)
           begin
               if(originy <= 0)
               originy = 0;
               else
               originy = originy - 1;
           end
           else if(rot == 3)
           begin
                if(originx >= 8)
                originx = 8;
                else
                originx = originx + 1;
           end
           else if(rot == 1)
            begin
                if(originx <= 0)
                originx = 0;
                else
                originx = originx - 1;
            end

        end

           state = 1;
           busy = 1;
        end

        else if(cmd_valid == 1 && busy == 0 && cmd == 8) 
        begin
        if(zoom == 1)
        begin
           if(rot == 0 || rot == 2)
           begin
               if(originy >= 5)
               originy = 5;
               else
               originy = originy + 1;
           end
           else if(rot == 3)
           begin
                if(originx <= 0)
                originx = 0;
                else
                originx = originx - 1;
           end
           else if(rot == 1)
            begin
                if(originx >= 8)
                originx = 8;
                else
                originx = originx + 1;
            end
        end
           state = 1;
           busy = 1;
        end
    end
end


always @(posedge clk) 
begin
    if(state == 1 && busy == 1)
    begin
        if(zoom == 0)
        begin
            output_valid = 1;

            if(discnt == 16)
            begin
                discnt = 0;
                state = 1;
                output_valid = 0;
                busy = 0;
            end

            else
            begin
            if(rot == 0 || rot == 2)
            begin
                case(discnt)
                0:dataout = map[13];
                1:dataout = map[16];
                2:dataout = map[19];
                3:dataout = map[22];
                4:dataout = map[37];
                5:dataout = map[40];
                6:dataout = map[43];
                7:dataout = map[46];
                8:dataout = map[61];
                9:dataout = map[64];
                10:dataout = map[67];
                11:dataout = map[70];
                12:dataout = map[85];
                13:dataout = map[88];
                14:dataout = map[91];
                15:dataout = map[94];
                endcase
            end

            else if(rot == 3)
            begin
                case(discnt)
                12:dataout = map[13];
                8:dataout = map[16];
                4:dataout = map[19];
                0:dataout = map[22];
                13:dataout = map[37];
                9:dataout = map[40];
                5:dataout = map[43];
                1:dataout = map[46];
                14:dataout = map[61];
                10:dataout = map[64];
                6:dataout = map[67];
                2:dataout = map[70];
                15:dataout = map[85];
                11:dataout = map[88];
                7:dataout = map[91];
                3:dataout = map[94];
                endcase
            end

            else if(rot == 1)
            begin
                case(discnt)
                3:dataout = map[13];
                7:dataout = map[16];
                11:dataout = map[19];
                15:dataout = map[22];
                2:dataout = map[37];
                6:dataout = map[40];
                10:dataout = map[43];
                14:dataout = map[46];
                1:dataout = map[61];
                5:dataout = map[64];
                9:dataout = map[67];
                13:dataout = map[70];
                0:dataout = map[85];
                4:dataout = map[88];
                8:dataout = map[91];
                12:dataout = map[94];
                endcase  
            end
                discnt = discnt + 1; 
            end
        end

        else
        begin
            output_valid = 1;
            if(discnt == 16)
            begin
                discnt = 0;
                state = 1;
                output_valid = 0;
                busy = 0;
            end

            else
            begin
                if(rot == 0 || rot == 2)
                begin
                   case(discnt)
                    0:dataout = map[originy*12+originx];
                    1:dataout = map[originy*12+originx+1];
                    2:dataout = map[originy*12+originx+2];
                    3:dataout = map[originy*12+originx+3];
                    4:dataout = map[(originy+1)*12+originx];
                    5:dataout = map[(originy+1)*12+originx+1];
                    6:dataout = map[(originy+1)*12+originx+2];
                    7:dataout = map[(originy+1)*12+originx+3];
                    8:dataout = map[(originy+2)*12+originx];
                    9:dataout = map[(originy+2)*12+originx+1];
                    10:dataout = map[(originy+2)*12+originx+2];
                    11:dataout = map[(originy+2)*12+originx+3];
                    12:dataout = map[(originy+3)*12+originx];
                    13:dataout = map[(originy+3)*12+originx+1];
                    14:dataout = map[(originy+3)*12+originx+2];
                    15:dataout = map[(originy+3)*12+originx+3];
                    endcase
                end

                else if(rot == 3)
                begin
                   case(discnt)
                    12:dataout = map[originy*12+originx];
                    8:dataout = map[originy*12+originx+1];
                    4:dataout = map[originy*12+originx+2];
                    0:dataout = map[originy*12+originx+3];
                    13:dataout = map[(originy+1)*12+originx];
                    9:dataout = map[(originy+1)*12+originx+1];
                    5:dataout = map[(originy+1)*12+originx+2];
                    1:dataout = map[(originy+1)*12+originx+3];
                    14:dataout = map[(originy+2)*12+originx];
                    10:dataout = map[(originy+2)*12+originx+1];
                    6:dataout = map[(originy+2)*12+originx+2];
                    2:dataout = map[(originy+2)*12+originx+3];
                    15:dataout = map[(originy+3)*12+originx];
                    11:dataout = map[(originy+3)*12+originx+1];
                    7:dataout = map[(originy+3)*12+originx+2];
                    3:dataout = map[(originy+3)*12+originx+3];
                    endcase
                end
                
                else if(rot == 1)
                begin
                    case(discnt)
                    3:dataout = map[originy*12+originx];
                    7:dataout = map[originy*12+originx+1];
                    11:dataout = map[originy*12+originx+2];
                    15:dataout = map[originy*12+originx+3];
                    2:dataout = map[(originy+1)*12+originx];
                    6:dataout = map[(originy+1)*12+originx+1];
                    10:dataout = map[(originy+1)*12+originx+2];
                    14:dataout = map[(originy+1)*12+originx+3];
                    1:dataout = map[(originy+2)*12+originx];
                    5:dataout = map[(originy+2)*12+originx+1];
                    9:dataout = map[(originy+2)*12+originx+2];
                    13:dataout = map[(originy+2)*12+originx+3];
                    0:dataout = map[(originy+3)*12+originx];
                    4:dataout = map[(originy+3)*12+originx+1];
                    8:dataout = map[(originy+3)*12+originx+2];
                    12:dataout = map[(originy+3)*12+originx+3];
                    endcase
                end
                discnt = discnt + 1;
            end
        end
    end
end



endmodule
