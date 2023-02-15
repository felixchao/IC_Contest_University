module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

wire  cmp [7:0];
wire cmp2 [7:0];
reg [2:0] state;
reg [2:0] NextState;
reg [2:0] arr [7:0];
reg [3:0] i;
reg [3:0] count;
reg has;
reg [3:0] j;
reg [6:0] temp;
reg [9:0] total;

parameter Pivot = 0;
parameter Replace = 1;
parameter Convert = 2;
parameter Load = 3;
parameter Finish = 5;

assign cmp[0] = (arr[0] < arr[1]);
assign cmp[1] = (arr[1] < arr[2]);
assign cmp[2] = (arr[2] < arr[3]);
assign cmp[3] = (arr[3] < arr[4]);
assign cmp[4] = (arr[4] < arr[5]);
assign cmp[5] = (arr[5] < arr[6]);
assign cmp[6] = (arr[6] < arr[7]);






always@(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        has <= 0;
        Valid <= 0;
        arr[0] <= 0;
        arr[1] <= 1;
        arr[2] <= 2;
        arr[3] <= 3;
        arr[4] <= 4;
        arr[5] <= 5;
        arr[6] <= 6;
        arr[7] <= 7;
        i <= 0;
        j <= 0;
        W <= 0;
        total <= Cost;
        J <= arr[0];
        MatchCount <= 0;
        temp <= 101;
        MinCost <= 1023;
        state <= Load;
        count <= 7;
        total <= 0;
    end
    else
    begin
        state <= NextState;
        case(state)
        Load: begin
                  if(i < 8)
                  begin
                         W <= i+1;
                         J <= arr[i+1];
                         total <= total + Cost; 
                         i <= i+1;
                  end
                  else
                  begin
                        if(MinCost == total)
                        begin
                        MatchCount <= MatchCount + 1;
                        end
                        else if(MinCost > total)
                        begin
                         MinCost <= total;
                         MatchCount <= 1;
                        end
                       i <= 0;
                       j <= 7;
                  end
              end


        Pivot: begin
                    if(cmp[6])
                    begin
                             has <= 1;
                             i <= 6;
                             temp <= 8;
                    end
                    else if(cmp[5])
                    begin
                             has <= 1;
                             i <= 5;
                             temp <= 8;                        
                    end
                    else if(cmp[4])
                    begin
                             has <= 1;
                             i <= 4;
                             temp <= 8;                        
                    end
                    else if(cmp[3])
                    begin
                             has <= 1;
                             i <= 3;
                             temp <= 8;                        
                    end
                    else if(cmp[2])
                    begin
                             has <= 1;
                             i <= 2;
                             temp <= 8;                       
                    end
                    else if(cmp[1])
                    begin
                             has <= 1;
                             i <= 1;
                             temp <= 8;                        
                    end
                    else if(cmp[0])
                    begin
                             has <= 1;
                             i <= 0;
                             temp <= 8;                        
                    end
                    else
                    begin
                        Valid <= 1;
                    end
                    count <= i+1;
                end

        Replace: begin
            
                      if(count == 8)
                      begin
                          j <= 7;
                          count <= i+1;
                          arr[i] <= arr[j];
                          arr[j] <= arr[i];
                      end
                      else
                      begin
                          if(arr[i] < arr[count]&&arr[count] < temp)
                          begin
                              temp <= arr[count];
                              j <= count;
                          end
                          count <= count + 1;
                      end
                 end


        Convert: begin

                case(count)
                 0: begin
                        arr[0] <= arr[7];
                        arr[7] <= arr[0];
                        arr[1] <= arr[6];
                        arr[6] <= arr[1];
                        arr[2] <= arr[5];
                        arr[5] <= arr[2];
                        arr[3] <= arr[4];
                        arr[4] <= arr[3];
                    end
                 1: begin
                        arr[7] <= arr[1];
                        arr[1] <= arr[7];
                        arr[6] <= arr[2];
                        arr[2] <= arr[6];
                        arr[5] <= arr[3];
                        arr[3] <= arr[5];
                    end
                 2: begin
                        arr[7] <= arr[2];
                        arr[2] <= arr[7];
                        arr[6] <= arr[3];
                        arr[3] <= arr[6];
                        arr[5] <= arr[4];
                        arr[4] <= arr[5];
                    end
                 3: begin
                        arr[3] <= arr[7];
                        arr[7] <= arr[3];
                        arr[4] <= arr[6];
                        arr[6] <= arr[4];
                    end
                 4: begin
                        arr[4] <= arr[7];
                        arr[7] <= arr[4];
                        arr[5] <= arr[6];
                        arr[6] <= arr[5];
                    end
                 5: begin
                        arr[5] <= arr[7];
                        arr[7] <= arr[5];
                    end
                 6: begin
                        arr[6] <= arr[7];
                        arr[7] <= arr[6];
                    end
                 default: arr[7] <= arr[7];
                 endcase
                 total <= 0;
                j <= 1;
                count <= 7;
                i <= 0;
                has <= 0;
                W <= 0;
                J <= arr[0];
                 end

        endcase

    end
end


always@(*)
begin
    case(state)
    Load:begin
              if(i == 8)
              begin
                  NextState = Pivot;
              end
              else
              begin
                  NextState = Load;
              end
         end

    Pivot: begin
                if(has)
                begin
                    NextState = Replace;
                end
                else
                begin
                    NextState = Pivot;
                end
           end
    Replace: begin
                  if(count == 8)
                  begin
                    NextState = Convert;
                  end
                  else
                  begin
                      NextState = Replace;
                  end
             end
    Convert: begin
                    NextState = Load;
             end

    default: NextState = Load;
    endcase
end

endmodule


