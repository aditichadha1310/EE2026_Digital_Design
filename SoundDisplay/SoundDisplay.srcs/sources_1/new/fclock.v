`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2021 19:11:49
// Design Name: 
// Module Name: fclock
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


module fclock(
    input CLOCK,
    input [27:0]hp, //half of period * 10^8
    output newclock
    );
    
    reg [27:0] count = 0;
    reg newclock = 0;
    
    always @ (posedge CLOCK) begin    
        if (count < hp) count <= count + 1; 
        else begin count <= 0; end  
        newclock <= ( count == 0 ) ? ~newclock : newclock ;  
    end
endmodule
