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
parameter BALL_SIZE = 40;

reg signed [9:0] BALL_1Vx   = 4;
reg signed [9:0] BALL_1Vy   = 4;
reg signed [1:0] BALL_1_Dx  = 1;
reg signed [1:0] BALL_1_Dy  = 1;
reg signed [9:0] BALL_2Vx   = 4;
reg signed [9:0] BALL_2Vy   = 4;
reg signed [1:0] BALL_2_Dx  = 1;
reg signed [1:0] BALL_2_Dy  = 1;
reg signed [9:0] BALL_3Vx   = 4;
reg signed [9:0] BALL_3Vy   = 4;
reg signed [1:0] BALL_3_Dx  = 1;
reg signed [1:0] BALL_3_Dy  = 1;

wire refr_tick; 
assign refr_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // ?? ????????? ?? clk ????? 1?? ??. 

// table
wire table_out_on, table_in_on;
assign table_out_on = (x >= TABLE_OUT_L && x <= TABLE_OUT_R - 1 && y >= TABLE_OUT_T && y <= TABLE_OUT_B - 1);
assign table_in_on = (x >= TABLE_IN_L && x <= TABLE_IN_R - 1 && y >= TABLE_IN_T && y <= TABLE_IN_B - 1);

// ball
wire ball1_reach_top, ball1_reach_bottom, ball1_reach_left, ball1_reach_right;
wire ball2_reach_top, ball2_reach_bottom, ball2_reach_left, ball2_reach_right;
wire ball3_reach_top, ball3_reach_bottom, ball3_reach_left, ball3_reach_right;

wire ball1_on;
reg [9:0]  ball1_x_reg, ball1_y_reg;
reg [9:0]  ball1_vx_reg, ball1_vy_reg;
wire [9:0] ball1_x_l, ball1_x_r, ball1_y_t, ball1_y_b;
wire [9:0] ball1_x_c, ball1_y_c;

wire ball2_on;
reg [9:0]  ball2_vx_reg, ball2_vy_reg;
reg [9:0]  ball2_x_reg, ball2_y_reg; 
wire [9:0] ball2_x_l, ball2_x_r, ball2_y_t, ball2_y_b;
wire [9:0] ball2_x_c, ball2_y_c;

wire ball3_on;
reg [9:0]  ball3_vx_reg, ball3_vy_reg;
reg [9:0]  ball3_x_reg, ball3_y_reg; 
wire [9:0] ball3_x_l, ball3_x_r, ball3_y_t, ball3_y_b;
wire [9:0] ball3_x_c, ball3_y_c;

//FLAG
//12
wire ball12_L, ball12_xC, ball12_R, ball12_T, ball12_yC, ball12_B;
wire ball12_LTRB, ball12_RTLB, ball12_LBRT, ball12_RBLT;
wire ball12_LCRC, ball12_RCLC, ball12_CTCB,  ball12_CBCT;

//13
wire ball13_L, ball13_xC, ball13_R, ball13_T, ball13_yC, ball13_B;
wire ball13_LTRB, ball13_RTLB, ball13_LBRT, ball13_RBLT;
wire ball13_LCRC, ball13_RCLC, ball13_CTCB,  ball13_CBCT;

//23
wire ball23_L, ball23_xC, ball23_R, ball23_T, ball23_yC, ball23_B;
wire ball23_LTRB, ball23_RTLB, ball23_LBRT, ball23_RBLT;
wire ball23_LCRC, ball23_RCLC, ball23_CTCB,  ball23_CBCT;

// 공1 범위
assign ball1_x_l = ball1_x_reg; //ball의 left
assign ball1_x_r = ball1_x_reg + BALL_SIZE - 1; //ball의 right
assign ball1_y_t = ball1_y_reg; //ball의 top
assign ball1_y_b = ball1_y_reg + BALL_SIZE - 1; //ball의 bottom

assign ball1_x_c = ball1_x_reg + (BALL_SIZE/2) - 1;
assign ball1_y_c = ball1_y_reg + (BALL_SIZE/2) - 1;

