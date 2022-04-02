module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output valid;
output is_inside;


reg valid;
reg is_inside;
reg [2:0] count;
reg signed [10:0] fx [6:0];
reg signed [10:0] fy [6:0];
reg [2:0] i;
reg [2:0] j;
reg [1:0] state;
reg c1;
reg c2;
reg t;
reg [2:0] x;
reg [2:0] y;



always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
        valid <= 0;
        count <= 0;
        i<=5;
        j<=1;
        state <= 0;
        is_inside <= 0;
        c1 <= 0;
        c2 <= 0;
    end

    else
    begin
         case(state)
         0:
         begin
            if(count == 7)
            begin
                count <= 0;
                state <= 1;
                x <= 2;
                y <= 3;
                t <= 1;
                i <= 4;
                j <= 0;
            end
            else
             begin
                fx[count] <= X;
                fy[count] <= Y;
             end
            count <= count + 1;
         end

        1:  //sort
        begin

        
        if(i>=1 && i<=5)
        begin
           if(j<=i)
           begin
                if((fx[x]-fx[t])*(fy[y]-fy[t]) - (fx[y]-fx[t])*(fy[x]-fy[t]) > 0)
                begin 
                    fx[j+2] <= fx[j+1];
                    fy[j+2] <= fy[j+1];
                    fx[j+1] <= fx[j+2];
                    fy[j+1] <= fy[j+2];
                end
                j <= j+1;
                x <= j+2;
                y <= j+3;
           end
           else
           begin
               i <= i-1;
               j <= 1;
               x <= 2;
               y <= 3;
           end
        end
        else
        begin
            state <= 2;
            i <= 1;
            j <= 2;
            x <= 1;
            y <= 2;
            t <= 0;
        end
    end

    2:  //determine
    begin      
        if(i<=6)
        begin
             if(i == 5)
             begin
                 j <= 1;
                 y <= 1;
             end
             else
             begin
                j <= i+2;
                y <= i+2;
             end

              if( (fx[x]-fx[t])*(fy[y]-fy[t]) - (fx[y]-fx[t])*(fy[x]-fy[t]) > 0)
              begin
                   c1 <= 1;
              end
              else
              begin
                   c2 <= 1;
              end
             i<=i+1;
             x<=i+1;
         end
         else
         begin
         if(c1 == 0||c2 == 0)
           is_inside <= 1;
        else
           is_inside <= 0;

           valid <= 1;
           state <= 3;
         end
    end

    3:
    begin
         valid <= 0;
         is_inside <= 0;
         state <= 0;
         c1 <= 0;
         c2 <= 0;
         count <= 0;
    end
    endcase
    end
end




endmodule

