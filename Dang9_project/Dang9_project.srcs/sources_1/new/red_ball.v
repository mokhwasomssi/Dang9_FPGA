module red_ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    output reg [9:0] center_x,
    output reg [9:0] center_y,
    
    output red_ball_on
    );

// 시작지점
parameter START_X = `MAX_X/2;
parameter START_Y = `MAX_Y/2;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// 빨간공 변수
reg signed [1:0] dir_x;
reg signed [1:0] dir_y;

reg signed [4:0] vx = 8*3/5;
reg signed [4:0] vy = 8*3/5;

reg signed [9:0] vx_reg;
reg signed [9:0] vy_reg;

// 빨간공-테이블 충돌 플래그
wire reach_top, reach_bottom, reach_left, reach_right;

assign reach_top = (`TABLE_IN_T >= (center_y - `BALL_R)) ? 1 : 0;
assign reach_bottom = (`TABLE_IN_B <= (center_y + `BALL_R)) ? 1 : 0;
assign reach_left = (`TABLE_IN_L >= (center_x - `BALL_R)) ? 1 : 0;
assign reach_right = (`TABLE_IN_R <= (center_x + `BALL_R)) ? 1 : 0;

// 테이블에 부딪혔을 때 방향 업데이트
always @(posedge clk or posedge rst) begin
    if(rst) begin
        dir_x <= 1;
        dir_y <= -1;
    end
    else begin
        if(reach_top) begin
            dir_y <= 1;
        end
        else if (reach_bottom) begin
            dir_y <= -1;
        end
        else if (reach_left) begin
            dir_x <= 1;
        end
        else if (reach_right) begin 
            dir_x <= -1;
        end
    end
end

// 최종 속도
always @(posedge clk or posedge rst) begin
    if(rst) begin
        vx_reg <= 0;
        vy_reg <= 0;
    end
    else begin
        vx_reg <= dir_x*vx;
        vy_reg <= dir_y*vy;
    end
end

// 빨간공 중심 좌표 업데이트
always @(posedge clk or posedge rst) begin
    if(rst) begin
        center_x <= START_X;
        center_y <= START_Y;
    end
    else if(refr_tick) begin
        center_x <= center_x + vx_reg;
        center_y <= center_y + vy_reg;
    end
end

// 빨간공 그리기
assign red_ball_on = (`BALL_R*`BALL_R >= (x-center_x)*(x-center_x) + (y-center_y)*(y-center_y)) ? 1 : 0;

endmodule
