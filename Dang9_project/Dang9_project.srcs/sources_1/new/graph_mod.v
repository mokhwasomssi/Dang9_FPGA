`include "defines.v"

module graph_mod (
    input clk, 
    input rst, 
    
    input [9:0] x, 
    input [9:0] y, 
    
    input [4:0] key, 
    input [4:0] key_pulse, 
    
    output [2:0] rgb
    );

// RGB 플래그
wire [1:0] ball_rgb;
wire [1:0] cue_rgb;
wire [3:0] hole_rgb;
wire       table_rgb;
wire       font;

// 인스턴시
ball       ball_inst   (clk, rst, x, y, key, key_pulse, ball_rgb, cue_rgb, font);
table_mod  table_inst  (clk, rst, x, y, table_rgb);
hole       hole_inst   (clk, rst, x, y, hole_rgb);

// 최종 출력
assign rgb = (font == 1)           ? `WHITE   : // 게임 종료 시 폰트 생성
             (ball_rgb[0] == 1)    ? `YELLOW  : // 공A
             (ball_rgb[1] == 1)    ? `RED    : // 공B
             //(ball_rgb[2] == 1)    ? `GREEN  : // 충돌

             (cue_rgb[0] == 1)     ? `YELLOW : // 공A 큐
             (cue_rgb[1] == 1)     ? `RED  : // 공B 큐

             (hole_rgb[0] == 1)    ? `BLACK  : // 홀A
             (hole_rgb[1] == 1)    ? `BLACK  : // 홀B
             (hole_rgb[2] == 1)    ? `BLACK  : // 홀C
             (hole_rgb[3] == 1)    ? `BLACK  : // 홀D

             (table_rgb == 1)      ? `WHITE  : // 테이블
                                     `BLACK; 
endmodule