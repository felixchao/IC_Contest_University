module LCD_CTRL(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);
input           clk;
input           reset;
input   [7:0]   datain;
input   [2:0]   cmd;
input           cmd_valid;
output  reg [7:0]  dataout;
output   reg    output_valid;
output   reg    busy;

reg [7:0] map [63:0];
reg [5:0] originx;
reg [5:0] originy;
reg multi;
reg [6:0] cnt;
reg [3:0] state;
reg [4:0] discnt;


always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
        originx <= 0;
        originy <= 0;
        multi <= 0;
        cnt <= 0;
        busy <= 0;
        discnt <= 0;
        output_valid <= 0;
    end
    else
    begin
        if(cmd_valid == 1 && cmd == 1 && busy == 0)   //load data
        begin
            state <= 1;
            busy <= 1;
            multi <= 0;
        end
        else if(cmd_valid == 1 && cmd == 0&& busy == 0)
        begin
            state <= 0;
            busy <= 1;
        end
        else if(cmd_valid == 1 && cmd == 2&& busy == 0)
        begin
            state <= 2;
            busy <= 1;
            multi <= 1;
        end       
        else if(cmd_valid == 1 && cmd == 3&& busy == 0)
        begin
            state <= 3;
            busy <= 1;
            multi <= 0;
        end
        else if(cmd_valid == 1 && cmd == 4&& busy == 0)
        begin
            state <= 4;
            busy <= 1;
        end
        else if(cmd_valid == 1 && cmd == 5&& busy == 0)
        begin
            state <= 5;
            busy <= 1;
        end
        else if(cmd_valid == 1 && cmd == 6&& busy == 0)
        begin
            state <= 6;
            busy <= 1;
        end
        else if(cmd_valid == 1 && cmd == 7&& busy == 0)
        begin
            state <= 7;
            busy <= 1;
        end
            if(state == 0 && busy == 1)     //display
    begin
        if(multi == 1)
        begin
        output_valid <= 1;
        if(discnt == 16)
        begin
            discnt <= 0;
            state <= 0;
            output_valid <= 0;
            busy <= 0;
        end
        else
        begin
        dataout <= map[((originy+discnt[3:2])<<3) + originx + discnt[1:0]];
        discnt <= discnt + 1;
        end
        end

        else
        begin
            output_valid <= 1;
        if(discnt == 16)
        begin
            discnt <= 0;
            state <= 0;
            output_valid <= 0;
            busy <= 0;
        end
        else
        begin
        if(discnt == 0)
          dataout <= map[0];
        else if(discnt == 1)
          dataout <= map[2];
        else if(discnt == 2)
          dataout <= map[4];
        else if(discnt == 3)
          dataout <= map[6];
        else if(discnt == 4)
          dataout <= map[16];
        else if(discnt == 5)
          dataout <= map[18];
        else if(discnt == 6)
          dataout <= map[20];
        else if(discnt == 7)
          dataout <= map[22];
        else if(discnt == 8)
          dataout <= map[32];
        else if(discnt == 9)
          dataout <= map[34];
        else if(discnt == 10)
          dataout <= map[36];
        else if(discnt == 11)
          dataout <= map[38];
        else if(discnt == 12)
          dataout <= map[48];
        else if(discnt == 13)
          dataout <= map[50];
        else if(discnt == 14)
          dataout <= map[52];
        else if(discnt == 15)
          dataout <= map[54];
        discnt <= discnt + 1;
        end
        end
    end

    else if(state == 1)    //load
    begin
        if(cnt == 64)
        begin
           state <= 0;
           cnt <= 0;
        end
        else
        begin
        busy <= 1;
        map[cnt] <= datain;
        cnt <= cnt + 1;
        end
    end

    else if(state == 2)
    begin
        originx <= 2;
        originy <= 2;
        state <= 0;
    end

    else if(state == 3)
    begin
        originx <= 0;
        originy <= 0;
        state <= 0;
    end

    else if(state == 4)
    begin
        if(multi == 1)
        begin
            if(originx == 4)
              originx <= 4;
            else
              originx <= originx + 1;
        end
        state <= 0;
    end

    else if(state == 5)
    begin
        if(multi == 1)
        begin
            if(originx == 0)
              originx <= 0;
            else
              originx <= originx - 1;
        end
        state <= 0;
    end

    else if(state == 6)
    begin
        if(multi == 1)
        begin
            if(originy == 0)
              originy <= 0;
            else
              originy <= originy - 1;
        end
        state <= 0;
    end

    else if(state == 7)
    begin
        if(multi == 1)
        begin
            if(originy == 4)
              originy <= 4;
            else
              originy <= originy + 1;
        end
        state <= 0;
    end
    end
    

end


endmodule
