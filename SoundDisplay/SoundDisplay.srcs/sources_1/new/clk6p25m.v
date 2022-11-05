`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 10:07:05
// Design Name: 
// Module Name: clk6p25m
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
//////////////////////////////////////////////////////////////////////////////////


module clk6p25m(
    input clock,
    output reg clk_6p25m
    );
        reg [2:0] count1 = 3'd0;
        
        initial begin 
        clk_6p25m = 0;
        end 
        
        always@(posedge clock) 
        begin
        count1 <= count1 + 1 ;
        clk_6p25m <= (count1 == 0) ? ~clk_6p25m : clk_6p25m;

        end

endmodule