// 공2 범위
assign ball2_x_l = ball2_x_reg; //ball의 left
assign ball2_x_r = ball2_x_reg + BALL_SIZE - 1; //ball의 right
assign ball2_y_t = ball2_y_reg; //ball의 top
assign ball2_y_b = ball2_y_reg + BALL_SIZE - 1; //ball의 bottom

assign ball2_x_c = ball2_x_reg + (BALL_SIZE/2) - 1;
assign ball2_y_c = ball2_y_reg + (BALL_SIZE/2) - 1;

//공3 범위
assign ball3_x_l = ball3_x_reg; //ball의 left
assign ball3_x_r = ball3_x_reg + BALL_SIZE - 1; //ball의 right
assign ball3_y_t = ball3_y_reg; //ball의 top
assign ball3_y_b = ball3_y_reg + BALL_SIZE - 1; //ball의 bottom

assign ball3_x_c = ball3_x_reg + (BALL_SIZE/2) - 1;
assign ball3_y_c = ball3_y_reg + (BALL_SIZE/2) - 1;

assign ball1_on = (x>=ball1_x_l && x<=ball1_x_r && y>=ball1_y_t && y<=ball1_y_b)? 1 : 0; //ball1이 있는 영역
assign ball2_on = (x>=ball2_x_l && x<=ball2_x_r && y>=ball2_y_t && y<=ball2_y_b)? 1 : 0; //ball2이 있는 영역
assign ball3_on = (x>=ball3_x_l && x<=ball3_x_r && y>=ball3_y_t && y<=ball3_y_b)? 1 : 0; //ball2이 있는 영역

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

// 공3 충돌 인식
assign ball3_reach_top = (TABLE_IN_T >= ball3_y_t) ? 1 : 0;
assign ball3_reach_bottom = (TABLE_IN_B <= ball3_y_b) ? 1 : 0;
assign ball3_reach_left = (TABLE_IN_L >= ball3_x_l) ? 1 : 0;
assign ball3_reach_right = (TABLE_IN_R <= ball3_x_r) ? 1 : 0;


//충돌 검출 알고리즘
//L,xC,R, T,yC,B 모두 앞에 공이 기준임
//ball12_L 이면 Ball2가 Ball1 왼쪽에 닿았다는 의미

