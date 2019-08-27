`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/16 10:33:31
// Design Name: 
// Module Name: text_pixel_gen
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


module text_pixel_gen(
    input rst,
    input clk_25MHz,
    input [1:0]show_text,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [8:0]text_pixel
    );
    reg [13:0]addr_gameover,addr_complete,addr_ready;
    always@*
    if(h_cnt >= 160 + 20 && h_cnt < 160 + 20 + 280 && v_cnt >= 100 && v_cnt < 134 )
        addr_gameover = (v_cnt-100)*280 + h_cnt - 160 -20;
    else
        addr_gameover = 0;
        
    always@*
        if(h_cnt >= 160 + 53 && h_cnt < 160 + 53 + 214 && v_cnt >= 100 && v_cnt < 135 )
            addr_complete = (v_cnt-100)*214 + h_cnt - 160 -53;
        else
            addr_complete = 0;

    always@*
        if(h_cnt >= 160 + 40 && h_cnt < 160 + 40 + 260 && v_cnt >= 100 && v_cnt < 162 )
            addr_ready = (v_cnt-100)*260 + h_cnt - 160 -40;
        else
            addr_ready = 0;
 

wire [8:0]pixel_gameover,pixel_ready,pixel_complete;
wire [8:0]data;

    blk_mem_gen_gameover blk_mem_gen_gameover_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(addr_gameover),
      .dina(data[8:0]),
      .douta(pixel_gameover)
    );                  

    blk_mem_gen_ready blk_mem_gen_ready_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(addr_ready),
      .dina(data[8:0]),
      .douta(pixel_ready)
    );  
    
    blk_mem_gen_complete blk_mem_gen_complete_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(addr_complete),
      .dina(data[8:0]),
      .douta(pixel_complete)
    );              
     
    always@*
    if(show_text== 2'b01)
        text_pixel = pixel_ready;
    else if(show_text== 2'b10)
        text_pixel = pixel_gameover;
    else if(show_text== 2'b11)
        text_pixel = pixel_complete;
    else 
        text_pixel = 0;
endmodule
