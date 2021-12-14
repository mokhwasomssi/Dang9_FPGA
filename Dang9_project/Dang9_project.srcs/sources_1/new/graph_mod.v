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
wire [9:0] ball_rgb;

// ?��????
table_mod  table_inst  (clk, rst, x, y, table_rgb);
ball       ball_inst   (clk, rst, x, y, key, key_pulse, ball_rgb);

// ???? ????
assign rgb = (ball_rgb[0] == 1)    ? `WHITE :
             (ball_rgb[1] == 1)    ? `WHITE :
             (ball_rgb[2] == 1)    ? `WHITE : 
             (ball_rgb[3] == 1)    ? `RED : 
             (ball_rgb[4] == 1)    ? `GREEN : 
             (ball_rgb[5] == 1)    ? `BLACK :
             (ball_rgb[6] == 1)    ? `BLACK :
             (ball_rgb[7] == 1)    ? `BLACK :
             (ball_rgb[8] == 1)    ? `BLACK :
             (ball_rgb[9] == 1)    ? `YELLOW :
             (table_rgb == 1)      ? `WHITE : `BLACK; 
endmodule