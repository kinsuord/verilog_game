/*
320*480
寬160
戰鬥機40*
*/
//////////////positon 9bits
`define CLK_MAIN_FREQ 4999//10000HZ
`define AX 320//畫面大小
`define AY 480
//
`define MEM_W 200//記憶體圖片的寬度
`define MEM_H 558

//儲存飛機的記憶體開始位置
`define ME_MEM_W 160
`define ME_MEM_H 0
`define ME_W 40//戰機的寬高
`define ME_H 55
/////血量6bits
//最多有20顆子彈
//最多有10個敵人
//最多有8種不同敵人型態
//最多有4種子彈
//子彈 15*15
//enemy1 40*35 有3個 前 左前 右前
//enemy2 40*40 有3個 前 左前 右前
//enemy3 200*110 boss
//heart 35*24
//////game over 280* 34 14bit
//////success 214*35
///////ready    260*62 14bit

`define ME_BLT_GEN_SPEED 599//大約畫面上會有12.多個子彈

////////counter speed 8bits 
`define BLT_MOVE_SPEED 14 //60*clk_main 子彈飛行速度，大約1.5秒跑完全部畫面，會影響到blt大小
`define ME_MOVE_SPEED 49 //100* clk_main = 100pixel/sec
//keyboard
`define KEY_D {1'b0 , 8'h73}
`define KEY_U {1'b0 , 8'h75}
`define KEY_L {1'b0 , 8'h6B}
`define KEY_R {1'b0 , 8'h74}
`define KEY_SPACE {1'b0 , 8'h72}
