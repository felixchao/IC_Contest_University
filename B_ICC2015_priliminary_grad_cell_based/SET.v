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

reg [1:0] state, NextState;
wire in_A, in_B, in_C;
reg [7:0] Ax, Ay, Bx, By, Cx, Cy;
reg [7:0] ra, rb, rc;
reg [7:0] i,j;
reg [1:0] sets_mode;

//Determine the (i,j) is in the sets
assign in_A = `is_in(Ax,Ay,i,j,ra);
assign in_B = `is_in(Bx,By,i,j,rb);
assign in_C = `is_in(Cx,Cy,i,j,rc);

parameter Detection = 0;
parameter Counting = 1;
parameter Finish = 2;

parameter Mode1 = 0;
parameter Mode2 = 1;
parameter Mode3 = 2;
parameter Mode4 = 3;

//Sequential Circuit
always@(posedge clk or posedge rst)
begin
   if(rst)
   begin
     busy <= 0;
     valid <= 0;
     i <= 1;
     j <= 1;
     state <= Detection;
     candidate <= 0;
   end
   else
   begin
      state <= NextState;

      case(state)
      Detection:begin
                  if(en)
                  begin
                     candidate <= 0;
                     i <= 1;
                     j <= 1;
                     busy <= 1;
                     valid <= 0;
                     sets_mode <= mode;
                     case(mode)
                     Mode1:begin
                             Ax <= central[23:20];
                             Ay <= central[19:16];
                             ra <= radius[11:8];
                           end

                     Mode2:begin
                             Ax <= central[23:20];
                             Ay <= central[19:16];
                             ra <= radius[11:8];
                             Bx <= central[15:12];
                             By <= central[11:8];
                             rb <= radius[7:4];
                           end

                     Mode3:begin
                             Ax <= central[23:20];
                             Ay <= central[19:16];
                             ra <= radius[11:8];
                             Bx <= central[15:12];
                             By <= central[11:8];
                             rb <= radius[7:4];
                           end

                     Mode4:begin
                             Ax <= central[23:20];
                             Ay <= central[19:16];
                             ra <= radius[11:8];
                             Bx <= central[15:12];
                             By <= central[11:8];
                             rb <= radius[7:4];
                             Cx <= central[7:4];
                             Cy <= central[3:0];
                             rc <= radius[3:0];
                           end
                     endcase
                  end
                end

      Counting:begin
                 case(sets_mode)
                 Mode1:begin
                         if(i <= 8)
                         begin
                           if(j <= 8)
                           begin
                             if(in_A)
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
                       end
                 Mode2:begin
                         if(i <= 8)
                         begin
                           if(j <= 8)
                           begin
                             if(in_A && in_B)
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
                       end
                 Mode3:begin
                         if(i <= 8)
                         begin
                           if(j <= 8)
                           begin
                             if((in_A || in_B) && !(in_A && in_B))
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
                       end                 
                 Mode4:begin
                         if(i <= 8)
                         begin
                           if(j <= 8)
                           begin
                             if(((in_A && in_B) || (in_B && in_C) || (in_A && in_C)) && !(in_A && in_B && in_C))
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
                       end
                 endcase
               end

      Finish:begin
               valid <= 1;
               busy <= 0;
             end
 

      endcase
   end
end

//State Machine
always@(*)
begin
   case(state)
   Detection:begin
                if(en)
                  NextState = Counting;
                else
                  NextState = Detection;
             end

   Counting:begin
              if(i == 8 && j == 8)
                NextState = Finish;
              else
                NextState = Counting;
            end

   Finish:begin
             NextState = Detection;
          end

   default:begin
             NextState = Finish;
           end
   endcase
end


endmodule


