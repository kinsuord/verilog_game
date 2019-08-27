`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/16 03:34:47
// Design Name: 
// Module Name: heart_pixel_gen
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

`include "config.h"
module heart_pixel_gen(
    input rst,
    input clk_25MHz,
    input [2:0]me_lifes,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [8:0]heart_pixel
    );
    
    reg [9:0]addr;
    always@*
    if(h_cnt >= 160 && h_cnt < 160 + 35 && v_cnt >= `AY-24 && v_cnt < `AY )//顯示生命
        if(me_lifes>1)
            addr= (v_cnt-(`AY - 24))*35 + h_cnt - 160 ;
        else
            addr= 0;
    else if(h_cnt >= 160 + 35 && h_cnt < 160 + 35*2 && v_cnt >= `AY-24 && v_cnt < `AY )
        if(me_lifes>2)
            addr= (v_cnt-(`AY - 24))*35 + h_cnt - 160 - 35 ;
        else
            addr= 0;
    else
        addr = 0; 

wire [8:0]data;
    blk_mem_gen_heart blk_mem_gen_heart_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(addr),
      .dina(data[8:0]),
      .douta(heart_pixel)
    );         
    
            
            
    

endmodule
