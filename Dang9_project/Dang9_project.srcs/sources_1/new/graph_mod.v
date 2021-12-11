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


// cue size
parameter CUE_X_SIZE = 72;
parameter CUE_Y_SIZE = 16;

// rgb flag
wire white_ball_on;
wire red_ball_on;
wire table_rgb;
wire collision_on;

wire [2:0] ball_rgb;

wire [9:0] x1; // white_ball_center_x
wire [9:0] y1; // white_ball_center_y
wire [9:0] x2; // red_ball_center_x
wire [9:0] y2; // red_ball_center_y

//white_ball white_ball_inst (clk, rst, x, y, key, key_pulse, x1, y1, white_ball_on);
//red_ball   red_ball_inst   (clk, rst, x, y, x2, y2, red_ball_on);
table_mod  table_inst      (clk, rst, x, y, table_rgb);

ball white_ball (clk, rst, x, y, ball_rgb);


//collision collision_inst (clk, rst, x1, y1, x2, y2, collision_on);


// 최종 출력
assign rgb = (ball_rgb[0] == 1)    ? `WHITE : 
             (ball_rgb[1] == 1)    ? `RED : 
             (ball_rgb[2] == 1)    ? `GREEN : 
             (table_rgb == 1)      ? `WHITE : 
             (collision_on == 1)  ? `GREEN : `BLACK;
             
endmodule