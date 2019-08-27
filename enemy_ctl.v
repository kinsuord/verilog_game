`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/03 21:31:20
// Design Name: 
// Module Name: enemy_ctl
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
`define BOSS_STATE0 2'b00
`define BOSS_STATE1 2'b01
`define BOSS_STATE2 2'b10
`define BOSS_STATE3 2'b11 

module enemy_ctl(
    input [8:0]me_x,
    input rst,
    input en,
    input clk_main,
    input [9:0]eli_enemy,input [19:0]eli_enemy_blt,
    output [89:0]enemy_x,output [89:0]enemy_y,//8
    output reg [29:0]enemy_type,output [9:0]enemy_x_m,output [9:0]enemy_y_m,//如果從邊邊出現位置有可能是負的，先不要用這個
    output [134:0]enemy_blt_x,output [134:0]enemy_blt_y,output[14:0]enemy_blt_vi,//15
    output [29:0]enemy_blt_type,output [9:0]enemy_vi,
    output is_complete, //是否已經結束，都結束了就過關了
    /////////test
    output [59:0]now_enemy_lifes
    );
    reg [14:0]cnt;
    wire clk_10HZ;
    freq_div F0 (.rst(rst), .f_cst(clk_main), .freq(499), .fout(clk_10HZ));
    
    always@(posedge clk_10HZ or posedge rst)//主要計時器
    if(rst | ~en )
        cnt<=0;   
    else
        cnt <= cnt+1;
    
    reg [9:0]enemy_x_am;
    reg [9:0]enemy_y_am;
    reg [9:0]rst_enemy;
    reg [89:0]rst_enemy_x,rst_enemy_y;
    reg [69:0]enemy_speed_x,enemy_speed_y;//7
    reg [59:0]enemy_lifes;
    /////////////////////////boss ctl
    reg [1:0]boss_mode;
    wire [1:0]random;
    reg boss_move;
    
    random_num_gen R0(.clk(clk_main),.in((cnt%50)==1), .f(random));
    
    always@*
    if(((cnt-350)%50)>=5)
        boss_mode = random+1;
    else
        boss_mode = 2'b00;
    
    always@*
    if(((cnt-350)%40) >=20 )//cnt/64
        boss_move = 0;
    else
        boss_move = 1;

    /////////////////////////
    //1號
    always@*begin
    
    if(cnt>30 && cnt<80)begin//在3到10秒之間
        enemy_type[2:0] = 0;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 4;//血量設為4
        rst_enemy_x[8:0] = 60;
        rst_enemy_y[8:0] = 0;
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 49;
        enemy_y_am[0] = 1;
    end        
    else if(cnt>90 && cnt<140)begin
        enemy_type[2:0] = 1;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 4;//血量設為4
        rst_enemy_x[8:0] = 60;
        rst_enemy_y[8:0] = 0;    
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 49;
        enemy_y_am[0] = 1;
    end
    else if(cnt>145 && cnt<185)begin
        enemy_type[2:0] = 1;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 5;//血量設為4
        rst_enemy_x[8:0] = 320;
        rst_enemy_y[8:0] = 50;    
        enemy_speed_x[6:0] = 39;    
        enemy_speed_y[6:0] = 39;
        enemy_y_am[0] = 1;
    end
    else if(cnt>200 && cnt<250)begin
        enemy_type[2:0] = 0;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 4;//血量設為4
        rst_enemy_x[8:0] = 140;
        rst_enemy_y[8:0] = 0;    
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 34;
        enemy_y_am[0] = 1;
    end
    else if(cnt>270 && cnt<320)begin
        enemy_type[2:0] = 0;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 3;//血量設為4
        rst_enemy_x[8:0] = 140;
        rst_enemy_y[8:0] = 0;    
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 32;
        enemy_y_am[0] = 1;
    end
    else if(cnt>350)begin///////////////////////////////////boss
        enemy_type[2:0] = 2;    
        rst_enemy[0] = 1;//產生敵人1
        enemy_lifes [5:0] = 63;
        rst_enemy_x[8:0] = 60;
        rst_enemy_y[8:0] = 1;    
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 99;
        enemy_y_am[0] = boss_move;   
    end
    else begin
        enemy_type[2:0] = 0;
        rst_enemy[0] = 0;
        enemy_lifes [5:0] = 0;
        rst_enemy_x[8:0] = 0;
        rst_enemy_y[8:0] = 0;   
        enemy_speed_x[6:0] = 0;    
        enemy_speed_y[6:0] = 49;     
        enemy_y_am[0] = 1;   
    end    
    end
    
    //2號
    always@*begin
    enemy_y_am[1] = 1;        
    if(cnt>30 && cnt<80)begin//在3到10秒之間
        enemy_speed_x[13:7] = 0;    
        enemy_speed_y[13:7] = 49;
        rst_enemy[1] = 1;//產生敵人1
        enemy_lifes [11:6] = 4;//血量設為4
        rst_enemy_x[17:9] = 220;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 0;
        enemy_x_am[1] = 0;
    end   
    else if(cnt>90 && cnt<140) begin
        enemy_speed_x[13:7] = 0;    
        enemy_speed_y[13:7] = 39;
        rst_enemy[1] = 1;
        enemy_lifes [11:6] = 4;
        rst_enemy_x[17:9] = 130;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 1;  
        enemy_x_am[1] = 0;      
    end    
    else if(cnt>205 && cnt<255) begin
        enemy_speed_x[13:7] = 0;    
        enemy_speed_y[13:7] = 39;
        rst_enemy[1] = 1;
        enemy_lifes [11:6] = 5;
        rst_enemy_x[17:9] = 100;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 1;  
        enemy_x_am[1] = 0;      
    end    
    else if(cnt>145 && cnt<185) begin
        enemy_speed_x[13:7] = 39;    
        enemy_speed_y[13:7] = 49;
        rst_enemy[1] = 1;
        enemy_lifes [11:6] = 4;
        enemy_x_am[1] = 1;
        rst_enemy_x[17:9] = 0;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 0;        
    end  
    else if(cnt>280 && cnt<330) begin
        enemy_speed_x[13:7] = 44;    
        enemy_speed_y[13:7] = 44;
        rst_enemy[1] = 1;
        enemy_lifes [11:6] = 5;
        enemy_x_am[1] = 1;
        rst_enemy_x[17:9] = 80;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 1;        
    end      
    else begin
        enemy_speed_x[13:7] = 0;    
        enemy_speed_y[13:7] = 49;
        rst_enemy[1] = 0;
        enemy_lifes [11:6] = 0;
        rst_enemy_x[17:9] = 0;
        rst_enemy_y[17:9] = 0;
        enemy_type[5:3] = 0; 
        enemy_x_am[1] = 0;       
    end 
    end
    
    //3號
    always@*begin
    
    enemy_y_am[2] = 1;    
    if(cnt>145 && cnt<185)begin//在3到10秒之間
        enemy_speed_x[20:14] = 39;    
        enemy_speed_y[20:14] = 39;
        rst_enemy[2] = 1;//產生敵人1
        enemy_lifes [17:12] = 5;//血量設為4
        rst_enemy_x[26:18] = 320;
        rst_enemy_y[26:18] = 100;
        enemy_type[8:6] = 1;
    end   
    else if(cnt>205 && cnt<255)begin//在3到10秒之間
        enemy_speed_x[20:14] = 0;    
        enemy_speed_y[20:14] = 39;
        rst_enemy[2] = 1;//產生敵人1
        enemy_lifes [17:12] = 5;//
        rst_enemy_x[26:18] = 180;
        rst_enemy_y[26:18] = 0;
        enemy_type[8:6] = 1;
    end  
    else if(cnt>280 && cnt<330)begin//在3到10秒之間
        enemy_speed_x[20:14] = 44;    
        enemy_speed_y[20:14] = 44;
        rst_enemy[2] = 1;//產生敵人1
        enemy_lifes [17:12] = 5;//
        rst_enemy_x[26:18] = 200;
        rst_enemy_y[26:18] = 0;
        enemy_type[8:6] = 1;
    end
    else begin
        enemy_speed_x[20:14]  = 0;    
        enemy_speed_y[20:14]  = 49;
        rst_enemy[2] = 0;
        enemy_lifes [17:12] = 0;
        rst_enemy_x[26:18] = 0;
        rst_enemy_y[26:18] = 0;
        enemy_type[8:6] = 0;        
    end 
    end
    
    //enemy4
    
    always@*begin
    enemy_y_am[3] = 1;   
    if(cnt>210 && cnt<260)begin//在3到10秒之間
        enemy_speed_x[27:21] = 0;    
        enemy_speed_y[27:21] = 42;
        rst_enemy[3] = 1;//產生敵人1
        enemy_lifes [23:18] = 4;//血量設為4
        rst_enemy_x[35:27] = 60;
        rst_enemy_y[35:27] = 0;
        enemy_type[11:9] = 0;
    end   
    else begin
        enemy_speed_x[27:21]  = 0;    
        enemy_speed_y[27:21]  = 49;
        rst_enemy[3] = 0;
        enemy_lifes [23:18] = 0;
        rst_enemy_x[35:27] = 0;
        rst_enemy_y[35:27] = 0;
        enemy_type[11:9] = 0;        
    end 
    end
    
    //enemy5
    always@*begin   
    enemy_y_am[4] = 1;
    if(cnt>210 && cnt<260)begin//在3到10秒之間
        enemy_speed_x[34:28] = 0;    
        enemy_speed_y[34:28] = 42;
        rst_enemy[4] = 1;//產生敵人1
        enemy_lifes [29:24] = 4;//血量設為4
        rst_enemy_x[44:36] = 220;
        rst_enemy_y[44:36] = 0;
        enemy_type[14:12] = 0;
    end   
    else begin
        enemy_speed_x[34:28]  = 0;    
        enemy_speed_y[34:28]  = 49;
        rst_enemy[4] = 0;
        enemy_lifes [29:24] = 0;
        rst_enemy_x[44:36] = 0;
        rst_enemy_y[44:36] = 0;
        enemy_type[14:12] = 0;        
    end 
    end
        
    generate
        genvar i;
        for(i=0;i<10;i=i+1)begin : enemy
            obj_ctl U (
            .rst_lifes(enemy_lifes[i*6+5:i*6]),
            . clk(clk_main),
            . rst(rst),
            . eli(eli_enemy[i]),//當它posedge 後扣血或被消滅，要長於clk
            . en(1),//會不會移動
            . rst_obj(rst_enemy[i]),//當它變成1之後，顯示在螢幕上並開始動 要長於speed除頻後的clk
            . rst_x(rst_enemy_x[8+9*i : 9*i]),.rst_y(rst_enemy_y[8+9*i : 9*i]),
            . x_am(enemy_x_am[i]), . y_am(enemy_y_am[i]),
            . x_speed(enemy_speed_x[i*7+6:i*7]), .y_speed(enemy_speed_y[i*7+6:i*7]),//決定位移的速度
            . vi(enemy_vi[i]),//決定這個東西可不可見
            . x(enemy_x[i*9+8 : i*9]), . y(enemy_y[i*9+8 : i*9]),
            . lifes(now_enemy_lifes[i*6+5:i*6])
            );
        end 
    endgenerate
    ///////////////////////子彈
    reg [14:0]rst_enemy_blt;//15
    reg [134:0]rst_enemy_blt_x,rst_enemy_blt_y;
    reg [104:0]enemy_blt_speed_x,enemy_blt_speed_y;//7 
    reg [89:0]enemy_blt_lifes;
    reg [14:0]enemy_blt_am;

    always@*begin
    
    //子彈1
    
    if(cnt>95 && cnt<140) begin
        enemy_blt_speed_x[6:0] = 39;    
        enemy_blt_speed_y[6:0] = 29;
        rst_enemy_blt[0] = 1;
        enemy_blt_lifes [5:0] = 1;
        rst_enemy_blt_x[8:0] = 320;
        rst_enemy_blt_y[8:0] = 50;    
    end
    else if(cnt>155 && cnt<185) begin//跟著地2號敵機
        enemy_blt_speed_x[6:0] = 0;    
        enemy_blt_speed_y[6:0] = 39;
        rst_enemy_blt[0] = 1;
        enemy_blt_lifes [5:0] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[8:0] = enemy_x[17:9];
        rst_enemy_blt_y[8:0] = enemy_x[17:9];    
    end    
    else if(cnt>285 && cnt<330) begin
        enemy_blt_speed_x[6:0] = 0;    
        enemy_blt_speed_y[6:0] = 29;
        rst_enemy_blt[0] = 1;
        enemy_blt_lifes [5:0] = (now_enemy_lifes[17:12]!=0) ? 1:0;
        rst_enemy_blt_x[8:0] = enemy_x[26:18];
        rst_enemy_blt_y[8:0] = enemy_x[26:18];    
    end  
    else if(cnt%50>0 && cnt>350) begin/////////////////////////////////////1
        enemy_blt_speed_x[6:0] = 0;    
        enemy_blt_speed_y[6:0] = 29;
        rst_enemy_blt[0] = 1;
        enemy_blt_lifes [5:0] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[8:0] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[0] = 0;
        else
            rst_enemy_blt[0] = 1;
        
        case(boss_mode)
            2'b00:rst_enemy_blt_x[8:0] = 0;                       
            2'b01:rst_enemy_blt_x[8:0] = 100;
            2'b10:rst_enemy_blt_x[8:0] = 220;
            2'b11:rst_enemy_blt_x[8:0] = me_x[8:0];
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////1
    else  begin
        enemy_blt_speed_x[6:0] = 0;    
        enemy_blt_speed_y[6:0] = 29;
        rst_enemy_blt[0] = 0;
        enemy_blt_lifes [5:0] = 0;
        rst_enemy_blt_x[8:0] = 130;
        rst_enemy_blt_y[8:0] = 0;
    end         
    
    //子彈2
    if(cnt>100 && cnt<145) begin
        enemy_blt_speed_x[13:7] = 39;    
        enemy_blt_speed_y[13:7] = 29;
        rst_enemy_blt[1] = 1;
        enemy_blt_lifes [11:6] = 1;
        rst_enemy_blt_x[17:9] = 320;
        rst_enemy_blt_y[17:9] = 100;    
    end  
    else if(cnt>165 && cnt<195) begin
        enemy_blt_speed_x[13:7] = 0;    
        enemy_blt_speed_y[13:7] = 39;
        rst_enemy_blt[1] = 1;
        enemy_blt_lifes [11:6] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[17:9] = enemy_x[17:9];
        rst_enemy_blt_y[17:9] = enemy_y[17:9];   
    end  
    else if(cnt>220 && cnt<260) begin
        enemy_blt_speed_x[13:7] = 0;    
        enemy_blt_speed_y[13:7] = 29;
        rst_enemy_blt[1] = 1;
        enemy_blt_lifes [11:6] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[17:9] = enemy_x[17:9];
        rst_enemy_blt_y[17:9] = enemy_y[17:9];   
    end  
    else if(cnt>285 && cnt<330) begin
        enemy_blt_speed_x[13:7] = 0;    
        enemy_blt_speed_y[13:7] = 29;
        rst_enemy_blt[1] = 1;
        enemy_blt_lifes [11:6] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[17:9] = enemy_x[17:9];
        rst_enemy_blt_y[17:9] = enemy_y[17:9];   
    end 
    else if(cnt%50>0 && cnt>350) begin/////////////////////////////////////2  
        enemy_blt_speed_y[13:7] = 29;
        rst_enemy_blt[1] = 1;
        enemy_blt_lifes [11:6] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[17:9] = enemy_y[8:0] + 80; 
        enemy_blt_am[1] = 1;
        
        if(boss_mode==0)
            rst_enemy_blt[1] = 0;
        else
            rst_enemy_blt[1] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[17:9] = 0; 
                enemy_blt_speed_x[13:7] = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[17:9] = 100;
                enemy_blt_speed_x[13:7] = 39;
            end
            2'b10:begin
                rst_enemy_blt_x[17:9] = 220;
                enemy_blt_speed_x[13:7] = 39;
            end
            2'b11:begin
                rst_enemy_blt_x[17:9] = me_x[8:0]-20;
                enemy_blt_speed_x[13:7] = 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////
    else  begin
        enemy_blt_speed_x[13:7] = 0;    
        enemy_blt_speed_y[13:7] = 39;
        rst_enemy_blt[1] = 0;
        enemy_blt_lifes [11:6] = 0;
        rst_enemy_blt_x[17:9] = 130;
        rst_enemy_blt_y[17:9] = 0;
    end         

    
    //子彈3
    if(cnt>220 && cnt<260) begin
        enemy_blt_speed_x[20:14] = 0;    
        enemy_blt_speed_y[20:14] = 29;
        rst_enemy_blt[2] = 1;
        enemy_blt_lifes [17:12] = (now_enemy_lifes[17:12]!=0) ? 1:0;
        rst_enemy_blt_x[26:18] = enemy_x[26:18];
        rst_enemy_blt_y[26:18] = enemy_y[26:18];    
    end  
    else if(cnt>290 && cnt<330) begin
        enemy_blt_speed_x[20:14] = 0;    
        enemy_blt_speed_y[20:14] = 29;
        rst_enemy_blt[2] = 1;
        enemy_blt_lifes [17:12] = (now_enemy_lifes[17:12]!=0) ? 1:0;
        rst_enemy_blt_x[26:18] = enemy_x[26:18];
        rst_enemy_blt_y[26:18] = enemy_y[26:18];    
    end 
    else if(cnt%50>0 && cnt>350) begin/////////////////////////////////////3
        enemy_blt_speed_y[20:14] = 29;
        rst_enemy_blt[2] = 1;
        enemy_blt_lifes [17:12] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[26:18] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[2] = 0;
        else
            rst_enemy_blt[2] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[26:18] = 0; 
                enemy_blt_speed_x[20:14] = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[26:18] = 100;
                enemy_blt_speed_x[20:14] = 39;
            end
            2'b10:begin
                rst_enemy_blt_x[26:18] = 220;
                enemy_blt_speed_x[20:14] = 39;
            end
            2'b11:begin
                rst_enemy_blt_x[26:18] = me_x[8:0]-20;
                enemy_blt_speed_x[20:14]= 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////                
    else  begin
        enemy_blt_speed_x[20:14] = 0;    
        enemy_blt_speed_y[20:14] = 29;
        rst_enemy_blt[2] = 0;
        enemy_blt_lifes [17:12] = 0;
        rst_enemy_blt_x[26:18] = 130;
        rst_enemy_blt_y[126:18] = 0;
    end         
    
    //bullet4
    if(cnt>220 && cnt<260) begin
        enemy_blt_speed_x[27:21] = 0;    
        enemy_blt_speed_y[27:21] = 29;
        rst_enemy_blt[3] = 1;
        enemy_blt_lifes [23:18] = (now_enemy_lifes[23:18]!=0) ? 1:0;
        rst_enemy_blt_x[35:27] = enemy_x[35:27];
        rst_enemy_blt_y[35:27] = enemy_y[35:27];    
    end  
    else if(cnt>290 && cnt<330) begin
        enemy_blt_speed_x[27:21] = 0;    
        enemy_blt_speed_y[27:21] = 29;
        rst_enemy_blt[3] = 1;
        enemy_blt_lifes [23:18] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[35:27] = enemy_x[17:9];
        rst_enemy_blt_y[35:27] = enemy_y[17:9];    
    end 
    else if(cnt%50>10 && cnt>350) begin/////////////////////////////////////4
        enemy_blt_speed_x[27:21] = 0;    
        enemy_blt_speed_y[27:21] = 29;
        rst_enemy_blt[3] = 1;
        enemy_blt_lifes [23:18] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[35:27] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[3] = 0;
        else
            rst_enemy_blt[3] = 1;
        
        case(boss_mode)
            2'b00:rst_enemy_blt_x[35:27] = 0;                       
            2'b01:rst_enemy_blt_x[35:27] = 100;
            2'b10:rst_enemy_blt_x[35:27] = 220;
            2'b11:rst_enemy_blt_x[35:27] = me_x[8:0];
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////4
    else  begin
        enemy_blt_speed_x[27:21] = 0;    
        enemy_blt_speed_y[27:21] = 29;
        rst_enemy_blt[3] = 0;
        enemy_blt_lifes [23:18] = 0;
        rst_enemy_blt_x[35:27] = 130;
        rst_enemy_blt_y[35:27] = 0;
    end     
    
    //bullet5
    if(cnt>220 && cnt<260) begin
        enemy_blt_speed_x[34:28] = 0;    
        enemy_blt_speed_y[34:28] = 29;
        rst_enemy_blt[4] = 1;
        enemy_blt_lifes [29:24] = (now_enemy_lifes[29:24]!=0) ? 1:0;
        rst_enemy_blt_x[44:36] = enemy_x[44:36];
        rst_enemy_blt_y[44:36] = enemy_y[44:36];   
    end  
    else if(cnt>295 && cnt<330) begin
        enemy_blt_speed_x[34:28] = 0;    
        enemy_blt_speed_y[34:28] = 29;
        rst_enemy_blt[4] = 1;
        enemy_blt_lifes [29:24] = (now_enemy_lifes[17:12]!=0) ? 1:0;
        rst_enemy_blt_x[44:36] = enemy_x[26:18];
        rst_enemy_blt_y[44:36] = enemy_y[26:18];    
    end 
    else if(cnt%50>10 && cnt>350) begin/////////////////////////////////////5
        enemy_blt_speed_y[34:28] = 29;
        enemy_blt_lifes [29:24] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[44:36] = enemy_y[8:0] + 80; 
        enemy_blt_am[4] = 1;
        
        if(boss_mode==0)
            rst_enemy_blt[4] = 0;
        else
            rst_enemy_blt[4] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[44:36] = 0; 
                enemy_blt_speed_x[34:28] = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[44:36] = 100;
                enemy_blt_speed_x[34:28] = 39;
            end
            2'b10:begin
                rst_enemy_blt_x[44:36] = 220;
                enemy_blt_speed_x[34:28] = 39;
            end
            2'b11:begin
                rst_enemy_blt_x[44:36] = me_x[8:0]-20;
                enemy_blt_speed_x[34:28] = 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////5
    else  begin
        enemy_blt_speed_x[34:28] = 0;    
        enemy_blt_speed_y[34:28] = 29;
        rst_enemy_blt[4] = 0;
        enemy_blt_lifes [29:24] = 0;
        rst_enemy_blt_x[44:36] = 130;
        rst_enemy_blt_y[44:36] = 0;
    end
    
    //bullet6   
    if(cnt>295 && cnt<330) begin
        enemy_blt_speed_x[41:35] = 0;    
        enemy_blt_speed_y[41:35] = 29;
        rst_enemy_blt[5] = 1;
        enemy_blt_lifes [35:30] = (now_enemy_lifes[11:6]!=0) ? 1:0;
        rst_enemy_blt_x[53:45] = enemy_x[17:9];
        rst_enemy_blt_y[53:45] = enemy_y[17:9];    
    end
    else if(cnt%50>10 && cnt>350) begin/////////////////////////////////////6
        enemy_blt_speed_y[41:35] = 29;
        enemy_blt_lifes [35:30] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[53:45] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[5] = 0;
        else
            rst_enemy_blt[5] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[53:45] = 0; 
                enemy_blt_speed_x[41:35] = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[53:45] = 100;
                enemy_blt_speed_x[41:35]= 39;
            end
            2'b10:begin
                rst_enemy_blt_x[53:45] = 220;
                enemy_blt_speed_x[41:35]= 39;
            end
            2'b11:begin
                rst_enemy_blt_x[53:45] = me_x[8:0]-20;
                enemy_blt_speed_x[41:35]= 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////  6     
    else  begin
        enemy_blt_speed_x[41:35] = 0;    
        enemy_blt_speed_y[41:35] = 29;
        rst_enemy_blt[5] = 0;
        enemy_blt_lifes [35:30] = 0;
        rst_enemy_blt_x[53:45] = 130;
        rst_enemy_blt_y[53:45] = 0;
    end
    ///////////bullet7
    if(cnt%50>20 && cnt>350) begin/////////////////////////////////////7
        enemy_blt_speed_x[48:42] = 0;    
        enemy_blt_speed_y[48:42] = 29;
        enemy_blt_lifes [41:36] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[62:54] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[6] = 0;
        else
            rst_enemy_blt[6] = 1;
        
        case(boss_mode)
            2'b00:rst_enemy_blt_x[62:54] = 0;                       
            2'b01:rst_enemy_blt_x[62:54] = 100;
            2'b10:rst_enemy_blt_x[62:54] = 220;
            2'b11:rst_enemy_blt_x[62:54] = me_x[8:0];
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////7
    else  begin
        enemy_blt_speed_x[48:42] = 0;    
        enemy_blt_speed_y[48:42] = 29;
        rst_enemy_blt[6] = 0;
        enemy_blt_lifes [41:36] = 0;
        rst_enemy_blt_x[62:54]= 130;
        rst_enemy_blt_y[62:54] = 0;
    end     
    
    /////////bullet8    
    if(cnt%50>20 && cnt>350) begin/////////////////////////////////////8
        enemy_blt_speed_y[55:49] = 29;
        enemy_blt_lifes [47:42] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[71:63] = enemy_y[8:0] + 80; 
        enemy_blt_am[7] = 1;
        
        if(boss_mode==0)
            rst_enemy_blt[7] = 0;
        else
            rst_enemy_blt[7] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[71:63] = 0; 
                enemy_blt_speed_x[55:49] = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[71:63] = 100;
                enemy_blt_speed_x[55:49] = 39;
            end
            2'b10:begin
                rst_enemy_blt_x[71:63] = 220;
                enemy_blt_speed_x[55:49] = 39;
            end
            2'b11:begin
                rst_enemy_blt_x[71:63] = me_x[8:0]-20;
                enemy_blt_speed_x[55:49] = 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////8
    else  begin
        enemy_blt_speed_x[55:49] = 0;    
        enemy_blt_speed_y[55:49] = 29;
        rst_enemy_blt[7] = 0;
        enemy_blt_lifes [47:42] = 0;
        rst_enemy_blt_x[71:63] = 130;
        rst_enemy_blt_y[71:63] = 0;
    end
    
    //////////bullet9
    if(cnt%50>20 && cnt>350) begin/////////////////////////////////////9
        enemy_blt_speed_y[62:56] = 29;
        enemy_blt_lifes [53:48] = (now_enemy_lifes[5:0]!=0) ? 1:0;
        rst_enemy_blt_y[80:72] = enemy_y[8:0] + 80; 
        
        if(boss_mode==0)
            rst_enemy_blt[8] = 0;
        else
            rst_enemy_blt[8] = 1;
        
        case(boss_mode)
            2'b00:begin
                rst_enemy_blt_x[80:72] = 0; 
                enemy_blt_speed_x[62:56]  = 0;
            end                       
            2'b01:begin 
                rst_enemy_blt_x[80:72] = 100;
                enemy_blt_speed_x[62:56] = 39;
            end
            2'b10:begin
                rst_enemy_blt_x[80:72] = 220;
                enemy_blt_speed_x[62:56] = 39;
            end
            2'b11:begin
                rst_enemy_blt_x[80:72] = me_x[8:0]+20;
                enemy_blt_speed_x[62:56] = 0;
            end
        endcase  
    end  /////////////////////////////////////////////////////////////////////////////  9   
    else  begin
        enemy_blt_speed_x[62:56]  = 0;    
        enemy_blt_speed_y[62:56]  = 29;
        rst_enemy_blt[8] = 0;
        enemy_blt_lifes [53:48] = 0;
        rst_enemy_blt_x[80:72] = 130;
        rst_enemy_blt_y[80:72] = 0;
    end
              
    end   
         
    generate
        genvar j;
        for(j=0;j<15;j=j+1)begin : enemyblt
            obj_ctl U1 (
            . rst_lifes(enemy_blt_lifes [j*6+5:j*6]),
            . clk(clk_main),
            . rst(rst),
            . eli(eli_enemy_blt[j]),//當它posedge 後扣血或被消滅，要長於clk
            . en(1),//會不會移動
            . rst_obj(rst_enemy_blt[j]),//當它變成1之後，顯示在螢幕上並開始動 要長於speed除頻後的clk
            . rst_x(rst_enemy_blt_x[8+9*j : 9*j]),.rst_y(rst_enemy_blt_y[8+9*j : 9*j]),
            . x_am(enemy_blt_am[j]), . y_am(1),
            . x_speed(enemy_blt_speed_x[j*7+6:j*7]), .y_speed(enemy_blt_speed_y[j*7+6:j*7]),//決定位移的速度
            . vi(enemy_blt_vi[j]),//決定這個東西可不可見
            . x(enemy_blt_x[j*9+8 : j*9]), . y(enemy_blt_y[j*9+8 : j*9])
            );
        end 
    endgenerate    
    assign is_complete = (cnt>360 && now_enemy_lifes[5:0]==0) ? 1:0;
endmodule
