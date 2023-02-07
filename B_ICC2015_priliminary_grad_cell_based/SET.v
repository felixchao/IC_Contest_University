`define abs(x,i) ((x > i) ? (x - i) : (i - x))
`define is_in(x,y,r) (x + y <= r)

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
reg [3:0] Ax, Ay, Bx, By, Cx, Cy;
reg [3:0] ra, rb, rc;
reg [3:0] i,j;
reg [7:0] Axp,Bxp,Cxp,Ayp,Byp,Cyp,rap,rbp,rcp;
reg [1:0] sets_mode;

//Determine the (i,j) is in the sets
assign in_A = `is_in(Axp,Ayp,rap);
assign in_B = `is_in(Bxp,Byp,rbp);
assign in_C = `is_in(Cxp,Cyp,rcp);

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

//Counting power (replace the multiplier == better performance)
always@(*)
begin
     case(`abs(Ax,i))
     0: Axp = 0;
     1: Axp = 1;
     2: Axp = 4;
     3: Axp = 9;
     4: Axp = 16;
     5: Axp = 25;
     6: Axp = 36;
     7: Axp = 49;
     8: Axp = 64;
     default: Axp = 0;
     endcase

    case(`abs(Ay, j))
     0: Ayp = 0;
     1: Ayp = 1;
     2: Ayp = 4;
     3: Ayp = 9;
     4: Ayp = 16;
     5: Ayp = 25;
     6: Ayp = 36;
     7: Ayp = 49;
     8: Ayp = 64;
     default: Ayp = 0;
     endcase

    case(`abs(Bx, i))
     0: Bxp = 0;
     1: Bxp = 1;
     2: Bxp = 4;
     3: Bxp = 9;
     4: Bxp = 16;
     5: Bxp = 25;
     6: Bxp = 36;
     7: Bxp = 49;
     8: Bxp = 64;
     default: Bxp = 0;
     endcase

    case(`abs(By, j))
     0: Byp = 0;
     1: Byp = 1;
     2: Byp = 4;
     3: Byp = 9;
     4: Byp = 16;
     5: Byp = 25;
     6: Byp = 36;
     7: Byp = 49;
     8: Byp = 64;
     default: Byp = 0;
     endcase

    case(`abs(Cx, i))
     0: Cxp = 0;
     1: Cxp = 1;
     2: Cxp = 4;
     3: Cxp = 9;
     4: Cxp = 16;
     5: Cxp = 25;
     6: Cxp = 36;
     7: Cxp = 49;
     8: Cxp = 64;
     default: Cxp = 0;
     endcase


    case(`abs(Cy, j))
     0: Cyp = 0;
     1: Cyp = 1;
     2: Cyp = 4;
     3: Cyp = 9;
     4: Cyp = 16;
     5: Cyp = 25;
     6: Cyp = 36;
     7: Cyp = 49;
     8: Cyp = 64;
     default: Cyp = 0;
     endcase

    case(ra)
     1: rap = 1;
     2: rap = 4;
     3: rap = 9;
     4: rap = 16;
     5: rap = 25;
     6: rap = 36;
     7: rap = 49;
     8: rap = 64;
     endcase

    case(rb)
     1: rbp = 1;
     2: rbp = 4;
     3: rbp = 9;
     4: rbp = 16;
     5: rbp = 25;
     6: rbp = 36;
     7: rbp = 49;
     8: rbp = 64;
     endcase

    case(rc)
     1: rcp = 1;
     2: rcp = 4;
     3: rcp = 9;
     4: rcp = 16;
     5: rcp = 25;
     6: rcp = 36;
     7: rcp = 49;
     8: rcp = 64;
     endcase
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


