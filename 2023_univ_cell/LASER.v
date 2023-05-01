module LASER (
input CLK,
input RST,
input [3:0] X,
input [3:0] Y,
output reg [3:0] C1X,
output reg [3:0] C1Y,
output reg [3:0] C2X,
output reg [3:0] C2Y,
output reg DONE);

reg [2:0] count;
reg [4:0] state;
reg [5:0] counter;
reg [3:0] point_x[39:0];
reg [3:0] point_y[39:0];

reg [5:0] max_points;
reg [5:0] tmp_max_points;
reg [3:0] X1;
reg [3:0] Y1;
reg [3:0] X2;
reg [3:0] Y2; // circle center 0 : 1    1 : 2

reg circle; 

wire [9:0] mul;
reg signed [5:0] pos_x, pos_y;
assign mul = pos_x * pos_x + pos_y * pos_y;

wire [9:0] mul2;
reg signed [5:0] pos_x2, pos_y2;
assign mul2 = pos_x2 * pos_x2 + pos_y2 * pos_y2;

always@(posedge CLK)begin
    if(RST)begin
        C1X <= 0;
        C1Y <= 0;
        C2X <= 0;
        C2Y <= 0;
        DONE <= 0;
        
        X1 <= 0;
        Y1 <= 0;
        X2 <= 2;
        Y2 <= 2;
        count <= 0; // test
        
        circle <= 1;
        state <= 0;
        counter <= 0;
        max_points <=  0;
        tmp_max_points <= 0;
    end 
    else begin
        case(state)
            0: begin
                    DONE <= 0;
                    point_x[counter] <= X;
                    point_y[counter] <= Y;
                    
                    if(counter == 39)begin
                        counter <= 0;
                        state <= state + 1 ;  
                    end
                    else begin
                        counter <= counter + 1;
                    end
                    
                end
            1: begin
                    pos_x <= X1 -  point_x[counter];
                    pos_y <= Y1 -  point_y[counter];
                    counter <= counter + 1;
                    state <= state + 1 ;
                end
            2: begin
                    pos_x <= X1 -  point_x[counter];
                    pos_y <= Y1 -  point_y[counter];

                    if (mul <= 16) begin
                        tmp_max_points <= tmp_max_points + 1;
                    end

                    if(counter == 39)begin
                        counter <= 0;
                        state <= state + 1;
                    end
                    else begin
                        counter <= counter + 1;
                    end
                end
            3: begin
                    if(X1 == 13 && Y1 == 13)begin
                        state <= 4;
                        
                        X1 <= C1X;
                        Y1 <= C1Y;

                        X2 <= 2;
                        Y2 <= 2;
                        circle <= 1;
                    end
                    else begin
                        state <= 1;
                        if(X1 == 13)begin
                            X1 <= 2;
                            Y1 <= Y1 + 1;
                        end
                        else begin
                            X1 <= X1 + 1;
                        end
                    end

                    if(tmp_max_points >= max_points)begin
                        C1X <= X1;
                        C1Y <= Y1;
                        max_points <= tmp_max_points;
                    end
              
                    tmp_max_points <= 0;
                   
                end
            4: begin // circle 2 start
                    pos_x <= X1 -  point_x[counter];
                    pos_y <= Y1 -  point_y[counter];

                    pos_x2 <= X2 -  point_x[counter];
                    pos_y2 <= Y2 -  point_y[counter];

                    counter <= counter + 1;

                    state <= state + 1 ;
                end
            5: begin
                    pos_x <= X1 -  point_x[counter];
                    pos_y <= Y1 -  point_y[counter];

                    pos_x2 <= X2 -  point_x[counter];
                    pos_y2 <= Y2 -  point_y[counter];

                    if (mul <= 16 || mul2 <= 16) begin
                        tmp_max_points <= tmp_max_points + 1;
                    end                   

                    if(counter == 40)begin
                        counter <= 0;
                        state <= state + 1 ;
                    end
                    else begin
                        counter <= counter + 1;
                    end
                end
            6: begin
                    if(circle == 0)begin
                        if(X1 == 13 && Y1 == 13)begin
                            X1 <= C1X;
                            Y1 <= C1Y;
                            X2 <= 2;
                            Y2 <= 2;
                            circle <= 1;

                            count <= count + 1;
                        end
                        else begin
                            if(X1 == 13)begin
                                X1 <= 2;
                                Y1 <= Y1 + 1;
                            end
                            else begin
                                X1 <= X1 + 1;
                            end
                        end
                    end
                    else begin
                        if(X2 == 13 && Y2 == 13)begin
                            X1 <= 2;
                            Y1 <= 2;
                            X2 <= C2X;
                            Y2 <= C2Y;
                            circle <= 0;

                            count <= count + 1;
                        end
                        else begin
                            if(X2 == 13)begin
                                X2 <= 2;
                                Y2 <= Y2 + 1;
                            end
                            else begin
                                X2 <= X2 + 1;
                            end
                        end
                    end

                    if(tmp_max_points >= max_points)begin
                        if(circle == 0)begin
                            C1X <= X1;
                            C1Y <= Y1;
                        end
                        else begin
                            C2X <= X2;
                            C2Y <= Y2;
                        end
                        max_points <= tmp_max_points;
                    end 
                    
                    if (count == 7) begin
                        DONE <= 1;
                        state <= 7;
                    end
                    else begin
                        state <= 4;
                    end
                   
                    tmp_max_points <= 0;

                end
                7: begin
                        DONE <= 0;
                        state <= 0;
                        max_points <= 0;
                        tmp_max_points <= 0;
                        X1 <= 0;
                        Y1 <= 0;
                        X2 <= 0;
                        Y2 <= 0;
                        C1X <= 0;
                        C1Y <= 0;
                        C2X <= 0;
                        C2Y <= 0;
                        count <= 0;
                        counter <= 0;
                    end
        endcase
    end    

end
endmodule



