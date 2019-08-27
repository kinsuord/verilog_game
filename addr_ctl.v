`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/31 16:16:51
// Design Name: 
// Module Name: addr_ctl
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


module addr_ctl(
    input [16:0]me_blt_addr,
    input [16:0]me_addr,
    output reg [16:0]addr
    );
    
    always@*
    if(me_blt_addr==0)
        addr = me_addr;
    else
        addr = me_blt_addr;
    
endmodule
