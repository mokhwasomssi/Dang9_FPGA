module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [2:0] rgb; 

// 화면 크기 설정
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

// table의 좌표 설정 
parameter TABLE_OUT_L = 20;
parameter TABLE_OUT_R = 620;
parameter TABLE_OUT_T = 20;
parameter TABLE_OUT_B = 460;

parameter TABLE_IN_L = 40;
parameter TABLE_IN_R = 600;
parameter TABLE_IN_T = 40;
parameter TABLE_IN_B = 440;

// ball의 속도, 크기 설정
parameter BALL_SIZE = 8;
parameter BALL_V = 4;

wire refr_tick; 
assign refr_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

// table
wire table_out_on, table_in_on;
assign table_out_on = (x >= TABLE_OUT_L && x <= TABLE_OUT_R - 1 && y >= TABLE_OUT_T && y <= TABLE_OUT_B - 1);
assign table_in_on = (x >= TABLE_IN_L && x <= TABLE_IN_R - 1 && y >= TABLE_IN_T && y <= TABLE_IN_B - 1);

// ball
wire ball1_reach_top, ball1_reach_bottom, ball1_reach_left, ball1_reach_right;
wire ball2_reach_top, ball2_reach_bottom, ball2_reach_left, ball2_reach_right;

wire ball1_on;
reg [9:0]  ball1_x_reg, ball1_y_reg;
reg [9:0]  ball1_vx_reg, ball1_vy_reg;
wire [9:0] ball1_x_l, ball1_x_r, ball1_y_t, ball1_y_b;

wire ball2_on;
reg [9:0]  ball2_vx_reg, ball2_vy_reg;
reg [9:0]  ball2_x_reg, ball2_y_reg; 
wire [9:0] ball2_x_l, ball2_x_r, ball2_y_t, ball2_y_b;

// 공1 범위
assign ball1_x_l = ball1_x_reg; //ball의 left
assign ball1_x_r = ball1_x_reg + BALL_SIZE - 1; //ball의 right
assign ball1_y_t = ball1_y_reg; //ball의 top
assign ball1_y_b = ball1_y_reg + BALL_SIZE - 1; //ball의 bottom

// 공2 범위
assign ball2_x_l = ball2_x_reg; //ball의 left
assign ball2_x_r = ball2_x_reg + BALL_SIZE - 1; //ball의 right
assign ball2_y_t = ball2_y_reg; //ball의 top
assign ball2_y_b = ball2_y_reg + BALL_SIZE - 1; //ball의 bottom

assign ball1_on = (x>=ball1_x_l && x<=ball1_x_r && y>=ball1_y_t && y<=ball1_y_b)? 1 : 0; //ball1이 있는 영역
assign ball2_on = (x>=ball2_x_l && x<=ball2_x_r && y>=ball2_y_t && y<=ball2_y_b)? 1 : 0; //ball2이 있는 영역

// 공1 충돌 인식
assign ball1_reach_top = (TABLE_IN_T >= ball1_y_t) ? 1 : 0;
assign ball1_reach_bottom = (TABLE_IN_B <= ball1_y_b) ? 1 : 0;
assign ball1_reach_left = (TABLE_IN_L >= ball1_x_l) ? 1 : 0;
assign ball1_reach_right = (TABLE_IN_R <= ball1_x_r) ? 1 : 0;

// 공2 충돌 인식
assign ball2_reach_top = (TABLE_IN_T >= ball2_y_t) ? 1 : 0;
assign ball2_reach_bottom = (TABLE_IN_B <= ball2_y_b) ? 1 : 0;
assign ball2_reach_left = (TABLE_IN_L >= ball2_x_l) ? 1 : 0;
assign ball2_reach_right = (TABLE_IN_R <= ball2_x_r) ? 1 : 0;

// 공1 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball1_vx_reg <= -1*BALL_V; //game이 멈추면 왼쪽으로 
        ball1_vy_reg <= BALL_V; //game이 멈추면 아래로
    end else begin
        if (ball1_reach_top) ball1_vy_reg <= BALL_V; //천장에 부딪히면 아래로.
        else if (ball1_reach_bottom) ball1_vy_reg <= -1*BALL_V; //바닥에 부딪히면 위로
        else if (ball1_reach_left) ball1_vx_reg <= BALL_V; //벽에 부딪히면 오른쪽으로 
        else if (ball1_reach_right) ball1_vx_reg <= -1*BALL_V; //바에 튕기면 왼쪽으로
    end  
end

// 공2 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= BALL_V; //game이 멈추면 왼쪽으로 
        ball2_vy_reg <= -1*BALL_V; //game이 멈추면 아래로
    end else begin
        if (ball2_reach_top) ball2_vy_reg <= BALL_V; //천장에 부딪히면 아래로.
        else if (ball2_reach_bottom) ball2_vy_reg <= -1*BALL_V; //바닥에 부딪히면 위로
        else if (ball2_reach_left) ball2_vx_reg <= BALL_V; //벽에 부딪히면 오른쪽으로 
        else if (ball2_reach_right) ball2_vx_reg <= -1*BALL_V; //바에 튕기면 왼쪽으로
    end  
end

// 공1, 2 좌표 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball1_x_reg <= MAX_X/2; ball2_x_reg <= MAX_X/2; // game이 멈추면 중간에서 시작
        ball1_y_reg <= MAX_Y/2; ball2_y_reg <= MAX_Y/2; // game이 멈추면 중간에서 시작
    end else if (refr_tick) begin
        ball1_x_reg <= ball1_x_reg + ball1_vx_reg;  //매 프레임마다 ball_vx_reg만큼 움직임
        ball1_y_reg <= ball1_y_reg + ball1_vy_reg;  //매 프레임마다 ball_vy_reg만큼 움직임
        ball2_x_reg <= ball2_x_reg + ball2_vx_reg;
        ball2_y_reg <= ball2_y_reg + ball2_vy_reg;
    end
end

// 최종 출력
assign rgb = (table_out_on == 1 && table_in_on == 0) ? 3'b111 :
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 0 && ball2_on == 0) ? 3'b000 : 
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 1) ? 3'b001 : 
             (table_out_on == 1 && table_in_on == 1 && ball2_on == 1) ? 3'b100 : 3'b000;

endmodule