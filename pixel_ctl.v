`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/01 00:57:11
// Design Name: 
// Module Name: pixel_ctl
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


module pixel_ctl(
    input valid,
    input [8:0]text_pixel,
    input [8:0]enemy_pixel,
    input [8:0]enemy_blt_pixel,
    input [8:0]me_pixel,
    input [8:0]me_blt_pixel,
    input [8:0]bg_pixel,
    input [8:0]heart_pixel,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
    );
    always@*
        if(valid==0)
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if(text_pixel!=9'b0)
            {vgaRed, vgaGreen, vgaBlue} = {text_pixel[8:6],1'b0 , text_pixel[5:3] , 1'b0 , text_pixel[2:0] , 1'b0};                        
        else if(heart_pixel!=9'b0)
            {vgaRed, vgaGreen, vgaBlue} = {heart_pixel[8:6],1'b0 , heart_pixel[5:3] , 1'b0 , heart_pixel[2:0] , 1'b0};            
        else if(me_blt_pixel!=9'b0)
            {vgaRed, vgaGreen, vgaBlue} = {me_blt_pixel[8:6],1'b0 , me_blt_pixel[5:3] , 1'b0 , me_blt_pixel[2:0] , 1'b0};
        else if(enemy_blt_pixel!=9'b0)
            {vgaRed, vgaGreen, vgaBlue} = {enemy_blt_pixel[8:6],1'b0 , enemy_blt_pixel[5:3] , 1'b0 , enemy_blt_pixel[2:0] , 1'b0};
        else if(enemy_pixel!=9'b0)
            {vgaRed, vgaGreen, vgaBlue} = {enemy_pixel[8:6],1'b0 , enemy_pixel[5:3] , 1'b0 , enemy_pixel[2:0] , 1'b0};
        else if(me_pixel!=0)
            {vgaRed, vgaGreen, vgaBlue} = {me_pixel[8:6],1'b0 , me_pixel[5:3] , 1'b0 , me_pixel[2:0] , 1'b0};
        else
            {vgaRed, vgaGreen, vgaBlue} = {bg_pixel[8:6],1'b0 , bg_pixel[5:3] , 1'b0 , bg_pixel[2:0] , 1'b0};
endmodule
