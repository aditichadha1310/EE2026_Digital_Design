`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 14:56:10
// Design Name: 
// Module Name: linearshiftshort
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


module linearshiftshort (
    input clk , // clock input
    input [3:0]data , // 8 bit data  
    input reset , // reset input
    input enable, // Enable for counter
    output [3:0]out  // Output of the counter
);

    reg [3:0] out;
    wire linear_feedback;

    assign linear_feedback = !(out[3] ^ out[2]);

    always @(posedge clk)
        begin
            if (reset) 
                begin
                    out <= 4'b0;
                end
            else if(enable) 
                begin
                    out <= {out[3], out[2],out[1],out[0],linear_feedback};
                end                              
    end

endmodule
