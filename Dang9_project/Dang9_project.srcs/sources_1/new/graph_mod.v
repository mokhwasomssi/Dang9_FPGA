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

// cue size
parameter CUE_X_SIZE = 72;
parameter CUE_Y_SIZE = 16;

// ball size
parameter BALL_SIZE = 12;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; 


// table rgb flag
wire table_out_on, table_in_on;

assign table_out_on = (x >= TABLE_OUT_L && x <= TABLE_OUT_R - 1 && y >= TABLE_OUT_T && y <= TABLE_OUT_B - 1);
assign table_in_on = (x >= TABLE_IN_L && x <= TABLE_IN_R - 1 && y >= TABLE_IN_T && y <= TABLE_IN_B - 1);


// 테이블-공 충돌 플래그
wire ball1_reach_top, ball1_reach_bottom, ball1_reach_left, ball1_reach_right;

assign ball1_reach_top = (TABLE_IN_T >= (ball1_center_y - BALL_SIZE)) ? 1 : 0;
assign ball1_reach_bottom = (TABLE_IN_B <= (ball1_center_y + BALL_SIZE)) ? 1 : 0;
assign ball1_reach_left = (TABLE_IN_L >= (ball1_center_x - BALL_SIZE)) ? 1 : 0;
assign ball1_reach_right = (TABLE_IN_R <= (ball1_center_x + BALL_SIZE)) ? 1 : 0;


// 테이블-공 충돌 시 방향 업데이트
reg [9:0] ball1_vx_reg;
reg [9:0] ball1_vy_reg;
reg [4:0] ball1_vx = 4;
reg [4:0] ball1_vy = 4;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball1_vx_reg <= ball1_vx;
        ball1_vy_reg <= ball1_vy;
    end
    else begin
        if(ball1_reach_top) begin
            ball1_vy_reg <= ball1_vy;
        end
        else if (ball1_reach_bottom) begin
            ball1_vy_reg <= -1*ball1_vy;
        end
        else if (ball1_reach_left) begin
            ball1_vx_reg <= ball1_vx;
        end
        else if (ball1_reach_right) begin 
            ball1_vx_reg <= -1*ball1_vx;
        end
    end
end

// 중심 좌표 업데이트
reg [9:0] ball1_center_x;
reg [9:0] ball1_center_y;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball1_center_x <= 300;
        ball1_center_y <= 200;
    end
    else if(refr_tick) begin
        ball1_center_x <= ball1_center_x + ball1_vx_reg;
        ball1_center_y <= ball1_center_y + ball1_vy_reg;
    end
end

// ball1 rgb flag
wire ball1_on;
assign ball1_on = (BALL_SIZE*BALL_SIZE >= (x-ball1_center_x)*(x-ball1_center_x) + (y-ball1_center_y)*(y-ball1_center_y)) ? 1 : 0;

// 최종 출력
assign rgb = (ball1_on == 1) ? 3'b111 : 
             (table_out_on == 1 && table_in_on == 0) ? 3'b111 : 3'b000;
             
endmodule