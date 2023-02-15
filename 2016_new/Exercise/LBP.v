
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
input   	gray_ready;
input   [7:0] 	gray_data;
output  reg [13:0] 	gray_addr;
output  reg      	gray_req;
output  reg [13:0] 	lbp_addr;
output  reg	lbp_valid;
output  reg [7:0] 	lbp_data;
output  reg	finish;

reg [1:0] state, NextState;
reg [7:0] sliding_window [8:0];
reg [7:0] center;
reg [3:0] counter;
wire binary_data [7:0];

parameter Load_Window = 0;
parameter Write = 1;
parameter Reset = 2;

assign binary_data[0] = sliding_window[0] >= center;
assign binary_data[1] = sliding_window[1] >= center;
assign binary_data[2] = sliding_window[2] >= center;
assign binary_data[3] = sliding_window[3] >= center;
assign binary_data[4] = sliding_window[4] >= center;
assign binary_data[5] = sliding_window[5] >= center;
assign binary_data[6] = sliding_window[6] >= center;
assign binary_data[7] = sliding_window[7] >= center;

//====================================================================

always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
      state <= Load_Window;
      gray_addr <= 129;
      gray_req <= 0;
      lbp_addr <= 0;
      lbp_valid <= 0;
      finish <= 0;
      counter <= 0;
    end
    else
    begin
        state <= NextState;
        case(state)
        Load_Window:begin 
                       if(gray_ready)
                       begin
                         gray_req <= 1;
                         case(counter)
                         0:begin
                              gray_addr <= gray_addr - 129;
                           end
                         1:begin
                              gray_addr <= gray_addr + 1;
                              sliding_window[0] <= gray_data;
                           end
                         2:begin
                              gray_addr <= gray_addr + 1;
                              sliding_window[1] <= gray_data;
                           end
                         3:begin
                              gray_addr <= gray_addr + 126;
                              sliding_window[2] <= gray_data;
                           end
                         4:begin
                              gray_addr <= gray_addr + 1;
                              sliding_window[3] <= gray_data;
                           end
                         5:begin
                              gray_addr <= gray_addr + 1;
                              center <= gray_data;
                           end
                         6:begin
                              gray_addr <= gray_addr + 126;
                              sliding_window[4] <= gray_data;
                           end
                         7:begin
                              gray_addr <= gray_addr + 1;
                              sliding_window[5] <= gray_data;
                           end
                         8:begin
                              gray_addr <= gray_addr + 1;
                              sliding_window[6] <= gray_data;
                           end
                         9:begin
                              gray_addr <= gray_addr - 129;
                              sliding_window[7] <= gray_data;
                              gray_req <= 0;
                           end
                         endcase
                         counter <= counter + 1;
                       end
                    end

        Write:begin
                lbp_addr <= gray_addr;
                lbp_data <= {binary_data[7], binary_data[6], binary_data[5], binary_data[4], binary_data[3], binary_data[2], binary_data[1], binary_data[0]};
                lbp_valid <= 1;
              end

        Reset:begin
                if(lbp_addr == 16254)
                begin
                   finish <= 1;
                end
                else
                begin
                   counter <= 0;
                   if(gray_addr[6:0]==126)
                   begin
                     gray_addr <= gray_addr + 3;
                   end
                   else
                   begin
                     gray_addr <= gray_addr + 1;
                   end
                   lbp_valid <= 0;
                end
              end
        endcase
    end
end


//State machine
always@(*)
begin
    case(state)
    Load_Window:begin
                  if(counter == 9)
                    NextState = Write;
                  else
                    NextState = Load_Window;
                end

    Write:begin
             NextState = Reset;
          end

    Reset:begin
              if(lbp_addr == 16254)
               NextState = Reset;
              else
               NextState = Load_Window;
          end
    default:begin
              NextState = Reset;
            end
    endcase
end

//====================================================================
endmodule
