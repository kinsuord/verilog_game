`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/22 19:32:47
// Design Name: 
// Module Name: top
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

module top(
    input rst,
    input clk,
    //VGA
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,        
    //keyboard
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    //test_LED
    output [15:0]test_LED,
    output [3:0]bit_dsp,
    output [7:0]BCD_dsp        
    );
    
///////////clk_main

wire clk_main;
freq_div F0 (.rst(rst), .f_cst(clk), .freq(`CLK_MAIN_FREQ), .fout(clk_main));//10000HZ
    
//////////////keyboard input
wire [511:0]key_down;
wire [8:0]last_change;
wire key_valid;
KeyboardDecoder U0(
    .key_down(key_down),.last_change(last_change),
    .key_valid(key_valid),.PS2_DATA(PS2_DATA),.PS2_CLK(PS2_CLK),
    .rst(rst),.clk(clk)
);  
/////////////////////////////////game ctl
wire is_gameover,is_complete;
wire me_en,emeny_en;
wire [1:0]show_text;
game_FSM F1(
    .clk_main(clk_main),
    .rst(rst),
    .is_gameover(is_gameover),
    .is_complete(is_complete),
    .key_down(key_down), .last_change(last_change),
    .me_en(me_en),.enemy_en(enemy_en),
    .show_text(show_text)
    );


//////////////me_ctl
wire [12:0]eli_me_blt;
wire eli_me;
wire [8:0]me_x,me_y;
wire [2:0]me_lifes;
wire [12:0]me_blt_vi;
wire me_vi;
wire [116:0]me_blt_x,me_blt_y;
me_ctl U1(
    .en(me_en),
    .clk_main(clk_main), .rst(rst),
    .me_lifes(me_lifes), .eli_me(eli_me),
    .eli_me_blt(eli_me_blt),
    .last_change(last_change), .key_down(key_down),
    .me_x(me_x),.me_y(me_y), 
    .me_vi(me_vi),
    .me_blt_x(me_blt_x), .me_blt_y(me_blt_y),
    .me_blt_vi(me_blt_vi),
    .is_gameover(is_gameover)
);

