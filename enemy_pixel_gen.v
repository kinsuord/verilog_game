`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/04 15:12:26
// Design Name: 
// Module Name: enemy_pixel_gen
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

module enemy_pixel_gen(
    input clk_25MHz,
    input [89:0]enemy_x,input [89:0]enemy_y,//8
    input [9:0]enemy_vi,
    input [29:0]enemy_type,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [8:0]enemy_pixel
    );
    reg [149:0]tmp1,tmp2,tmp3 ;
    generate
        genvar i;
        for(i=0;i<10;i=i+1)begin : addr
            always@*
                if(enemy_type[i*3+2:i*3]==0 &&
                    h_cnt >= enemy_x[i*9 + 8:i*9] + 160 && h_cnt < enemy_x[i*9+8 : i*9]+ 160 + 40 && 
                    v_cnt >= enemy_y[i*9+8 : i*9] && v_cnt < enemy_y[i*9+8 : i*9] + 35 )
                    if(enemy_vi[i]==1)
                        tmp1[i*15+14 : i*15] = (v_cnt - enemy_y[i*9 + 8:i*9] )* 120 + h_cnt - enemy_x[i*9 + 8:i*9] -160 ;
                    else
                        tmp1[i*15+14 : i*15] = 0;                               
                else
                    tmp1[i*15+14 : i*15] = 0;

            always@*
                if(enemy_type[i*3+2:i*3]==1 &&
                    h_cnt >= enemy_x[i*9 + 8:i*9] + 160 && h_cnt < enemy_x[i*9+8 : i*9]+ 160 + 40 && 
                    v_cnt >= enemy_y[i*9+8 : i*9] && v_cnt < enemy_y[i*9+8 : i*9] + 40 )
                    if(enemy_vi[i]==1)
                        tmp2[i*15+14 : i*15] = (v_cnt - enemy_y[i*9 + 8:i*9] )* 120 + h_cnt - enemy_x[i*9 + 8:i*9] -160 ;
                    else
                        tmp2[i*15+14 : i*15] = 0;                               
                else
                    tmp2[i*15+14 : i*15] = 0;

            always@*
                if(enemy_type[i*3+2:i*3]==2 &&
                    h_cnt >= enemy_x[i*9 + 8:i*9] + 160 && h_cnt < enemy_x[i*9+8 : i*9]+ 160 + 200 && 
                    v_cnt >= enemy_y[i*9+8 : i*9] && v_cnt < enemy_y[i*9+8 : i*9] + 110 )
                    if(enemy_vi[i]==1)
                        tmp3[i*15+14 : i*15] = (v_cnt - enemy_y[i*9 + 8:i*9] )* 200 + h_cnt - enemy_x[i*9 + 8:i*9] -160 ;
                    else
                        tmp3[i*15+14 : i*15] = 0;                               
                else
                    tmp3[i*15+14 : i*15] = 0;
            
            /*        
            else 
                if(h_cnt >= enemy_x[i*9 + 8:i*9] + 160 && h_cnt < enemy_x[i*9+8 : i*9]+ 160 + 40 && 
                    v_cnt >= enemy_y[i*9+8 : i*9] && v_cnt < enemy_y[i*9+8 : i*9] + 40 )
                    if(enemy_vi[i]==1)
                        tmp[i*15+14 : i*15] = (v_cnt - enemy_y[i*9 + 8:i*9] )* 120 + h_cnt - enemy_x[i*9 + 8:i*9] -160 ;
                    else
                        tmp[i*15+14 : i*15] = 0;                               
                else
                    tmp[i*15+14 : i*15] = 0;
                */
        end
    endgenerate
        
    wire [8:0]data;
    wire [8:0]enemy1_pixel,enemy2_pixel,enemy3_pixel;
    wire [14:0]enemy1_addr,enemy2_addr,enemy3_addr; 
    assign enemy1_addr[14:0] = tmp1[149-:15] | tmp1[14-:15] | tmp1[29-:15] | tmp1[44-:15] | tmp1[59-:15] | tmp1[74-:15] | tmp1[89-:15] | tmp1[104-:15] | tmp1[119-:15] | tmp1[134-:15]; 
    assign enemy2_addr[14:0] = tmp2[149-:15] | tmp2[14-:15] | tmp2[29-:15] | tmp2[44-:15] | tmp2[59-:15] | tmp2[74-:15] | tmp2[89-:15] | tmp2[104-:15] | tmp2[119-:15] | tmp2[134-:15]; 
    assign enemy3_addr[14:0] = tmp3[149-:15] | tmp3[14-:15] | tmp3[29-:15] | tmp3[44-:15] | tmp3[59-:15] | tmp3[74-:15] | tmp3[89-:15] | tmp3[104-:15] | tmp3[119-:15] | tmp3[134-:15]; 
    
    blk_mem_gen_enemy1 blk_mem_gen_enemy1_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(enemy1_addr[12:0]),
      .dina(data[8:0]),
      .douta(enemy1_pixel)
    ); 

    blk_mem_gen_enemy2 blk_mem_gen_enemy2_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(enemy2_addr[12:0]),
      .dina(data[8:0]),
      .douta(enemy2_pixel)
    ); 
    blk_mem_gen_enemy3 blk_mem_gen_enemy3_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(enemy3_addr[14:0]),
      .dina(data[8:0]),
      .douta(enemy3_pixel)
    );         
    assign enemy_pixel = enemy1_pixel | enemy2_pixel | enemy3_pixel;
    
    
    
endmodule
