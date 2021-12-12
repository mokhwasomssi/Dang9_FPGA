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

parameter MAX_HIT_FORCE = 12;
parameter MAT_HIT_ANGLE = 360;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// 공A의 변수
wire signed [1:0] dax, day;
reg signed [1:0] dax1, day1; // 테이블 충돌시 방향 업데이트
wire signed [4:0] vax, vay;
reg signed [4:0] vax1, vay1;
reg signed [9:0] vax_reg, vay_reg;
reg [9:0] cax, cay; // 공A 중심좌표
wire ba_top, ba_bottom, ba_left, ba_right; // 공A-테이블 충돌 플래그

// 공B의 변수
reg signed [1:0] dbx, dby;
reg signed [4:0] vbx, vby;
reg signed [9:0] vbx_reg, vby_reg;
reg [9:0] cbx, cby; // 공B 중심좌표
wire bb_top, bb_bottom, bb_left, bb_right; // 공B-테이블 충돌 플래그

// 충돌 변수
/*
wire ba_bb;
reg state;

reg signed [9:0] dx, dy;

reg signed [9:0] vax_p, vay_p;
reg signed [9:0] vbx_p, vby_p;

reg signed [9:0] vax_buf, vay_buf;
reg signed [9:0] vbx_buf, vby_buf;

reg signed [9:0] vax_new, vay_new;
reg signed [9:0] vbx_new, vby_new;
*/

/*---------------------------------------------------------*/
// 충돌 감지
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

// 공A-공B 충돌 후 속력
/*
always @ (*) begin 
    if(ba_bb && state == 0) begin
    vax_p = dbx*vbx*((cbx-cax)/24) + dby*vby*((cby-cay)/24);
    vay_p = day*vay*((cbx-cax)/24) - dax*vax*((cby-cay)/24);
    vbx_p = dax*vax*((cbx-cax)/24) + day*vay*((cby-cay)/24);
    vby_p = dby*vby*((cbx-cax)/24) - dbx*vbx*((cby-cay)/24);
    
    vax_buf = vax_p*((cbx-cax)/24) - vay_p*((cby-cay)/24);
    vay_buf = vax_p*((cby-cay)/24) + vay_p*((cbx-cax)/24);
    vbx_buf = vbx_p*((cbx-cax)/24) - vby_p*((cby-cay)/24);
    vby_buf = vbx_p*((cby-cay)/24) + vby_p*((cbx-cax)/24);

    // 음의 속도 양수로 변환. 방향은 따로 처리
    if (vax_buf[9] == 1'b1) vax_new = -1 * vax_buf;
    else vax_new = vax_buf;
    if (vay_buf[9] == 1'b1) vay_new = -1 * vay_buf;
    else vay_new = vay_buf;
    if (vbx_buf[9] == 1'b1) vbx_new = -1 * vbx_buf;
    else vbx_new = vbx_buf;
    if (vby_buf[9] == 1'b1) vby_new = -1 * vby_buf;
    else vby_new = vby_buf;
    
    state = 1;
    
    end
    else if (ba_bb == 0 && state == 1) begin
        state = 0;
    end
end
*/

/*---------------------------------------------------------*/
// 공A의 위치
/*---------------------------------------------------------*/
reg [6:0] cnt1;
reg [6:0] cnt2;
reg [6:0] cnt3;
reg [5:0] hit_force_t;
reg [5:0] hit_force;
reg [8:0] hit_angle_t;
reg [8:0] hit_angle;

always @(posedge clk or posedge rst) begin // 치는 힘 업데이트
   if(rst) begin
       hit_force <= 0;
   end
   else if(refr_tick) begin
        if(key == 5'h14) begin // 4번키를 누르고 있으면 치는 힘이 커짐
            if(hit_force_t < MAX_HIT_FORCE && cnt1 > 5) begin
                hit_force_t <= hit_force_t + 1;
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (cnt2 == 20 && hit_force > 0) begin // 치는 힘이 0 이상이면 주기적으로 줄어들음
            hit_force <= hit_force - 1;
            cnt2 <= 0;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
   end
   else if(key_pulse == 5'h10) begin// 0번키를 누르면 치는 힘 인가
        hit_force <= hit_force_t;
        hit_force_t <= 0;
   end
end

always @(posedge clk or posedge rst) begin // 치는 각도 업데이트
    if(rst) begin
        hit_angle <= 0;
    end
    else if (refr_tick) begin
        if (key == 5'h11) begin // 1번키 누르고 있으면 각도 증가
            if (hit_angle_t < 360 && cnt3 > 5) begin
                hit_angle_t <= hit_angle_t + 5;
                cnt3 <= 0;
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
        if (key == 5'h17) begin // 7번키 누르고 있으면 각도 감소
            if (hit_angle_t > 0 && cnt3 > 5) begin
                hit_angle_t <= hit_angle_t - 5;
                cnt3 <= 0;
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
    end 
    else if(key_pulse == 5'h10) begin// 0번키를 누르면 치는 힘 인가
        hit_angle <= hit_angle_t;
        hit_angle_t <= 0;
    end
end

deg_set deg_set_inst (hit_force, hit_angle, vax, vay, dax, day); // 공속도 출력

reg collision;

always @(posedge clk or posedge rst) begin // 공A의 방향
    if(rst | key_pulse == 5'h10) begin 
        dax1 <= 0;
        day1 <= 0;
        collision <= 0;
    end
    else begin
        if(ba_top) begin
            day1 <= 1;
            collision <= 1;
        end
        else if (ba_bottom) begin
            day1 <= -1;
            collision <= 1;
        end
        else if (ba_left) begin
            dax1 <= 1;
            collision <= 1;
        end
        else if (ba_right) begin 
            dax1 <= -1;
            collision <= 1;
        end
        else if(collision == 0)begin
            dax1 <= dax;
            day1 <= day;
        end
        /*
        else if (ba_bb) begin
            if (cbx-cax >= 0)     dax <= -1;
            else if (cbx-cax < 0) dax <=  1;
            if (cby-cay >= 0)     day <= -1;
            else if (cby-cay < 0) day <=  1;
        end
        */
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

always @ (posedge clk or posedge rst) begin // 공B의 속력
    if(rst) begin
        vbx <= 0;
        vby <= 0;
    end
    /*
    else if (state == 1) begin
        vbx <= vbx_new;
        vby <= vby_new;
    end
    */
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


// 공 그리기
assign ball_rgb[0] = (`BALL_R*`BALL_R >= (x-cax)*(x-cax) + (y-cay)*(y-cay)) ? 1 : 0;
assign ball_rgb[1] = (`BALL_R*`BALL_R >= (x-cbx)*(x-cbx) + (y-cby)*(y-cby)) ? 1 : 0;
assign ball_rgb[2] = ba_bb;

endmodule 