///////////////enemy_ctl
    wire [89:0]enemy_x,enemy_y;
    wire [29:0]enemy_type;
    wire [134:0]enemy_blt_x,enemy_blt_y;
    wire [14:0]enemy_blt_vi;
    wire [29:0]enemy_blt_type;//20*2
    wire [9:0]enemy_vi;
    wire [9:0]eli_enemy;
    wire is_end;
    ////
    wire [59:0] now_enemy_lifes;
    enemy_ctl U5(
    .en(enemy_en),
    . me_x(me_x),
    . rst(rst),
    . clk_main(clk_main),
    . eli_enemy(eli_enemy),//. [19:0]enemy_blt_eli,
    . enemy_x(enemy_x),.enemy_y(enemy_y),//8
    . enemy_type(enemy_type), //.[9:0]enemy_x_m,. [9:0]enemy_y_m,//如果從邊邊出現位置有可能是負的，先不要用這個
    . enemy_blt_x(enemy_blt_x),. enemy_blt_y(enemy_blt_y),.enemy_blt_vi(enemy_blt_vi),//20
    . enemy_blt_type(enemy_blt_type),. enemy_vi(enemy_vi),
    . now_enemy_lifes(now_enemy_lifes),
    . is_complete(is_complete)
    );

    //assign test_LED[15:9] = me_y[8:2];
    ////////////////////////eli_ct
    wire [89:0]size_x;
    eli_ctl E0(.rst(rst), .clk_main(clk_main),
        .me_x(me_x), .me_y(me_y),
        .me_blt_x(me_blt_x), .me_blt_y(me_blt_y), .me_blt_vi(me_blt_vi),
        .enemy_x(enemy_x), .enemy_y(enemy_y), .enemy_type(enemy_type), .enemy_vi(enemy_vi),
        .enemy_blt_x(enemy_blt_x),.enemy_blt_y(enemy_blt_y),. enemy_blt_vi(enemy_blt_vi),
        .eli_me(eli_me), .eli_me_blt(eli_me_blt), .eli_enemy(eli_enemy),
        .size_x(size_x)
    );
    assign test_LED[8:0]=size_x[8:0];
    //////////////////////////////////////////////////////////////////////VGA
    
    wire [8:0] data;
    wire clk_25MHz;
    wire clk_22;
    
    wire [8:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480

    wire is_scoll,clk_div;
    clock_divisor clk_wiz_0_inst(
        .clk(clk), 
        .clk1(clk_25MHz),
        .clk22(clk_22)
    );
    
    ///////// me_pixel_gen
    wire [8:0] me_pixel;
    wire [11:0] me_pixel_addr;
    //assign test_LED[9:0] = v_cnt;
    me_addr_gen G0(
        .me_x(me_x), .me_y(me_y), .me_lifes(me_lifes),.me_vi(me_vi),
        .h_cnt(h_cnt), .v_cnt(v_cnt),
        .pixel_addr(me_pixel_addr)
    );    
    //me_memery
    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(me_pixel_addr),
      .dina(data[8:0]),
      .douta(me_pixel)
    ); 
        
    //assign test_LED[3:0] = me_pixel_addr[3:0];
    //me_blt_addr_gen
    wire [8:0]me_blt_addr;
    wire [8:0]me_blt_pixel;
    me_blt_addr_gen U3(
        . me_blt_vi(me_blt_vi),
        . me_blt_x(me_blt_x),
        . me_blt_y(me_blt_y),    
        . h_cnt(h_cnt),
        . v_cnt(v_cnt),
         .me_blt_addr(me_blt_addr)      
    );
    //me_blt_memery
    blk_mem_gen_1 blk_mem_gen_1_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(me_blt_addr),
      .dina(data[8:0]),
      .douta(me_blt_pixel)
    ); 
    ////////////////////enemy_pixel_gen
    wire [8:0]enemy_pixel;
    enemy_pixel_gen G6(
    .enemy_x(enemy_x),.enemy_y(enemy_y),//8
    . enemy_vi(enemy_vi),
    .enemy_type(enemy_type),
    . h_cnt(h_cnt),
    . v_cnt(v_cnt),
    . clk_25MHz(clk_25MHz),
    . enemy_pixel(enemy_pixel)
);
    ////////////////////////////////////enemy_blt_pixel_gen
    wire [8:0]enemy_blt_pixel;
    enemy_blt_pixel_gen G7(
    .enemy_blt_x(enemy_blt_x),.enemy_blt_y(enemy_blt_y),//8
    . enemy_blt_vi(enemy_blt_vi),
    . h_cnt(h_cnt),
    . v_cnt(v_cnt),
    . clk_25MHz(clk_25MHz),
    . enemy_blt_pixel(enemy_blt_pixel)
);    
////////////////////////heart_pixel_gen
    wire [8:0]heart_pixel;
    heart_pixel_gen G9(
    .rst(rst),
    . me_lifes(me_lifes),
    . h_cnt(h_cnt),
    . v_cnt(v_cnt),
    . clk_25MHz(clk_25MHz),
    . heart_pixel(heart_pixel)
);    

///////////////////////text_pixel_gen
    wire [8:0]text_pixel;
    text_pixel_gen G10(
    .rst(rst),
    . show_text(show_text),
    . h_cnt(h_cnt),
    . v_cnt(v_cnt),
    . clk_25MHz(clk_25MHz),
    . text_pixel(text_pixel)
);         
    /////////////////////////bg_pixel_gen
    wire [8:0]bg_pixel;
    bg_pixel_gen G8(
    .rst(rst),
    . clk_22(clk_22),
    . h_cnt(h_cnt),
    . v_cnt(v_cnt),
    . clk_25MHz(clk_25MHz),
    . bg_pixel(bg_pixel)
);      
//assign test_LED[15:7] = enemy_pixel;
    
      vga_controller   vga_inst(
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
      );
      
      pixel_ctl U4(
      .valid(valid),
      .enemy_pixel(enemy_pixel),
      .enemy_blt_pixel(enemy_blt_pixel),
      .text_pixel(text_pixel),
      .me_blt_pixel(me_blt_pixel),
      .me_pixel(me_pixel),
      .bg_pixel(bg_pixel),
      .heart_pixel(heart_pixel),
      .vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue)
      );  
    //assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? {me_pixel[8:6],1'b0 , me_pixel[5:3] , 1'b0 , me_pixel[2:0] , 1'b0} :12'h0;    
    
endmodule
