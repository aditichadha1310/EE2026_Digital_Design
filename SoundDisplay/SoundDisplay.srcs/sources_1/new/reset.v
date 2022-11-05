`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 10:29:37
// Design Name: 
// Module Name: reset
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


module reset(input clock, input button, output single_pulse_out);
wire q1;
wire Q;



//reg counter = 0 ;

 my_dff fa1 (clock,button, q1);
 my_dff fa2 (clock, q1, Q);
 assign single_pulse_out = q1 & (~Q);
 endmodule

