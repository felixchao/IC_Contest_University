module huffman(clk, reset, gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, gray_data, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;

reg [3:0] state, NextState;
reg [6:0] counter;
reg [2:0] i,j,k;

//Combination Stage tables
reg [5:0] C0_arr [5:0];
reg [5:0] C1_arr [4:0];
reg [5:0] C2_arr [3:0];
reg [5:0] C3_arr [2:0];
reg [5:0] C4_arr [1:0];

reg [7:0] sorting_arr [5:0];
reg [7:0] buffer_arr [4:0];
reg [7:0] value;
reg [7:0] temp;
reg [7:0] hc [5:0];
reg [7:0] hm [5:0];

//States
parameter Load_Data = 0;
parameter Initialize = 1;
parameter C1 = 2;
parameter C2 = 3;
parameter C3 = 4;
parameter C4 = 5;
parameter Split = 6;
parameter Finish = 7;

//Symbols
parameter A1 = 1;
parameter A2 = 2;
parameter A3 = 3;
parameter A4 = 4;
parameter A5 = 5;
parameter A6 = 6;


//Sequential Circuit
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
      state <= Load_Data;
      CNT1 <= 0;
      CNT2 <= 0;
      CNT3 <= 0;
      CNT4 <= 0;
      CNT5 <= 0;
      CNT6 <= 0;
      counter <= 0;
      CNT_valid <= 0;
      code_valid <= 0;
      for(k = 0;k<6;k=k+1)
      begin
        hc[k] <= 0;
        hm[k] <= 0;
      end
    end
    else
    begin
        state <= NextState;

        case(state)
        Load_Data:begin
                     if(gray_valid)
                     begin
                        if(counter == 99)
                        begin
                          counter <= 0;
                          CNT_valid <= 1;
                        end
                        else
                        begin
                          counter <= counter + 1;
                        end

                        case(gray_data)
                        A1: CNT1 <= CNT1 + 1;
                        A2: CNT2 <= CNT2 + 1;
                        A3: CNT3 <= CNT3 + 1;
                        A4: CNT4 <= CNT4 + 1;
                        A5: CNT5 <= CNT5 + 1;
                        A6: CNT6 <= CNT6 + 1;
                        endcase
                     end
                  end

        Initialize:begin
                     CNT_valid <= 0;
                     value <= sorting_arr[5] + sorting_arr[4];
                   end

        C1:begin
              if(value > sorting_arr[0])
              begin
                 C1_arr[0] <= C0_arr[5] + C0_arr[4];
                 C1_arr[1] <= C0_arr[0];
                 C1_arr[2] <= C0_arr[1];
                 C1_arr[3] <= C0_arr[2];
                 C1_arr[4] <= C0_arr[3];
                 buffer_arr[0] <= value;
                 buffer_arr[1] <= sorting_arr[0];
                 buffer_arr[2] <= sorting_arr[1];
                 buffer_arr[3] <= sorting_arr[2];
                 buffer_arr[4] <= sorting_arr[3];
                 value <= sorting_arr[2] + sorting_arr[3];
              end  
              else if(value > sorting_arr[1])
              begin
                 C1_arr[1] <= C0_arr[5] + C0_arr[4];
                 C1_arr[0] <= C0_arr[0];
                 C1_arr[2] <= C0_arr[1];
                 C1_arr[3] <= C0_arr[2];
                 C1_arr[4] <= C0_arr[3];
                 buffer_arr[1] <= value;
                 buffer_arr[0] <= sorting_arr[0];
                 buffer_arr[2] <= sorting_arr[1];
                 buffer_arr[3] <= sorting_arr[2];
                 buffer_arr[4] <= sorting_arr[3];
                 value <= sorting_arr[2] + sorting_arr[3];
              end
              else if(value > sorting_arr[2])
              begin
                 C1_arr[2] <= C0_arr[5] + C0_arr[4];
                 C1_arr[0] <= C0_arr[0];
                 C1_arr[1] <= C0_arr[1];
                 C1_arr[3] <= C0_arr[2];
                 C1_arr[4] <= C0_arr[3];
                 buffer_arr[2] <= value;
                 buffer_arr[0] <= sorting_arr[0];
                 buffer_arr[1] <= sorting_arr[1];
                 buffer_arr[3] <= sorting_arr[2];
                 buffer_arr[4] <= sorting_arr[3];
                 value <= sorting_arr[2] + sorting_arr[3];
              end
              else if(value > sorting_arr[3])
              begin
                 C1_arr[3] <= C0_arr[5] + C0_arr[4];
                 C1_arr[0] <= C0_arr[0];
                 C1_arr[1] <= C0_arr[1];
                 C1_arr[2] <= C0_arr[2];
                 C1_arr[4] <= C0_arr[3];
                 buffer_arr[3] <= value;
                 buffer_arr[0] <= sorting_arr[0];
                 buffer_arr[1] <= sorting_arr[1];
                 buffer_arr[2] <= sorting_arr[2];
                 buffer_arr[4] <= sorting_arr[3];
                 value <= sorting_arr[3] + value;
              end  
              else
              begin
                 C1_arr[4] <= C0_arr[5] + C0_arr[4];
                 C1_arr[0] <= C0_arr[0];
                 C1_arr[1] <= C0_arr[1];
                 C1_arr[2] <= C0_arr[2];
                 C1_arr[3] <= C0_arr[3];
                 buffer_arr[4] <= value;
                 buffer_arr[0] <= sorting_arr[0];
                 buffer_arr[1] <= sorting_arr[1];
                 buffer_arr[2] <= sorting_arr[2];
                 buffer_arr[3] <= sorting_arr[3];
                 value <= sorting_arr[3] + value;
              end
           end

        C2:begin
              if(value > buffer_arr[0])
              begin
                 C2_arr[0] <= C1_arr[3] + C1_arr[4];
                 C2_arr[1] <= C1_arr[0];
                 C2_arr[2] <= C1_arr[1];
                 C2_arr[3] <= C1_arr[2];
                 buffer_arr[0] <= value;
                 buffer_arr[1] <= buffer_arr[0];
                 buffer_arr[2] <= buffer_arr[1];
                 buffer_arr[3] <= buffer_arr[2];
                 value <= buffer_arr[2] + buffer_arr[1];
              end  
              else if(value > buffer_arr[1])
              begin
                 C2_arr[1] <= C1_arr[3] + C1_arr[4];
                 C2_arr[0] <= C1_arr[0];
                 C2_arr[2] <= C1_arr[1];
                 C2_arr[3] <= C1_arr[2];
                 buffer_arr[1] <= value;
                 buffer_arr[2] <= buffer_arr[1];
                 buffer_arr[3] <= buffer_arr[2];
                 value <= buffer_arr[2] + buffer_arr[1];
              end
              else if(value > buffer_arr[2])
              begin
                 C2_arr[2] <= C1_arr[3] + C1_arr[4];
                 C2_arr[0] <= C1_arr[0];
                 C2_arr[1] <= C1_arr[1];
                 C2_arr[3] <= C1_arr[2];
                 buffer_arr[2] <= value;
                 buffer_arr[3] <= buffer_arr[2];
                 value <= buffer_arr[2] + value;
              end
              else
              begin
                 C2_arr[3] <= C1_arr[3] + C1_arr[4];
                 C2_arr[0] <= C1_arr[0];
                 C2_arr[1] <= C1_arr[1];
                 C2_arr[2] <= C1_arr[2];
                 buffer_arr[3] <= value;
                 value <= buffer_arr[2] + value;
              end
           end

        C3:begin
              if(value > buffer_arr[0])
              begin
                 C3_arr[0] <= C2_arr[3] + C1_arr[2];
                 C3_arr[1] <= C2_arr[0];
                 C3_arr[2] <= C2_arr[1];
                 buffer_arr[0] <= value;
                 buffer_arr[1] <= buffer_arr[0];
                 buffer_arr[2] <= buffer_arr[1];
                 value <= buffer_arr[0] + buffer_arr[1];
              end  
              else if(value > buffer_arr[1])
              begin
                 C3_arr[1] <= C2_arr[3] + C2_arr[2];
                 C3_arr[0] <= C2_arr[0];
                 C3_arr[2] <= C2_arr[1];
                 buffer_arr[1] <= value;
                 buffer_arr[2] <= buffer_arr[1];
                 value <= value + buffer_arr[1];
              end
              else
              begin
                 C3_arr[2] <= C2_arr[3] + C2_arr[2];
                 C3_arr[0] <= C2_arr[0];
                 C3_arr[1] <= C2_arr[1];
                 buffer_arr[2] <= value;
                 value <= value + buffer_arr[1];
              end
           end

        C4:begin
              if(value > buffer_arr[0])
              begin
                 C4_arr[0] <= C3_arr[1] + C3_arr[2];
                 C4_arr[1] <= C3_arr[0];
                 buffer_arr[0] <= value;
                 buffer_arr[1] <= buffer_arr[0];
              end  
              else
              begin
                 C4_arr[1] <= C3_arr[1] + C3_arr[2];
                 C4_arr[0] <= C3_arr[0];
                 buffer_arr[1] <= value;
              end
           end

        Split:begin
                 case(counter)
                 0:begin
                      for(k=0;k<6;k=k+1)
                      begin
                         if(C4_arr[0][k])
                         begin
                            hm[k] <= 1;
                         end
                         else if(C4_arr[1][k])
                         begin
                            hc[k] <= (hc[k] | 1); 
                            hm[k] <= 1;
                         end
                      end             
                   end
                 1:begin
                      for(k=0;k<6;k=k+1)
                      begin
                         if(C3_arr[1][k])
                         begin
                            hm[k] <= (hm[k] << 1) + 1;
                            hc[k] <= hc[k] << 1; 
                         end
                         else if(C3_arr[2][k])
                         begin
                            hc[k] <= ((hc[k] << 1) | 1);
                            hm[k] <= (hm[k] << 1) + 1; 
                         end
                      end 
                   end
                 2:begin
                      for(k=0;k<6;k=k+1)
                      begin
                         if(C2_arr[2][k])
                         begin
                            hm[k] <= (hm[k] << 1) + 1; 
                            hc[k] <= hc[k] << 1; 
                         end
                         else if(C2_arr[3][k])
                         begin
                            hc[k] <= ((hc[k] << 1) | 1);
                            hm[k] <= (hm[k] << 1) + 1; 
                         end
                      end 
                   end

                 3:begin
                      for(k=0;k<6;k=k+1)
                      begin
                         if(C1_arr[3][k])
                         begin
                            hm[k] <= (hm[k] << 1) + 1; 
                            hc[k] <= hc[k] << 1; 
                         end
                         else if(C1_arr[4][k])
                         begin
                            hc[k] <= ((hc[k] << 1) | 1);
                            hm[k] <= (hm[k] << 1) + 1; 
                         end
                      end 
                   end

                 4:begin
                      for(k=0;k<6;k=k+1)
                      begin
                         if(C0_arr[4][k])
                         begin
                            hm[k] <= (hm[k] << 1) + 1; 
                            hc[k] <= hc[k] << 1; 
                         end
                         else if(C0_arr[5][k])
                         begin
                            hc[k] <= ((hc[k] << 1) | 1);
                            hm[k] <= (hm[k] << 1) + 1; 
                         end
                      end 
                   end
                 endcase
                 counter <= counter + 1;
              end

        Finish:begin
                 HC1 <= hc[0];
                 HC2 <= hc[1];
                 HC3 <= hc[2];
                 HC4 <= hc[3];
                 HC5 <= hc[4];
                 HC6 <= hc[5];
                 M1 <= hm[0];
                 M2 <= hm[1];
                 M3 <= hm[2];
                 M4 <= hm[3];
                 M5 <= hm[4];
                 M6 <= hm[5];
                 code_valid <= 1;
               end
        endcase
    end
end

//Double Sorting for values and symbols
always@(*)
begin
   
   C0_arr[0] = 1;
   C0_arr[1] = 2;
   C0_arr[2] = 4;
   C0_arr[3] = 8;
   C0_arr[4] = 16;
   C0_arr[5] = 32;

   sorting_arr[0] = CNT1;
   sorting_arr[1] = CNT2;
   sorting_arr[2] = CNT3;
   sorting_arr[3] = CNT4;
   sorting_arr[4] = CNT5;
   sorting_arr[5] = CNT6;

   for(i = 0;i<6;i=i+1)
   begin
      for(j = i+1;j<6;j=j+1)
      begin
         if(sorting_arr[i] < sorting_arr[j] || (sorting_arr[i] == sorting_arr[j] && C0_arr[i] > C0_arr[j]))
         begin
            temp = sorting_arr[i];
            sorting_arr[i] = sorting_arr[j];
            sorting_arr[j] = temp;

            temp = C0_arr[i];
            C0_arr[i] = C0_arr[j];
            C0_arr[j] = temp;
         end
      end
   end

end

//State Machine
always@(*)
begin
    case(state)
      Load_Data:begin
                  if(counter == 99)
                     NextState = Initialize;
                  else
                     NextState = Load_Data;
                end

      Initialize:begin
                    NextState = C1;
                 end
    
      C1:begin
           NextState = C2;
         end

      C2:begin
           NextState = C3;
         end

      C3:begin
           NextState = C4;
         end

      C4:begin
           NextState = Split;
         end

      Split:begin
               if(counter == 4)
                NextState = Finish;
               else
                NextState = Split;
            end

      Finish:begin
                NextState = Finish;
             end

    endcase
end
  
endmodule

