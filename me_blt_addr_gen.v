`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/31 00:27:18
// Design Name: 
// Module Name: me_blt_addr_gen
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
module me_blt_addr_gen(
    input [12:0] me_blt_vi,
    input [116:0] me_blt_x,
    input [116:0] me_blt_y,    
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [16:0]me_blt_addr
    );
    
    reg [220:0]tmp;
    generate
        genvar i;
        for(i=0;i<13;i=i+1)begin : addr
            always@*
                if(h_cnt >= me_blt_x[i*9 + 8:i*9] + 160 && h_cnt < me_blt_x[i*9+8 : i*9]+ 160 + 15 && 
                    v_cnt >= me_blt_y[i*9+8 : i*9] && v_cnt < me_blt_y[i*9+8 : i*9] + 15 )
                    if(me_blt_vi[i]==1)
                        tmp[i*17+16 : i*17] = (v_cnt - me_blt_y[i*9 + 8:i*9] )* 30 + h_cnt - me_blt_x[i*9 + 8:i*9] -160 ;
                    else
                        tmp[i*17+16 : i*17] = 0;                               
                else
                    tmp[i*17+16 : i*17] = 0;
        end
    endgenerate
    assign me_blt_addr = tmp[220-:17] | tmp[16-:17] | tmp[33-:17]| tmp[50-:17]| tmp[67-:17]| tmp[84-:17]| tmp[101-:17]| tmp[118-:17]| tmp[135-:17]| tmp[152-:17]| tmp[169-:17]| tmp[186-:17]| tmp[203-:17] ;

    /*
    always@*
    if( (h_cnt >= me_blt_x[8:0] + 160 && h_cnt < me_blt_x[8:0]+ 160 + 15 && 
        v_cnt >= me_blt_y[8:0] && v_cnt < me_blt_y[8:0] + 15 ) 
        || (h_cnt >= me_blt_x[17:9] + 160 && h_cnt < me_blt_x[17:9]+ 160 + 15 && 
        v_cnt >= me_blt_y[17:9] && v_cnt < me_blt_y[17:9] + 15 ) 
        || (h_cnt >= me_blt_x[26:18] + 160 && h_cnt < me_blt_x[26:18]+ 160 + 15 && 
        v_cnt >= me_blt_y[26:18] && v_cnt < me_blt_y[26:18] + 15 ) 
        || (h_cnt >= me_blt_x[35:27] + 160 && h_cnt < me_blt_x[35:27]+ 160 + 15 && 
        v_cnt >= me_blt_y[35:27] && v_cnt < me_blt_y[35:27] + 15 ) 
        || (h_cnt >= me_blt_x[44:36] + 160 && h_cnt < me_blt_x[44:36]+ 160 + 15 && 
        v_cnt >= me_blt_y[44:36] && v_cnt < me_blt_y[44:36] + 15 ) 
        || (h_cnt >= me_blt_x[53:45] + 160 && h_cnt < me_blt_x[53:45]+ 160 + 15 && 
        v_cnt >= me_blt_y[53:45] && v_cnt < me_blt_y[53:45] + 15 ) 
        || (h_cnt >= me_blt_x[62:54] + 160 && h_cnt < me_blt_x[62:54]+ 160 + 15 && 
        v_cnt >= me_blt_y[62:54] && v_cnt < me_blt_y[62:54] + 15 ) 
        || (h_cnt >= me_blt_x[71:63] + 160 && h_cnt < me_blt_x[71:63]+ 160 + 15 && 
        v_cnt >= me_blt_y[71:63] && v_cnt < me_blt_y[71:63] + 15 ) 
        || (h_cnt >= me_blt_x[80:72] + 160 && h_cnt < me_blt_x[80:72]+ 160 + 15 && 
        v_cnt >= me_blt_y[80:72] && v_cnt < me_blt_y[80:72] + 15 ) 
        || (h_cnt >= me_blt_x[89:81] + 160 && h_cnt < me_blt_x[89:81]+ 160 + 15 && 
        v_cnt >= me_blt_y[89:81] && v_cnt < me_blt_y[89:81] + 15 ) 
        || (h_cnt >= me_blt_x[98:90] + 160 && h_cnt < me_blt_x[98:90]+ 160 + 15 && 
        v_cnt >= me_blt_y[98:90] && v_cnt < me_blt_y[98:90] + 15 ) 
        || (h_cnt >= me_blt_x[107:99] + 160 && h_cnt < me_blt_x[107:99]+ 160 + 15 && 
        v_cnt >= me_blt_y[107:99] && v_cnt < me_blt_y[107:99] + 15 ) 
        || (h_cnt >= me_blt_x[116:108] + 160 && h_cnt < me_blt_x[116:108]+ 160 + 15 && 
        v_cnt >= me_blt_y[116:108] && v_cnt < me_blt_y[116:108] + 15 ) 
    )
        me_blt_addr = (v_cnt-(`AY - `ME_H))*`MEM_W + h_cnt - 160 + `ME_MEM_W;
    else    
        me_blt_addr = 0;*/
    
endmodule
