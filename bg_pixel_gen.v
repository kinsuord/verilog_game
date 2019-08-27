`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/16 01:24:54
// Design Name: 
// Module Name: bg_pixel_gen
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


module bg_pixel_gen(
    input rst,
    input clk_25MHz,
    input clk_22,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [8:0]bg_pixel
    );
    
    wire [8:0]data;
    reg [9:0]cnt,cnt_tmp;
    always@*
    if(cnt==0)
        cnt_tmp=557;
    else
        cnt_tmp = cnt-1;
    
    always@(posedge clk_22 or posedge rst)
    if(rst)
        cnt <= 557;
    else
        cnt <= cnt_tmp;
        
    wire [16:0]addr;
    assign addr = (h_cnt>=160 && h_cnt<480) ? (((h_cnt-160)>>1)+160*(v_cnt>>1)+ cnt*160 )% 89280 : 0;
    
    blk_mem_gen_background blk_mem_gen_background_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(addr),
      .dina(data[8:0]),
      .douta(bg_pixel)
    );     
    
    
endmodule