//12
assign ball12_L = ((ball1_x_l <= ball2_x_r) && (ball2_x_r <= ball1_x_c)) ? 1 : 0;
assign ball12_xC = ((ball1_x_l + 3*(BALL_SIZE/6) <= ball2_x_c) && (ball2_x_c <= ball1_x_c  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball12_R = ((ball1_x_c <= ball2_x_l) && (ball2_x_l <= ball1_x_r)) ? 1 : 0;

assign ball12_T = ((ball1_y_c <= ball2_y_t) && (ball2_y_t <= ball1_y_b)) ? 1 : 0;
assign ball12_yC = ((ball1_y_t + 3*(BALL_SIZE/6) <= ball2_y_c) && (ball2_y_c <= ball1_y_b  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball12_B = ((ball1_y_t <= ball2_y_b) && (ball2_y_b <= ball1_y_c)) ? 1 : 0;

assign ball12_LTRB = ball12_L && ball12_T;
assign ball12_RTLB = ball12_R && ball12_B;

assign ball12_LBRT = ball12_L && ball12_B;
assign ball12_RBLT = ball12_R && ball12_B;

assign ball12_LCRC = ball12_L && ball12_yC;
assign ball12_RCLC = ball12_R && ball12_yC;

assign ball12_CTCB = ball12_xC && ball12_B;
assign ball12_CBCT = ball12_xC && ball12_T;

//13

assign ball13_L = ((ball1_x_l <= ball3_x_r) && (ball3_x_r <= ball1_x_c)) ? 1 : 0;
assign ball13_xC = ((ball1_x_l + 3*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball1_x_c  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball13_R = ((ball1_x_c <= ball3_x_l) && (ball3_x_l <= ball1_x_r)) ? 1 : 0;

assign ball13_T = ((ball1_y_c <= ball3_y_t) && (ball3_y_t <= ball1_y_b)) ? 1 : 0;
assign ball13_yC = ((ball1_y_t + 3*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball1_y_b  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball13_B = ((ball1_y_t <= ball3_y_b) && (ball3_y_b <= ball1_y_c)) ? 1 : 0;

assign ball13_LTRB = ball13_L && ball13_T;
assign ball13_RTLB = ball13_R && ball13_B;

assign ball13_LBRT = ball13_L && ball13_B;
assign ball13_RBLT = ball13_R && ball13_B;

assign ball13_LCRC = ball13_L && ball13_yC;
assign ball13_RCLC = ball13_R && ball13_yC;

assign ball13_CTCB = ball13_xC && ball13_B;
assign ball13_CBCT = ball13_xC && ball13_T;

//23
assign ball23_L = ((ball2_x_l <= ball3_x_r) && (ball3_x_r <= ball2_x_c)) ? 1 : 0;
assign ball23_xC = ((ball2_x_l + 3*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball2_x_c  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_R = ((ball2_x_c <= ball3_x_l) && (ball3_x_l <= ball2_x_r)) ? 1 : 0;

assign ball23_T = ((ball2_y_c <= ball3_y_t) && (ball3_y_t <= ball2_y_b)) ? 1 : 0;
assign ball23_yC = ((ball2_y_t + 3*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball2_y_b  + 3*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_B = ((ball2_y_t <= ball3_y_b) && (ball3_y_b <= ball2_y_c)) ? 1 : 0;

assign ball23_LTRB = ball23_L && ball23_T;
assign ball23_RTLB = ball23_R && ball23_B;

assign ball23_LBRT = ball23_L && ball23_B;
assign ball23_RBLT = ball23_R && ball23_B;

assign ball23_LCRC = ball23_L && ball23_yC;
assign ball23_RCLC = ball23_R && ball23_yC;

assign ball23_CTCB = ball23_xC && ball23_B;
assign ball23_CBCT = ball23_xC && ball23_T;

//공1 방향 업데이트 B
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        BALL_1_Dx <= -1;
        BALL_1_Dy <= 1;
        ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
    end
    else begin
        if (ball1_reach_top) begin//ball1_vy_reg <= BALL_1Vy; //??? ?ε????? ???????..
            BALL_1_Dy <= 1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end 
        else if (ball1_reach_bottom) begin//ball1_vy_reg <= -1*BALL_1Vy; //???? ?ε????? ????
            BALL_1_Dy <= -1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball1_reach_left) begin//ball1_vx_reg <= BALL_1Vx; //???? ?ε????? ??????????
            BALL_1_Dx <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        end
        else if (ball1_reach_right) begin//ball1_vx_reg <= -1*BALL_1Vx; //??? ???? ????????
            BALL_1_Dx <= -1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        end
        //with ball
        else if (ball13_LTRB || ball12_LTRB) begin 
            BALL_1_Dx <= 1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_RTLB || ball12_RTLB) begin 
            BALL_1_Dx <= -1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_LBRT || ball12_LBRT) begin 
            BALL_1_Dx <= 1;
            BALL_1_Dy <= -1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_RBLT || ball12_RBLT) begin 
            BALL_1_Dx <= -1;
            BALL_1_Dy <= -1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_LCRC || ball12_LCRC) begin 
            BALL_1_Dx <= 1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_RCLC || ball12_RCLC) begin 
            BALL_1_Dx <= -1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_CTCB || ball12_CTCB) begin 
            BALL_1_Dx <= 1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball13_CBCT || ball12_CBCT) begin 
            BALL_1_Dx <= -1;
            BALL_1_Dy <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
    end  
end

//공2 방향 업데이트 R
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= BALL_2Vx; ////game?? ????? ???????? 
        ball2_vy_reg <= -1*BALL_2Vy; //game?? ????? ?????
    end
    else begin
        if (ball2_reach_top) begin//ball2_vy_reg <= BALL_2Vy; //??? ?ε????? ???????..
            BALL_2_Dy <= 1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end 
        else if (ball2_reach_bottom) begin//ball2_vy_reg <= -1*BALL_2Vy; //???? ?ε????? ????
            BALL_2_Dy <= -1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball2_reach_left) begin//ball2_vx_reg <= BALL_2Vx; //???? ?ε????? ??????????
            BALL_2_Dx <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
        end
        else if (ball2_reach_right) begin//ball2_vx_reg <= -1*BALL_2Vx; //??? ???? ????????
            BALL_2_Dx <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
        end
        //with ball
        else if (ball23_LTRB) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_RTLB) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_LBRT) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_RBLT) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_LCRC) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_RCLC) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_CTCB) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball23_CBCT) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_LTRB) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_RTLB) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_LBRT) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_RBLT) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_LCRC) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_RCLC) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_CTCB) begin 
            BALL_2_Dx <= -1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball12_CBCT) begin 
            BALL_2_Dx <= 1;
            BALL_2_Dy <= -1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
    end  
