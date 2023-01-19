module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);
input clk, reset, nt;
input [2:0] xi, yi;
output reg busy, po;
output reg [2:0] xo, yo;


reg [1:0] state, NextState;
reg [4:0] x1,y1,x2,y3;
reg [5:0] count;




parameter Initialize = 0;
parameter Determination = 1;
parameter Next_Coordinate = 2;
parameter Finish = 3;


//Sequential Circuit
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        busy <= 0;
        po <= 0;
        count <= 0;
        state <= Initialize;
    end
    else
    begin
      state <= NextState;

      case(state)
      Initialize: begin
                      case(count)
                      0:begin
                           if(nt == 1)
                           begin
                              x1 <= xi;
                              y1 <= yi;
                              count <= 1;
                           end
                        end

                      1:begin
                           x2 <= xi;
                           count <= 2;
                        end

                      2:begin
                           y3 <= yi;
                           busy <= 1;
                           count <= 0;
                        end
                      endcase
                  end

      Determination: begin
                         if(count[2:0] >= x1 && count[5:3] >= y1 && count[2:0] <= x2 && count[5:3] <= y3)
                         begin
                              if((x2 - count[2:0])*(y3 - y1) >= (x2 - x1)*(count[5:3] - y1))
                              begin
                                  po <= 1;
                                  xo <= count[2:0];
                                  yo <= count[5:3];
                              end
                         end
                     end

      Next_Coordinate: begin
                          po <= 0;
                          count <= count + 1;
                       end

      Finish: begin
                   count <= 0;
                   busy <= 0;
              end
      endcase
    end
end


//State Machine
always@(*)
begin
    case(state)
    Initialize: begin
                    if(count == 2)
                      NextState = Determination;
                    else
                      NextState = Initialize;
                end

    Determination: begin
                      NextState = Next_Coordinate;
                   end

    Next_Coordinate: begin
                        if(count == 63)
                           NextState = Finish;
                        else
                           NextState = Determination;
                     end
    Finish: begin
                NextState = Initialize;
            end

    endcase
end
                   

endmodule
