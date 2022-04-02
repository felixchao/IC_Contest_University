
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

reg [1:0] state;
reg [1:0] NextState;
reg [13:0] cpos;
reg [3:0] count;
reg [13:0] pixels;
reg [7:0] mem [8:0];
reg [7:0] sum;
reg [6:0] r;


parameter Request = 0;
parameter Process = 1;
parameter Store = 2;
parameter Finish = 3;


//====================================================================

always @(posedge clk or posedge reset) 
begin
    if(reset)
    begin
        finish <= 0;
        lbp_valid <= 0;
        state <= Request;
        gray_req <= 0;
        count <= 0;
        pixels <= 0;
        cpos <= 129;
        sum <= 0;
        r <= 1;
    end
    else
    begin
        state <= NextState;
        case(state)
        Request:  begin
                       if(gray_ready && !gray_req)
                       begin
                           gray_req <= 1;
                           gray_addr <= cpos - 129;
                       end
                       else if(gray_req)
                       begin
                           case(count)
        
                               0:  begin 
                                        gray_addr <= cpos - 128;
                                        count <= count + 1;
                                   end
                               1:  begin
                                        gray_addr <= cpos - 127;
                                        count <= count + 1;
                                   end
                               2:  begin
                                        gray_addr <= cpos - 1;
                                        count <= count + 1;
                                   end
                               3:  begin
                                        gray_addr <= cpos + 1;
                                        count <= count + 1;
                                   end
                               4:  begin
                                        gray_addr <= cpos + 127;
                                        count <= count + 1;
                                   end
                               5:  begin
                                        gray_addr <= cpos + 128;
                                        count <= count + 1;
                                   end
                               6:  begin
                                        gray_addr <= cpos + 129;
                                        count <= count + 1;
                                   end
                               7:  begin
                                        gray_addr <= cpos;
                                        count <= count + 1;
                                   end
                               8:  begin
                                        gray_req <= 0;    
                                        count <= 0;   
                                   end
                           endcase
                        mem[count] <= gray_data;
                       end

                  end

        Process:  begin
                      if(mem[count] >= mem[8])
                      begin
                          sum[count] <= 1;
                      end
                      else
                      begin
                          sum[count] <= 0;
                      end
                      count <= count + 1;
                  end
    
        Store:  begin
                    if(r == 126)
                    begin
                        cpos <= cpos + 3;
                        r <= 1;
                    end
                    else
                    begin
                        cpos <= cpos + 1;
                        r <= r + 1;
                    end
                    lbp_addr <= cpos;
                    lbp_data <= sum;
                    lbp_valid <= 1;
                    pixels <= pixels + 1;
                end     

        Finish: begin
                    if(pixels == 15876)
                    begin
                    finish <= 1;
                    end
                    else
                    begin
                      count <= 0;
                      lbp_valid <= 0;
                      sum <= 0;
                    end

                end
        
        endcase
    end
end


//State machine
always@(*)
begin
    case(state)
    Request:  begin
                 if(count == 8)
                 begin
                     NextState = Process;
                 end
                 else
                 begin
                     NextState = Request;
                 end
              end

    Process:  begin
                 if(count == 7)
                 begin
                    NextState = Store;
                 end
                 else
                 begin
                     NextState = Process;
                 end

              end
    
    Store: begin
                NextState = Finish;
           end

    Finish: begin
                if(pixels == 15876)
                begin
                    NextState = Finish;
                end
                else
                begin
                    NextState = Request;
                end
           end 

    default: NextState = Finish;

    endcase
end

//====================================================================
endmodule
