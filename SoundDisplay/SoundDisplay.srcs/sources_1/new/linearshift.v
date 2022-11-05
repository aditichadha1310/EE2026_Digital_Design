`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2021 20:35:13
// Design Name: 
// Module Name: linearshift
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

module linearshift (
    input clk , // clock input
    input [4:0]data , // 8 bit data  
    input reset , // reset input
    input enable, // Enable for counter
    output [4:0]out  // Output of the counter
);

    reg [4:0] out;
    wire linear_feedback;

    assign linear_feedback = !(out[4] ^ out[3]);

    always @(posedge clk)
        begin
            if (reset) 
                begin
                    out <= 5'b0;
                end
            else if(enable) 
                begin
                    out <= {out[4], out[3], out[2],out[1],out[0],linear_feedback};
                end                              
    end

endmodule
