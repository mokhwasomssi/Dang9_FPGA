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

// rgb flag
wire table_rgb;
wire [2:0] ball_rgb;

// 인스턴시
table_mod  table_inst  (clk, rst, x, y, table_rgb);
ball       ball_inst   (clk, rst, x, y, key, key_pulse, ball_rgb);

// 최종 출력
assign rgb = (ball_rgb[0] == 1)    ? `WHITE : 
             (ball_rgb[1] == 1)    ? `RED : 
             (ball_rgb[2] == 1)    ? `GREEN : 
             (table_rgb == 1)      ? `WHITE : `BLACK;         

endmodule