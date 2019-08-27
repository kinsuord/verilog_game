`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/27 15:35:52
// Design Name: 
// Module Name: SSD_Decoder
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


module ssd_decoder(
     score00,
     score01,
     score02,
     score03,
     display0,
     display1,
     display2,
     display3
    );
    
    output reg [7:0] display0;
    output reg [7:0] display1;
    output reg [7:0] display2;
    output reg [7:0] display3;
    input [3:0]score00;
    input [3:0]score01;
    input [3:0]score02;
    input [3:0]score03;
    always@(score00)
        case(score00)
        4'd0 : display0 <= 8'b00000011; //0
        4'd1 : display0 <= 8'b10011111; //1
        4'd2 : display0 <= 8'b00100101; //2
        4'd3 : display0 <= 8'b00001101; //3
        4'd4 : display0 <= 8'b10011001; //4
        4'd5 : display0 <= 8'b01001001; //5
        4'd6 : display0 <= 8'b01000001 ; //6
        4'd7 : display0 <= 8'b00011111 ; //7
        4'd8 : display0 <= 8'b00000001 ; //8
        4'd9 : display0 <= 8'b00001001; //9
        default : display0 <= 8'b01110001; //F
        endcase
        
    always@(score01)
        case(score01)
        4'd0 : display1 <= 8'b00000011; //0
        4'd1 : display1 <= 8'b10011111; //1
        4'd2 : display1 <= 8'b00100101; //2
        4'd3 : display1 <= 8'b00001101; //3
        4'd4 : display1 <= 8'b10011001; //4
        4'd5 : display1 <= 8'b01001001; //5
        4'd6 : display1 <= 8'b01000001 ; //6
        4'd7 : display1 <= 8'b00011111 ; //7
        4'd8 : display1 <= 8'b00000001 ; //8
        4'd9 : display1 <= 8'b00001001; //9
        default : display1 <= 8'b01110001; //F
        endcase
    always@(score02)
        case(score02)
            4'd0 : display2 <= 8'b00000011; //0
            4'd1 : display2 <= 8'b10011111; //1
            4'd2 : display2 <= 8'b00100101; //2
            4'd3 : display2 <= 8'b00001101; //3
            4'd4 : display2 <= 8'b10011001; //4
            4'd5 : display2 <= 8'b01001001; //5
            4'd6 : display2 <= 8'b01000001 ; //6
            4'd7 : display2 <= 8'b00011111 ; //7
            4'd8 : display2 <= 8'b00000001 ; //8
            4'd9 : display2 <= 8'b00001001; //9
            default : display2 <= 8'b01110001; //F
        endcase
     always@(score03)
         case(score03)
            4'd0 : display3 <= 8'b00000011; //0
            4'd1 : display3 <= 8'b10011111; //1
            4'd2 : display3 <= 8'b00100101; //2
            4'd3 : display3 <= 8'b00001101; //3
            4'd4 : display3 <= 8'b10011001; //4
            4'd5 : display3 <= 8'b01001001; //5
            4'd6 : display3 <= 8'b01000001 ; //6
            4'd7 : display3 <= 8'b00011111 ; //7
            4'd8 : display3 <= 8'b00000001 ; //8
            4'd9 : display3 <= 8'b00001001; //9
            default : display3 <= 8'b01110001; //F
         endcase
endmodule
