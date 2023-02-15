
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

parameter Load_Image = 0;
parameter


//====================================================================

always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
      state <= Load_Image;
      gray_addr <= 0;
      gray_
    end
    else
    begin
        state <= NextState;
        case(state)
        Load_Image:begin

                   end
        endcase
    end
end


//State machine
always@(*)
begin
    case(state)
    Load_Image:begin
                 NextState = ;
               end

    endcase
end

//====================================================================
endmodule
