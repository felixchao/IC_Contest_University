`define is_in(x,y,i,j,r) ((i-x)*(i-x) + (j-y)*(j-y) <= r*r)

module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;


reg [7:0] ra, rb;
reg [1:0] state;
reg [7:0] Ax , Ay, Bx, By;
reg [7:0] i,j;


always@(posedge clk or posedge rst)
begin
     if(rst)
     begin
         busy <= 0;
         valid <= 0;
         i<=1;
         j<=1;
         candidate<=0;
     end
     else
     begin
          if(en)
          begin
               Ax <= central[23:20];
               Ay <= central[19:16];
               Bx <= central[15:12];
               By <= central[11:8];
               ra <= radius[11:8];
               rb <= radius[7:4];   
               state <= mode;
               i<=1;
               j<=1;
               busy <=1;
               candidate <= 0;
          end
          
          if(valid == 1)
     begin
          i <= 1;
          j <= 1;
          valid <= 0;
          busy <= 0;
          candidate <= 0;
     end
     else if(state == 0 && busy == 1)  // mode0
     begin
          if(i <= 8)
          begin
               if(j<=8)
               begin
                   if(`is_in(Ax,Ay,i,j,ra))
                   begin
                    candidate <= candidate + 1;
                   end
                   j <= j+1;
               end
               else
               begin
                    i <= i+1;
                    j <= 1;
               end
          end
          else
          begin
               valid <= 1;
          end
     end

     else if(state == 1 && busy == 1) // mode1
     begin
          if(i <= 8)
          begin
               if(j<=8)
               begin
                   if(`is_in(Ax,Ay,i,j,ra) && `is_in(Bx,By,i,j,rb))
                   begin
                    candidate <= candidate + 1;
                   end
                   j <= j+1;
               end
               else
               begin
                    i <= i+1;
                    j <= 1;
               end
          end
          else
          begin
                valid <= 1;
          end
     end

     else if(state == 2 && busy == 1) // mode2
     begin
          if(i <= 8) 
          begin
            if(j<=8)
            begin
               if(`is_in(Ax,Ay,i,j,ra) &&  !`is_in(Bx,By,i,j,rb))
               begin
                    candidate <= candidate + 1;
               end
               else if(!`is_in(Ax,Ay,i,j,ra) && `is_in(Bx,By,i,j,rb))
               begin
                    candidate <= candidate + 1;
               end  
               j <= j+1;                 
            end
            else
            begin
               i <= i+1; 
               j <= 1; 
            end
          end
          else
          begin
                valid <= 1;
          end
     end
          
          
          
     end
end
endmodule