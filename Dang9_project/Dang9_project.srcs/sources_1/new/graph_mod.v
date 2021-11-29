module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [2:0] rgb; 

// ȭ�� ũ�� ����
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

// table�� ��ǥ ���� 
parameter TABLE_OUT_L = 20;
parameter TABLE_OUT_R = 620;
parameter TABLE_OUT_T = 20;
parameter TABLE_OUT_B = 460;

parameter TABLE_IN_L = 40;
parameter TABLE_IN_R = 600;
parameter TABLE_IN_T = 40;
parameter TABLE_IN_B = 440;

// ball�� �ӵ�, ũ�� ����
parameter BALL_SIZE = 24;

reg signed [9:0] BALL_1Vx   = 10;
reg signed [9:0] BALL_1Vy   = 0;
reg signed [1:0] BALL_1_Dx  = 1;
reg signed [1:0] BALL_1_Dy  = 1;
reg signed [9:0] BALL_2Vx   = 8;
reg signed [9:0] BALL_2Vy   = 2;
reg signed [1:0] BALL_2_Dx  = 1;
reg signed [1:0] BALL_2_Dy  = 1;
reg signed [9:0] BALL_3Vx   = 1;
reg signed [9:0] BALL_3Vy   = 1;
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

// ��1 ����
assign ball1_x_l = ball1_x_reg; //ball�� left
assign ball1_x_r = ball1_x_reg + BALL_SIZE - 1; //ball�� right
assign ball1_y_t = ball1_y_reg; //ball�� top
assign ball1_y_b = ball1_y_reg + BALL_SIZE - 1; //ball�� bottom

assign ball1_x_c = ball1_x_reg + (BALL_SIZE/2) - 1;
assign ball1_y_c = ball1_y_reg + (BALL_SIZE/2) - 1;

// ��2 ����
assign ball2_x_l = ball2_x_reg; //ball�� left
assign ball2_x_r = ball2_x_reg + BALL_SIZE - 1; //ball�� right
assign ball2_y_t = ball2_y_reg; //ball�� top
assign ball2_y_b = ball2_y_reg + BALL_SIZE - 1; //ball�� bottom

assign ball2_x_c = ball2_x_reg + (BALL_SIZE/2) - 1;
assign ball2_y_c = ball2_y_reg + (BALL_SIZE/2) - 1;

//��3 ����
assign ball3_x_l = ball3_x_reg; //ball�� left
assign ball3_x_r = ball3_x_reg + BALL_SIZE - 1; //ball�� right
assign ball3_y_t = ball3_y_reg; //ball�� top
assign ball3_y_b = ball3_y_reg + BALL_SIZE - 1; //ball�� bottom

assign ball3_x_c = ball3_x_reg + (BALL_SIZE/2) - 1;
assign ball3_y_c = ball3_y_reg + (BALL_SIZE/2) - 1;

assign ball1_on = (x>=ball1_x_l && x<=ball1_x_r && y>=ball1_y_t && y<=ball1_y_b)? 1 : 0; //ball1�� �ִ� ����
assign ball2_on = (x>=ball2_x_l && x<=ball2_x_r && y>=ball2_y_t && y<=ball2_y_b)? 1 : 0; //ball2�� �ִ� ����
assign ball3_on = (x>=ball3_x_l && x<=ball3_x_r && y>=ball3_y_t && y<=ball3_y_b)? 1 : 0; //ball2�� �ִ� ����

// ��1 �浹 �ν�
assign ball1_reach_top = (TABLE_IN_T >= ball1_y_t) ? 1 : 0;
assign ball1_reach_bottom = (TABLE_IN_B <= ball1_y_b) ? 1 : 0;
assign ball1_reach_left = (TABLE_IN_L >= ball1_x_l) ? 1 : 0;
assign ball1_reach_right = (TABLE_IN_R <= ball1_x_r) ? 1 : 0;

// ��2 �浹 �ν�
assign ball2_reach_top = (TABLE_IN_T >= ball2_y_t) ? 1 : 0;
assign ball2_reach_bottom = (TABLE_IN_B <= ball2_y_b) ? 1 : 0;
assign ball2_reach_left = (TABLE_IN_L >= ball2_x_l) ? 1 : 0;
assign ball2_reach_right = (TABLE_IN_R <= ball2_x_r) ? 1 : 0;

