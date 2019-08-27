`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/06 21:56:10
// Design Name: 
// Module Name: is_collide
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


module is_collide(//判斷1跟2有沒有相撞
    input en,//en is 0 output
    input [8:0]x1,
    input [8:0]y1,
    input [8:0]x2,
    input [8:0]y2,
    input [8:0]w1,
    input [8:0]h1,
    input [8:0]w2,
    input [8:0]h2,
    output out
    );
    assign out = ((x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2 ) & en) ? 1:0;

        
endmodule
