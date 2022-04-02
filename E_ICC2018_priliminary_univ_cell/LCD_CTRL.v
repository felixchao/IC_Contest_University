module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output reg IROM_rd;
output reg [5:0] IROM_A;
output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;
output reg busy;
output reg done;

reg [3:0] state;
reg [5:0] map [63:0];
integer cnt;

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        IROM_rd <= 1;
        cnt <= 0;
        busy <= 1;
    end

    else
    begin
        if(IROM_rd)
        begin
            map[cnt] <= IROM_A;
        end
    end
end

always@(posedge clk)
begin
    
end


endmodule



