`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/04/09 23:24:25
// Design Name: 
// Module Name: counter
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


module counter(
    input rst,
    input clk,
    input a_or_m, //是1的話就加 是0的話就減
    input en,// 如果是1的話每clk加或減一次
    input rst_counter,//只當posedge後rst  ，訊號要大於一個clk  
    input [8:0]rst_value,//如果rst的話設成這個值
    input [8:0]max,//count的最大值
    input [8:0]min,//count的最小值
    output reg [8:0]cnt
    );
 
    reg[1:0]rst_in;
    reg [8:0]cnt_tmp;    
    always @*
        if(rst_in==2'b10)
            cnt_tmp = rst_value;
        else if(en==0)
            cnt_tmp = cnt;
        else if(a_or_m)
            if(cnt == max)
                cnt_tmp = cnt; 
            else
                cnt_tmp = cnt + 1; 
        else
            if(cnt == min)
                cnt_tmp = cnt; 
            else
                cnt_tmp = cnt - 1; 
    
                       
    //flip-flop
    
    always @(posedge clk or posedge rst )
        if (rst) begin
              cnt <= rst_value;
        end
        else cnt <= cnt_tmp;
        
    //in
    reg tmp;
    always@(posedge clk)begin
        tmp<=rst_counter;
        rst_in[0]<=tmp;
    end
    always@*
        rst_in[1]=rst_counter;
        
    endmodule
       
