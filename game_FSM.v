`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/08 14:49:35
// Design Name: 
// Module Name: game_FSM
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
`define GAME_READY 3'b000
`define GAME_START 3'b001
`define GAME_OVER 3'b010
`define GAME_COMPLETE 3'b011
`define GAME_PAUSE 3'b100

module game_FSM(
    input clk_main,
    input rst,
    input is_gameover,
    input is_complete,
    input [511:0]key_down,
    input [8:0]last_change,
    output reg me_en,
    output reg enemy_en,
    output reg [1:0]show_text//00->show nothing 
                        //01->show"push any butn to start"
                        //10->show gameover
                        //11->show  success
    );
    
    reg is_gameover_tmp,is_complete_tmp,key_down_tmp;
    always@(posedge clk_main or posedge rst)
    if(rst)begin
        is_gameover_tmp <= 0;
        is_complete_tmp <= 0;
        key_down_tmp <= 0;
    end
    else begin
        is_gameover_tmp <= is_gameover;
        is_complete_tmp <= is_complete;
        key_down_tmp <= key_down[last_change];    
    end
    
    reg [2:0]stat,next_stat;
    always@(posedge clk_main or posedge rst)
    if(rst)
        stat<=0;
    else
        stat<=next_stat;
        
    always@*
    case(stat)
    `GAME_READY:
        if({key_down[last_change],key_down_tmp}==2'b10)
            next_stat = `GAME_START;
        else
            next_stat = `GAME_READY;
        
    `GAME_START:    
        if({is_gameover,is_gameover_tmp}==2'b10)
            next_stat = `GAME_OVER;
        else if({is_complete,is_complete_tmp}==2'b10)
            next_stat = `GAME_COMPLETE;
        else
            next_stat = `GAME_START;

    `GAME_OVER:
        if({key_down[last_change],key_down_tmp}==2'b10)
            next_stat = `GAME_READY;
        else
            next_stat = `GAME_OVER;
            
    `GAME_COMPLETE:
        if({key_down[last_change],key_down_tmp}==2'b10)
            next_stat = `GAME_READY;
        else
            next_stat = `GAME_COMPLETE;
    default:next_stat= `GAME_READY;
    endcase
    
    /////output
    always@*
    if(stat==`GAME_START)
        me_en = 1;
    else
        me_en = 0;
        
    always@*
    if(stat==`GAME_START || stat==`GAME_OVER)
        enemy_en = 1;
    else
        enemy_en = 0;   
        
    always@*
    case(stat)
    `GAME_READY: show_text = 2'b01; 
    `GAME_OVER: show_text = 2'b10;
    `GAME_COMPLETE: show_text = 2'b11;
    default: show_text = 2'b00;  
    endcase
    
endmodule
