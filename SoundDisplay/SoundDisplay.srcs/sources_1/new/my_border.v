`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2021 11:24:20
// Design Name: 
// Module Name: my_border
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////// ///////////////////////////////////////////////////////////////


module my_border(input switch_color_theme,
    input switch_border,
    input switch_vol_bar,
    input unlocked,
    input recording,
    input avg,
    input togglegame, //sw[14]
    input toggle_robo_game, //sw[13]
    input toggleavg, //sw[12]
    input togglepattern, //sw[11]
    input [30:0]bar,    
    input btnL, 
    input btnR, 
    input btnD,
    input clk, 
    input px1border, 
    input [12:0]pixel_index, 
    output reg [15:0]oled_data,
    output [30:0]score,
    output [30:0]robo_score
);
  
    wire R;
    wire L;
    wire D;
    wire [5:0]newheight;
    wire [5:0]newheighttop;
    
    reg [30:0]countgame = 0;
    
    reg [7:0]x_index;
    reg [6:0]y_index; 
    reg [7:0]x_index_begin = 38;    
    reg [30:0]playerxbegin = 0;
    reg [30:0]playerybegin = 40;
    
    reg [30:0]speed;
    reg gameover = 0;
    reg lsfrreset = 1;
    reg [30:0]score = 0;
        
    reg [30:0]spike1xbegin = 35;
    reg [30:0]spike1yheight = 0;
    reg [30:0]spike2xbegin = 55;
    reg [30:0]spike2yheight = 0;
    reg [30:0]spike3xbegin = 75;
    reg [30:0]spike3yheight = 0;
    reg [30:0]spike4xbegin = 95;
    reg [30:0]spike4yheight = 0;
    reg [30:0]spiketop1xbegin = 40;
    reg [30:0]spiketop1yheight = 0;
    reg [30:0]spiketop2xbegin = 60;
    reg [30:0]spiketop2yheight = 0;
    reg [30:0]spiketop3xbegin = 80;
    reg [30:0]spiketop3yheight = 0;
    reg [30:0]spiketop4xbegin = 95;
    reg [30:0]spiketop4yheight = 0;
    reg height1init = 0;   
    reg height2init = 0;   
    reg height3init = 0;   
    reg height4init = 0;   
    reg heighttop1init = 0;   
    reg heighttop2init = 0;   
    reg heighttop3init = 0;   
    reg heighttop4init = 0;  
    
    reg settingpattern = 0;
    reg [100:0]patterncountend = 2000000000;
    reg [30:0]colortimes[6:0]; 
    reg [30:0]currcolor = 0;
    reg barsp = 0;
    wire beat;
    reg [30:0]endcolor = 0;
    reg [100:0]patterncount = 0;
    
    reg [30:0]robo_killer_x_begin = 95;
    reg [30:0]robo_killer_y_begin = 10;
    reg robo_killer_yinit = 0;
    reg [30:0]boat_x_begin = 33; 
    reg [30:0]boat_y_begin = 54;
    reg [30:0]robo1_y_begin = 0;
    reg [30:0]robo1_x_begin = 0;
    reg [30:0]counter_robo_game = 0;
    reg robo_game_over = 0;              
    reg roboxinit = 0;
    reg[30:0]robo_score=0;
                        
    always@(posedge clk)begin
        x_index_begin <= x_index_begin - L + R;
        if(x_index_begin > 71) begin x_index_begin <= 71; end
        if(x_index_begin < 4) begin x_index_begin <= 4; end
        y_index =  pixel_index/96;
        x_index = pixel_index % 96;
        boat_x_begin <= boat_x_begin - L + R; 
        if(boat_x_begin < 0) begin boat_x_begin <= 0; end
        if(boat_x_begin > 65) begin boat_x_begin <= 65; end

        if(unlocked)
            begin
                if(togglegame)
                    begin   
                        if(D) //reset
                            begin 
                                countgame = 0;
                                score = 0;
                                playerybegin = 0;
                                spike1xbegin = 35;
                                spike1yheight = 0;
                                spike2xbegin = 55;
                                spike2yheight = 0;
                                spike3xbegin = 75;
                                spike3yheight = 0;
                                spike4xbegin = 95;
                                spike4yheight = 0;
                                spiketop1xbegin = 40;
                                spiketop1yheight = 0;
                                spiketop2xbegin = 60;
                                spiketop2yheight = 0;
                                spiketop3xbegin = 80;
                                spiketop3yheight = 0;
                                spiketop4xbegin = 95;
                                spiketop4yheight = 0;
                                gameover = 0;
                                height1init = 0;   
                                height2init = 0;   
                                height3init = 0;   
                                height4init = 0;   
                                heighttop1init = 0;   
                                heighttop2init = 0;   
                                heighttop3init = 0;   
                                heighttop4init = 0;
                            end
                
                        lsfrreset <= 1;
                        lsfrreset <= 0; 
                        if(!height1init) begin spike1yheight <= newheight; height1init <= 1; end
                        else if(!height2init) begin spike2yheight <= newheight; height2init <= 1; end
                        else if(!height3init) begin spike3yheight <= newheight; height3init <= 1; end
                        else if(!height4init) begin spike4yheight <= newheight; height4init <= 1; end        
                        else if(!heighttop1init) begin spiketop1yheight <= newheighttop; heighttop1init <= 1; end
                        else if(!heighttop2init) begin spiketop2yheight <= newheighttop; heighttop2init <= 1; end
                        else if(!heighttop3init) begin spiketop3yheight <= newheighttop; heighttop3init <= 1; end
                        else if(!heighttop4init) begin spiketop4yheight <= newheighttop; heighttop4init <= 1; end  
                        //render frames
                        else if((x_index >= spike1xbegin) && (x_index <= (spike1xbegin + 2)) && (y_index >= 63 - spike1yheight))
                            begin
                                oled_data <= 16'b00100_110111_00110;
                            end
                        else if((x_index >= spike2xbegin) && (x_index <= (spike2xbegin + 2)) && (y_index >= 63 - spike2yheight))
                            begin
                                oled_data <= 16'b11000_110011_01010;
                            end
                        else if((x_index >= spike3xbegin) && (x_index <= (spike3xbegin + 2)) && (y_index >= 63 - spike3yheight))
                            begin
                                oled_data <= 16'b10100_11101_10100;
                            end
                        else if((x_index >= spike4xbegin) && (x_index <= (spike4xbegin + 2)) && (y_index >= 63 - spike4yheight))
                            begin
                                oled_data <= 16'b01101_010101_01010;
                            end            
                        else if((x_index >= spiketop1xbegin) && (x_index <= (spiketop1xbegin + 2)) && (y_index <= spiketop1yheight))
                            begin
                                oled_data <= 16'b01111_100101_10101;
                            end
                        else if((x_index >= spiketop2xbegin) && (x_index <= (spiketop2xbegin + 2)) && (y_index <= spiketop2yheight))
                            begin
                                oled_data <= 16'b01110_110001_01110;
                            end
                        else if((x_index >= spiketop3xbegin) && (x_index <= (spiketop3xbegin + 2)) && (y_index <= spiketop3yheight))
                            begin
                                oled_data <= 16'b01100_101001_01100;
                            end       
                        else if((x_index >= spiketop4xbegin) && (x_index <= (spiketop4xbegin + 2)) && (y_index <= spiketop4yheight))
                            begin
                                oled_data <= 16'b10000_011111_10000;
                            end                  
                        else if((x_index >= playerxbegin) && (x_index <= (playerxbegin + 10)) && (y_index >= playerybegin) && (y_index <= (playerybegin + 10)))
                            begin
                                if(y_index == playerybegin || y_index == playerybegin + 7) begin oled_data <= 16'hffff; end
                                else if(x_index == playerxbegin || x_index == playerxbegin + 10) begin oled_data <= 16'hffff; end
                                else if((x_index == playerxbegin + 3 || x_index == playerxbegin + 4) && (y_index == playerybegin + 3)) begin oled_data <= 16'hffff; end
                                else if((x_index == playerxbegin + 7 || x_index == playerxbegin + 8) && (y_index == playerybegin + 3)) begin oled_data <= 16'hffff; end
                                else if((x_index >= playerxbegin + 3 && x_index <= playerxbegin + 8) && (y_index == playerybegin + 5)) begin oled_data <= 16'hffff; end
                                else if((x_index == playerxbegin + 4 || x_index == playerxbegin + 7) && (y_index >= playerybegin + 7)) begin oled_data <= 16'hffff; end
                                else begin oled_data <= 16'h0000; end              
                            end
                        else
                            begin
                                oled_data <= 16'h0000;
                            end
                    
                        //game clock 
                        if(countgame == 625000 && !gameover)
                            begin
                                score <= score + 1;
                                countgame <= 0;
                                if(spike1xbegin <= 11 && playerybegin >= 52 - spike1yheight)
                                    begin
                                        gameover <= 1; 
                                    end
                                else if(spike2xbegin <= 11 && playerybegin >= 52 - spike2yheight)
                                    begin
                                        gameover <= 1; 
                                    end
                                else if(spike3xbegin <= 11 && playerybegin >= 52 - spike3yheight)
                                    begin
                                        gameover <= 1; 
                                    end
                                else if(spike4xbegin <= 11 && playerybegin >= 52 - spike4yheight)
                                    begin
                                        gameover <= 1; 
                                    end                    
                                else if(spiketop1xbegin <= 11 && playerybegin <= spiketop1yheight + 1)
                                    begin
                                        gameover <= 1; 
                                    end
                                else if(spiketop2xbegin <= 11 && playerybegin <= spiketop2yheight + 1)
                                    begin
                                        gameover <= 1; 
                                    end
                                else if(spiketop3xbegin <= 11 && playerybegin <= spiketop3yheight + 1)
                                    begin
                                        gameover <= 1; 
                                    end       
                                else if(spiketop4xbegin <= 11 && playerybegin <= spiketop4yheight + 1)
                                    begin
                                        gameover <= 1; 
                                    end                             
                                else 
                                    begin                       
                                        if(spike1xbegin <= 1)
                                            begin
                                                spike1xbegin <= 95;
                                                spike1yheight <= newheight;
                                            end                        
                                        else if(spike2xbegin <= 1)
                                            begin
                                                spike2xbegin <= 95;
                                                spike2yheight <= newheight;
                                            end                        
                                        else if(spike3xbegin <= 1)
                                            begin
                                                spike3xbegin <= 95;
                                                spike3yheight <= newheight;
                                            end                        
                                        else if(spike4xbegin <= 1)
                                            begin
                                                spike4xbegin <= 95;
                                                spike4yheight <= newheight;
                                            end
                                        else if(spiketop1xbegin <= 1)
                                            begin
                                                spiketop1xbegin <= 94;
                                                spiketop1yheight <= newheighttop;
                                            end                        
                                        else if(spiketop2xbegin <= 1)
                                            begin
                                                spiketop2xbegin <= 94;
                                                spiketop2yheight <= newheighttop;
                                            end                        
                                        else if(spiketop3xbegin <= 1)
                                            begin
                                                spiketop3xbegin <= 94;
                                                spiketop3yheight <= newheighttop;
                                            end   
                                        else if(spiketop4xbegin <= 1)
                                            begin
                                                spiketop4xbegin <= 94;
                                                spiketop4yheight <= newheighttop;
                                            end                                
                                        else 
                                            begin 
                                                spike1xbegin <= spike1xbegin - 1; 
                                                spike2xbegin <= spike2xbegin - 1; 
                                                spike3xbegin <= spike3xbegin - 1; 
                                                spike4xbegin <= spike4xbegin - 1; 
                                                spiketop1xbegin <= spiketop1xbegin - 1;
                                                spiketop2xbegin <= spiketop2xbegin - 1;
                                                spiketop3xbegin <= spiketop3xbegin - 1;
                                                spiketop4xbegin <= spiketop4xbegin - 1;
                                            end     
                                    end                                         
                        
                                if(bar >= 2)
                                    begin
                                        if(playerybegin >= 3)
                                            begin
                                                playerybegin <= playerybegin - 1;
                                            end                    
                                    end
                                else if(bar >= 4)
                                    begin
                                        if(playerybegin >= 3)
                                            begin
                                                playerybegin <= playerybegin - 3;
                                            end                    
                                    end
                                else if(bar >= 8)
                                    begin
                                        if(playerybegin >= 3)
                                            begin
                                                playerybegin <= playerybegin - 6;
                                            end                    
                                    end
                                else 
                                    begin 
                                        if(playerybegin <= 50)
                                            begin
                                                playerybegin <= playerybegin + 1;
                                            end
                                    end                 
                            end
                        else
                            begin
                                countgame <= countgame + 1; 
                            end
                    end
                else if(toggleavg)
                    begin
                        if(recording)
                            begin    
                                if(bar >= 1 && (((x_index >= 46 && x_index <= 49) && (y_index == 30 || y_index == 31)) || ((x_index >= 48 && x_index <= 49) && (y_index >= 32 && y_index <= 33)) || ((y_index >= 32 && y_index <= 33) && (x_index >= 46 && x_index <= 47)) || ((y_index >= 32 && y_index <= 33) && (x_index >= 48 && x_index <= 49)))) begin oled_data <= 16'hfa49; end
                                else if(bar >= 2 && (((x_index >= 44 && x_index <= 51) && (y_index == 28 || y_index == 29)) || ((x_index >= 46 && x_index <= 51) && (y_index >= 34 && y_index <= 35)) || ((y_index >= 30 && y_index <= 35) && (x_index >= 44 && x_index <= 45)) || ((y_index >= 30 && y_index <= 35) && (x_index >= 50 && x_index <= 51)))) begin oled_data <= 16'hfc09; end
                                else if(bar >= 3 && (((x_index >= 42 && x_index <= 53) && (y_index == 26 || y_index == 27)) || ((x_index >= 44 && x_index <= 53) && (y_index >= 36 && y_index <= 37)) || ((y_index >= 28 && y_index <= 37) && (x_index >= 42 && x_index <= 43)) || ((y_index >= 28 && y_index <= 37) && (x_index >= 52 && x_index <= 53)))) begin oled_data <= 16'hfec9; end
                                else if(bar >= 4 && (((x_index >= 40 && x_index <= 55) && (y_index == 24 || y_index == 25)) || ((x_index >= 40 && x_index <= 55) && (y_index >= 38 && y_index <= 39)) || ((y_index >= 26 && y_index <= 39) && (x_index >= 40 && x_index <= 41)) || ((y_index >= 26 && y_index <= 39) && (x_index >= 54 && x_index <= 55)))) begin oled_data <= 16'hbfe9; end
                                else if(bar >= 5 && (((x_index >= 38 && x_index <= 57) && (y_index == 22 || y_index == 23)) || ((x_index >= 38 && x_index <= 57) && (y_index >= 40 && y_index <= 41)) || ((y_index >= 24 && y_index <= 41) && (x_index >= 38 && x_index <= 39)) || ((y_index >= 24 && y_index <= 41) && (x_index >= 56 && x_index <= 57)))) begin oled_data <= 16'h57e9; end
                                else if(bar >= 6 && (((x_index >= 36 && x_index <= 59) && (y_index ==20 || y_index == 21)) || ((x_index >= 36 && x_index <= 59) && (y_index >= 42 && y_index <= 43)) || ((y_index >= 22 && y_index <= 43) && (x_index >= 36 && x_index <= 37)) || ((y_index >= 22 && y_index <= 43) && (x_index >= 58 && x_index <= 59)))) begin oled_data <= 16'h4ff7; end
                                else if(bar >= 7 && (((x_index >= 34 && x_index <= 61) && (y_index == 18 || y_index == 19)) || ((x_index >= 34 && x_index <= 61) && (y_index >= 44 && y_index <= 45)) || ((y_index >= 20 && y_index <= 45) && (x_index >= 34 && x_index <= 35)) || ((y_index >= 20 && y_index <= 45) && (x_index >= 60 && x_index <= 61)))) begin oled_data <= 16'h4fff; end
                                else if(bar >= 8 && (((x_index >= 32 && x_index <= 63) && (y_index == 16 || y_index == 17)) || ((x_index >= 32 && x_index <= 63) && (y_index >= 46 && y_index <= 47)) ||((y_index >= 18 && y_index <= 47) && (x_index >= 32 && x_index <= 33)) || ((y_index >= 18 && y_index <= 47) && (x_index >= 62 && x_index <= 63)))) begin oled_data <= 16'h4d7f; end
                                else if(bar >= 9 && (((x_index >= 30 && x_index <= 65) && (y_index == 14 || y_index == 15)) || ((x_index >= 30 && x_index <= 65) && (y_index >= 48 && y_index <= 49)) || ((y_index >= 16 && y_index <= 49) && (x_index >= 30 && x_index <= 31)) || ((y_index >= 16 && y_index <= 49) && (x_index >= 64 && x_index <= 65)))) begin oled_data <= 16'h4bbf; end
                                else if(bar >= 10 && (((x_index >= 28 && x_index <= 67) && (y_index == 12 || y_index == 13)) || ((x_index >= 28 && x_index <= 67) && (y_index >= 50 && y_index <= 51)) || ((y_index >= 14 && y_index <= 51) && (x_index >= 28 && x_index <= 29)) || ((y_index >= 14 && y_index <= 51) && (x_index >= 66 && x_index <= 67)))) begin oled_data <= 16'h525f; end
                                else if(bar >= 11 && (((x_index >= 26 && x_index <= 69) && (y_index == 10 || y_index == 11)) || ((x_index >= 26 && x_index <= 69) && (y_index >= 52 && y_index <= 53)) || ((y_index >= 12 && y_index <= 53) && (x_index >= 26 && x_index <= 27)) || ((y_index >= 12 && y_index <= 53) && (x_index >= 68 && x_index <= 69)))) begin oled_data <= 16'h825f; end
                                else if(bar >= 12 && (((x_index >=  24 && x_index <= 71) && (y_index == 8 || y_index == 9)) || ((x_index >= 24 &&x_index <= 71) && (y_index >= 54 && y_index <= 55)) || ((y_index >= 10 && y_index <= 55) && (x_index >= 24 && x_index <= 25)) || ((y_index >= 10 && y_index <= 55) && (x_index >= 70 && x_index <= 71)))) begin oled_data <= 16'hba5f; end
                                else if(bar >= 13 && (((x_index >= 22 && x_index <= 73) && (y_index == 6 || y_index == 7)) || ((x_index >= 22 && x_index <= 73) && (y_index >= 56 && y_index <= 57)) || ((y_index >= 8 && y_index <= 57) && (x_index >= 22 && x_index <= 23)) || ((y_index >= 8 && y_index <= 57) && (x_index >= 72 && x_index <= 73)))) begin oled_data <= 16'hfa5f; end
                                else if(bar >=14 && (((x_index >= 20 && x_index <= 75) && (y_index == 4 || y_index == 5)) || ((x_index >= 20 && x_index <= 75) && (y_index >= 58 && y_index <= 59)) || ((y_index >= 6 && y_index <= 59) && (x_index >= 20 && x_index <= 21)) || ((y_index >= 6 && y_index <= 59) && (x_index >= 74 && x_index <= 75)))) begin oled_data <= 16'hfa57; end
                                else if(bar >= 15 && (((x_index >= 18 && x_index <= 77) && (y_index == 2 || y_index == 3)) || ((x_index >= 18 && x_index <= 77) && (y_index >= 60 && y_index <= 61)) || ((y_index >= 4 && y_index <= 61) && (x_index >= 18 && x_index <= 19)) || ((y_index >= 4 && y_index <= 61) && (x_index >= 76 && x_index <= 77)))) begin oled_data <= 16'hfa4e; end
                                else if(bar >= 16 && (((x_index >= 16 && x_index <= 79) && (y_index == 0 || y_index == 1)) || ((x_index >= 16 && x_index <= 79) && (y_index >= 62 && y_index <= 63)) || ((y_index >= 2 && y_index <= 63) && (x_index >= 16 && x_index <= 17)) || ((y_index >= 2 && y_index <= 63) && (x_index >= 78 && x_index <= 79)))) begin oled_data <= 16'hffff; end
                                else begin oled_data <= 16'b0000000000000000;  end                                
                            end
                        else
                            begin   
                                if(avg >= 1 && (((x_index >= 46 && x_index <= 49) && (y_index == 30 || y_index == 31)) || ((x_index >= 48 && x_index <= 49) && (y_index >= 32 && y_index <= 33)) || ((y_index >= 32 && y_index <= 33) && (x_index >= 46 && x_index <= 47)) || ((y_index >= 32 && y_index <= 33) && (x_index >= 48 && x_index <= 49)))) begin oled_data <= 16'hfa49; end
                                else if(avg >= 2 && (((x_index >= 44 && x_index <= 51) && (y_index == 28 || y_index == 29)) || ((x_index >= 46 && x_index <= 51) && (y_index >= 34 && y_index <= 35)) || ((y_index >= 30 && y_index <= 35) && (x_index >= 44 && x_index <= 45)) || ((y_index >= 30 && y_index <= 35) && (x_index >= 50 && x_index <= 51)))) begin oled_data <= 16'hfc09; end
                                else if(avg >= 3 && (((x_index >= 42 && x_index <= 53) && (y_index == 26 || y_index == 27)) || ((x_index >= 44 && x_index <= 53) && (y_index >= 36 && y_index <= 37)) || ((y_index >= 28 && y_index <= 37) && (x_index >= 42 && x_index <= 43)) || ((y_index >= 28 && y_index <= 37) && (x_index >= 52 && x_index <= 53)))) begin oled_data <= 16'hfec9; end
                                else if(avg >= 4 && (((x_index >= 40 && x_index <= 55) && (y_index == 24 || y_index == 25)) || ((x_index >= 40 && x_index <= 55) && (y_index >= 38 && y_index <= 39)) || ((y_index >= 26 && y_index <= 39) && (x_index >= 40 && x_index <= 41)) || ((y_index >= 26 && y_index <= 39) && (x_index >= 54 && x_index <= 55)))) begin oled_data <= 16'hbfe9; end
                                else if(avg >= 5 && (((x_index >= 38 && x_index <= 57) && (y_index == 22 || y_index == 23)) || ((x_index >= 38 && x_index <= 57) && (y_index >= 40 && y_index <= 41)) || ((y_index >= 24 && y_index <= 41) && (x_index >= 38 && x_index <= 39)) || ((y_index >= 24 && y_index <= 41) && (x_index >= 56 && x_index <= 57)))) begin oled_data <= 16'h57e9; end
                                else if(avg >= 6 && (((x_index >= 36 && x_index <= 59) && (y_index ==20 || y_index == 21)) || ((x_index >= 36 && x_index <= 59) && (y_index >= 42 && y_index <= 43)) || ((y_index >= 22 && y_index <= 43) && (x_index >= 36 && x_index <= 37)) || ((y_index >= 22 && y_index <= 43) && (x_index >= 58 && x_index <= 59)))) begin oled_data <= 16'h4ff7; end
                                else if(avg >= 7 && (((x_index >= 34 && x_index <= 61) && (y_index == 18 || y_index == 19)) || ((x_index >= 34 && x_index <= 61) && (y_index >= 44 && y_index <= 45)) || ((y_index >= 20 && y_index <= 45) && (x_index >= 34 && x_index <= 35)) || ((y_index >= 20 && y_index <= 45) && (x_index >= 60 && x_index <= 61)))) begin oled_data <= 16'h4fff; end
                                else if(avg >= 8 && (((x_index >= 32 && x_index <= 63) && (y_index == 16 || y_index == 17)) || ((x_index >= 32 && x_index <= 63) && (y_index >= 46 && y_index <= 47)) ||((y_index >= 18 && y_index <= 47) && (x_index >= 32 && x_index <= 33)) || ((y_index >= 18 && y_index <= 47) && (x_index >= 62 && x_index <= 63)))) begin oled_data <= 16'h4d7f; end
                                else if(avg >= 9 && (((x_index >= 30 && x_index <= 65) && (y_index == 14 || y_index == 15)) || ((x_index >= 30 && x_index <= 65) && (y_index >= 48 && y_index <= 49)) || ((y_index >= 16 && y_index <= 49) && (x_index >= 30 && x_index <= 31)) || ((y_index >= 16 && y_index <= 49) && (x_index >= 64 && x_index <= 65)))) begin oled_data <= 16'h4bbf; end
                                else if(avg >= 10 && (((x_index >= 28 && x_index <= 67) && (y_index == 12 || y_index == 13)) || ((x_index >= 28 && x_index <= 67) && (y_index >= 50 && y_index <= 51)) || ((y_index >= 14 && y_index <= 51) && (x_index >= 28 && x_index <= 29)) || ((y_index >= 14 && y_index <= 51) && (x_index >= 66 && x_index <= 67)))) begin oled_data <= 16'h525f; end
                                else if(avg >= 11 && (((x_index >= 26 && x_index <= 69) && (y_index == 10 || y_index == 11)) || ((x_index >= 26 && x_index <= 69) && (y_index >= 52 && y_index <= 53)) || ((y_index >= 12 && y_index <= 53) && (x_index >= 26 && x_index <= 27)) || ((y_index >= 12 && y_index <= 53) && (x_index >= 68 && x_index <= 69)))) begin oled_data <= 16'h825f; end
                                else if(avg >= 12 && (((x_index >=  24 && x_index <= 71) && (y_index == 8 || y_index == 9)) || ((x_index >= 24 &&x_index <= 71) && (y_index >= 54 && y_index <= 55)) || ((y_index >= 10 && y_index <= 55) && (x_index >= 24 && x_index <= 25)) || ((y_index >= 10 && y_index <= 55) && (x_index >= 70 && x_index <= 71)))) begin oled_data <= 16'hba5f; end
                                else if(avg >= 13 && (((x_index >= 22 && x_index <= 73) && (y_index == 6 || y_index == 7)) || ((x_index >= 22 && x_index <= 73) && (y_index >= 56 && y_index <= 57)) || ((y_index >= 8 && y_index <= 57) && (x_index >= 22 && x_index <= 23)) || ((y_index >= 8 && y_index <= 57) && (x_index >= 72 && x_index <= 73)))) begin oled_data <= 16'hfa5f; end
                                else if(avg >=14 && (((x_index >= 20 && x_index <= 75) && (y_index == 4 || y_index == 5)) || ((x_index >= 20 && x_index <= 75) && (y_index >= 58 && y_index <= 59)) || ((y_index >= 6 && y_index <= 59) && (x_index >= 20 && x_index <= 21)) || ((y_index >= 6 && y_index <= 59) && (x_index >= 74 && x_index <= 75)))) begin oled_data <= 16'hfa57; end
                                else if(avg >= 15 && (((x_index >= 18 && x_index <= 77) && (y_index == 2 || y_index == 3)) || ((x_index >= 18 && x_index <= 77) && (y_index >= 60 && y_index <= 61)) || ((y_index >= 4 && y_index <= 61) && (x_index >= 18 && x_index <= 19)) || ((y_index >= 4 && y_index <= 61) && (x_index >= 76 && x_index <= 77)))) begin oled_data <= 16'hfa4e; end
                                else if(avg >= 16 && (((x_index >= 16 && x_index <= 79) && (y_index == 0 || y_index == 1)) || ((x_index >= 16 && x_index <= 79) && (y_index >= 62 && y_index <= 63)) || ((y_index >= 2 && y_index <= 63) && (x_index >= 16 && x_index <= 17)) || ((y_index >= 2 && y_index <= 63) && (x_index >= 78 && x_index <= 79)))) begin oled_data <= 16'hffff; end
                                else begin oled_data <= 16'b0000000000000000;  end                                                                        
                            end                          
                    end                          
                else if(toggle_robo_game)
                    begin
                        if(D) //reset
                            begin 
                                counter_robo_game = 0;
                                boat_x_begin = 0; 
                                boat_y_begin = 54;
                                robo1_y_begin = 0;
                                robo1_x_begin = 0;
                                counter_robo_game = 0;
                                robo_game_over = 0;              
                                roboxinit = 0;
                                robo_score = 0;                        
                            end
                                                
                            lsfrreset <= 1;
                            lsfrreset <= 0;
                            if(!roboxinit)begin robo1_x_begin <= 2* newheight + newheighttop/2; roboxinit <= 1; end//lsfr
                            //else
                            else if(y_index == 63 || y_index == 62 || y_index == 61 || y_index == 60)// water
                                begin
                                    oled_data <= 16'b00000_000000_11111; 
                                end
                            else if((x_index == robo_killer_x_begin) && (y_index == robo_killer_y_begin ))
                                begin
                                    oled_data <= 16'hf800; 
                                end
                            else if(y_index == 59)//water waves
                                begin
                                    if(x_index%3==0)begin oled_data <= 16'b00000_000000_11111;end
                                    else begin oled_data <= 16'b00000_000000_00000; end
                                end
                            else if((x_index >= boat_x_begin) && (x_index <= boat_x_begin + 30) && (y_index >= 52 && y_index <= 58))//boat
                                begin oled_data <= 16'b11111_111111_00000; end
                            else if((x_index >= robo1_x_begin) && (x_index <= (robo1_x_begin + 10)) && (y_index >= robo1_y_begin) && (y_index <= (robo1_y_begin + 10)))//object
                                begin
                                    if(y_index == robo1_y_begin || y_index == robo1_y_begin + 7) begin oled_data <= 16'h07f6; end
                                    else if(x_index == robo1_x_begin || x_index == robo1_x_begin + 10) begin oled_data <= 16'h07f6; end
                                    else if((x_index == robo1_x_begin + 3 || x_index == robo1_x_begin  + 4) && (y_index == robo1_y_begin + 3)) begin oled_data <= 16'h07f6; end
                                    else if((x_index == robo1_x_begin + 7 || x_index == robo1_x_begin + 8) && (y_index == robo1_y_begin + 3)) begin oled_data <= 16'h07f6; end
                                    else if((x_index >= robo1_x_begin + 3 && x_index <= robo1_x_begin + 8) && (y_index == robo1_y_begin + 5)) begin oled_data <= 16'h07f6; end
                                    else if((x_index == robo1_x_begin + 4 || x_index == robo1_x_begin + 7) && (y_index >= robo1_y_begin + 7)) begin oled_data <= 16'h07f6; end
                                    else begin oled_data <= 16'b00000_000000_00000; end              
                                end 
                            else 
                                begin 
                                    oled_data =16'h0000;
                                end
                            //game over and clock conditons
                            if(counter_robo_game == 625000 && !robo_game_over)
                                begin
                                    counter_robo_game <= 0;
                                    robo1_y_begin <= robo1_y_begin + 1;
                                    if(robo_killer_x_begin == 1) begin robo_killer_x_begin <= 95; robo_killer_y_begin <=newheight; end
                                    else begin robo_killer_x_begin <= robo_killer_x_begin -2; end
                    //              game over conditions
                                    if(robo1_y_begin + 10 == 58) 
                                        begin 
                                            robo_game_over <= 1; 
                                        end                  
                                    else if((robo_killer_x_begin >= robo1_x_begin && robo_killer_x_begin <= robo1_x_begin + 10 && robo_killer_y_begin >= robo1_y_begin && robo_killer_y_begin <= robo1_y_begin+10)) 
                                        begin
                                            robo_game_over <= 1;
                                        end         
                                    else begin
                                        if(robo1_y_begin == 41) 
                                            begin
                                                if(robo1_x_begin >=  boat_x_begin && robo1_x_begin <= boat_x_begin + 20) begin  robo1_y_begin <= 0; robo1_x_begin <= 2*newheight + newheighttop/2; robo_score <= robo_score + 1; end 
                                                else begin robo_game_over <= 1; end 
                                            end
                                    end 
                                                                            
                                    if(bar >= 2)
                                        begin
                                            if(robo1_y_begin >= 3)begin robo1_y_begin <= robo1_y_begin - 1; end                    
                                        end
                                    else if(bar >= 5)
                                        begin
                                            if(robo1_y_begin >= 4)begin robo1_y_begin <= robo1_y_begin - 3; end                    
                                        end
                                    else if(bar >= 10)
                                        begin
                                            if(playerybegin >= 7) begin playerybegin <= playerybegin - 6; end                    
                                        end                                                                                    
                                end//end of if
                            else begin counter_robo_game<= counter_robo_game + 1; end
                    end
                else if(togglepattern)
                    begin
                        patterncount <= patterncount + 1;
                                    
                        if(D)
                            begin 
                                if(!settingpattern) 
                                    begin
                                        colortimes[0] <= 0;
                                        colortimes[1] <= 0;
                                        colortimes[2] <= 0;
                                        colortimes[3] <= 0;
                                        colortimes[4] <= 0;
                                        colortimes[5] <= 0;
                                        colortimes[6] <= 0;
                                        endcolor <= 0;
                                        currcolor <= 0;
                                    end
                                    settingpattern <= ~settingpattern;
                                    patterncount <= 0;                   
                            end   
                                        
                            if(bar >= 2)begin barsp <= 1; end
                            else begin barsp <= 0; end
                                    
                            if(settingpattern)
                                begin
                                    oled_data <= 16'hFFFF;
                                    if(beat)
                                        begin
                                            colortimes[currcolor] <= patterncount;
                                            currcolor <= currcolor + 1;
                                            endcolor <= endcolor + 1;
                                        end
                                end
                            else
                                begin
                                    if(patterncount <= colortimes[0] || endcolor == 0) begin oled_data <= 16'hF800; end
                                    else if(patterncount <= colortimes[1] || endcolor == 1) begin oled_data <= 16'hFC40; end
                                    else if(patterncount <= colortimes[2] || endcolor == 2) begin oled_data <= 16'hFF00; end 
                                    else if(patterncount <= colortimes[3] || endcolor == 3) begin oled_data <= 16'h0FE0; end 
                                    else if(patterncount <= colortimes[4] || endcolor == 4) begin oled_data <= 16'h069F; end 
                                    else if(patterncount <= colortimes[5] || endcolor == 5) begin oled_data <= 16'h381F; end 
                                    else if(patterncount <= colortimes[6] || endcolor == 6) begin oled_data <= 16'hC81F; end 
                                end                              
                    end                        
                else
                    begin
                    if((switch_border == 1) && (px1border == 0) && (y_index == 0 || y_index == 63 || x_index == 0 || x_index == 95  || y_index == 1 || y_index == 62 || x_index == 1 || x_index == 94 || y_index == 2 || y_index == 61 || x_index == 2 || x_index == 93))
                        oled_data <=  switch_color_theme ? 16'h2ebb : 16'b1111111111111111; 
                    else if((switch_border == 1) && (px1border == 1) && (y_index == 0 || y_index == 63 || x_index == 0 || x_index == 95))        
                        oled_data <= switch_color_theme ? 16'h2ebb : 16'b1111111111111111; 
                    //volume bars
                    else if((switch_vol_bar ==1) &&  (x_index >= x_index_begin && x_index <= x_index_begin + 20))
                         begin
                         //green bar 1 
                         if(bar >= 1 && (y_index == 53 || y_index == 54)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //green bar 2 
                         else if(bar >= 2 && (y_index == 50 || y_index == 51)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //green bar 3      
                         else if(bar >= 3 && (y_index == 47 || y_index == 48)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //green bar 4
                         else if(bar >= 4 && (y_index == 44 || y_index == 45)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //green bar 5
                         else if(bar >= 5 && (y_index == 41 || y_index == 42)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //green bar 6
                         else if(bar >= 6 && (y_index == 39 || y_index == 38)) oled_data <= switch_color_theme ? 16'hf9ad : 16'b00000_111111_00000;
                         //yellow bar 1
                         else if(bar >= 7 && (y_index == 36 || y_index == 35)) oled_data <= switch_color_theme ? 16'ha189 : 16'b11111_111111_00000;
                         //yellow bar 2
                         else if(bar >= 8 && (y_index == 33 || y_index == 32)) oled_data <= switch_color_theme ? 16'ha189 : 16'b11111_111111_00000;
                         //yellow bar 3
                         else if(bar >=9 && ( y_index == 30 || y_index == 29)) oled_data <= switch_color_theme ? 16'ha189 : 16'b11111_111111_00000;
                         //yellow bar 4
                         else if(bar >= 10 && (y_index == 27 || y_index == 26)) oled_data <= switch_color_theme ? 16'ha189 : 16'b11111_111111_00000;
                         //yellow bar 5
                         else if(bar >= 11 && (y_index == 24 || y_index == 23)) oled_data <= switch_color_theme ? 16'ha189 : 16'b11111_111111_00000;
                         //red bar 1
                         else if(bar >= 12 && (y_index == 21 || y_index == 20)) oled_data <= switch_color_theme ? 16'h58a8 : 16'b11111_000000_00000;
                         //red bar 2
                         else if(bar >= 13 && (y_index == 18 || y_index == 17)) oled_data <= switch_color_theme ? 16'h58a8 :16'b11111_000000_00000;
                         //red bar 3
                         else if(bar >=14 && (y_index == 15 || y_index == 14)) oled_data <= switch_color_theme ? 16'h58a8 :16'b11111_000000_00000;
                         //red bar 4
                         else if(bar >= 15 && (y_index == 12 || y_index == 11))  oled_data <= switch_color_theme ? 16'h58a8 :16'b11111_000000_00000;
                         //red bar 5
                         else if(bar >= 16 && (y_index == 9 || y_index == 8))  oled_data <= switch_color_theme ? 16'h58a8 :16'b11111_000000_00000;
                         else oled_data <= switch_color_theme ? 16'hfe9a : 16'h0000;  
                         end
                    else
                        begin
                             oled_data <= switch_color_theme ? 16'hfe9a : 16'h0000;  
                        end
//                        if((px1border == 0) && (y_index == 0 || y_index == 63 || x_index == 0 || x_index == 95  || y_index == 1 || y_index == 62 || x_index == 1 || x_index == 94 || y_index == 2 || y_index == 61 || x_index == 2 || x_index == 93))
//                            oled_data <=16'b1111111111111111; 
//                        else if((px1border == 1) && (y_index == 0 || y_index == 63 || x_index == 0 || x_index == 95))        
//                            oled_data <=16'b1111111111111111; 
//                        //volume bars
//                        else if(x_index >= x_index_begin && x_index <= x_index_begin + 20)
//                            begin
//                                //green bar 1 
//                                if(bar >= 1 && (y_index == 53 || y_index == 54)) oled_data <= 16'b00000_111111_00000;
//                                //green bar 2 
//                                else if(bar >= 2 && (y_index == 50 || y_index == 51)) oled_data <= 16'b00000_111111_00000;
//                                //green bar 3      
//                                else if(bar >= 3 && (y_index == 47 || y_index == 48)) oled_data <= 16'b00000_111111_00000;
//                                //green bar 4
//                                else if(bar >= 4 && (y_index == 44 || y_index == 45)) oled_data <= 16'b00000_111111_00000;
//                                //green bar 5
//                                else if(bar >= 5 && (y_index == 41 || y_index == 42)) oled_data <= 16'b00000_111111_00000;
//                                //green bar 6
//                                else if(bar >= 6 && (y_index == 39 || y_index == 38)) oled_data <= 16'b00000_111111_00000;
//                                //yellow bar 1
//                                else if(bar >= 7 && (y_index == 36 || y_index == 35)) oled_data <= 16'b11111_111111_00000;
//                                //yellow bar 2
//                                else if(bar >= 8 && (y_index == 33 || y_index == 32)) oled_data <= 16'b11111_111111_00000;
//                                //yellow bar 3
//                                else if(bar >=9 && ( y_index == 30 || y_index == 29)) oled_data <= 16'b11111_111111_00000;
//                                //yellow bar 4
//                                else if(bar >= 10 && (y_index == 27 || y_index == 26)) oled_data <= 16'b11111_111111_00000;
//                                //yellow bar 5
//                                else if(bar >= 11 && (y_index == 24 || y_index == 23)) oled_data <= 16'b11111_111111_00000;
//                                //red bar 1
//                                else if(bar >= 12 && (y_index == 21 || y_index == 20)) oled_data <= 16'b11111_000000_00000;
//                                //red bar 2
//                                else if(bar >= 13 && (y_index == 18 || y_index == 17)) oled_data <= 16'b11111_000000_00000;
//                                //red bar 3
//                                else if(bar >=14 && (y_index == 15 || y_index == 14)) oled_data <= 16'b11111_000000_00000;
//                                //red bar 4
//                                else if(bar >= 15 && (y_index == 12 || y_index == 11))  oled_data <= 16'b11111_000000_00000;
//                                //red bar 5
//                                else if(bar >= 16 && (y_index == 9 || y_index == 8))  oled_data <= 16'b11111_000000_00000;
//                                else oled_data <= 16'b0000000000000000;  
//                            end
//                        else
//                            begin
//                                oled_data <= 16'b0000000000000000;  
//                            end    
                    end
            end
        

    end//end of always block
    
    reset fa1(clk, btnL, L);      
    reset fa2(clk, btnR, R);
    reset fa5(clk, btnD, D);
    reset fa6(clk, barsp, beat);
    linearshift fa3(clk, 5'b00000, lsfrreset, 1, newheight);
    linearshiftshort fa4(clk, 5'b00000, lsfrreset, 1, newheighttop);
    
endmodule 