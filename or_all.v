`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/07 13:37:47
// Design Name: 
// Module Name: or_all
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


module or_all(
    input [15:0]in,
    output out
    );
    assign out = in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] 
    | in[7] | in[8] | in[9] | in[10] | in[11] | in[12] | in[13] | in[14] | in[15] ;
endmodule
