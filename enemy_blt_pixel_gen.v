`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/12 14:17:40
// Design Name: 
// Module Name: enemy_blt_pixel_gen
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

module enemy_blt_pixel_gen(
    input clk_25MHz,
    input [134:0]enemy_blt_x,input[134:0]enemy_blt_y,
    input [14:0]enemy_blt_vi,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [8:0]enemy_blt_pixel    
    );
    reg [224:0]tmp1;
    generate
        genvar i;
        for(i=0;i<15;i=i+1)begin : addr
            always@*
                if(
                    h_cnt >= enemy_blt_x[i*9 + 8:i*9] + 160 && h_cnt < enemy_blt_x[i*9+8 : i*9]+ 160 + 15 && 
                    v_cnt >= enemy_blt_y[i*9+8 : i*9] && v_cnt < enemy_blt_y[i*9+8 : i*9] + 15 )
                    if(enemy_blt_vi[i]==1)
                        tmp1[i*15+14 : i*15] = (v_cnt - enemy_blt_y[i*9 + 8:i*9] )* 30 + h_cnt - enemy_blt_x[i*9 + 8:i*9] -160 +15;
                    else
                        tmp1[i*15+14 : i*15] = 0;                               
                else
                    tmp1[i*15+14 : i*15] = 0;

        end
    endgenerate  
    
    wire [8:0]data;
    wire [8:0]enemy_blt1_pixel;
    wire [14:0]enemy_blt1_addr; 
    assign enemy_blt1_addr[14:0] = tmp1[149-:15] | tmp1[14-:15] | tmp1[29-:15] | tmp1[44-:15] | tmp1[59-:15] |
        tmp1[74-:15] | tmp1[89-:15] | tmp1[104-:15] | tmp1[119-:15] | tmp1[134-:15]
         | tmp1[164-:15] | tmp1[179-:15] | tmp1[194-:15] | tmp1[209-:15] | tmp1[224-:15]; 
         
    blk_mem_gen_1 blk_mem_gen_enemy1_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(enemy_blt1_addr[12:0]),
           .dina(data[8:0]),
           .douta(enemy_blt1_pixel)
         );      
         
     assign enemy_blt_pixel = enemy_blt1_pixel;
      
endmodule
