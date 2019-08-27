`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/05 17:58:14
// Design Name: 
// Module Name: eli_ctl
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


module eli_ctl(
    input rst,input clk_main,
    input [8:0]me_x,input [8:0]me_y,
    input [116:0]me_blt_x,input [116:0]me_blt_y,input [12:0]me_blt_vi,
    input [89:0]enemy_x,input [89:0]enemy_y, input [29:0]enemy_type, input [9:0]enemy_vi,
    input [134:0]enemy_blt_x,input [134:0]enemy_blt_y,input[14:0]enemy_blt_vi,//15
    output eli_me,
    output [12:0]eli_me_blt,
    output [9:0]eli_enemy,
    output reg [89:0]size_x
    );
    wire clk_slow;
    freq_div F0 (.rst(rst), .f_cst(clk_main), .freq(99), .fout(clk_slow));////////////////////////////////
    //////////////////////////collide
    wire [9:0]enemy_me_cld;//敵人跟自己相撞
    reg [89:0]size_y;
    generate
        genvar i;
        for(i=0;i<10;i=i+1)begin : cldenemyme
            always@* begin
            if(enemy_type[i*3+2:i*3]==2)begin
                size_x[i*9+8:i*9] = 180;
                size_y[i*9+8:i*9] = 90;
            end
            else begin
                size_x[i*9+8:i*9] = 20;
                size_y[i*9+8:i*9] = 20;            
            end
            end
            
            is_collide C0(.en(enemy_vi[i]), .x1(me_x), .y1(me_y), .h1(35), .w1(35), .x2(enemy_x[i*9+8:i*9]), .y2(enemy_y[i*9+8:i*9]),
                .h2(size_y[i*9+8:i*9]),.w2(size_x[i*9+8:i*9]),.out(enemy_me_cld[i])); 
        end
    endgenerate    
    
    wire [129:0]enemy_blt_cld;//敵人跟自己的子彈相撞[12:0]是第一個敵人與子彈的相撞
    generate
    genvar n0;
    //地一個敵人
    for(n0=0;n0<10;n0=n0+1) begin : cldenemy
        genvar j;
        for(j=0;j<13;j=j+1)begin : cldenemyblt
            is_collide C0(.en(me_blt_vi[j] & enemy_vi[n0]), .x1(enemy_x[8 + n0 * 9 : n0 * 9]), .y1(enemy_y[8+ n0 * 9:n0 * 9]), .h1(size_y[n0*9+8:n0*9]), .w1(size_x[n0*9+8:n0*9]), 
                .x2(me_blt_x[j*9+8:j*9]), .y2(me_blt_y[j*9+8:j*9]), .h2(15),.w2(15),.out(enemy_blt_cld[j + n0*13]));   
        end
    end
    endgenerate      

    wire [14:0]enemy_blt_me_cld;//敵人子彈跟自己相撞
    generate
        genvar i0;
        for(i0=0;i0<15;i0=i0+1)begin : enebltme 
            is_collide C0(.en(enemy_blt_vi[i0] ), .x1(me_x), .y1(me_y), .h1(35), .w1(35), .x2(enemy_blt_x[i0*9+8:i0*9]), .y2(enemy_blt_y[i0*9+8:i0*9]),
                .h2(10),.w2(10),.out(enemy_blt_me_cld[i0]));
        end
    endgenerate 
    //地一個敵人

    /*
    generate//地二個敵人
        genvar j2;
        for(j2=0;j2<13;j2=j2+1)begin : cldenemyblt2
            is_collide C0(.en(me_blt_vi[j2] & enemy_vi[1]), .x1(enemy_x[17:9]), .y1(enemy_y[17:9]), .h1(30), .w1(30), 
                .x2(me_blt_x[j2*9+8:j2*9]), .y2(me_blt_y[j2*9+8:j2*9]), .h2(15),.w2(15),.out(enemy_blt_cld[j2+13]));
        end
    endgenerate   
    */
    //是否消滅敵人1
    wire [9:0]tmp;
    generate//地一個敵人
    genvar i2;
    for(i2=0;i2<10;i2=i2+1) begin : eliene
         or_all OO(.in(enemy_blt_cld[12+i2*13:i2*13]), .out(tmp[i2]));//只要跟13科子彈的任何一顆有相撞就算
         OnePulse O1 (.signal_single_pulse(eli_enemy[i2]), .signal(tmp[i2]), .clock(clk_slow));
    end
    endgenerate

    /////////////////////////////是否子彈相撞
    
    wire [129:0]eli_me_blt_;
    generate//地一個敵人
    genvar i1;
    for(i1=0;i1<10;i1=i1+1) begin : elibltene
        genvar j1;
        for(j1=0;j1<13;j1=j1+1)begin : eliblt
            OnePulse O2(.signal_single_pulse(eli_me_blt_[j1 + i1*13]), .signal(enemy_blt_cld[j1 + i1*13]), .clock(clk_slow));
        end
    end
    endgenerate    
    assign eli_me_blt = eli_me_blt_[12-:13] | eli_me_blt_[25-:13] | eli_me_blt_[38-:13] | eli_me_blt_[51-:13] | eli_me_blt_[64-:13] | 
                eli_me_blt_[77-:13] | eli_me_blt_[90-:13] | eli_me_blt_[103-:13] | eli_me_blt_[116-:13] | eli_me_blt_[129-:13];
    /*  
    generate//地一個敵人
         genvar j2;
         for(j2=0;j2<13;j2=j2+1)begin : eliblt2
             OnePulse O3(.signal_single_pulse(eli_me_blt2[j2]), .signal(enemy_blt_cld[j2]), .clock(clk_slow));
         end
     endgenerate      */
    ////////////////////////////是否扣自己的血
    reg eli_em_tmp;
    wire me_is_cld;//自己有沒有撞到東西
    assign me_is_cld = enemy_me_cld[0] | enemy_me_cld[1] | enemy_me_cld[2] | enemy_me_cld[3] | enemy_me_cld[4] | enemy_me_cld[5] | 
            enemy_me_cld[6] |  enemy_me_cld[7] | enemy_me_cld[8] | enemy_me_cld[9] 
            | enemy_blt_me_cld[0] | enemy_blt_me_cld[1] | enemy_blt_me_cld[2] | enemy_blt_me_cld[3] | enemy_blt_me_cld[4]
             | enemy_blt_me_cld[5] | enemy_blt_me_cld[6] | enemy_blt_me_cld[7] | enemy_blt_me_cld[8] | enemy_blt_me_cld[9]
              | enemy_blt_me_cld[10] | enemy_blt_me_cld[11] | enemy_blt_me_cld[12] | enemy_blt_me_cld[13] | enemy_blt_me_cld[14];//這樣都算死
	OnePulse O0 (.signal_single_pulse(eli_me), .signal(me_is_cld), .clock(clk_slow));
    
endmodule
