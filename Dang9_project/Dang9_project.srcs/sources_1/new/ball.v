`include "defines.v"

module ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    input [4:0] key, 
    input [4:0] key_pulse, 

    output [8:0] ball_rgb
    );

// 시작지점
parameter BA_START_X = `MAX_X/3;
parameter BA_START_Y = `MAX_Y/2;
parameter BB_START_X = `MAX_X/3*2;
parameter BB_START_Y = `MAX_Y/2;

parameter MAX_ba_HIT_FORCE = 12;
parameter MAT_ba_HIT_ANGLE = 360;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// 공A의 변수
wire signed [1:0] dax, day;
reg signed [1:0] dax1, day1;  // 최종 방향
wire signed [4:0] vax, vay;
reg signed [4:0] vax1, vay1;  // 최종 속도
reg signed [9:0] vax_reg, vay_reg;
reg [9:0] cax, cay; // 공A 중심좌표
wire ba_top, ba_bottom, ba_left, ba_right;  // 공A-테이블 충돌 플래그

// 공B의 변수
wire signed [1:0] dbx, dby; 
reg signed [1:0] dbx1, dby1; // 최종 방향
wire signed [4:0] vbx, vby;
reg signed [4:0] vbx1, vby1;// 최종 속도
reg signed [9:0] vbx_reg, vby_reg;
reg [9:0] cbx, cby; // 공B 중심좌표
wire bb_top, bb_bottom, bb_left, bb_right;  // 공B-테이블 충돌 플래그

// 충돌 변수
wire ba_bb;
reg state;
/*
reg [9:0] dx, dy;

reg [9:0] vax_p, vay_p;
reg [9:0] vbx_p, vby_p;

reg [9:0] vax_buf, vay_buf;
reg [9:0] vbx_buf, vby_buf;

reg [9:0] vax_new, vay_new;
reg [9:0] vbx_new, vby_new;
*/

/*---------------------------------------------------------*/
// 충돌 감지
//
// <설명>
//  공-테이블 충돌 또는 공A-공B 충돌을 감지
/*---------------------------------------------------------*/

assign ba_top    = (`TABLE_IN_T >= (cay - `BALL_R)) ? 1 : 0;  // 공A-테이블 충돌 감지
assign ba_bottom = (`TABLE_IN_B <= (cay + `BALL_R)) ? 1 : 0;
assign ba_left   = (`TABLE_IN_L >= (cax - `BALL_R)) ? 1 : 0;
assign ba_right  = (`TABLE_IN_R <= (cax + `BALL_R)) ? 1 : 0;

assign bb_top    = (`TABLE_IN_T >= (cby - `BALL_R)) ? 1 : 0;// 공B-테이블 충돌 감지
assign bb_bottom = (`TABLE_IN_B <= (cby + `BALL_R)) ? 1 : 0;
assign bb_left   = (`TABLE_IN_L >= (cbx - `BALL_R)) ? 1 : 0;
assign bb_right  = (`TABLE_IN_R <= (cbx + `BALL_R)) ? 1 : 0;

assign ba_bb = (`BALL_D*`BALL_D >= (cbx-cax)*(cbx-cax) + (cby-cay)*(cby-cay)) ? 1 : 0;  // 공A-공B 충돌 감지

/*---------------------------------------------------------*/
// 공A-공B 충돌 후 속도
//
// <설명>
//  공A-공B 충돌 후 속도를 계산하고 업데이트
/*---------------------------------------------------------*/
/*
always @ (*) begin 
    if(ba_bb && state == 0) begin
    vax_p = dbx*vbx*(cbx-cax) + dby*vby*(cby-cay);
    vay_p = day*vay*(cbx-cax) - dax*vax*(cby-cay);
    vbx_p = dax*vax*(cbx-cax) + day*vay*(cby-cay);
    vby_p = dby*vby*(cbx-cax) - dbx*vbx*(cby-cay);
   
    vax_buf = vax_p*(cbx-cax) - vay_p*(cby-cay);
    vay_buf = vax_p*(cby-cay) + vay_p*(cbx-cax);
    vbx_buf = vbx_p*(cbx-cax) - vby_p*(cby-cay);
    vby_buf = vbx_p*(cby-cay) + vby_p*(cbx-cax);

    // 음의 속도 양수로 변환. 방향은 따로 처리
    if (vax_buf[9] == 1'b1) vax_new = -1 * (vax_buf/12);
    else vax_new = (vax_buf/12);
    if (vay_buf[9] == 1'b1) vay_new = -1 * (vay_buf/12);
    else vay_new = (vay_buf/12);
    if (vbx_buf[9] == 1'b1) vbx_new = -1 * (vbx_buf/12);
    else vbx_new = (vbx_buf/12);
    if (vby_buf[9] == 1'b1) vby_new = -1 * (vby_buf/12);
    else vby_new = (vby_buf/12);

    //속도 제한
    if (vax_new > 12) vax_new = 12;
    if (vay_new > 12) vay_new = 12;
    if (vbx_new > 12) vbx_new = 12;
    if (vby_new > 12) vby_new = 12;

    state = 1;
    end
    else if (ba_bb == 0 && state == 1) begin
        state = 0;
    end
end
*/

/*---------------------------------------------------------*/
// 공A 발사
//
// <설명>
//  키패드를 이용하여 공A를 발사. 시간에 따라 공A의 속력은 점점 감소하고 결국은 정지.
//
// <조작법>
//  KEY[1] : 반시계 방향으로 각도 회전
//  KEY[7] : 시계 방향으로 각도 회전
//  KEY[4] : 치는 힘(속력) 충전?
//  KEY[0] : 공A 발사
//
// <NOTE>
//  치는 힘은 공의 속력으로 치환됨
//  시작각도 : 0도
//  입력된 힘과 각도는 deg_set모듈을 통해 공의 속도로 변환
/*---------------------------------------------------------*/
reg [6:0] cnt1, cnt2, cnt3;  // 키 입력 감도
reg [5:0] ba_hit_force_t, ba_hit_force;
reg [8:0] ba_hit_angle_t, ba_hit_angle;

always @(posedge clk or posedge rst) begin // 치는 힘 업데이트
   if(rst) begin
       ba_hit_force <= 0;
   end
   else if(refr_tick) begin
        //추후에 여기에 if(status != Player2)
        if(key == 5'h14) begin// 4번키를 누르고 있으면 치는 힘이 커짐
            if(ba_hit_force_t < MAX_ba_HIT_FORCE && cnt1 > 5) begin
                ba_hit_force_t <= ba_hit_force_t + 1;
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (cnt2 == 20 && ba_hit_force > 0) begin// 치는 힘이 0 이상이면 주기적으로 줄어들음
            ba_hit_force <= ba_hit_force - 1;
            cnt2 <= 0;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
   end
   else if(key_pulse == 5'h10) begin // 공쏘기
        ba_hit_force <= ba_hit_force_t;
        ba_hit_force_t <= 0;
   end
end

always @(posedge clk or posedge rst) begin// 치는 각도 업데이트
    if(rst) begin
        ba_hit_angle <= 0;
    end
    else if (refr_tick) begin
        if (key == 5'h11) begin // 1번키 누르고 있으면 각도 증가
            if (cnt3 > 3) begin
                if (ba_hit_angle_t < 360) begin
                    ba_hit_angle_t <= ba_hit_angle_t + 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 360) begin // 현재 각도가 360도이면 0도로 변환
                    ba_hit_angle_t <= 0;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
        if (key == 5'h17) begin  // 7번키 누르고 있으면 각도 감소
            if (cnt3 > 3) begin
                if (ba_hit_angle_t > 0) begin
                    ba_hit_angle_t <= ba_hit_angle_t - 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 0) begin // 현재 각도가 0도이면 360도로 변환
                    ba_hit_angle_t <= 360;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
    end 
    else if(key_pulse == 5'h10) begin // 공쏘기
        ba_hit_angle <= ba_hit_angle_t;
        ba_hit_angle_t <= 0;
    end
end

deg_set deg_set_ba (ba_hit_force, ba_hit_angle, vax, vay, dax, day);// 치는 힘과 각도를 받아서 공속도 출력

/*---------------------------------------------------------*/
// 공A-공B 충돌 후 공B의 속도
//
// <설명>
//  공A-공B 충돌 후 공B 속도 업데이트
/*---------------------------------------------------------*/
reg [5:0] bb_hit_force_t, bb_hit_force;
reg [8:0] bb_hit_angle_t, bb_hit_angle;
reg [5:0] cnt5;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bb_hit_force <= 0;
        bb_hit_angle <= 0;
    end
    else if (ba_bb) begin
        bb_hit_force <= ba_hit_force;
        bb_hit_angle <= ba_hit_angle;
    end
    else if (refr_tick) begin
        if (cnt5 == 20 && bb_hit_force > 0) begin
            bb_hit_force <= bb_hit_force - 1;
            cnt5 <= 0;
        end
        else begin
            cnt5 <= cnt5 + 1;
        end
    end
end

deg_set deg_set_bb (bb_hit_force, bb_hit_angle, vbx, vby, dbx, dby); // 치는 힘과 각도를 받아서 공속도 출력

/*---------------------------------------------------------*/
// 공A의 위치
//
// <설명>
//  방향과 속력을 나누어서 관리. 
//  방향과 속력을 곱해서 구한 속도로 공A의 중심좌표 업데이트
/*---------------------------------------------------------*/
reg ba_collision;

always @(posedge clk or posedge rst) begin // 공A의 방향
    if(rst | key_pulse == 5'h10) begin 
        dax1 <= 0;
        day1 <= 0;
        ba_collision <= 0;
    end
    else begin
        if(ba_top) begin // 테이블 위쪽 충돌
            day1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_bottom) begin   // 테이블 아래쪽 충돌
            day1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_left) begin // 테이블 왼쪽 충돌
            dax1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_right) begin // 테이블 오른쪽 충돌
            dax1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_bb) begin // 공B와 충돌
            if (cbx-cax >= 0)     dax1 <= -1;
            else if (cbx-cax < 0) dax1 <=  1;
            if (cby-cay >= 0)     day1 <= -1;
            else if (cby-cay < 0) day1 <=  1;
            ba_collision <= 1;
        end
        else if(ba_collision == 0) begin// deg_set에서 출력하는 방향을 넣어줌
            dax1 <= dax;
            day1 <= day;
        end
    end
end

always @ (posedge clk or posedge rst) begin // 공A의 속력
    if(rst) begin
        vax1 <= 0;
        vay1 <= 0;
    end
    else begin
        vax1 <= vax;
        vay1 <= vay;
    end
end

always @(posedge clk or posedge rst) begin // 공A 최종 속도
    if(rst) begin
        vax_reg <= 0;
        vay_reg <= 0;
    end
    else begin
        vax_reg <= dax1*vax1;
        vay_reg <= day1*vay1;
    end
end

always @(posedge clk or posedge rst) begin // 공A 중심 좌표 업데이트
    if(rst) begin
        cax <= BA_START_X;
        cay <= BA_START_Y;
    end
    else if(refr_tick) begin
        cax <= cax + vax_reg;
        cay <= cay + vay_reg;
    end
end

/*---------------------------------------------------------*/
// 공B의 위치
//
// <설명>
//  방향과 속력을 나누어서 관리. 
//  방향과 속력을 곱해서 구한 속도로 공B의 중심좌표 업데이트
/*---------------------------------------------------------*/
reg bb_collision;

always @(posedge clk or posedge rst) begin // 공B의 방향
    if(rst) begin
        dbx1 <= 0;
        dby1 <= 0;
    end
    else begin
        if(bb_top) begin
            dby1 <= 1;
        end
        else if (bb_bottom) begin
            dby1 <= -1;
        end
        else if (bb_left) begin
            dbx1 <= 1;
        end
        else if (bb_right) begin 
            dbx1 <= -1;
        end
        else if (ba_bb) begin // ??B?? ?浹
            if (cbx-cax >= 0)     dbx1 <=  1;
            else if (cbx-cax < 0) dbx1 <= -1;
            if (cby-cay >= 0)     dby1 <=  1;
            else if (cby-cay < 0) dby1 <= -1;
        end
    end
end

reg [2:0] flag;
reg [4:0] cnt4;
reg [4:0] ratio;

always @ (posedge clk or posedge rst) begin // 공B의 속력
    if(rst) begin
        vbx1 <= 0;
        vby1 <= 0;
    end
    else begin
        vbx1 <= vbx;
        vby1 <= vby;
    end
end

always @(posedge clk or posedge rst) begin// 공B 최종 속도
    if(rst) begin
        vbx_reg <= 0;
        vby_reg <= 0;
    end
    else begin
        vbx_reg <= dbx1*vbx1;
        vby_reg <= dby1*vby1;
    end
end

always @(posedge clk or posedge rst) begin // 공B 중심 좌표 업데이트
    if(rst) begin
        cbx <= BB_START_X;
        cby <= BB_START_Y;
    end
    else if(refr_tick) begin
        cbx <= cbx + vbx_reg;
        cby <= cby + vby_reg;
    end
end

/*---------------------------------------------------------*/
// HOLE A, B, C, D
/*---------------------------------------------------------*/
parameter HOLE_CA_X = 40;
parameter HOLE_CA_Y = 40;
parameter HOLE_CB_X = 600;
parameter HOLE_CB_Y = 40;
parameter HOLE_CC_X = 40;
parameter HOLE_CC_Y = 440;
parameter HOLE_CD_X = 600;
parameter HOLE_CD_Y = 440;
parameter HOLE_SIZE = 30;

reg ha_ba, ha_bb;
reg hb_ba, hb_bb;
reg hc_ba, hc_bb;
reg hd_ba, hd_bb;

reg Ball_a_Hole_Flag, Ball_b_Hole_Flag;


always @(posedge clk or posedge rst) begin
    if (rst) begin

    end
    else begin
        ha_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CA_X-cbx)*(HOLE_CA_X-cbx) + (HOLE_CA_Y-cby)*(HOLE_CA_Y-cby)) ? 1 : 0; // holeA-ballaB ?浹 ????
        hb_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CB_X-cax)*(HOLE_CB_X-cax) + (HOLE_CB_Y-cay)*(HOLE_CB_Y-cay)) ? 1 : 0; // holeA-ballaA ?浹 ????
        hb_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CB_X-cbx)*(HOLE_CB_X-cbx) + (HOLE_CB_Y-cby)*(HOLE_CB_Y-cby)) ? 1 : 0; // holeA-ballaB ?浹 ????
        hc_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CC_X-cax)*(HOLE_CC_X-cax) + (HOLE_CC_Y-cay)*(HOLE_CC_Y-cay)) ? 1 : 0; // holeA-ballaA ?浹 ????
        hc_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CC_X-cbx)*(HOLE_CC_X-cbx) + (HOLE_CC_Y-cby)*(HOLE_CC_Y-cby)) ? 1 : 0; // holeA-ballaB ?浹 ????
        hd_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CD_X-cax)*(HOLE_CD_X-cax) + (HOLE_CD_Y-cay)*(HOLE_CD_Y-cay)) ? 1 : 0; // holeA-ballaA ?浹 ????
        hd_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CD_X-cbx)*(HOLE_CD_X-cbx) + (HOLE_CD_Y-cby)*(HOLE_CD_Y-cby)) ? 1 : 0; // holeA-ballaB ?浹 ????

        Ball_a_Hole_Flag = (ha_ba || hb_ba || hc_ba || hd_ba);
        Ball_b_Hole_Flag = (ha_bb || hb_bb || hc_bb || hd_bb);
    end
end

/*---------------------------------------------------------*/
// CUE
/*---------------------------------------------------------*/
wire [9:0] cue_x2, cue_y2;
parameter CUE_BALL_SIZE = 5;
cue_deg cue_deg_init (ba_hit_angle_t, cax, cay, cue_x2, cue_y2); //


/*---------------------------------------------------------*/
// FSM
/*---------------------------------------------------------*/
parameter Player1 = 0;
parameter Player1_play = 1;
parameter Player2 = 2;
parameter Player2_play = 3;
parameter Player1_win = 4;
parameter Player2_win = 5;

reg [4:0] status;
reg [5:0] ba_hit_force_Buf;
reg [8:0] ba_hit_angle_Buf;
reg [5:0] bb_hit_force_Buf;
reg [8:0] bb_hit_angle_Buf;

reg cue_1_flag, cue_2_flag;

reg Player1_win_FLAG, Player2_win_FLAG;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        status = Player1;
        Player1_win_FLAG = 0;
        Player2_win_FLAG = 0;
        cue_1_flag = 0;
    end
    else begin
        case(status)
            Player1 : begin
                if(key_pulse == 5'h10) status <= Player1_play;
                 cue_1_flag <= 1;
            end
            Player1_play : begin
                cue_1_flag <= 0;
                if(Ball_a_Hole_Flag)begin
                    status <= Player2_win;
                end
                else if(Ball_b_Hole_Flag)begin
                    status <= Player1_win;
                end
                else if((vax1 == 0) && (vay1 == 0) && (vbx1 == 0) && (vby1 == 0)) begin
                    status <= Player1;
                end
            end
            /*
            Player2 : begin
                //deg_set_ba의 INPUT인자를 ba_hit_force_Buf, ba_hit_angle_Buf로 변경
                ba_hit_force_Buf = 0;
                ba_hit_angle_Buf = 0;
                //deg_set_bb의 INPUT인자를 bb_hit_force_Buf, bb_hit_angle_Buf로 변경
                bb_hit_force_Buf = bb_hit_force;
                bb_hit_angle_Buf = bb_hit_angle;

                if(key_pulse == 5'h10) begin
                    status = Player2_play;
                end
            end
            Player2_play : begin
                if(Ball_a_Hole_Flag)begin
                    status = Player1_win;
                end
                else if(Ball_b_Hole_Flag)begin
                    status = Player2_win;
                end
                if((vax1 == 0) && (vay1 == 0) && (vbx1 == 0) && (vby1 == 0)) begin
                    status = Player1;
                end
            end
            */
            Player1_win : begin
                Player1_win_FLAG <= 1;
            end
            Player2_win : begin
                Player2_win_FLAG <= 1;
            end
        endcase
    end
end
/*---------------------------------------------------------*/
// 공A, B, Hole, 큐대 그리기
/*---------------------------------------------------------*/
assign ball_rgb[0] = (`BALL_R*`BALL_R >= (x-cax)*(x-cax) + (y-cay)*(y-cay)) ? 1 : 0;
assign ball_rgb[1] = (`BALL_R*`BALL_R >= (x-cbx)*(x-cbx) + (y-cby)*(y-cby)) ? 1 : 0;
assign ball_rgb[2] = (ba_bb || Player1_win_FLAG || Player1_win_FLAG); // Flag indicate


assign ball_rgb[3] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CA_X)*(x - HOLE_CA_X) + (y - HOLE_CA_Y)*(y - HOLE_CA_Y)) ? 1 : 0;
assign ball_rgb[4] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CB_X)*(x - HOLE_CB_X) + (y - HOLE_CB_Y)*(y - HOLE_CB_Y)) ? 1 : 0;
assign ball_rgb[5] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CC_X)*(x - HOLE_CC_X) + (y - HOLE_CC_Y)*(y - HOLE_CC_Y)) ? 1 : 0;
assign ball_rgb[6] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CD_X)*(x - HOLE_CD_X) + (y - HOLE_CD_Y)*(y - HOLE_CD_Y)) ? 1 : 0;
assign ball_rgb[7] = (cue_1_flag == 1) ? ((CUE_BALL_SIZE * CUE_BALL_SIZE >= (x - cue_x2)*(x - cue_x2) + (y - cue_y2)*(y - cue_y2)) ? 1 : 0) : 0;
//assign ball_rgb[7] = cue_1_flag;
endmodule 