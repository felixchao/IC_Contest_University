module Queue(clk, rst, operation, in, out, empty, full);
    input       clk;
    input       rst;
    input [1:0] operation;
    input [7:0] in;
    // Register
    output reg [7:0] out;
    output      empty;
    // Wire
    output       full;

parameter Idle = 2'b00, 
          Enqueue = 2'b01, 
          Dequeue = 2'b10, 
          Clear = 2'b11;


reg [7:0] mem [7:0];
reg [3:0] count; 


assign full = (count == 8);
assign empty = (count == 0);


always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        mem[0] <= 0;
        mem[1] <= 0;
        mem[2] <= 0;
        mem[3] <= 0;
        mem[4] <= 0;
        mem[5] <= 0;
        mem[6] <= 0;
        mem[7] <= 0;
        count <= 4'd0;
        out <= 8'd0;
    end
    else
    begin
        case(operation)

             Enqueue:begin
                          if(full)
                          begin
                              
                          end
                          else
                          begin
                              out <= 0;
                              mem[count] <= in;
                              count <= count + 1;
                          end
                     end

             Dequeue:begin
                          if(empty)
                          begin
                              
                          end
                          else
                          begin
                              out <= mem[0];
                              mem[0] <= mem[1];
                              mem[1] <= mem[2];
                              mem[2] <= mem[3];
                              mem[3] <= mem[4];
                              mem[4] <= mem[5];
                              mem[5] <= mem[6];
                              mem[6] <= mem[7];
                              mem[7] <= 0;
                              count <= count - 1;
                          end
                     end

             Clear:begin
                         if(empty)
                         begin
                             
                         end
                         else
                         begin
                              out <= 0;
                              mem[0] <= 0;
                              mem[1] <= 0;
                              mem[2] <= 0;
                              mem[3] <= 0;
                              mem[4] <= 0;
                              mem[5] <= 0;
                              mem[6] <= 0;
                              mem[7] <= 0;
                              count <= 0;                             
                         end
                   end

        endcase
    end
end 







endmodule