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
    input [5:0]rst_lifes,//��rst�ɩҭn�]�w����q
    input clk,
    input rst,
    input eli,//��posedge �ᦩ��γQ�����A�n����6clk
    input en,//�|���|����
    input rst_obj,//���ܦ�1����A��ܦb�ù��W�ö}�l�� �n����speed���W�᪺clk
    input [8:0]rst_x,//rst���᪺��m
    input [8:0]rst_y,
    input x_am,//�M�w�n�V�k�٬O�V�� 1�V�k  0�V��
    input y_am,//1�V�U 0�V�W
    input [7:0]x_speed,//�M�w�첾���t��
    input [7:0]y_speed,//�M�w�첾���t��
    output reg vi,//�M�w�o�ӪF��i���i��
    output [8:0]x,//�L�̫᪺��m
    output [8:0]y,
    output reg [5:0]lifes//������q
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
    else if({eli,eli_tmp}==2'b10 && lifes>0)//��eli 0�ܦ�1��
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
    else if(x==0 || x==`AX || y==0 || y==`AY)//�b��ɪ��ɭԭn�ð_��
        vi=0;
    else
        vi=1;
    
endmodule