// ��3 �浹 �ν�
assign ball3_reach_top = (TABLE_IN_T >= ball3_y_t) ? 1 : 0;
assign ball3_reach_bottom = (TABLE_IN_B <= ball3_y_b) ? 1 : 0;
assign ball3_reach_left = (TABLE_IN_L >= ball3_x_l) ? 1 : 0;
assign ball3_reach_right = (TABLE_IN_R <= ball3_x_r) ? 1 : 0;


//�浹 ���� �˰�����
//L,xC,R, T,yC,B ���? �տ� ���� ������
//ball12_L �̸� Ball2�� Ball1 ���ʿ� ��Ҵٴ�? �ǹ�

//12
assign ball12_L = ((ball1_x_l <= ball2_x_r) && (ball2_x_r <= ball1_x_c)) ? 1 : 0;
assign ball12_xC = ((ball1_x_l + 2*(BALL_SIZE/6) <= ball2_x_c) && (ball2_x_c <= ball1_x_c  + 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball12_R = ((ball1_x_c <= ball2_x_l) && (ball2_x_l <= ball1_x_r)) ? 1 : 0;

assign ball12_T = ((ball1_y_c <= ball2_y_t) && (ball2_y_t <= ball1_y_b)) ? 1 : 0;
assign ball12_yC = ((ball1_y_t + 2*(BALL_SIZE/6) <= ball2_y_c) && (ball2_y_c <= ball1_y_b  + 2*(BALL_SIZE/6))) ? 1 : 0;
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
assign ball13_xC = ((ball1_x_l + 2*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball1_x_c  + 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball13_R = ((ball1_x_c <= ball3_x_l) && (ball3_x_l <= ball1_x_r)) ? 1 : 0;

assign ball13_T = ((ball1_y_c <= ball3_y_t) && (ball3_y_t <= ball1_y_b)) ? 1 : 0;
assign ball13_yC = ((ball1_y_t + 2*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball1_y_b  + 2*(BALL_SIZE/6))) ? 1 : 0;
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
assign ball23_xC = ((ball2_x_l + 1*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball2_x_c  + 1*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_R = ((ball2_x_c <= ball3_x_l) && (ball3_x_l <= ball2_x_r)) ? 1 : 0;

assign ball23_T = ((ball2_y_c <= ball3_y_t) && (ball3_y_t <= ball2_y_b)) ? 1 : 0;
assign ball23_yC = ((ball2_y_t + 2*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball2_y_b  + 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_B = ((ball2_y_t <= ball3_y_b) && (ball3_y_b <= ball2_y_c)) ? 1 : 0;

assign ball23_LTRB = ball23_L && ball23_T;
assign ball23_RTLB = ball23_R && ball23_B;

assign ball23_LBRT = ball23_L && ball23_B;
assign ball23_RBLT = ball23_R && ball23_B;

assign ball23_LCRC = ball23_L && ball23_yC;
assign ball23_RCLC = ball23_R && ball23_yC;

assign ball23_CTCB = ball23_xC && ball23_B;
assign ball23_CBCT = ball23_xC && ball23_T;

//��1 ���� ������Ʈ B
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        BALL_1_Dx <= -1;
        BALL_1_Dy <= 1;
        ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
    end
    else begin
        if (ball1_reach_top) begin//ball1_vy_reg <= BALL_1Vy; //??? ?��????? ???????..
            BALL_1_Dy <= 1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end 
        else if (ball1_reach_bottom) begin//ball1_vy_reg <= -1*BALL_1Vy; //???? ?��????? ????
            BALL_1_Dy <= -1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball1_reach_left) begin//ball1_vx_reg <= BALL_1Vx; //???? ?��????? ??????????
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

//��2 ���� ������Ʈ R
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= BALL_2Vx; ////game?? ????? ???????? 
        ball2_vy_reg <= -1*BALL_2Vy; //game?? ????? ?????
    end
    else begin
        if (ball2_reach_top) begin//ball2_vy_reg <= BALL_2Vy; //??? ?��????? ???????..
            BALL_2_Dy <= 1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end 
        else if (ball2_reach_bottom) begin//ball2_vy_reg <= -1*BALL_2Vy; //???? ?��????? ????
            BALL_2_Dy <= -1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball2_reach_left) begin//ball2_vx_reg <= BALL_2Vx; //???? ?��????? ??????????
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

//��3 ���� ������Ʈ G
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball3_vx_reg <= BALL_3Vx; ////game?? ????? ???????? 
        ball3_vy_reg <= BALL_3Vy; //game?? ????? ?????
    end
    else begin
        if (ball3_reach_top) begin//ball3_vy_reg <= BALL_3Vy; //??? ?��????? ???????..
            BALL_3_Dy <= 1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end 
        else if (ball3_reach_bottom) begin//ball3_vy_reg <= -1*BALL_3Vy; //???? ?��????? ????
            BALL_3_Dy <= -1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball3_reach_left) begin//ball3_vx_reg <= BALL_3Vx; //???? ?��????? ??????????
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

// �� 1,2 ��ǥ������Ʈ
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball1_x_reg <= 150; ball2_x_reg <= 300;  ball3_x_reg <= 450;// game�� ���߸� �߰����� ����
        ball1_y_reg <= MAX_Y/2; ball2_y_reg <= MAX_Y/2; ball3_y_reg <= MAX_Y/2;// e�� ���߸� �߰����� ����
    end else if (refr_tick) begin
        ball1_x_reg <= ball1_x_reg + ball1_vx_reg;  //�� �����Ӹ��� ball_vx_reg��ŭ ������
        ball1_y_reg <= ball1_y_reg + ball1_vy_reg;  //�� �����Ӹ��� ball_vy_reg��ŭ ������
        ball2_x_reg <= ball2_x_reg + ball2_vx_reg;
        ball2_y_reg <= ball2_y_reg + ball2_vy_reg;
        ball3_x_reg <= ball3_x_reg + ball3_vx_reg;
        ball3_y_reg <= ball3_y_reg + ball3_vy_reg;
    end
end

// �������?
assign rgb = (table_out_on == 1 && table_in_on == 0) ? 3'b111 :
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 0 && ball2_on == 0 && ball3_on == 0) ? 3'b000 : 
             (table_out_on == 1 && table_in_on == 1 && ball1_on == 1) ? 3'b111 : 
             (table_out_on == 1 && table_in_on == 1 && ball2_on == 1) ? 3'b100 :
             (table_out_on == 1 && table_in_on == 1 && ball3_on == 1) ? 3'b110 : 3'b000;

//���� ���?
//���� Vx,Vy, dirX,dir Y ���� ���⼭ �޾ƿ� ����.
reg [9:0] deg, Vx, Vy, Dx, Dy, R ;

always @(posedge clk or posedge rst)
    if(rst) begin     
    end
    else begin
        case(R)
            12 : case(deg)
                0	:	begin	Vx	=	12	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	3	;	Vy	=	12	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	11	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	10	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	4	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	11	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	12	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	11	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	9	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	6	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	11	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	12	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	12	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	7	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	7	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	11	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	2	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	12	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	6	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	8	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	10	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	3	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	12	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	4	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	9	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	5	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	12	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                140	:	begin	Vx	=	3	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	10	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	8	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	6	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	12	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	11	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	7	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	8	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	12	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	11	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	11	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	5	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	9	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	11	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	2	;	Vy	=	11	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	11	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                225	:	begin	Vx	=	4	;	Vy	=	12	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	10	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	10	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	3	;	Vy	=	11	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	11	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	2	;	Vy	=	12	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	11	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	9	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	5	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	11	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	1	;	Vy	=	12	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	12	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	8	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	6	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	11	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	12	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	7	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	8	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	10	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	12	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	5	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	9	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	10	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	4	;	Vy	=	12	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	12	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	4	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            11 : case(deg)
                0	:	begin	Vx	=	11	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	3	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	10	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	9	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	4	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	10	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	8	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	5	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	10	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	11	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	11	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	7	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	6	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	10	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	2	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	11	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	5	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	8	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	3	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	11	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	4	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	8	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	5	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	11	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	3	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	9	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	7	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	6	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	11	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	10	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	6	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	7	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	11	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	5	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	8	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	10	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	2	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	10	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	4	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	9	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	3	;	Vy	=	10	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	10	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	2	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	10	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	9	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	4	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	1	;	Vy	=	11	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	11	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	7	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	6	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	10	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	11	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	6	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	7	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	9	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	11	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	5	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	8	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	4	;	Vy	=	11	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	11	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	4	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            10 : case(deg)
                0	:	begin	Vx	=	10	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	2	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	4	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	9	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	10	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	7	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	9	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	10	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	10	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	6	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	6	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	9	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	2	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	7	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	3	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	10	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	4	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	8	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	7	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	4	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	10	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	2	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	6	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	5	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	9	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	5	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	6	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	10	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	9	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	4	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	7	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	9	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	1	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	9	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	3	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	8	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	9	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	3	;	Vy	=	9	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	9	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	2	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	9	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	4	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	9	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	1	;	Vy	=	10	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	10	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	7	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	9	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	10	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	6	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	6	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	9	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	10	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	5	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	7	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	3	;	Vy	=	10	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	10	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	3	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            9 : case(deg)
                0	:	begin	Vx	=	9	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	2	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	8	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	3	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	8	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	9	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	7	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	9	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	9	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	6	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	9	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	6	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	3	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	9	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	3	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	7	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	4	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	9	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	7	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	6	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	9	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	5	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	6	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	9	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	8	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	4	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	7	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	8	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	3	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	8	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	8	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	8	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	2	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	8	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	7	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	4	;	Vy	=	8	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	8	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	9	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	9	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	6	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	5	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	9	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	5	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	6	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	9	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	4	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	3	;	Vy	=	9	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	9	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	3	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            8 : case(deg)
                0	:	begin	Vx	=	8	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	4	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	8	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	7	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	8	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	8	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	3	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	8	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	8	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	5	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	8	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	6	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	7	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	7	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	7	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	8	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	8	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	6	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	4	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	8	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	7	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	8	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	3	;	Vy	=	8	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	8	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            7 : case(deg)
                0	:	begin	Vx	=	7	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	7	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	4	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	3	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	7	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	4	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	4	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	4	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	3	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	5	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	6	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	6	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	7	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	3	;	Vy	=	6	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	7	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	7	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	7	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	3	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	2	;	Vy	=	7	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	7	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            6 : case(deg)
                0	:	begin	Vx	=	6	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	6	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	3	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	6	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	3	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	5	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	5	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	6	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	6	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	6	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	6	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	4	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	5	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	2	;	Vy	=	6	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	6	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            5 : case(deg)
                0	:	begin	Vx	=	5	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	5	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	5	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	3	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                200	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	4	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	4	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	5	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	5	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	5	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	2	;	Vy	=	5	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	5	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            4 : case(deg)
                0	:	begin	Vx	=	4	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	4	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	4	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	3	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	3	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                200	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	3	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	4	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	4	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	4	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	2	;	Vy	=	4	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	4	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            3 : case(deg)
                0	:	begin	Vx	=	3	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	3	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                150	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	3	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                175	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	2	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                200	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	3	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	3	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	3	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	1	;	Vy	=	3	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	3	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            2 : case(deg)
                0	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                20	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                25	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                45	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                50	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                70	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                75	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                95	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                100	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                120	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                125	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                145	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                150	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                170	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                175	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                195	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                200	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	2	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                220	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                240	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                245	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	2	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                265	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                270	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                290	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                295	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                315	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                320	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
                340	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	1	;	Dy	=	-1	;	end
                345	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	1	;	Vy	=	2	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	2	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	-1	;	end
            endcase
            1 : case(deg)
                0	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                20	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                25	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                45	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                50	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                70	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                75	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                95	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                100	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                120	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                125	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                145	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                150	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                165	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                170	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                175	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                195	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                200	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                220	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                240	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                245	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                265	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                270	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                290	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                295	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                315	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                320	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
                340	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                345	:	begin	Vx	=	0	;	Vy	=	1	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	1	;	Vy	=	1	;	Dx	=	-1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	1	;	Vy	=	0	;	Dx	=	-1	;	Dy	=	1	;	end
            endcase
            0 : case(deg)
                0	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                5	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                10	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                15	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                20	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                25	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                30	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                35	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                40	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                45	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                50	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                55	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	0	;	Dy	=	1	;	end
                60	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                65	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                70	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                75	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                80	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                85	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                90	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                95	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                100	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                105	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                110	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                115	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                120	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                125	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                130	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                135	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                140	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                145	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                150	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                155	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                160	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                165	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                170	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                175	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                180	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                185	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                190	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                195	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                200	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                205	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                210	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                215	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                220	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                225	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                230	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                235	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                240	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                245	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                250	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                255	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                260	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                265	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                270	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                275	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                280	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                285	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                290	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                295	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                300	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                305	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                310	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                315	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                320	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                325	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                330	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                335	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                340	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                345	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                350	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                355	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
                360	:	begin	Vx	=	0	;	Vy	=	0	;	Dx	=	1	;	Dy	=	1	;	end
            endcase
        endcase
    end
endmodule