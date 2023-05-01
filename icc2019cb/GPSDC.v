`timescale 1ns/10ps
module GPSDC(clk, reset_n, DEN, LON_IN, LAT_IN, COS_ADDR, COS_DATA, ASIN_ADDR, ASIN_DATA, Valid, a, D);
input              clk;
input              reset_n;
input              DEN;
input      [23:0]  LON_IN;
input      [23:0]  LAT_IN;
input      [95:0]  COS_DATA;
output     reg [6:0]   COS_ADDR;
input      [127:0] ASIN_DATA;
output     reg [5:0]   ASIN_ADDR;
output     reg        Valid;
output     reg [39:0]  D;
output     reg [63:0]  a;




reg state, NextState;


parameter R = 12756274;

always @(posedge clk or negedge reset_n) 
begin
    if(reset_n)
    begin
       
    end
    else
    begin
        state <= NextState;

        case(state)




        endcase
    end
end





always@(*)
begin
     case(state)
      


     endcase
end


endmodule
