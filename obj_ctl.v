`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/02 12:13:07
// Design Name: 
// Module Name: blt_ctl
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

module obj_ctl(
    input [5:0]rst_lifes,//當rst時所要設定的血量
    input clk,
    input rst,
    input eli,//當它posedge 後扣血或被消滅，要長於6clk
    input en,//會不會移動
    input rst_obj,//當它變成1之後，顯示在螢幕上並開始動 要長於speed除頻後的clk
    input [8:0]rst_x,//rst之後的位置
    input [8:0]rst_y,
    input x_am,//決定要向右還是向左 1向右  0向左
    input y_am,//1向下 0向上
    input [7:0]x_speed,//決定位移的速度
    input [7:0]y_speed,//決定位移的速度
    output reg vi,//決定這個東西可不可見
    output [8:0]x,//他最後的位置
    output [8:0]y,
    output reg [5:0]lifes//它的血量
    );
    
    wire en_x,en_y;
    wire clk_slow;
    freq_div F0 (.rst(rst), .f_cst(clk), .freq(x_speed), .fout(clk_x));
    freq_div F1 (.rst(rst), .f_cst(clk), .freq(y_speed), .fout(clk_y));

    assign clk_slow = (x_speed>y_speed) ? clk_x : clk_y;
    assign en_x = (x_speed==0) ? 0:1;
    assign en_y = (y_speed==0) ? 0:1;
    
    counter X (
        .rst(rst), .clk(clk_x), 
        .a_or_m(x_am), .en( en & en_x),
        .rst_value(rst_x), .rst_counter(rst_obj),
        .max(`AX), .min(0),
        .cnt(x)
    );    

    counter Y (
        .rst(rst), .clk(clk_y), 
        .a_or_m(y_am), .en(en & en_y),
        .rst_value(rst_y), .rst_counter(rst_obj),
        .max(`AY ), .min(0),
        .cnt(y)
    );     
    
    reg eli_tmp,rst_obj_tmp;
    reg [5:0]lifes_tmp;
    always@(posedge clk_slow or posedge rst)
    if(rst)begin
        eli_tmp <= 0;
        rst_obj_tmp <= 0;
    end
    else begin
        eli_tmp <= eli;
        rst_obj_tmp <= rst_obj;
    end
        
    always@*
    if({rst_obj,rst_obj_tmp}==2'b10)
        lifes_tmp = rst_lifes;
    else if({eli,eli_tmp}==2'b10 && lifes>0)//當eli 0變成1時
        lifes_tmp = lifes-1;
    else 
        lifes_tmp = lifes;

    always@(posedge clk_slow or posedge rst)
    if(rst)
        lifes <= rst_lifes;
    else
        lifes <= lifes_tmp;
        
    always@*
    if(lifes==0)
        vi=0;
    else if(x==0 || x==`AX || y==0 || y==`AY)//在邊界的時候要藏起來
        vi=0;
    else
        vi=1;
    
endmodule
