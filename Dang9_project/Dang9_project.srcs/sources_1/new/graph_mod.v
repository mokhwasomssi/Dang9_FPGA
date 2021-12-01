module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [2:0] rgb; 

// VGA resolution : 640x480
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

// table coordinate
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
parameter BALL_SIZE = 24;

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

// 60Hz tick
wire refr_tick; 
assign refr_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; 

// table rgb flag
wire table_out_on, table_in_on;
assign table_out_on = (x >= TABLE_OUT_L && x <= TABLE_OUT_R - 1 && y >= TABLE_OUT_T && y <= TABLE_OUT_B - 1);
assign table_in_on = (x >= TABLE_IN_L && x <= TABLE_IN_R - 1 && y >= TABLE_IN_T && y <= TABLE_IN_B - 1);

// ball variables
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

// collision flag of ball
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

// ball1 coordinate
assign ball1_x_l = ball1_x_reg; // ball1 left coordinate
assign ball1_x_r = ball1_x_reg + BALL_SIZE - 1; // ball1 right coordinate
assign ball1_y_t = ball1_y_reg; // ball1 top coordinate
assign ball1_y_b = ball1_y_reg + BALL_SIZE - 1; // ball1 bottom coordinate

assign ball1_x_c = ball1_x_reg + (BALL_SIZE/2) - 1;
assign ball1_y_c = ball1_y_reg + (BALL_SIZE/2) - 1;

// ball2 coordinate
assign ball2_x_l = ball2_x_reg; // ball2 left coordinate
assign ball2_x_r = ball2_x_reg + BALL_SIZE - 1; // ball2 right coordinate
assign ball2_y_t = ball2_y_reg; // ball2 top coordinate
assign ball2_y_b = ball2_y_reg + BALL_SIZE - 1; // ball2 bottom coordinate

assign ball2_x_c = ball2_x_reg + (BALL_SIZE/2) - 1;
assign ball2_y_c = ball2_y_reg + (BALL_SIZE/2) - 1;

// ball3 coordinate
assign ball3_x_l = ball3_x_reg; // ball3 left coordinate
assign ball3_x_r = ball3_x_reg + BALL_SIZE - 1; // ball3 right coordinate
assign ball3_y_t = ball3_y_reg; // ball3 top coordinate
assign ball3_y_b = ball3_y_reg + BALL_SIZE - 1; // ball3 bottom coordinate

assign ball3_x_c = ball3_x_reg + (BALL_SIZE/2) - 1;
assign ball3_y_c = ball3_y_reg + (BALL_SIZE/2) - 1;

// ball rgb flag
assign ball1_on = (x>=ball1_x_l && x<=ball1_x_r && y>=ball1_y_t && y<=ball1_y_b)? 1 : 0; 
assign ball2_on = (x>=ball2_x_l && x<=ball2_x_r && y>=ball2_y_t && y<=ball2_y_b)? 1 : 0; 
assign ball3_on = (x>=ball3_x_l && x<=ball3_x_r && y>=ball3_y_t && y<=ball3_y_b)? 1 : 0; 

// collision between ball1 and table
assign ball1_reach_top = (TABLE_IN_T >= ball1_y_t) ? 1 : 0;
assign ball1_reach_bottom = (TABLE_IN_B <= ball1_y_b) ? 1 : 0;
assign ball1_reach_left = (TABLE_IN_L >= ball1_x_l) ? 1 : 0;
assign ball1_reach_right = (TABLE_IN_R <= ball1_x_r) ? 1 : 0;

// collision between ball2 and table
assign ball2_reach_top = (TABLE_IN_T >= ball2_y_t) ? 1 : 0;
assign ball2_reach_bottom = (TABLE_IN_B <= ball2_y_b) ? 1 : 0;
assign ball2_reach_left = (TABLE_IN_L >= ball2_x_l) ? 1 : 0;
assign ball2_reach_right = (TABLE_IN_R <= ball2_x_r) ? 1 : 0;

// collision between ball3 and table
assign ball3_reach_top = (TABLE_IN_T >= ball3_y_t) ? 1 : 0;
assign ball3_reach_bottom = (TABLE_IN_B <= ball3_y_b) ? 1 : 0;
assign ball3_reach_left = (TABLE_IN_L >= ball3_x_l) ? 1 : 0;
assign ball3_reach_right = (TABLE_IN_R <= ball3_x_r) ? 1 : 0;


