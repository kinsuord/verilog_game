/*
320*480
�e160
�԰���40*
*/
//////////////positon 9bits
`define CLK_MAIN_FREQ 4999//10000HZ
`define AX 320//�e���j�p
`define AY 480
//
`define MEM_W 200//�O����Ϥ����e��
`define MEM_H 558

//�x�s�������O����}�l��m
`define ME_MEM_W 160
`define ME_MEM_H 0
`define ME_W 40//�Ծ����e��
`define ME_H 55
/////��q6bits
//�̦h��20���l�u
//�̦h��10�ӼĤH
//�̦h��8�ؤ��P�ĤH���A
//�̦h��4�ؤl�u
//�l�u 15*15
//enemy1 40*35 ��3�� �e ���e �k�e
//enemy2 40*40 ��3�� �e ���e �k�e
//enemy3 200*110 boss
//heart 35*24
//////game over 280* 34 14bit
//////success 214*35
///////ready    260*62 14bit

`define ME_BLT_GEN_SPEED 599//�j���e���W�|��12.�h�Ӥl�u

////////counter speed 8bits 
`define BLT_MOVE_SPEED 14 //60*clk_main �l�u����t�סA�j��1.5��]�������e���A�|�v�T��blt�j�p
`define ME_MOVE_SPEED 49 //100* clk_main = 100pixel/sec
//keyboard
`define KEY_D {1'b0 , 8'h73}
`define KEY_U {1'b0 , 8'h75}
`define KEY_L {1'b0 , 8'h6B}
`define KEY_R {1'b0 , 8'h74}
`define KEY_SPACE {1'b0 , 8'h72}
