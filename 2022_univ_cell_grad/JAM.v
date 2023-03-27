module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );



reg [1:0] state, NextState;
reg [2:0] workers [7:0];
reg [9:0] costs;
reg [2:0] pivot;
reg [2:0] pivot2;
reg [2:0] temp;
reg [2:0] value;
reg [2:0] i;
wire [6:0] compare;

assign compare[0] = workers[0] < workers[1];
assign compare[1] = workers[1] < workers[2];
assign compare[2] = workers[2] < workers[3];
assign compare[3] = workers[3] < workers[4];
assign compare[4] = workers[4] < workers[5];
assign compare[5] = workers[5] < workers[6];
assign compare[6] = workers[6] < workers[7];


parameter Load = 0;
parameter Inverse = 1;
parameter Determine = 2;


//Sequentail Circuit
always@(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        Valid <= 0;
        MatchCount <= 0;
        MinCost <= 1023;
        workers[0] <= 0;
        workers[1] <= 1;
        workers[2] <= 2;
        workers[3] <= 3;
        workers[4] <= 4;
        workers[5] <= 5;
        workers[6] <= 6;
        workers[7] <= 7;
        W <= 0;
        costs <= 0;
        state <= Load;
    end
    else
    begin
        state <= NextState;
        case(state)
        Load:begin
                  if(W != 0)
                  begin
                   costs <= costs + Cost;
                  end
                  W <= W + 1;
                  J <= workers[W];
                  if(compare == 0)
                  begin
                     Valid <= 1;
                  end
             end

        Determine:begin
                     costs <= costs + Cost;
                     pivot2 <= pivot;
                     workers[pivot] <= workers[temp];
                     workers[temp] <= workers[pivot];  
                  end

        Inverse:begin
                    if(costs == MinCost)
                    begin
                       MatchCount <= MatchCount + 1;
                    end
                    else if(costs < MinCost)
                    begin
                       MinCost <= costs;
                       MatchCount <= 1;
                    end
                    costs <= 0;

                   case(pivot2)
                   0:begin
                       workers[1] <= workers[7];
                       workers[2] <= workers[6];
                       workers[3] <= workers[5];
                       workers[4] <= workers[4];
                       workers[5] <= workers[3];
                       workers[6] <= workers[2];
                       workers[7] <= workers[1];
                     end
                   1:begin
                       workers[2] <= workers[7];
                       workers[3] <= workers[6];
                       workers[4] <= workers[5];
                       workers[5] <= workers[4];
                       workers[6] <= workers[3];
                       workers[7] <= workers[2];
                     end
                   2:begin
                       workers[3] <= workers[7];
                       workers[4] <= workers[6];
                       workers[5] <= workers[5];
                       workers[6] <= workers[4];
                       workers[7] <= workers[3];
                     end
                   3:begin
                       workers[4] <= workers[7];
                       workers[5] <= workers[6];
                       workers[6] <= workers[5];
                       workers[7] <= workers[4];
                     end
                   4:begin
                       workers[5] <= workers[7];
                       workers[6] <= workers[6];
                       workers[7] <= workers[5];
                     end
                   5:begin
                       workers[6] <= workers[7];
                       workers[7] <= workers[6];
                     end
                   endcase
                end
        endcase
    end
end

//decode the pivot
always@(*)
begin
              if(compare[6])
              begin
                 pivot = 6;
              end
              else if(compare[5])
              begin
                 pivot = 5;
              end
              else if(compare[4])
              begin
                 pivot = 4;
              end
              else if(compare[3])
              begin
                 pivot = 3;
              end
              else if(compare[2])
              begin
                 pivot = 2;
              end
              else if(compare[1])
              begin 
                 pivot = 1;
              end
              else if(compare[0])
              begin
                 pivot = 0;
              end
              else
              begin
                 pivot = 0;
              end
end

//get the pivot and temp
always@(*)
begin
     value = 7;
     for(i = 7;i>0;i=i-1)
     begin
         if(workers[i] > workers[pivot] && workers[i] <= value && i > pivot)
         begin
            temp = i;
            value = workers[i];
         end
         else
         begin
           temp = temp;
         end
     end
end

//State Machine
always@(*)
begin
   case(state)
   Load:begin
           if(W == 7)
              NextState = Determine;
           else
              NextState = Load; 
        end
   Determine:begin
                NextState = Inverse;
             end

    Inverse:begin
               NextState = Load;
            end
   default:begin
              NextState = Load;
           end
    
   endcase
end


endmodule


