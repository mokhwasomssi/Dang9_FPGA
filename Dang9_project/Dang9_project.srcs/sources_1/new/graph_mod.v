module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [2:0] rgb; 

// 화면 크기 설정
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

parameter TABLE_OUT_L = 20;
parameter TABLE_OUT_R = 620;
parameter TABLE_OUT_T = 20;
parameter TABLE_OUT_B = 460;

parameter TABLE_IN_L = 40;
parameter TABLE_IN_R = 600;
parameter TABLE_IN_T = 40;
parameter TABLE_IN_B = 440;

wire table_out_on, table_in_on;
assign table_out_on = (x >= TABLE_OUT_L && x <= TABLE_OUT_R - 1 && y >= TABLE_OUT_T && y <= TABLE_OUT_B - 1);
assign table_in_on = (x >= TABLE_IN_L && x <= TABLE_IN_R - 1 && y >= TABLE_IN_T && y <= TABLE_IN_B - 1);

wire refr_tick; 
assign refr_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

assign rgb = (table_out_on == 1 && table_in_on == 0) ? 3'b111 :
             (table_out_on == 1 && table_in_on == 1) ? 3'b000 : 3'b000;
endmodule