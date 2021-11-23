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
wire ball_on;
wire reach_top, reach_bottom, reach_left, reach_right;
reg [9:0] ball_x_reg, ball_y_reg;
reg [9:0]  ball_vx_reg, ball_vy_reg; 
wire [9:0] ball_x_l, ball_x_r, ball_y_t, ball_y_b;

assign ball_x_l = ball_x_reg; //ball의 left
assign ball_x_r = ball_x_reg + BALL_SIZE - 1; //ball의 right
assign ball_y_t = ball_y_reg; //ball의 top
assign ball_y_b = ball_y_reg + BALL_SIZE - 1; //ball의 bottom

assign ball_on = (x>=ball_x_l && x<=ball_x_r && y>=ball_y_t && y<=ball_y_b)? 1 : 0; //ball이 있는 영역

// 공 좌표 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball_x_reg <= MAX_X/2; // game이 멈추면 중간에서 시작
        ball_y_reg <= MAX_Y/2; // game이 멈추면 중간에서 시작
    end else if (refr_tick) begin
        ball_x_reg <= ball_x_reg + ball_vx_reg; //매 프레임마다 ball_vx_reg만큼 움직임
        ball_y_reg <= ball_y_reg + ball_vy_reg; //매 프레임마다 ball_vy_reg만큼 움직임
    end
end

// 충돌 인식
assign reach_top = (TABLE_IN_T >= ball_y_t) ? 1 : 0;
assign reach_bottom = (TABLE_IN_B <= ball_y_b) ? 1 : 0;
assign reach_left = (TABLE_IN_L >= ball_x_l) ? 1 : 0;
assign reach_right = (TABLE_IN_R <= ball_x_r) ? 1 : 0;

// 공 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball_vx_reg <= -1*BALL_V; //game이 멈추면 왼쪽으로 
        ball_vy_reg <= BALL_V; //game이 멈추면 아래로
    end else begin
        if (reach_top) ball_vy_reg <= BALL_V; //천장에 부딪히면 아래로.
        else if (reach_bottom) ball_vy_reg <= -1*BALL_V; //바닥에 부딪히면 위로
        else if (reach_left) ball_vx_reg <= BALL_V; //벽에 부딪히면 오른쪽으로 
        else if (reach_right) ball_vx_reg <= -1*BALL_V; //바에 튕기면 왼쪽으로
    end  
end

// 최종 출력
assign rgb = (table_out_on == 1 && table_in_on == 0) ? 3'b111 :
             (table_out_on == 1 && table_in_on == 1 && ball_on == 0) ? 3'b000 : 
             (table_out_on == 1 && table_in_on == 1 && ball_on == 1) ? 3'b001 : 3'b000;
endmodule