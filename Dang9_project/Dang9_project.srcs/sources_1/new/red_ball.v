module red_ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    output [9:0] ball2_center_x,
    output [9:0] ball2_center_y,
    
    output red_ball_on
    );


parameter MAX_HIT_FORCE = 20;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// 빨간공 변수
reg signed [1:0] ball2_dir_x;
reg signed [1:0] ball2_dir_y;

reg [5:0] hit_force;

reg signed [4:0] ball2_vx = 17/4;
reg signed [4:0] ball2_vy = 17/4;

reg signed [9:0] ball2_vx_reg;
reg signed [9:0] ball2_vy_reg;

reg [9:0] ball2_center_x;
reg [9:0] ball2_center_y;

// 빨간공-테이블 충돌 플래그
wire ball2_reach_top, ball2_reach_bottom, ball2_reach_left, ball2_reach_right;

assign ball2_reach_top = (`TABLE_IN_T >= (ball2_center_y - `BALL_SIZE)) ? 1 : 0;
assign ball2_reach_bottom = (`TABLE_IN_B <= (ball2_center_y + `BALL_SIZE)) ? 1 : 0;
assign ball2_reach_left = (`TABLE_IN_L >= (ball2_center_x - `BALL_SIZE)) ? 1 : 0;
assign ball2_reach_right = (`TABLE_IN_R <= (ball2_center_x + `BALL_SIZE)) ? 1 : 0;

// 테이블에 부딪혔을 때 방향 업데이트
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball2_dir_x <= 1;
        ball2_dir_y <= -1;
    end
    else begin
        if(ball2_reach_top) begin
            ball2_dir_y <= 1;
        end
        else if (ball2_reach_bottom) begin
            ball2_dir_y <= -1;
        end
        else if (ball2_reach_left) begin
            ball2_dir_x <= 1;
        end
        else if (ball2_reach_right) begin 
            ball2_dir_x <= -1;
        end
    end
end

// 최종 속도
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= 0;
        ball2_vy_reg <= 0;
    end
    else begin
        ball2_vx_reg <= ball2_dir_x*ball2_vx;
        ball2_vy_reg <= ball2_dir_y*ball2_vy;
    end
end

// 빨간공 중심 좌표 업데이트
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball2_center_x <= `MAX_X/2;
        ball2_center_y <= `MAX_Y/2;
    end
    else if(refr_tick) begin
        ball2_center_x <= ball2_center_x + ball2_vx_reg;
        ball2_center_y <= ball2_center_y + ball2_vy_reg;
    end
end

// 빨간공 그리기
assign red_ball_on = (`BALL_SIZE*`BALL_SIZE >= (x-ball2_center_x)*(x-ball2_center_x) + (y-ball2_center_y)*(y-ball2_center_y)) ? 1 : 0;

endmodule