end

//공3 방향 업데이트 G
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball3_vx_reg <= BALL_3Vx; ////game?? ????? ???????? 
        ball3_vy_reg <= BALL_3Vy; //game?? ????? ?????
    end
    else begin
        if (ball3_reach_top) begin//ball3_vy_reg <= BALL_3Vy; //??? ?ε????? ???????..
            BALL_3_Dy <= 1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end 
        else if (ball3_reach_bottom) begin//ball3_vy_reg <= -1*BALL_3Vy; //???? ?ε????? ????
            BALL_3_Dy <= -1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball3_reach_left) begin//ball3_vx_reg <= BALL_3Vx; //???? ?ε????? ??????????
            BALL_3_Dx <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
        end
        else if (ball3_reach_right) begin//ball3_vx_reg <= -1*BALL_3Vx; //??? ???? ????????
            BALL_3_Dx <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
        end
        //with ball
        else if (ball23_LTRB || ball13_LTRB) begin 
            BALL_3_Dx <= -1;
            BALL_3_Dy <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_RTLB || ball13_RTLB) begin 
            BALL_3_Dx <= 1;
            BALL_3_Dy <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_LBRT || ball13_LBRT) begin 
            BALL_3_Dx <= -1;
            BALL_3_Dy <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_RBLT || ball13_RBLT) begin 
            BALL_3_Dx <= 1;
            BALL_3_Dy <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_LCRC || ball13_LCRC) begin 
            BALL_3_Dx <= -1;
            BALL_3_Dy <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_RCLC || ball13_RCLC) begin 
            BALL_3_Dx <= 1;
            BALL_3_Dy <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_CTCB || ball13_CTCB) begin 
            BALL_3_Dx <= -1;
            BALL_3_Dy <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball23_CBCT || ball13_CBCT) begin 
            BALL_3_Dx <= 1;
            BALL_3_Dy <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
    end  
end

// 공 1,2 좌표업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball1_x_reg <= 150; ball2_x_reg <= 300;  ball3_x_reg <= 450;// game이 멈추면 중간에서 시작
        ball1_y_reg <= MAX_Y/2; ball2_y_reg <= MAX_Y/2; ball3_y_reg <= MAX_Y/2;// e이 멈추면 중간에서 시작
    end else if (refr_tick) begin
        ball1_x_reg <= ball1_x_reg + ball1_vx_reg;  //매 프레임마다 ball_vx_reg만큼 움직임
        ball1_y_reg <= ball1_y_reg + ball1_vy_reg;  //매 프레임마다 ball_vy_reg만큼 움직임
        ball2_x_reg <= ball2_x_reg + ball2_vx_reg;
        ball2_y_reg <= ball2_y_reg + ball2_vy_reg;
        ball3_x_reg <= ball3_x_reg + ball3_vx_reg;
        ball3_y_reg <= ball3_y_reg + ball3_vy_reg;
    end
end

// 최종출력
assign rgb = (table_out_on == 1 && table_in_on == 0) ? 3'b111 :
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 0 && ball2_on == 0 && ball3_on == 0) ? 3'b000 : 
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 1) ? 3'b001 : 
             (table_out_on == 1 && table_in_on == 1 && ball2_on == 1) ? 3'b100 :
             (table_out_on == 1 && table_in_on == 1 && ball3_on == 1) ? 3'b010 : 3'b000;
endmodule