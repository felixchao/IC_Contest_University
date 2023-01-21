module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output match;
output [4:0] match_index;
output valid;


reg match;
reg [4:0] match_index;
reg valid;
reg [2:0] state, Nextstate;
reg [7:0] string [31:0];
reg [7:0] pattern [8:0];
reg [5:0] cs;
reg [5:0] cp;
reg [5:0] lens;
reg [5:0] lenp;
reg [7:0] count;
reg store;
reg [4:0] i,j;



parameter Load = 0;
parameter Check = 1;
parameter Case1 = 2;
parameter Case2 = 3;
parameter Case3 = 4;
parameter Case4 = 5;
parameter Match = 6;
parameter NotMatch = 7;


//Sequential Circuit
always @(posedge clk or posedge reset)
begin
    
    if(reset)
    begin
       valid <= 0;
       state <= Load;
       count <= 0;
       cs <= 0;
       cp <= 0;
       i <= 0;
       j <= 0;
       store <= 0;
    end
    
    else
    begin

        state <= Nextstate;

        case(state)

        Load: begin
                    valid <= 0;
                    if(isstring)
                    begin
                        string[cs] <= chardata;
                        cs <= cs + 1;
                        store <= 1;
                    end
                    else if(ispattern)
                    begin
                        pattern[cp] <= chardata;
                        cp <= cp + 1;
                    end
                    else
                    begin
                        if(store == 1)
                        begin
                            lens <= cs;
                            store <= 0;
                        end
                           
                        lenp <= cp;
                        cs <= 0;
                        cp <= 0;
                        count <= 0;
                    end                   
              end


        Check: begin
                    if(pattern[0] == 8'h5E && pattern[lenp-1] == 8'h24)  //^$
                    begin
                         i <= 0;
                         j <= 1;
                    end

                    else if(pattern[0] ==8'h5E) //^
                    begin
                        i <= 0;
                        j <= 1;
                    end

                    else if(pattern[lenp-1] == 8'h24)//$
                    begin
                        i <= 0;
                        j <= 0;
                    end

                    else
                    begin
                         i <= 0;
                         j <= 0;
                    end
               end

        Case1: begin
                    if(i<=lens - lenp + 2)
                    begin
                        if(j < lenp - 1)
                        begin
                            if((i == 0 || string[i-1] == 8'h20) && (i+lenp-3 == lens-1 || string[i+lenp-2] == 8'h20))
                            begin
                                if((pattern[j]==8'h2E)||(string[i+j-1] == pattern[j]))
                                begin
                                    count<=count+1;
                                    match_index <= i;
                                end
                            end
                            j <= j+1;
                        end
                        else
                        begin
                            count <= 0;
                            j <= 0;
                            i <= i+1;
                        end
                    end
               end

        Case2: begin
                    if(i<=lens - lenp + 1)
                    begin
                        if(j < lenp)
                        begin
                             if(i==0||string[i-1] == 8'h20 )
                             begin
                                  if((pattern[j]==8'h2E)||(string[i+j-1] == pattern[j]))
                                  begin
                                      count<=count+1;
                                      match_index <= i;
                                  end
                                
                             end
                             j <= j+1;
                        end
                        else
                        begin
                            count <= 0;
                            j <= 0;
                            i <= i+1;
                        end
                    end                  
               end

        Case3: begin
                    if(i<=lens - lenp+1)
                    begin
                        if(j < lenp-1)
                        begin
                            if(i+lenp-2 == lens-1 || string[i+lenp-1] == 8'h20 )
                            begin
                                if((pattern[j]==8'h2E)||(string[i+j] == pattern[j]))
                                begin
                                    count<=count+1;
                                    match_index <= i;
                                 end  
                                                          
                            end
                             j<=j+1; 
                        end
                        else
                        begin
                            count <= 0;
                            j <= 0;
                            i <= i+1;
                        end
                    end                
               end

        Case4: begin
                    if(i<=lens - lenp)
                    begin
                        if(j < lenp)
                        begin
                            if((pattern[j]==8'h2E)||(string[i+j] == pattern[j]))
                            begin
                                count<=count+1;
                                match_index <= i;
                            end

                            j <= j+1;
                        end
                        else
                        begin
                            count <= 0;
                            j <= 0;
                            i <= i+1;
                        end
                    end              
               end


        Match: begin
                    match <= 1;
                    valid <= 1;
                    i <= 0;
                    j <= 0;
               end
        
        NotMatch: begin
                    match <= 0;
                    valid <= 1;
                    i <= 0;
                    j <= 0;
                  end
        endcase
    end

end



//Combinational Circuit
always @(*) 
begin
     case(state)

        Load: begin
                  if(!ispattern&&!isstring)
                     Nextstate = Check;
                  else
                     Nextstate = Load;
              end

        Check:begin
                    if(pattern[0] == 8'h5E && pattern[lenp-1] == 8'h24)  //^$
                    begin
                        Nextstate = Case1;
                    end

                    else if(pattern[0] ==8'h5E) //^
                    begin
                         Nextstate = Case2;
                    end

                    else if(pattern[lenp-1] == 8'h24)//$
                    begin
                        Nextstate = Case3;
                    end

                    else
                    begin
                         Nextstate = Case4;
                    end                  
              end

        Case1: begin
                    if(count == lenp-2)
                       Nextstate = Match;
                    else if(i >= lens - lenp + 3)
                       Nextstate = NotMatch;
                    else
                       Nextstate = Case1;
               end

        Case2: begin
                    if(count == lenp-1)
                       Nextstate = Match;
                    else if(i >= lens - lenp + 2)
                       Nextstate = NotMatch;
                    else
                       Nextstate = Case2;
               end

        Case3: begin
                    if(count == lenp-1)
                    begin
                        Nextstate = Match;
                    end
                      
                    else if(i >= lens - lenp + 2)
                    begin
                        Nextstate = NotMatch;
                    end
                       
                    else
                       Nextstate = Case3;
               end

        Case4: begin
                    if(count == lenp)
                       Nextstate = Match;
                    else if(i >= lens - lenp+1)
                       Nextstate = NotMatch;
                    else
                       Nextstate = Case4;
               end


        Match: begin
                   Nextstate = Load;
               end

        NotMatch: begin
                      Nextstate = Load;
                  end
        default: begin
                      Nextstate = Load;
                 end
     endcase
end


endmodule
