`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/16 13:55:16
// Design Name: 
// Module Name: score
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


module score(
input rst,
input clk_main,
input rst_score,
input [12:0]eli_me_blt, //是1的話就加 是0的話就減
input [9:0]eli_enemy,
output reg [15:0]score
);

    reg [12:0]eli_me_blt_tmp;
    wire [12:0]tmp2;
    generate
    genvar i;
    for(i=0;i<13;i=i+1)begin : me_blt
        always@(posedge clk_main or posedge rst)
        if(rst)
            eli_me_blt_tmp[i]=0;
        else
            eli_me_blt_tmp[i]=eli_me_blt[i];
            
        assign tmp2[i] = ({eli_me_blt[i],eli_me_blt_tmp[i]}==2'b10)? 1:0;
    end 
endgenerate

    reg [9:0]eli_enemy_tmp;
    wire [9:0]tmp1;
    generate
    genvar j;
    for(j=0;j<10;j=j+1)begin : eliene
        always@(posedge clk_main or posedge rst)
        if(rst)
            eli_enemy_tmp[j]=0;
        else
            eli_enemy_tmp[j]=eli_enemy[j];
        
        assign tmp1[j] = ({eli_enemy[j],eli_enemy_tmp[j]}==2'b10)? 1:0;
    end 
endgenerate

reg [15:0]score_tmp;
    always@(posedge clk_main or posedge rst)
        if(rst | rst_score)
            score=0;
        else
            score=score_tmp;
wire blt;
wire enemy;
or_all O1(.in(tmp1),.out(blt));
or_all O2(.in(tmp2),.out(enemy));

always@*
    if(blt==1 && enemy==0)
    score_tmp = score + 10;
    else if(blt==0 && enemy==1)
        score_tmp = score + 100;
    else if(blt==1 && enemy==1)
        score_tmp = score + 110;
    else
        score_tmp = score;
        
    ssd_ctl C0 (.f_cst(f_cst),.rst(rst),.dsp0(score-(score%1000)),.dsp1(dsp1),.dsp2(dsp2),.dsp3(dsp3),
                    .BCD(BCD_dsp),.BCD_c(bit_dsp));    
endmodule
