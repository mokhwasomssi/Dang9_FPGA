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

// hit force
parameter MAX_HIT_FORCE = 20;

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


// 테이블에 부딪혔을 때 방향 업데이트
reg signed [1:0] ball1_dir_x;
reg signed [1:0] ball1_dir_y;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball1_dir_x <= 1;
        ball1_dir_y <= -1;
    end
    else begin
        if(ball1_reach_top) begin
            ball1_dir_y <= 1;
        end
        else if (ball1_reach_bottom) begin
            ball1_dir_y <= -1;
        end
        else if (ball1_reach_left) begin
            ball1_dir_x <= 1;
        end
        else if (ball1_reach_right) begin 
            ball1_dir_x <= -1;
        end
    end
end

// 치는 힘 업데이트
reg [5:0] hit_force;
reg [6:0] cnt1;

always @(posedge clk or posedge rst) begin
   if(rst) begin
       hit_force <= 0;
   end
   else if(refr_tick) begin
        if(key == 5'h14) // 4번키를 누르고 있으면 치는 힘이 커짐
            if(hit_force < MAX_HIT_FORCE && cnt1 > 5) begin
                hit_force <= hit_force + 1;
                cnt1 <= 0;
            end
            else
                cnt1 <= cnt1 + 1;
   end
   else if(key_pulse == 5'h10) // 0번키를 누르면 hit_force 초기화
        hit_force <= 0;
end

// 시간에 따라 속력 감소
reg signed [4:0] ball1_vx;
reg signed [4:0] ball1_vy;
reg [6:0] cnt2;

always @(posedge clk or posedge rst) begin
    if(rst | key_pulse == 5'h10) begin // 0번키를 누르면 치는 힘을 공에 전가해줌. 레지스터 특성상 0으로 초기화되기 전 값이 ball1_vx에 들어감.
        ball1_vx <= hit_force;
        ball1_vy <= hit_force;
    end
    else if(refr_tick) begin
        if(cnt2 == 20) begin // 0.3초마다 속력 감소
            if(ball1_vx > 0) ball1_vx <= ball1_vx - 1;
            if(ball1_vy > 0) ball1_vy <= ball1_vy - 1;
            cnt2 <= 0;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// 최종 속도
reg signed [9:0] ball1_vx_reg;
reg signed [9:0] ball1_vy_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball1_vx_reg <= 0;
        ball1_vy_reg <= 0;
    end
    else begin
        ball1_vx_reg <= ball1_dir_x*ball1_vx;
        ball1_vy_reg <= ball1_dir_y*ball1_vy;
    end
end

// 공1 중심 좌표 업데이트
reg [9:0] ball1_center_x;
reg [9:0] ball1_center_y;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ball1_center_x <= MAX_X/2;
        ball1_center_y <= MAX_Y/2;
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