// collision between ball and ball
// L,xC,R, T,yC,B ���? �տ� ���� ������
// ball12_L �̸� Ball2�� Ball1 ���ʿ� ��Ҵٴ�? �ǹ�

//12
assign ball12_L = ((ball1_x_l <= ball2_x_r) && (ball2_x_r <= ball1_x_c)) ? 1 : 0;
assign ball12_xC = ((ball1_x_l + 2*(BALL_SIZE/6) <= ball2_x_c) && (ball2_x_c <= ball1_x_r - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball12_R = ((ball1_x_c <= ball2_x_l) && (ball2_x_l <= ball1_x_r)) ? 1 : 0;

assign ball12_T = ((ball1_y_t <= ball2_y_b) && (ball2_y_b <= ball1_y_c)) ? 1 : 0;
assign ball12_yC = ((ball1_y_t + 2*(BALL_SIZE/6) <= ball2_y_c) && (ball2_y_c <= ball1_y_b - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball12_B = ((ball1_y_c <= ball2_y_t) && (ball2_y_t <= ball1_y_b)) ? 1 : 0;

assign ball12_LTRB = ball12_L && ball12_T;
assign ball12_RTLB = ball12_R && ball12_T;

assign ball12_LBRT = ball12_L && ball12_B;
assign ball12_RBLT = ball12_R && ball12_B;

assign ball12_LCRC = ball12_L && ball12_yC;
assign ball12_RCLC = ball12_R && ball12_yC;

assign ball12_CTCB = ball12_xC && ball12_B;
assign ball12_CBCT = ball12_xC && ball12_T;

//13
assign ball13_L = ((ball1_x_l <= ball3_x_r) && (ball3_x_r <= ball1_x_c)) ? 1 : 0;
assign ball13_xC = ((ball1_x_l + 2*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball1_x_r - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball13_R = ((ball1_x_c <= ball3_x_l) && (ball3_x_l <= ball1_x_r)) ? 1 : 0;

assign ball13_T = ((ball1_y_t <= ball3_y_b) && (ball3_y_b <= ball1_y_c)) ? 1 : 0;
assign ball13_yC = ((ball1_y_t + 2*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball1_y_b - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball13_B = ((ball1_y_c <= ball3_y_t) && (ball3_y_t <= ball1_y_b)) ? 1 : 0;

assign ball13_LTRB = ball13_L && ball13_T;
assign ball13_RTLB = ball13_R && ball13_T;

assign ball13_LBRT = ball13_L && ball13_B;
assign ball13_RBLT = ball13_R && ball13_B;

assign ball13_LCRC = ball13_L && ball13_yC;
assign ball13_RCLC = ball13_R && ball13_yC;

assign ball13_CTCB = ball13_xC && ball13_B;
assign ball13_CBCT = ball13_xC && ball13_T;

//23
assign ball23_L = ((ball2_x_l <= ball3_x_r) && (ball3_x_r <= ball2_x_c)) ? 1 : 0;
assign ball23_xC = ((ball2_x_l + 1*(BALL_SIZE/6) <= ball3_x_c) && (ball3_x_c <= ball2_x_r - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_R = ((ball2_x_c <= ball3_x_l) && (ball3_x_l <= ball2_x_r)) ? 1 : 0;

assign ball23_T = ((ball2_y_t <= ball3_y_b) && (ball3_y_b <= ball2_y_c)) ? 1 : 0;
assign ball23_yC = ((ball2_y_t + 2*(BALL_SIZE/6) <= ball3_y_c) && (ball3_y_c <= ball2_y_b - 2*(BALL_SIZE/6))) ? 1 : 0;
assign ball23_B = ((ball2_y_c <= ball3_y_t) && (ball3_y_t <= ball2_y_b)) ? 1 : 0;

assign ball23_LTRB = ball23_L && ball23_T;
assign ball23_RTLB = ball23_R && ball23_T;

assign ball23_LBRT = ball23_L && ball23_B;
assign ball23_RBLT = ball23_R && ball23_B;

assign ball23_LCRC = ball23_L && ball23_yC;
assign ball23_RCLC = ball23_R && ball23_yC;

assign ball23_CTCB = ball23_xC && ball23_B;
assign ball23_CBCT = ball23_xC && ball23_T;

// update direction and speed of ball1
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        // initial direction and speed
        BALL_1_Dx <= -1;
        BALL_1_Dy <= 1;
        ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
    end
    else begin
        // with table
        if (ball1_reach_top) begin
            BALL_1_Dy <= 1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end 
        else if (ball1_reach_bottom) begin
            BALL_1_Dy <= -1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball1_reach_left) begin
            BALL_1_Dx <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        end
        else if (ball1_reach_right) begin
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
        end //
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

// update direction and speed of ball2
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        // initial direction and speed
        ball2_vx_reg <= BALL_2Vx; 
        ball2_vy_reg <= -1*BALL_2Vy;
    end
    else begin
        // with table
        if (ball2_reach_top) begin
            BALL_2_Dy <= 1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end 
        else if (ball2_reach_bottom) begin
            BALL_2_Dy <= -1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball2_reach_left) begin
            BALL_2_Dx <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
        end
        else if (ball2_reach_right) begin
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

// update direction and speed of ball3
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        // initial direction and speed
        ball3_vx_reg <= BALL_3Vx; 
        ball3_vy_reg <= BALL_3Vy; 
    end
    else begin
        if (ball3_reach_top) begin
            BALL_3_Dy <= 1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end 
        else if (ball3_reach_bottom) begin
            BALL_3_Dy <= -1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball3_reach_left) begin
            BALL_3_Dx <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
        end
        else if (ball3_reach_right) begin
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

// update coordinate of ball1, ball2, ball3 using current speed
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        // start coordinate
        ball1_x_reg <= 150; // ball1
        ball1_y_reg <= MAX_Y/2; 
        ball2_x_reg <= 300; // ball2
        ball2_y_reg <= MAX_Y/2; 
        ball3_x_reg <= 450; // ball3
        ball3_y_reg <= MAX_Y/2;
    end else if (refr_tick) begin
        // update coordinate of ball as 60hz period
        ball1_x_reg <= ball1_x_reg + ball1_vx_reg; // ball1
        ball1_y_reg <= ball1_y_reg + ball1_vy_reg;
        ball2_x_reg <= ball2_x_reg + ball2_vx_reg; // ball2
        ball2_y_reg <= ball2_y_reg + ball2_vy_reg;
        ball3_x_reg <= ball3_x_reg + ball3_vx_reg; // ball3
        ball3_y_reg <= ball3_y_reg + ball3_vy_reg;
    end
end

// cue variables
wire cue_on;
reg [9:0]  cue_x_reg, cue_y_reg;
wire [9:0] cue_x_l, cue_x_r, cue_y_t, cue_y_b;

// cue coordinate
assign cue_x_l = cue_x_r - CUE_X_SIZE;
assign cue_x_r = ball1_x_c - 15;
assign cue_y_t = ball1_y_c - (CUE_Y_SIZE/2);
assign cue_y_b = ball1_y_c + (CUE_Y_SIZE/2);

// cue rgb flag
assign cue_on = ( x>=cue_x_l && x<=cue_x_r && y>=cue_y_t && y<=cue_y_b ) ? 1 : 0; 

// update cue coordinate
always @(posedge clk or posedge rst) begin
    if(rst) begin
        cue_x_reg <= 240;
        cue_y_reg <= 240;
    end
    else if (refr_tick) begin
        cue_x_reg <= 240;
        cue_y_reg <= 240;
    end
end

// final output
assign rgb = (cue_on == 1) ? 3'b011 : // cue : mint
             (ball1_on == 1) ? 3'b111 :  // ball1 : white
             (ball2_on == 1) ? 3'b100 :  // ball2 : red
             (ball3_on == 1) ? 3'b110 :  // ball3 : yellow
             (table_out_on == 1 && table_in_on == 0) ? 3'b111 : 3'b000; // table : white

// angle calculation
// reference of Vx, Vy, dirX, dirY
endmodule