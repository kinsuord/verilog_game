`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/22 20:09:28
// Design Name: 
// Module Name: me_ctl
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

module me_ctl(//控制飛機 移動與發射子彈
    input clk_main,
    input en,//是否可以操作
    input rst,
    input [8:0]last_change,
    input eli_me,
    input [511:0]key_down,
    input [12:0]eli_me_blt,
    output [8:0]me_x,
    output [8:0]me_y,
    output me_vi,
    output reg [2:0]me_lifes,
    output [12:0]me_blt_vi,//那些子彈是可以看見的
    output [116:0]me_blt_x,//13*9十三個子彈的位置
    output [116:0]me_blt_y,
    output is_gameover
    );
    /// me move speed
    wire clk_me_move;
    freq_div F0 (.rst(rst), .f_cst(clk_main), .freq(`ME_MOVE_SPEED), .fout(clk_me_move));
    // me_x
    wire x_a_or_m,x_en,rst_me_posi;
    assign x_en = ((key_down[`KEY_R] ^ key_down[`KEY_L]) & en)  ? 1:0;
    assign x_a_or_m = (key_down[`KEY_R]==1) ? 1:0;
    
    counter U0 (
        .rst(rst), .clk(clk_me_move), 
        .a_or_m(x_a_or_m), .en(x_en),
        .rst_counter(rst_me_posi), .rst_value((`AX>>1)-(`ME_W>>1)),
        .max(`AX - `ME_W), .min(0),
        .cnt(me_x)
    );
    // me_y
    wire y_a_or_m,y_en;
    assign y_en = ((key_down[`KEY_D] ^ key_down[`KEY_U]) & en) ? 1:0;
    assign y_a_or_m = (key_down[`KEY_D]==1) ? 1:0;
    
    counter U1 (
        .rst(rst), .clk(clk_me_move), 
        .a_or_m(y_a_or_m), .en(y_en),
        .rst_counter(rst_me_posi), .rst_value(`AY-`ME_H),
        .max(`AY - `ME_H), .min(0),
        .cnt(me_y)
    );
    
   // OnePulse O0 (.signal_single_pulse(), .signal(eli_me), .clock(clk_smain));
   reg eli_me_tmp;
    always@(posedge clk_main or posedge rst)
   if(rst)
       eli_me_tmp = 0;
   else
       eli_me_tmp = eli_me;
   
    reg [2:0]me_lifes_tmp;
    always@(posedge clk_main or posedge rst)
    if(rst)
        me_lifes = 3;
    else if(~en)
        me_lifes = 3;
    else
        me_lifes = me_lifes_tmp;
    
    always@*
        if({eli_me,eli_me_tmp}==2'b10 && me_lifes>0)//當eli 0變成1時
            me_lifes_tmp = me_lifes-1;
        else 
            me_lifes_tmp = me_lifes;
    
    assign me_vi=(me_lifes==0)? 0 :1;
    ///////////bullets 13顆子彈
    reg [3:0]cnt;
    wire clk_blt_gen;
    freq_div F2 (.rst(rst), .f_cst(clk_main), .freq(`ME_BLT_GEN_SPEED), .fout(clk_blt_gen));// 分配給13個子彈
    always@(posedge clk_blt_gen)
    if(cnt==12)
        cnt <= 0;
    else
        cnt<=cnt + 1;
    
    reg [12:0] tmp;
    reg [12:0] is_shoot; 
    reg [12:0] is_shoot_tmp;   
    generate
        genvar j;
        for(j=0;j<13;j=j+1)begin : shoot_ctl//把沒按到空白鑑的生命設成0
            always@(posedge clk_main or posedge rst)
            if(rst)begin
                tmp[j] <= 0;
                is_shoot[j] <= 0;
            end
            else begin
                tmp[j] <= (clk_blt_gen & (cnt==j));
                if({tmp[j] , (clk_blt_gen & (cnt==j))} == 2'b01)//當分配的clkposedge的時候
                    is_shoot[j]<=is_shoot_tmp[j];
                else
                    is_shoot[j]<=is_shoot[j];
            end
            
            always@*
                is_shoot_tmp[j] = key_down[`KEY_SPACE] & en;
        end 
    endgenerate       
   
    generate
        genvar i;
        for(i=0;i<13;i=i+1)begin : me_blt
            obj_ctl U (
            . clk(clk_main),
            . rst(rst),
            . eli(eli_me_blt[i]),//當它posedge 後扣血或被消滅，要長於clk
            . en(1),//會不會移動
            . rst_obj(clk_blt_gen & (cnt==i)),//當它變成1之後，顯示在螢幕上並開始動 要長於speed除頻後的clk
            . rst_x(me_x+(`ME_W>>1)-5), .rst_y(me_y), . rst_lifes(is_shoot[i]),
            . x_am(1), . y_am(0),
            . x_speed(0), .y_speed(`BLT_MOVE_SPEED),//決定位移的速度
            . vi(me_blt_vi[i]),//決定這個東西可不可見
            . x(me_blt_x[i*9+8 : i*9]), . y(me_blt_y[i*9+8 : i*9])
            );
        end 
    endgenerate
    
    assign is_gameover = (me_lifes==0) ? 1:0;
 /*   

    reg [3:0]cnt;
    freq_div F1 (.rst(rst), .f_cst(clk_main), .freq(`BLT_MOVE_SPEED), .fout(clk_blt));
    freq_div F2 (.rst(rst), .f_cst(clk_main), .freq(`ME_BLT_GEN_SPEED), .fout(clk_blt_gen));
    always@(posedge clk_blt_gen)
    if(cnt==12)
        cnt <= 0;
    else
        cnt<=cnt + 1;

    reg [12:0]vi_s;
    generate
        genvar i;
        for(i=0;i<13;i=i+1)begin : addr
            always@(posedge(clk_blt_gen & (cnt==i))) begin
                 me_blt_x[i*9+8:i*9] <= me_x;
                 if(key_down[`KEY_SPACE])  
                    vi_s[i] <= 1;
                 else
                    vi_s[i] <= 0;
            end
        end 
    endgenerate

    reg [12:0]vi_e;
    generate
        genvar j;
        for(j=0;j<13;j=j+1)begin : vie
            always@* begin
                 if(me_blt_y[j*9+8 : j*9] == 0)  
                    vi_e[j] <= 0;
                 else
                    vi_e[j] <= 1;
            end
        end 
    endgenerate
    assign me_blt_vi = vi_s & vi_e;

    
    counter U2 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==0)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[8:0])
    );    
    counter U3 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==1)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[17:9])
    );    
    counter U4 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==2)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[26:18])
    );    
    counter U5 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==3)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[35:27])
    );    
    counter U6 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==4)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[44:36])
    );    
    counter U7 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==5)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[53:45])
    );    
    counter U8 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==6)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[62:54])
    );    
    counter U9 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==7)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[71:63])
    );    
    counter U10 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==8)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[80:72])
    );    
    counter U11 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==9)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[89:81])
    );    
    counter U12 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==10)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[98:90])
    );    
    counter U13 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==11)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[107:99])
    );    
    counter U14 (
        .rst(rst), .clk(clk_blt), 
        .a_or_m(0), .en(1),
        .rst_counter(clk_blt_gen & (cnt==12)), .rst_value(me_y),
        .max(`AY ), .min(0),
        .cnt(me_blt_y[116:108])
    );    
    */
endmodule
