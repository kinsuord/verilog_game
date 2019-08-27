`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/13 16:07:16
// Design Name: 
// Module Name: ssd_ctl
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
// define segment codes
`define SS_0 8'b00000011
`define SS_1 8'b10011111
`define SS_2 8'b00100101
`define SS_3 8'b00001101
`define SS_4 8'b10011001
`define SS_5 8'b01001001
`define SS_6 8'b01000001
`define SS_7 8'b00011111
`define SS_8 8'b00000001
`define SS_9 8'b00001001
`define SS_A 8'b00010001
`define SS_P 8'b00110001
`define SS_F 8'b01110001

module ssd_ctl(
    input [3:0]dsp0,
    input [3:0]dsp1,
    input [3:0]dsp2,
    input [3:0]dsp3,
    input f_cst,
    output reg [7:0]BCD,
    output reg [3:0]BCD_c,
    input rst
    );
//counter
    reg [19:0] cnt,cnt_tmp;
    //+1
    always @(cnt)
        cnt_tmp <= cnt+1;       
    // Flip flops
    always @(posedge f_cst or posedge rst)
        if (rst) cnt <= 20'b0;
        else cnt <= cnt_tmp;
        
    wire [1:0]ssd_en;
    assign ssd_en = {cnt[19],cnt[18]};
    
    reg [3:0]BCD_tmp;
        
    always @(BCD_tmp)
        if(ssd_en==2'b10)case (BCD_tmp)
                4'd0: BCD = 8'b00000010;
                4'd1: BCD = 8'b10011110;
                4'd2: BCD = 8'b00100100;
                4'd3: BCD = 8'b00001100;
                4'd4: BCD = 8'b10011000;
                4'd5: BCD = 8'b01001000;
                4'd6: BCD = 8'b01000000;
                4'd7: BCD = 8'b00011110;
                4'd8: BCD = 8'b00000000;
                4'd9: BCD = 8'b00001000;
                4'd11:BCD = 8'b00010000;
                4'd10:BCD = 8'b00110000;
                default: BCD = 8'b01110000;
            endcase
        else
        case (BCD_tmp)
            4'd0: BCD = `SS_0;
            4'd1: BCD = `SS_1;
            4'd2: BCD = `SS_2;
            4'd3: BCD = `SS_3;
            4'd4: BCD = `SS_4;
            4'd5: BCD = `SS_5;
            4'd6: BCD = `SS_6;
            4'd7: BCD = `SS_7;
            4'd8: BCD = `SS_8;
            4'd9: BCD = `SS_9;
            4'd11: BCD = `SS_A;
            4'd10: BCD = `SS_P;
            default: BCD = `SS_F;
        endcase
        
        
    always @*
    case(ssd_en)
         2'b00: BCD_tmp = dsp0;
         2'b01: BCD_tmp = dsp1;
         2'b10: BCD_tmp = dsp2;
         2'b11: BCD_tmp = dsp3;
         default: BCD_tmp = 4'b0000;
    endcase
    
    always @*
    case(ssd_en)
         2'b00: BCD_c = 4'b1110;
         2'b01: BCD_c = 4'b1101;
         2'b10: BCD_c = 4'b1011;
         2'b11: BCD_c = 4'b0111;
         default: BCD_c = 4'b1111;
    endcase
    
    

endmodule
