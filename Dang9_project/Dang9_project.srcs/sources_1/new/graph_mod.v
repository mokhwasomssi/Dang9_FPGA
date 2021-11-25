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
//parameter BALL_V = 4;

reg [9:0] BALL_1Vx = 4;
reg [9:0] BALL_1Vy = 4;
reg [9:0] BALL_2Vx = 4;
reg [9:0] BALL_2Vy = 4;
reg [9:0] BALL_3Vx = 4;
reg [9:0] BALL_3Vy = 4;

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

wire Crash_ball1_to_ball2_x_l, Crash_ball1_to_ball2_x_r, Crash_ball1_to_ball2_y_t, Crash_ball1_to_ball2_y_b, Crash_ball1_to_ball2;
wire Crash_ball1_to_ball3_x_l, Crash_ball1_to_ball3_x_r, Crash_ball1_to_ball3_y_t, Crash_ball1_to_ball3_y_b, Crash_ball1_to_ball3;

wire Crash_ball2_to_ball1_x_l, Crash_ball2_to_ball1_x_r, Crash_ball2_to_ball1_y_t, Crash_ball2_to_ball1_y_b, Crash_ball2_to_ball1;
wire Crash_ball2_to_ball3_x_l, Crash_ball2_to_ball3_x_r, Crash_ball2_to_ball3_y_t, Crash_ball2_to_ball3_y_b, Crash_ball2_to_ball3;

wire Crash_ball3_to_ball1_x_l, Crash_ball3_to_ball1_x_r, Crash_ball3_to_ball1_y_t, Crash_ball3_to_ball1_y_b, Crash_ball3_to_ball1;
wire Crash_ball3_to_ball2_x_l, Crash_ball3_to_ball2_x_r, Crash_ball3_to_ball2_y_t, Crash_ball3_to_ball2_y_b, Crash_ball3_to_ball2;

wire ball1_on;
reg [9:0]  ball1_x_reg, ball1_y_reg;
reg [9:0]  ball1_vx_reg, ball1_vy_reg;
wire [9:0] ball1_x_l, ball1_x_r, ball1_y_t, ball1_y_b;

wire ball2_on;
reg [9:0]  ball2_vx_reg, ball2_vy_reg;
reg [9:0]  ball2_x_reg, ball2_y_reg; 
wire [9:0] ball2_x_l, ball2_x_r, ball2_y_t, ball2_y_b;

wire ball3_on;
reg [9:0]  ball3_vx_reg, ball3_vy_reg;
reg [9:0]  ball3_x_reg, ball3_y_reg; 
wire [9:0] ball3_x_l, ball3_x_r, ball3_y_t, ball3_y_b;

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

//공3 범위
assign ball3_x_l = ball3_x_reg; //ball의 left
assign ball3_x_r = ball3_x_reg + BALL_SIZE - 1; //ball의 right
assign ball3_y_t = ball3_y_reg; //ball의 top
assign ball3_y_b = ball3_y_reg + BALL_SIZE - 1; //ball의 bottom

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


