`include "../FFT_PE/FFT_PE.v"

module FAS(
       clk, 
       rst, 
       data_valid, 
       data, 
       fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7,
       fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15,
       fft_valid,
       done,
       freq
       );
       
input	clk;
input	rst;
input	data_valid;
input signed [15:0] data;
output signed [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
              fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
output reg fft_valid;
output reg done;                      
output reg [3:0] freq;

reg [2:0] state, NextState;
reg signed [31:0] buffer [159:0];
reg [7:0] counter;
reg [2:0] stage;
wire signed [31:0] data_flow_stage2 [15:0]; 
wire signed [31:0] data_flow_stage3 [15:0];
wire signed [31:0] data_flow_stage4 [15:0];

wire [31:0] determine [15:0]; 
wire [3:0] id1 [7:0];
wire [3:0] id2 [3:0];
wire [3:0] id3 [1:0];
wire [3:0] id4;

parameter Load_Data = 0;
parameter Transform = 1;
parameter Analysis = 2;
parameter Reset = 3;


//Stage 1
FFT_PE fft1_0(.clk(clk), .rst(rst), .a(buffer[counter]), .b(buffer[counter + 8]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage2[0]), .fft_b(data_flow_stage2[8]), .fft_pe_valid());
FFT_PE fft1_1(.clk(clk), .rst(rst), .a(buffer[counter+1]), .b(buffer[counter + 9]), .power(3'd1), .ab_valid(1), .fft_a(data_flow_stage2[1]), .fft_b(data_flow_stage2[9]), .fft_pe_valid());
FFT_PE fft1_2(.clk(clk), .rst(rst), .a(buffer[counter+2]), .b(buffer[counter + 10]), .power(3'd2), .ab_valid(1), .fft_a(data_flow_stage2[2]), .fft_b(data_flow_stage2[10]), .fft_pe_valid());
FFT_PE fft1_3(.clk(clk), .rst(rst), .a(buffer[counter+3]), .b(buffer[counter + 11]), .power(3'd3), .ab_valid(1), .fft_a(data_flow_stage2[3]), .fft_b(data_flow_stage2[11]), .fft_pe_valid());
FFT_PE fft1_4(.clk(clk), .rst(rst), .a(buffer[counter+4]), .b(buffer[counter + 12]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage2[4]), .fft_b(data_flow_stage2[12]), .fft_pe_valid());
FFT_PE fft1_5(.clk(clk), .rst(rst), .a(buffer[counter+5]), .b(buffer[counter + 13]), .power(3'd5), .ab_valid(1), .fft_a(data_flow_stage2[5]), .fft_b(data_flow_stage2[13]), .fft_pe_valid());
FFT_PE fft1_6(.clk(clk), .rst(rst), .a(buffer[counter+6]), .b(buffer[counter + 14]), .power(3'd6), .ab_valid(1), .fft_a(data_flow_stage2[6]), .fft_b(data_flow_stage2[14]), .fft_pe_valid());
FFT_PE fft1_7(.clk(clk), .rst(rst), .a(buffer[counter+7]), .b(buffer[counter + 15]), .power(3'd7), .ab_valid(1), .fft_a(data_flow_stage2[7]), .fft_b(data_flow_stage2[15]), .fft_pe_valid());

//Stage 2
FFT_PE fft2_0(.clk(clk), .rst(rst), .a(data_flow_stage2[0]), .b(data_flow_stage2[4]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage3[0]), .fft_b(data_flow_stage3[4]), .fft_pe_valid());
FFT_PE fft2_1(.clk(clk), .rst(rst), .a(data_flow_stage2[1]), .b(data_flow_stage2[5]), .power(3'd2), .ab_valid(1), .fft_a(data_flow_stage3[1]), .fft_b(data_flow_stage3[5]), .fft_pe_valid());
FFT_PE fft2_2(.clk(clk), .rst(rst), .a(data_flow_stage2[2]), .b(data_flow_stage2[6]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage3[2]), .fft_b(data_flow_stage3[6]), .fft_pe_valid());
FFT_PE fft2_3(.clk(clk), .rst(rst), .a(data_flow_stage2[3]), .b(data_flow_stage2[7]), .power(3'd6), .ab_valid(1), .fft_a(data_flow_stage3[3]), .fft_b(data_flow_stage3[7]), .fft_pe_valid());
FFT_PE fft2_4(.clk(clk), .rst(rst), .a(data_flow_stage2[8]), .b(data_flow_stage2[12]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage3[8]), .fft_b(data_flow_stage3[12]), .fft_pe_valid());
FFT_PE fft2_5(.clk(clk), .rst(rst), .a(data_flow_stage2[9]), .b(data_flow_stage2[13]), .power(3'd2), .ab_valid(1), .fft_a(data_flow_stage3[9]), .fft_b(data_flow_stage3[13]), .fft_pe_valid());
FFT_PE fft2_6(.clk(clk), .rst(rst), .a(data_flow_stage2[10]), .b(data_flow_stage2[14]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage3[10]), .fft_b(data_flow_stage3[14]), .fft_pe_valid());
FFT_PE fft2_7(.clk(clk), .rst(rst), .a(data_flow_stage2[11]), .b(data_flow_stage2[15]), .power(3'd6), .ab_valid(1), .fft_a(data_flow_stage3[11]), .fft_b(data_flow_stage3[15]), .fft_pe_valid());

//Stage 3
FFT_PE fft3_0(.clk(clk), .rst(rst), .a(data_flow_stage3[0]), .b(data_flow_stage3[2]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage4[0]), .fft_b(data_flow_stage4[2]), .fft_pe_valid());
FFT_PE fft3_1(.clk(clk), .rst(rst), .a(data_flow_stage3[1]), .b(data_flow_stage3[3]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage4[1]), .fft_b(data_flow_stage4[3]), .fft_pe_valid());
FFT_PE fft3_2(.clk(clk), .rst(rst), .a(data_flow_stage3[4]), .b(data_flow_stage3[6]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage4[4]), .fft_b(data_flow_stage4[6]), .fft_pe_valid());
FFT_PE fft3_3(.clk(clk), .rst(rst), .a(data_flow_stage3[5]), .b(data_flow_stage3[7]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage4[5]), .fft_b(data_flow_stage4[7]), .fft_pe_valid());
FFT_PE fft3_4(.clk(clk), .rst(rst), .a(data_flow_stage3[8]), .b(data_flow_stage3[10]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage4[8]), .fft_b(data_flow_stage4[10]), .fft_pe_valid());
FFT_PE fft3_5(.clk(clk), .rst(rst), .a(data_flow_stage3[9]), .b(data_flow_stage3[11]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage4[9]), .fft_b(data_flow_stage4[11]), .fft_pe_valid());
FFT_PE fft3_6(.clk(clk), .rst(rst), .a(data_flow_stage3[12]), .b(data_flow_stage3[14]), .power(3'd0), .ab_valid(1), .fft_a(data_flow_stage4[12]), .fft_b(data_flow_stage4[14]), .fft_pe_valid());
FFT_PE fft3_7(.clk(clk), .rst(rst), .a(data_flow_stage3[13]), .b(data_flow_stage3[15]), .power(3'd4), .ab_valid(1), .fft_a(data_flow_stage4[13]), .fft_b(data_flow_stage4[15]), .fft_pe_valid());

//Stage 4
FFT_PE fft4_0(.clk(clk), .rst(rst), .a(data_flow_stage4[0]), .b(data_flow_stage4[1]), .power(3'd0), .ab_valid(1), .fft_a(fft_d0), .fft_b(fft_d8), .fft_pe_valid());
FFT_PE fft4_1(.clk(clk), .rst(rst), .a(data_flow_stage4[2]), .b(data_flow_stage4[3]), .power(3'd0), .ab_valid(1), .fft_a(fft_d4), .fft_b(fft_d12), .fft_pe_valid());
FFT_PE fft4_2(.clk(clk), .rst(rst), .a(data_flow_stage4[4]), .b(data_flow_stage4[5]), .power(3'd0), .ab_valid(1), .fft_a(fft_d2), .fft_b(fft_d10), .fft_pe_valid());
FFT_PE fft4_3(.clk(clk), .rst(rst), .a(data_flow_stage4[6]), .b(data_flow_stage4[7]), .power(3'd0), .ab_valid(1), .fft_a(fft_d6), .fft_b(fft_d14), .fft_pe_valid());
FFT_PE fft4_4(.clk(clk), .rst(rst), .a(data_flow_stage4[8]), .b(data_flow_stage4[9]), .power(3'd0), .ab_valid(1), .fft_a(fft_d1), .fft_b(fft_d9), .fft_pe_valid());
FFT_PE fft4_5(.clk(clk), .rst(rst), .a(data_flow_stage4[10]), .b(data_flow_stage4[11]), .power(3'd0), .ab_valid(1), .fft_a(fft_d5), .fft_b(fft_d13), .fft_pe_valid());
FFT_PE fft4_6(.clk(clk), .rst(rst), .a(data_flow_stage4[12]), .b(data_flow_stage4[13]), .power(3'd0), .ab_valid(1), .fft_a(fft_d3), .fft_b(fft_d11), .fft_pe_valid());
FFT_PE fft4_7(.clk(clk), .rst(rst), .a(data_flow_stage4[14]), .b(data_flow_stage4[15]), .power(3'd0), .ab_valid(1), .fft_a(fft_d7), .fft_b(fft_d15), .fft_pe_valid());


//Comparator using butterfly method
assign determine[0] = $signed(fft_d0[31:16]) * $signed(fft_d0[31:16]) + $signed(fft_d0[15:0]) * $signed(fft_d0[15:0]);
assign determine[1] = $signed(fft_d1[31:16]) * $signed(fft_d1[31:16]) + $signed(fft_d1[15:0]) * $signed(fft_d1[15:0]); 
assign determine[2] = $signed(fft_d2[31:16]) * $signed(fft_d2[31:16]) + $signed(fft_d2[15:0]) * $signed(fft_d2[15:0]);
assign determine[3] = $signed(fft_d3[31:16]) * $signed(fft_d3[31:16]) + $signed(fft_d3[15:0]) * $signed(fft_d3[15:0]);
assign determine[4] = $signed(fft_d4[31:16]) * $signed(fft_d4[31:16]) + $signed(fft_d4[15:0]) * $signed(fft_d4[15:0]);
assign determine[5] = $signed(fft_d5[31:16]) * $signed(fft_d5[31:16]) + $signed(fft_d5[15:0]) * $signed(fft_d5[15:0]);
assign determine[6] = $signed(fft_d6[31:16]) * $signed(fft_d6[31:16]) + $signed(fft_d6[15:0]) * $signed(fft_d6[15:0]);
assign determine[7] = $signed(fft_d7[31:16]) * $signed(fft_d7[31:16]) + $signed(fft_d7[15:0]) * $signed(fft_d7[15:0]);
assign determine[8] = $signed(fft_d8[31:16]) * $signed(fft_d8[31:16]) + $signed(fft_d8[15:0]) * $signed(fft_d8[15:0]);
assign determine[9] = $signed(fft_d9[31:16]) * $signed(fft_d9[31:16]) + $signed(fft_d9[15:0]) * $signed(fft_d9[15:0]);
assign determine[10] = $signed(fft_d10[31:16]) * $signed(fft_d10[31:16]) + $signed(fft_d10[15:0]) * $signed(fft_d10[15:0]);
assign determine[11] = $signed(fft_d11[31:16]) * $signed(fft_d11[31:16]) + $signed(fft_d11[15:0]) * $signed(fft_d11[15:0]);
assign determine[12] = $signed(fft_d12[31:16]) * $signed(fft_d12[31:16]) + $signed(fft_d12[15:0]) * $signed(fft_d12[15:0]);
assign determine[13] = $signed(fft_d13[31:16]) * $signed(fft_d13[31:16]) + $signed(fft_d13[15:0]) * $signed(fft_d13[15:0]);
assign determine[14] = $signed(fft_d14[31:16]) * $signed(fft_d14[31:16]) + $signed(fft_d14[15:0]) * $signed(fft_d14[15:0]);
assign determine[15] = $signed(fft_d15[31:16]) * $signed(fft_d15[31:16]) + $signed(fft_d15[15:0]) * $signed(fft_d15[15:0]);

assign id1[0] = determine[0] > determine[1] ? 0 : 1;
assign id1[1] = determine[2] > determine[3] ? 2 : 3;
assign id1[2] = determine[4] > determine[5] ? 4 : 5;
assign id1[3] = determine[6] > determine[7] ? 6 : 7;
assign id1[4] = determine[8] > determine[9] ? 8 : 9;
assign id1[5] = determine[10] > determine[11] ? 10 : 11;
assign id1[6] = determine[12] > determine[13] ? 12 : 13;
assign id1[7] = determine[14] > determine[15] ? 14 : 15;

assign id2[0] = determine[id1[0]] > determine[id1[1]] ? id1[0] : id1[1];
assign id2[1] = determine[id1[2]] > determine[id1[3]] ? id1[2] : id1[3];
assign id2[2] = determine[id1[4]] > determine[id1[5]] ? id1[4] : id1[5];
assign id2[3] = determine[id1[6]] > determine[id1[7]] ? id1[6] : id1[7];

assign id3[0] = determine[id2[0]] > determine[id2[1]] ? id2[0] : id2[1];
assign id3[1] = determine[id2[2]] > determine[id2[3]] ? id2[2] : id2[3];

assign id4 = determine[id3[0]] > determine[id3[1]] ? id3[0] : id3[1];

//Sequential Circuit
always@(posedge clk or posedge rst)
begin
   if(rst)
   begin
      state <= Load_Data;
      counter <= 0;
      stage <= 0;
   end
   else
   begin
       state <= NextState;

       case(state)
       Load_Data:begin
                  if(data_valid)
                  begin
                    if(counter == 159)
                    begin
                      buffer[counter] <= {data,16'd0};
                      counter <= 0;
                    end
                    else
                    begin
                       buffer[counter] <= {data,16'd0};
                       counter <= counter + 1;
                    end
                  end
                 end

       Transform: begin
                     if(stage == 4)
                     begin
                        fft_valid <= 1;
                        stage <= 0;
                     end
                     else
                     begin
                        stage <= stage + 1;
                     end
                  end

       Analysis: begin
                    fft_valid <= 0;
                    done <= 1;
                    freq <= id4;
                 end

       Reset: begin
                 if(counter == 144)
                 begin
                   done <= 0;
                 end
                 else
                 begin
                   done <= 0;
                   counter <= counter + 16;
                 end
              end
       endcase
   end
end


//State machine
always@(*)
begin
   case(state)
   Load_Data: begin
                   if(counter == 159)
                     NextState = Transform;
                   else
                     NextState = Load_Data;
              end

   Transform: begin
                  if(stage == 4)
                    NextState = Analysis;
                  else 
                    NextState = Transform;
              end

   Analysis: begin
                NextState = Reset;
             end
   
   Reset: begin
             if(counter == 144)
               NextState = Reset;
             else
               NextState = Transform;
          end
   endcase
end

endmodule
