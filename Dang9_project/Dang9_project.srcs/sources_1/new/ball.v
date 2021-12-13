`include "defines.v"

module ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    input [4:0] key, 
    input [4:0] key_pulse, 

    output [2:0] ball_rgb
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
reg signed [1:0] dax1, day1; // 최종 방향
wire signed [4:0] vax, vay;
reg signed [4:0] vax1, vay1; // 최종 속도
reg signed [9:0] vax_reg, vay_reg;
reg [9:0] cax, cay; // 공A 중심좌표
wire ba_top, ba_bottom, ba_left, ba_right; // 공A-테이블 충돌 플래그

// 공B의 변수
wire signed [1:0] dbx, dby; 
reg signed [1:0] dbx1, dby1; // 최종 방향
wire signed [4:0] vbx, vby;
reg signed [4:0] vbx1, vby1; // 최종 속도
reg signed [9:0] vbx_reg, vby_reg;
reg [9:0] cbx, cby; // 공B 중심좌표
wire bb_top, bb_bottom, bb_left, bb_right; // 공B-테이블 충돌 플래그

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

assign ba_top    = (`TABLE_IN_T >= (cay - `BALL_R)) ? 1 : 0; // 공A-테이블 충돌 감지
assign ba_bottom = (`TABLE_IN_B <= (cay + `BALL_R)) ? 1 : 0;
assign ba_left   = (`TABLE_IN_L >= (cax - `BALL_R)) ? 1 : 0;
assign ba_right  = (`TABLE_IN_R <= (cax + `BALL_R)) ? 1 : 0;

assign bb_top    = (`TABLE_IN_T >= (cby - `BALL_R)) ? 1 : 0; // 공B-테이블 충돌 감지
assign bb_bottom = (`TABLE_IN_B <= (cby + `BALL_R)) ? 1 : 0;
assign bb_left   = (`TABLE_IN_L >= (cbx - `BALL_R)) ? 1 : 0;
assign bb_right  = (`TABLE_IN_R <= (cbx + `BALL_R)) ? 1 : 0;

assign ba_bb = (`BALL_D*`BALL_D >= (cbx-cax)*(cbx-cax) + (cby-cay)*(cby-cay)) ? 1 : 0; // 공A-공B 충돌 감지

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
// 공A-공B 충돌 후 공B의 속도
//
// <설명>
//  공A-공B 충돌 후 공B 속도 업데이트
/*---------------------------------------------------------*/
reg [5:0] bb_hit_force_t, bb_hit_force;
reg [8:0] bb_hit_angle_t, bb_hit_angle;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bb_hit_force <= 0;
        bb_hit_angle <= 0;
    end
    else if (ba_bb) begin
        bb_hit_force <= ba_hit_force;
        bb_hit_angle <= bb_hit_angle;
    end
end

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
reg [6:0] cnt1, cnt2, cnt3; // 키 입력 감도
reg [5:0] ba_hit_force_t, ba_hit_force;
reg [8:0] ba_hit_angle_t, ba_hit_angle;
reg collision;

always @(posedge clk or posedge rst) begin // 치는 힘 업데이트
   if(rst) begin
       ba_hit_force <= 0;
   end
   else if(refr_tick) begin
        if(key == 5'h14) begin // 4번키를 누르고 있으면 치는 힘이 커짐
            if(ba_hit_force_t < MAX_ba_HIT_FORCE && cnt1 > 5) begin
                ba_hit_force_t <= ba_hit_force_t + 1;
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (cnt2 == 20 && ba_hit_force > 0) begin // 치는 힘이 0 이상이면 주기적으로 줄어들음
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

always @(posedge clk or posedge rst) begin // 치는 각도 업데이트
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
        if (key == 5'h17) begin // 7번키 누르고 있으면 각도 감소
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

deg_set deg_set_inst (ba_hit_force, ba_hit_angle, vax, vay, dax, day); // 치는 힘과 각도를 받아서 공속도 출력
deg_set deg_set_inst (bb_hit_force, bb_hit_angle, vbx, vby, dbx, dby); // 충돌 시 공B의 속도 업데이트

/*---------------------------------------------------------*/
// 공A의 위치
//
// <설명>
//  방향과 속력을 나누어서 관리. 
//  방향과 속력을 곱해서 구한 속도로 공A의 중심좌표 업데이트
/*---------------------------------------------------------*/
always @(posedge clk or posedge rst) begin // 공A의 방향
    if(rst | key_pulse == 5'h10) begin 
        dax1 <= 0;
        day1 <= 0;
        collision <= 0;
    end
    else begin
        if(ba_top) begin // 테이블 위쪽 충돌
            day1 <= 1;
            collision <= 1;
        end
        else if (ba_bottom) begin  // 테이블 아래쪽 충돌
            day1 <= -1;
            collision <= 1;
        end
        else if (ba_left) begin // 테이블 왼쪽 충돌
            dax1 <= 1;
            collision <= 1;
        end
        else if (ba_right) begin // 테이블 오른쪽 충돌
            dax1 <= -1;
            collision <= 1;
        end
        else if (ba_bb) begin // 공B와 충돌
            if (cbx-cax >= 0)     dax1 <= -1;
            else if (cbx-cax < 0) dax1 <=  1;
            if (cby-cay >= 0)     day1 <= -1;
            else if (cby-cay < 0) day1 <=  1;
            collision <= 1;
        end
        else if(collision == 0) begin // deg_set에서 출력하는 방향을 넣어줌
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
always @(posedge clk or posedge rst) begin // 공B의 방향
    if(rst) begin
        dbx <= 1;
        dby <= -1;
    end
    else begin
        if(bb_top) begin
            dby <= 1;
        end
        else if (bb_bottom) begin
            dby <= -1;
        end
        else if (bb_left) begin
            dbx <= 1;
        end
        else if (bb_right) begin 
            dbx <= -1;
        end
        else if (ba_bb) begin
            if (cbx-cax >= 0)     dbx <=  1;
            else if (cbx-cax < 0) dbx <= -1;
            if (cby-cay >= 0)     dby <=  1;
            else if (cby-cay < 0) dby <= -1;
        end
    end
end

reg [2:0] flag;
reg [4:0] cnt4;
reg [4:0] ratio;

always @ (posedge clk or posedge rst) begin // 공B의 속력
    if(rst) begin
        vbx <= 0;
        vby <= 0;
    end
    else begin
        vbx1 <= vbx;
        vby1 <= vby;
    end
end

always @(posedge clk or posedge rst) begin // 공B 최종 속도
    if(rst) begin
        vbx_reg <= 0;
        vby_reg <= 0;
    end
    else begin
        vbx_reg <= dbx*vbx;
        vby_reg <= dby*vby;
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
reg [9:0] hole_cax, hole_cay;
reg [9:0] hole_cbx, hole_cby;
reg [9:0] hole_ccx, hole_ccy;
reg [9:0] hole_cdx, hole_cdy;

reg ha_ba, ha_bb;
reg hb_ba, hb_bb;
reg hc_ba, hc_bb;
reg hd_ba, hd_bb;

always @(posedge clk or posedge rst) begin
    ha_ba = (`BALL_D*`BALL_D >= (hole_cax-cax)*(hole_cax-cax) + (hole_cay-cay)*(hole_cay-cay)) ? 1 : 0; // holeA-ballaA 충돌 감지
    ha_bb = (`BALL_D*`BALL_D >= (hole_cax-cbx)*(hole_cax-cbx) + (hole_cay-cby)*(hole_cay-cby)) ? 1 : 0; // holeA-ballaB 충돌 감지
    
    hb_ba = (`BALL_D*`BALL_D >= (hole_cbx-cax)*(hole_cax-cax) + (hole_cby-cay)*(hole_cay-cay)) ? 1 : 0; // holeA-ballaA 충돌 감지
    hb_bb = (`BALL_D*`BALL_D >= (hole_cbx-cbx)*(hole_cax-cbx) + (hole_cby-cby)*(hole_cay-cby)) ? 1 : 0; // holeA-ballaB 충돌 감지

    hc_ba = (`BALL_D*`BALL_D >= (hole_ccx-cax)*(hole_cax-cax) + (hole_ccy-cay)*(hole_cay-cay)) ? 1 : 0; // holeA-ballaA 충돌 감지
    hc_bb = (`BALL_D*`BALL_D >= (hole_ccx-cbx)*(hole_cax-cbx) + (hole_ccy-cby)*(hole_cay-cby)) ? 1 : 0; // holeA-ballaB 충돌 감지
    
    hd_ba = (`BALL_D*`BALL_D >= (hole_cdx-cax)*(hole_cax-cax) + (hole_cdy-cay)*(hole_cay-cay)) ? 1 : 0; // holeA-ballaA 충돌 감지
    hd_bb = (`BALL_D*`BALL_D >= (hole_cdx-cbx)*(hole_cax-cbx) + (hole_cdy-cby)*(hole_cay-cby)) ? 1 : 0; // holeA-ballaB 충돌 감지

    if(ha_ba || ha_bb || hb_ba || hb_bb || hc_ba || hc_bb || hd_ba || hd_bb) ba_bb = 1; //Just test
end

/*---------------------------------------------------------*/
// 공A, B 그리기
/*---------------------------------------------------------*/
assign ball_rgb[0] = (`BALL_R*`BALL_R >= (x-cax)*(x-cax) + (y-cay)*(y-cay)) ? 1 : 0;
assign ball_rgb[1] = (`BALL_R*`BALL_R >= (x-cbx)*(x-cbx) + (y-cby)*(y-cby)) ? 1 : 0;
assign ball_rgb[2] = ba_bb; // 공A-공B 충돌을 확인하기 위한 신호 (임시)

endmodule 