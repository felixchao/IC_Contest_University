`timescale 1ns/10ps
module IOTDF( clk, rst, in_en, iot_in, fn_sel, busy, valid, iot_out);
input          clk;
input          rst;
input          in_en;
input  [7:0]   iot_in;
input  [2:0]   fn_sel;
output reg     busy;
output reg     valid;
output reg [127:0] iot_out;

reg [130:0] avg;
reg [127:0] input_buffer;
reg [3:0] state, NextState;
reg [3:0] counter;
reg [2:0] input_counter;
wire [6:0] index;
reg flag;

assign index = (15 - counter)<<3;

parameter Load = 0;
parameter F1 = 1;
parameter F2 = 2;
parameter F3 = 3;
parameter F4 = 4;
parameter F5 = 5;
parameter F6 = 6;
parameter F7 = 7;
parameter Reset = 8;


parameter Low_4 = 128'h6FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
parameter High_4 = 128'hAFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
parameter Low_5 = 128'h7FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
parameter High_5 = 128'hBFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


always@(posedge clk or posedge rst)
begin
   if(rst)
   begin
       state <= Load;
   end
   else
   begin
       state <= NextState;
   end
end



always @(posedge clk or posedge rst) 
begin
    if(rst)
    begin
       flag <= 0;
       avg <= 0;
       input_buffer <= 0;
       input_counter <= 0;
       busy <= 0;
       valid <= 0;
       counter <= 0;
       if(fn_sel == F7)
         iot_out <= 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
       else
         iot_out <= 0;
    end
    else
    begin
       case(state)
       Load:begin
              if(in_en)
              begin
                if(counter == 15)
                begin
                   input_buffer <= (iot_in << index) | input_buffer;
                   counter <= 0;
                   input_counter <= input_counter + 1;
                end
                else
                begin
                   if(counter == 14)
                   begin
                      busy <= 1;
                   end
                   input_buffer <= (iot_in << index) | input_buffer;
                   counter <= counter + 1;
                end
              end
            end

       F1:begin            
            if(input_counter == 0)
            begin
               iot_out <= (input_buffer > iot_out) ? input_buffer : iot_out;
               valid <= 1;
            end
            else if(input_counter == 1)
            begin
               iot_out <= input_buffer;
            end
            else
            begin
               iot_out <= (input_buffer > iot_out) ? input_buffer : iot_out;
            end
          end

      F2:begin
            if(input_counter == 0)
            begin
               iot_out <= (input_buffer < iot_out) ? input_buffer : iot_out;
               valid <= 1;
            end
            else if(input_counter == 1)
            begin
               iot_out <= input_buffer;
            end
            else
            begin
               iot_out <= (input_buffer < iot_out) ? input_buffer : iot_out;
            end
         end

      F3:begin
            if(input_counter == 0)
            begin
               iot_out <= (avg + input_buffer) >> 3;
               valid <= 1;
            end
            else if(input_counter == 1)
            begin
               avg <= input_buffer;
            end
            else
            begin
               avg <= avg + input_buffer;
            end
         end

      F4:begin
            iot_out <= input_buffer;
            if(input_buffer > Low_4 && input_buffer < High_4)
               valid <= 1;
         end

      F5:begin
            iot_out <= input_buffer;
            if(input_buffer < Low_5 || input_buffer > High_5)
               valid <= 1;
         end

      F6:begin
            if(input_counter == 0)
            begin
               flag <= 0;
               if(input_buffer > iot_out)
               begin
                  iot_out <= input_buffer;
                  valid <= 1;
               end
               else
                  valid <= flag;
            end
            else
            begin
               if(input_buffer > iot_out)
               begin
                  flag <= 1;
                  iot_out <= input_buffer;
               end
            end
         end

      F7:begin
            if(input_counter == 0)
            begin
               flag <= 0;
               if(input_buffer < iot_out)
               begin
                  iot_out <= input_buffer;
                  valid <= 1;
               end
               else
                  valid <= flag;
            end
            else
            begin
               if(input_buffer < iot_out)
               begin
                  flag <= 1;
                  iot_out <= input_buffer;
               end
            end
         end

      
      Reset:begin
               input_buffer <= 0;
               busy <= 0;
               valid <= 0;
            end


       endcase
    end
end


always@(*)
begin
   case(state)
   Load:begin
           if(counter == 15)
              NextState = fn_sel;
           else
              NextState = Load;
        end

   Reset:begin
            NextState = Load;
         end

   default:begin
             NextState = Reset;
           end
   endcase
end


endmodule
