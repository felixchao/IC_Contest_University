module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output reg R,
    output reg G,
    output reg Y
);

//write your code here
reg [2:0] Nextstate, state;
reg [8:0] count1;
reg [7:0] count2;
reg [5:0] count3;

always@(posedge clk)
begin
    if(rst)
    begin
        R <= 0;
        Y <= 0;
        G <= 1;
        state <= 0;
        count1 <= 0;
        count2 <= 0;
        count3 <= 0;
    end
    else
    begin
        if(pass && state != 0)
        begin
            R <= 0;
            Y <= 0;
            G <= 1;
            state <= 0;
            count1 <= 0;
            count2 <= 0;
            count3 <= 0;
        end
        else
        begin
            
            if(state == 0)
             begin
               G <= 1;
               count1 <= count1 + 1;
             end
            else if(state == 1)
             begin
                G <= 0;
                count3 <= count3+1;
             end
            else if(state == 2)
            begin
                G <= 1;
               count3 <= count3+1;
            end
            else if(state == 3)
            begin
                G <= 0;
               count3 <= count3+1;
            end
            else if(state == 4)
            begin
                G <= 1;
               count3 <= count3+1;
            end
            else if(state == 5)
            begin
                Y <= 1;
               count2 <= count2+1;
            end
            else if(state == 6)
            begin
                R <= 1;
               count1 <= count1+1;
            end

            if(count1 ==  511 || count2 == 255 || count3 == 63)
            begin
                if(Nextstate == 6)
                begin
                R <= 1;
                Y <= 0;
                G <= 0;
                end
                else if(Nextstate == 0||Nextstate == 2 || Nextstate == 4)
                begin
                R <= 0;
                Y <= 0;
                G <= 1;
                end
                else if(Nextstate == 5)
                begin
                    R <= 0;
                    Y <= 1;
                    G <= 0;
                end
                else 
                begin
                    R <= 0;
                    Y <= 0;
                    G <= 0;
                end

                count1 <= 0;
                count2 <= 0;
                count3 <= 0;
                state <= Nextstate;
            end

        end
    end
end

always@(*)
begin
    case(state)
    0:begin
        Nextstate = 1;
    end

    1:begin
        Nextstate = 2;
    end

    2:begin
       Nextstate = 3;
    end

    3:begin
        Nextstate = 4;
    end

    4:begin
        Nextstate = 5;
    end

    5:begin
        Nextstate = 6;
    end

    6:begin
        Nextstate = 0;
    end
        
    endcase
end


endmodule
