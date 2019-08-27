`include "config.h"
module me_addr_gen(
   input me_vi,
   input [2:0]me_lifes,
   input [8:0]me_x,
   input [8:0]me_y,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output reg [11:0]pixel_addr
   );
    
    always@*
    if(h_cnt >= me_x + 160 && h_cnt < me_x+ 160 + `ME_W && v_cnt >= me_y && v_cnt < me_y + `ME_H && me_vi==1)
        pixel_addr = (v_cnt-me_y)* `ME_W + h_cnt - me_x -160 ;
    /*
    else if(h_cnt >= 160 && h_cnt < 160 + `ME_W && v_cnt >= `AY-`ME_H && v_cnt < `AY )//顯示生命
        if(me_lifes>1)
            pixel_addr= (v_cnt-(`AY - `ME_H))*`ME_W + h_cnt - 160 ;
        else
            pixel_addr= 0;
    else if(h_cnt >= 160 + `ME_W && h_cnt < 160 + `ME_W*2 && v_cnt >= `AY-`ME_H && v_cnt < `AY )
        if(me_lifes>2)
            pixel_addr= (v_cnt-(`AY - `ME_H))*`ME_W + h_cnt - 160 - `ME_W ;
        else
            pixel_addr= 0;
            */
    else
        pixel_addr= 0;
    
endmodule
