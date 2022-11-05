`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input [15:0]sw,
    input clock, //100mhz
    input button,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    output [6:0]JC,// Delete this comment and include other inputs and outputs here
    output [15:0]led,
    output [6:0]seg,
    output [3:0]an
    );
    
    wire [12:0]pixel_index;
    wire clk_6p25m;
    wire resett;
    wire [15:0] oled_data; //changed from reg to wire 
    wire [30:0]score;
    wire [30:0]robo_score;
    wire cs;
    wire [11:0] mic_in;
    wire [30:0]counterr = 0;
    wire D;
    wire U;
    
    reg [30:0]bar;
    reg [11:0] mic_in_new;
    reg [11:0] mic_in_cleaned;
    reg [15:0] vol; 
    reg [30:0]count = 0;
    
    reg [30:0]staticcount = 0;
    reg [6:0] seg = 7'b1111111;
    reg [3:0] an = 4'b1111;
    reg [6:0]andisp0 = 7'b1111111;
    reg [6:0]andisp1 = 7'b1111111;
    reg [6:0]andisp2 = 7'b1111111;
    reg [6:0]andisp3 = 7'b1111111;
    reg [15:0]led = 0;
    
    reg [6:0] number [0:9];
    initial begin
        number[0] = 7'b1000000;
        number[1] = 7'b1111001;
        number[2] = 7'b0100100;
        number[3] = 7'b0110000;
        number[4] = 7'b0011001;
        number[5] = 7'b0010010;
        number[6] = 7'b0000010;
        number[7] = 7'b1111000;
        number[8] = 7'b0000000;
        number[9] = 7'b0010000;
    end
    
    reg [6:0]low = 7'b1000111;
    reg [6:0]med = 7'b1101010;
    reg [6:0]high = 7'b0001011;
        
    reg unlocked = 0;
    reg pwset = 0;
    reg [30:0]currno = 0;
    reg [9:0]pw = 10'b0000000000;
    reg [9:0]enteredpw = 10'b0000000000;
    reg [30:0]pwcount = 0;
    
    reg recording = 0;
    reg [30:0]sum = 0;
    reg [30:0]avgcount = 0;
    reg [30:0]avg = 0;
    
    clk6p25m fa5(clock, clk_6p25m);
    reset fa4(clk_6p25m, button, resett);
    fclock fa20k(clock, 2500, cs);
    Oled_Display fa1(clk_6p25m, resett,,,,pixel_index, oled_data,JC[0],JC[1],JC[2],JC[3],JC[4],JC[5],JC[6]);
    my_border fa2(sw[8],sw[10],sw[9],unlocked, recording, avg, sw[14], sw[13], sw[12], sw[11], bar, btnL, btnR, btnD, clk_6p25m, sw[15],pixel_index, oled_data, score, robo_score);
    Audio_Capture fa6(
        clock,                  // 100MHz clock
        cs,                   // sampling clock, 20kHz
        J_MIC3_Pin3,                 // J_MIC3_Pin3, serial mic input
        J_MIC3_Pin1,            // J_MIC3_Pin1
        J_MIC3_Pin4,            // J_MIC3_Pin4, MIC3 serial clock
        mic_in     // 12-bit audio sample data
        );
            
    always @ (posedge cs) begin //0.00005 seconds    
            //display different characters 
            staticcount <= staticcount + 1;
            if (staticcount < 13) begin an <= 4'b0111; seg <= andisp3; end
            else if (staticcount < 26) begin an <= 4'b1011; seg <= andisp2; end
            else if (staticcount < 52) begin an <= 4'b1101; seg <= andisp1; end
            else if (staticcount < 104) begin an <= 4'b1110; seg <= andisp0; end
            else begin staticcount <= 0; end    
            
            if(!unlocked)
                begin
                    if(!pwset)
                        begin
                            if(D) begin pwset <= 1; led <= 16'b0000000000000000; currno <= 0; end
                            if (pwcount < 20000)
                                begin 
                                    pwcount <= pwcount + 1;    
                                    if(mic_in_cleaned > 480)
                                        begin
                                            if(currno != 9)
                                                begin                                                                             
                                                    pw[currno+1] <= 1;
                                                    led[currno+1] <= 1;  
                                                end
                                            else begin pw[0] <= 1; led[0] <= 1; end
                                        end                            
                                end
                            else 
                                begin 
                                    if(currno == 0) begin currno <= 9; end
                                    else begin currno <= currno - 1; end
                                    pwcount <= 0; 
                                    andisp3 <= number[currno];                                
                                end    
                        end
                    else
                        begin
                            if(pwset && pw == enteredpw) begin unlocked <= 1; andisp3 <= 7'b1111111; end
                            if (pwcount < 20000)
                                begin 
                                    pwcount <= pwcount + 1;    
                                    if(mic_in_cleaned > 480)
                                        begin
                                            if(currno != 9)
                                                begin                                                                             
                                                    enteredpw[currno+1] <= 1;
                                                    led[currno+1] <= 1;  
                                                end
                                            else begin enteredpw[0] <= 1; led[0] <= 1; end
                                        end                            
                                end
                            else 
                                begin 
                                    if(currno == 0) begin currno <= 9; end
                                    else begin currno <= currno - 1; end
                                    pwcount <= 0; 
                                    andisp3 <= number[currno];                                
                                end    
                            end
                        end                        
            else if(sw[14])//game
                begin
                    andisp3 <= number[(score/1000)%10];
                    andisp2 <= number[(score/100)%10];
                    andisp1 <= number[(score/10)%10];
                    andisp0 <= number[score%10];
                end
            else if(sw[13])
                begin
                    andisp3 <= number[(robo_score/1000)%10];
                    andisp2 <= number[(robo_score/100)%10];
                    andisp1 <= number[(robo_score/10)%10];
                    andisp0 <= number[robo_score%10];
                end
            else if(sw[12])//avg
                begin
                    if(D)
                        begin
                            if(!recording)
                                begin
                                    sum <= 0;
                                    avgcount <= 0;
                                    avg <= 0;
                                end
                            recording <= ~recording;
                        end                                        
                    andisp3 <= number[(avg/10)%10];
                    andisp2 <= number[avg%10];   
                end
             else 
                begin
                    andisp2 <= 7'b1111111;   
                end
                
            if(unlocked)
                begin
                    if(U) 
                        begin 
                            unlocked <= 0; enteredpw <= 10'b0000000000; 
                            andisp3 <= 7'b1111111;  
                            andisp2 <= 7'b1111111;   
                            andisp1 <= 7'b1111111;
                            andisp0 <= 7'b1111111;
                        end
                
                    led[0] <= sw[0] ? vol[0] : mic_in[0];
                    led[1] <= sw[0] ? vol[1] : mic_in[1];
                    led[2] <= sw[0] ? vol[2] : mic_in[2];
                    led[3] <= sw[0] ? vol[3] : mic_in[3];
                    led[4] <= sw[0] ? vol[4] : mic_in[4];
                    led[5] <= sw[0] ? vol[5] : mic_in[5];
                    led[6] <= sw[0] ? vol[6] : mic_in[6];
                    led[7] <= sw[0] ? vol[7] : mic_in[7];
                    led[8] <= sw[0] ? vol[8] : mic_in[8];
                    led[9] <= sw[0] ? vol[9] : mic_in[9];
                    led[10] <= sw[0] ? vol[10] : mic_in[10];
                    led[11] <= sw[0] ? vol[11] : mic_in[11];
                    led[12] <= sw[0] ? vol[12] : 0;
                    led[13] <= sw[0] ? vol[13] : 0;
                    led[14] <= sw[0] ? vol[14] : 0;
                    led[15] <= sw[0] ? vol[15] : 0;
                end
                            
            //mic stuff      
            if (count < 2000) 
                begin 
                    count <= count + 1;
                    if(mic_in > mic_in_new)begin mic_in_new <= mic_in; end
                end
            else begin 
                count <= 0; 
                mic_in_cleaned <= mic_in_new - 2050;
                if(mic_in_cleaned < 120) //0
                    begin 
                        vol <= 16'b0000000000000000; bar <= 0; andisp1 <= 7'b1111111; andisp0 <= 7'b1000000;  
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end                         
                    end 
                else if(mic_in_cleaned < 240) //1
                    begin 
                        vol <= 16'b0000000000000001; bar <= 1; andisp1 <= 7'b1111111; andisp0 <= 7'b1111001;
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end    
                        end                    
                    end 
                else if(mic_in_cleaned < 360) //2
                    begin 
                        vol <= 16'b0000000000000011; bar <= 2; andisp1 <= 7'b1111111; andisp0 <= 7'b0100100; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 480) //3
                    begin 
                        vol <= 16'b0000000000000111; bar <= 3; andisp1 <= 7'b1111111; andisp0 <= 7'b0110000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 600) //4
                    begin 
                        vol <= 16'b0000000000001111; bar <= 4; andisp1 <= 7'b1111111; andisp0 <= 7'b0011001; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 720) //5
                    begin 
                        vol <= 16'b0000000000011111; bar <= 5; andisp1 <= 7'b1111111; andisp0 <= 7'b0010010; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 840) //6
                    begin 
                        vol <= 16'b0000000000111111; bar <= 6; andisp1 <= 7'b1111111; andisp0 <= 7'b0000010; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= low; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 960) //7
                    begin 
                        vol <= 16'b0000000001111111; bar <= 7; andisp1 <= 7'b1111111; andisp0 <= 7'b1111000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= med; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end  
                else if(mic_in_cleaned < 1080) //8
                    begin 
                        vol <= 16'b0000000011111111; bar <= 8; andisp1 <= 7'b1111111; andisp0 <= 7'b0000000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= med; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1200) //9
                    begin 
                        vol <= 16'b0000000111111111; bar <= 9; andisp1 <= 7'b1111111; andisp0 <= 7'b0010000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= med; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1320) //10
                    begin 
                        vol <= 16'b0000001111111111; bar <= 10; andisp1 <= 7'b1111001; andisp0 <= 7'b1000000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= med; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1440) //11
                    begin 
                        vol <= 16'b0000011111111111; bar <= 11; andisp1 <= 7'b1111001; andisp0 <= 7'b1111001; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= med; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1560) //12
                    begin 
                        vol <= 16'b0000111111111111; bar <= 12; andisp1 <= 7'b1111001; andisp0 <= 7'b0110000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= high; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1680) //13
                    begin 
                        vol <= 16'b0001111111111111; bar <= 13; andisp1 <= 7'b1111001; andisp0 <= 7'b0110000; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= high; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1800) //14
                    begin 
                        vol <= 16'b0011111111111111; bar <= 14; andisp1 <= 7'b1111001; andisp0 <= 7'b0011001;  
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= high; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else if(mic_in_cleaned < 1920) //15
                    begin 
                        vol <= 16'b0111111111111111; bar <= 15; andisp1 <= 7'b1111001; andisp0 <= 7'b0010010; 
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= high; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                else //16
                    begin 
                        vol <= 16'b1111111111111111; bar <= 16; andisp1 <= 7'b1111001; andisp0 <= 7'b0000010;  
                        if(unlocked) begin 
                            if(sw[1] && !sw[14]) begin andisp3 <= high; end
                            else begin andisp3 <= 7'b1111111; end
                        end
                    end 
                if(recording) begin
                    sum <= sum + bar;
                    avgcount <= avgcount + 1;
                    avg <= sum/avgcount;
                end
                mic_in_new <= 0;
            end
     end 
     
     reset fa8(cs, btnU, U);           
     reset fa9(cs, btnD, D);           
endmodule