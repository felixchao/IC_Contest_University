`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
*/
module CS(Y, X, reset, clk);

input clk, reset; 
input [7:0] X;
output reg [9:0] Y;

reg [7:0] mem [8:0];
reg [10:0] sum;

integer i;
reg [11:0] Xappr;
reg state;
reg [3:0] cnt;

always@(posedge clk or posedge reset)
begin
     if(reset)
     begin
          sum<=0;
          i<=0;
          state<=0;
          cnt <= 0;
     end
     else
     begin
          if(state == 0)
          begin

              mem[cnt] <= X;
              sum <= sum + X;
              cnt <= cnt + 1;
              if(cnt == 8)
              begin
                   state <= 1;
                   cnt <= 0;
              end
          end
          else if(state == 1)
          begin
               for (i = 0;i<8;i=i+1) 
                    mem[i] <= mem[i+1];
               mem[8] <= X;
               sum <= sum - mem[0] + X;
          end
     end
end

always@(*)
begin
     Xappr = 0;
     for(i = 0;i<9;i=i+1)
     begin
          if((mem[i]<=sum/9)&&(mem[i]>Xappr))
              Xappr = mem[i];
     end
     Y = (sum+(Xappr<<3)+Xappr)>>3;
end 
endmodule

