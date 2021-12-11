// define
`define WHITE 3'b111
`define BLACK 3'b000
`define RED   3'b100
`define GREEN 3'b100
`define BLUE  3'b001

`define MAX_X 640
`define MAX_Y 480

`define TABLE_OUT_L 20
`define TABLE_OUT_R 620
`define TABLE_OUT_T 20
`define TABLE_OUT_B 460

`define TABLE_IN_L 40
`define TABLE_IN_R 600
`define TABLE_IN_T 40
`define TABLE_IN_B 440

`define BALL_SIZE 12

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

// hit force
parameter MAX_HIT_FORCE = 20;

// rgb flag
wire white_ball_on;
wire red_ball_on;
wire table_on;

wire [9:0] wbc_x; // white_ball_center_x
wire [9:0] wbc_y; // white_ball_center_y
wire [9:0] rbc_x; // red_ball_center_x
wire [9:0] rbc_y; // red_ball_center_y

white_ball white_ball_inst (clk, rst, x, y, key, key_pulse, wbc_x, wbc_y, white_ball_on);
red_ball   red_ball_inst   (clk, rst, x, y, rbc_x, rbc_y, red_ball_on);
table_mod  table_inst      (clk, rst, x, y, table_on);

wire collision_on;

collision_dectect collision_dectect_inst (wbc_x, wbc_y, rbc_x, rbc_y, collision_on);

//���� ���
//test
assign rgb = (white_ball_on == 1) ? `WHITE : 
             (red_ball_on == 1)   ? `RED : 
             (table_on == 1)      ? `WHITE : 
             (collision_on == 1)  ? `GREEN : `BLACK;
             
endmodule