//공 간 충돌 검출
//ball1 기준
assign Crash_ball1_to_ball2_x_l = ((ball2_x_l <= ball1_x_l) && (ball1_x_l <= ball2_x_r)) ? 1 : 0; // 1?? ?? x????? 2???? x???? ?????? ????
assign Crash_ball1_to_ball2_x_r = ((ball2_x_l <= ball1_x_r) && (ball1_x_r <= ball2_x_r)) ? 1 : 0; // 1?? ?? x????? 2???? x???? ?????? ????
assign Crash_ball1_to_ball2_y_t = ((ball2_y_t <= ball1_y_t) && (ball1_y_t <= ball2_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball1_to_ball2_y_b = ((ball2_y_t <= ball1_y_b) && (ball1_y_b <= ball2_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

assign Crash_ball1_to_ball3_x_l = ((ball3_x_l <= ball1_x_l) && (ball1_x_l <= ball3_x_r)) ? 1 : 0; // 1?? ?? x????? 2???? x???? ?????? ????
assign Crash_ball1_to_ball3_x_r = ((ball3_x_l <= ball1_x_r) && (ball1_x_r <= ball3_x_r)) ? 1 : 0; // 1?? ?? x????? 2???? x???? ?????? ????
assign Crash_ball1_to_ball3_y_t = ((ball3_y_t <= ball1_y_t) && (ball1_y_t <= ball3_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball1_to_ball3_y_b = ((ball3_y_t <= ball1_y_b) && (ball1_y_b <= ball3_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

//ball2 기준
assign Crash_ball2_to_ball1_x_l = ((ball1_x_l <= ball2_x_l) && (ball2_x_l <= ball1_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball2_to_ball1_x_r = ((ball1_x_l <= ball2_x_r) && (ball2_x_r <= ball1_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball2_to_ball1_y_t = ((ball1_y_t <= ball2_y_t) && (ball2_y_t <= ball1_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball2_to_ball1_y_b = ((ball1_y_t <= ball2_y_b) && (ball2_y_b <= ball1_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

assign Crash_ball2_to_ball3_x_l = ((ball3_x_l <= ball2_x_l) && (ball2_x_l <= ball3_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball2_to_ball3_x_r = ((ball3_x_l <= ball2_x_r) && (ball2_x_r <= ball3_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball2_to_ball3_y_t = ((ball3_y_t <= ball2_y_t) && (ball2_y_t <= ball3_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball2_to_ball3_y_b = ((ball3_y_t <= ball2_y_b) && (ball2_y_b <= ball3_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

//ball3 기준
assign Crash_ball3_to_ball1_x_l = ((ball1_x_l <= ball3_x_l) && (ball3_x_l <= ball1_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball3_to_ball1_x_r = ((ball1_x_l <= ball3_x_r) && (ball3_x_r <= ball1_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball3_to_ball1_y_t = ((ball1_y_t <= ball3_y_t) && (ball3_y_t <= ball1_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball3_to_ball1_y_b = ((ball1_y_t <= ball3_y_b) && (ball3_y_b <= ball1_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

assign Crash_ball3_to_ball2_x_l = ((ball2_x_l <= ball3_x_l) && (ball3_x_l <= ball2_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball3_to_ball2_x_r = ((ball2_x_l <= ball3_x_r) && (ball3_x_r <= ball2_x_r)) ? 1 : 0; // 2?? ?? x????? 1???? x???? ?????? ????
assign Crash_ball3_to_ball2_y_t = ((ball2_y_t <= ball3_y_t) && (ball3_y_t <= ball2_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????
assign Crash_ball3_to_ball2_y_b = ((ball2_y_t <= ball3_y_b) && (ball3_y_b <= ball2_y_b)) ? 1 : 0; // 2?? ?? y????? 1???? y???? ?????? ????

//충돌 FLAG
assign Crash_ball1_to_ball2 = (Crash_ball1_to_ball2_x_l && Crash_ball1_to_ball2_y_t) ||
                              (Crash_ball1_to_ball2_x_l && Crash_ball1_to_ball2_y_b) ||
                              (Crash_ball1_to_ball2_x_r && Crash_ball1_to_ball2_y_t) ||
                              (Crash_ball1_to_ball2_x_r && Crash_ball1_to_ball2_y_b);
                              
assign Crash_ball1_to_ball3 = (Crash_ball1_to_ball3_x_l && Crash_ball1_to_ball3_y_t) ||
                              (Crash_ball1_to_ball3_x_l && Crash_ball1_to_ball3_y_b) ||
                              (Crash_ball1_to_ball3_x_r && Crash_ball1_to_ball3_y_t) ||
                              (Crash_ball1_to_ball3_x_r && Crash_ball1_to_ball3_y_b);

assign Crash_ball2_to_ball1 = (Crash_ball2_to_ball1_x_l && Crash_ball2_to_ball1_y_t) || 
                              (Crash_ball2_to_ball1_x_l && Crash_ball2_to_ball1_y_b) ||
                              (Crash_ball2_to_ball1_x_r && Crash_ball2_to_ball1_y_t) || 
                              (Crash_ball2_to_ball1_x_r && Crash_ball2_to_ball1_y_b);
                              
assign Crash_ball2_to_ball3 = (Crash_ball2_to_ball3_x_l && Crash_ball2_to_ball3_y_t) || 
                              (Crash_ball2_to_ball3_x_l && Crash_ball2_to_ball3_y_b) ||
                              (Crash_ball2_to_ball3_x_r && Crash_ball2_to_ball3_y_t) || 
                              (Crash_ball2_to_ball3_x_r && Crash_ball2_to_ball3_y_b);
                              
assign Crash_ball3_to_ball1 = (Crash_ball3_to_ball1_x_l && Crash_ball3_to_ball1_y_t) || 
                              (Crash_ball3_to_ball1_x_l && Crash_ball3_to_ball1_y_b) ||
                              (Crash_ball3_to_ball1_x_r && Crash_ball3_to_ball1_y_t) || 
                              (Crash_ball3_to_ball1_x_r && Crash_ball3_to_ball1_y_b);
                              
assign Crash_ball3_to_ball2 = (Crash_ball3_to_ball2_x_l && Crash_ball3_to_ball2_y_t) || 
                              (Crash_ball3_to_ball2_x_l && Crash_ball3_to_ball2_y_b) ||
                              (Crash_ball3_to_ball2_x_r && Crash_ball3_to_ball2_y_t) || 
                              (Crash_ball3_to_ball2_x_r && Crash_ball3_to_ball2_y_b);
// 공1 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball1_vx_reg <= -1*BALL_1Vx; //game이 멈추면 왼쪽으로 
        ball1_vy_reg <= BALL_1Vy; //game이 멈추면 아래로
    end else begin
        if (ball1_reach_top) ball1_vy_reg <= BALL_1Vy; //천장에 부딪히면 ㄴ아래로..
        else if (ball1_reach_bottom) ball1_vy_reg <= -1*BALL_1Vy; //바닥에 부딪히면 위로
        else if (ball1_reach_left) ball1_vx_reg <= BALL_1Vx; //벽에 부딪히면 오른쪽으로
        else if (ball1_reach_right) ball1_vx_reg <= -1*BALL_1Vx; //바에 튕기면 왼쪽으로
        else if ( Crash_ball1_to_ball2 || Crash_ball1_to_ball3 ||
                  Crash_ball2_to_ball1 || Crash_ball3_to_ball1) begin //Crash_ball1_to_ball2 || Crash_ball2_to_ball1
            ball1_vx_reg <= -1 * ball1_vx_reg;
            ball1_vy_reg <= -1 * ball1_vy_reg;
        end
    end  
end

// 공2 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= BALL_2Vx; ////game이 멈추면 왼쪽으로 
        ball2_vy_reg <= -1*BALL_2Vy; //game이 멈추면 아래로
    end else begin
        if (ball2_reach_top) ball2_vy_reg <= BALL_2Vy; //천장에 부딪히면 아래로
        else if (ball2_reach_bottom) ball2_vy_reg <= -1*BALL_2Vy; //.바닥에 부딪히면 위로
        else if (ball2_reach_left) ball2_vx_reg <= BALL_2Vx; //벽에 부딪히면 오른쪽으로
        else if (ball2_reach_right) ball2_vx_reg <= -1*BALL_2Vx; //바에 튕기면 왼쪽으로
        else if (Crash_ball2_to_ball1 || Crash_ball2_to_ball3 ||
                 Crash_ball1_to_ball2 || Crash_ball3_to_ball2) begin //Crash_ball1_to_ball2 || Crash_ball2_to_ball1
            //ball2_vx_reg <= -1 * ball2_vx_reg;
            //ball2_vy_reg <= -1 * ball2_vy_reg;
        end
    end  
end

// 공3 방향 업데이트
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball3_vx_reg <= BALL_3Vx; ////game이 멈추면 왼쪽으로 
        ball3_vy_reg <= BALL_3Vy; //game이 멈추면 아래로
    end else begin
        if (ball3_reach_top) ball3_vy_reg <= BALL_3Vy; //천장에 부딪히면 아래로
        else if (ball3_reach_bottom) ball3_vy_reg <= -1*BALL_3Vy; //.바닥에 부딪히면 위로
        else if (ball3_reach_left) ball3_vx_reg <= BALL_3Vx; //벽에 부딪히면 오른쪽으로
        else if (ball3_reach_right) ball3_vx_reg <= -1*BALL_3Vx; //바에 튕기면 왼쪽으로
        else if ( Crash_ball3_to_ball1 || Crash_ball3_to_ball2 ||
                  Crash_ball1_to_ball3 || Crash_ball2_to_ball3) begin //Crash_ball1_to_ball2 || Crash_ball2_to_ball1 || Crash_ball2_to_ball3
            //ball3_vx_reg <= -1 * ball3_vx_reg;
            //ball3_vy_reg <= -1 * ball3_vy_reg;
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