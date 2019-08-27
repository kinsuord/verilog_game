`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/13 15:50:34
// Design Name: 
// Module Name: random7_num_gen
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


module random_num_gen(
    input clk,
    input in,//每個posedge時
    output reg [1:0]f//隨機產生0到2的數
    );
    //counter
    reg [7:0]cnt = 8'b11111111;
    wire [7:0]cnt_tmp;
    //assign cnt_tmp = cnt+1;
    assign cnt_tmp[0] = cnt[7]^cnt[6];
    assign cnt_tmp[7:1] = cnt[6:0];
    always@(posedge clk)
        cnt<=cnt_tmp;
    /*
    reg [7:0]cnt,cnt_tmp;
    always@* begin
        cnt_tmp[0] = cnt[7]^cnt[6]^cnt[1] ;
        cnt_tmp[7:1] = cnt[6:0];
    end
    
    always@(posedge clk) begin
        cnt[0] <= cnt[7]^cnt[6] ;
        cnt[7:1] <= {cnt[6:0]}; 
    end
    */
    /*
    reg [9:0]Q;
        always @(posedge clk) begin
            Q[9] <= Q[8];
            Q[8] <= Q[7];
            Q[7] <= Q[6];
            Q[6] <= Q[5];
            Q[5] <= Q[4];
            Q[4] <= Q[3];
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= ((Q[2]^Q[5])^Q[7]);
         end
        */
    always@(posedge in)begin
        f <= cnt % 3;
    end
        
endmodule
