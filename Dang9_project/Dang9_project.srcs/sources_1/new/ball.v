`include "defines.v"

module ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    output [2:0] ball_rgb
    );

// 시작지점
parameter BA_START_X = `MAX_X/3;
parameter BA_START_Y = `MAX_Y/2;
parameter BB_START_X = `MAX_X/3*2;
parameter BB_START_Y = `MAX_Y/2;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// 공A의 변수
reg signed [1:0] dax, day;
reg signed [4:0] vax, vay;
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
wire ba_bb;
reg [3:0] status;

reg signed [9:0] dx, dy;

reg signed [9:0] vax_p, vay_p;
reg signed [9:0] vbx_p, vby_p;

reg signed [9:0] vax_new, vay_new;
reg signed [9:0] vbx_new, vby_new;


// 공A-테이블 충돌 감지
assign ba_top = (`TABLE_IN_T >= (cay - `BALL_R)) ? 1 : 0;
assign ba_bottom = (`TABLE_IN_B <= (cay + `BALL_R)) ? 1 : 0;
assign ba_left = (`TABLE_IN_L >= (cax - `BALL_R)) ? 1 : 0;
assign ba_right = (`TABLE_IN_R <= (cax + `BALL_R)) ? 1 : 0;

// 공B-테이블 충돌 감지
assign bb_top = (`TABLE_IN_T >= (cby - `BALL_R)) ? 1 : 0;
assign bb_bottom = (`TABLE_IN_B <= (cby + `BALL_R)) ? 1 : 0;
assign bb_left = (`TABLE_IN_L >= (cbx - `BALL_R)) ? 1 : 0;
assign bb_right = (`TABLE_IN_R <= (cbx + `BALL_R)) ? 1 : 0;

// 공A-공B 충돌 감지
assign ba_bb = (`BALL_D*`BALL_D >= (cbx-cax)*(cbx-cax) + (cby-cay)*(cby-cay)) ? 1 : 0;

/*
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        dx <= 0;
        dy <= 0;
        status <= 0;
    end
    else if(ba_bb) begin
        if (cbx-cax >= 0) dx <= cbx-cax;
        else (cbx-cax < 0) dx <= -1*(cbx-cax);
        if (cby-cay >= 0) dy <= cby-cay;
        else (cby-cay < 0) dy <= -1*(cby-cay);
    end 
end


// 충돌 각도가 업데이트 되면 충돌 후 속도 계산
always @ (*) begin
    if(status == 1) begin
    vax_p <= dbx*vbx*`COS(dx) + dby*vby*`SIN(dy);
    vay_p <= day*vay*`COS(dx) - dax*vax*`SIN(dy);
    vbx_p <= dax*vax*`COS(dx) + day*vay*`SIN(dy);
    vby_p <= dby*vby*`COS(dx) - dbx*vbx*`SIN(dy);
    
    vax_new <= vax_p*`COS(dx) - vay_p*`SIN(dy);
    vay_new <= vax_p*`SIN(dy) + vay_p*`COS(dx);
    vbx_new <= vbx_p*`COS(dx) - vby_p*`SIN(dy);
    vby_new <= vbx_p*`SIN(dy) + vby_p*`COS(dx);

    status <= 2;
    end
end
*/

// 공A의 방향
always @(posedge clk or posedge rst) begin
    if(rst) begin
        dax <= 1;
        day <= -1;
    end
    else begin
        if(ba_top) begin
            day <= 1;
        end
        else if (ba_bottom) begin
            day <= -1;
        end
        else if (ba_left) begin
            dax <= 1;
        end
        else if (ba_right) begin 
            dax <= -1;
        end
        else if (ba_bb) begin
            if (cbx-cax >= 0)     dax <= -1;
            else if (cbx-cax < 0) dax <=  1;
            if (cby-cay >= 0)     day <= -1;
            else if (cby-cay < 0) day <=  1;
        end
    end
end

// 공B의 방향
always @(posedge clk or posedge rst) begin
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

// 공A의 속력
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        vax <= 4;
        vay <= 4;
    end
    else if (ba_bb) begin
        vax <= vax_new;
        vay <= vay_new;
    end
end

// 공B의 속력
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        vbx <= 4;
        vby <= 4;
    end
    else if (ba_bb) begin
        vbx <= vbx_new;
        vby <= vby_new;
    end
end

// 공A 최종 속도
always @(posedge clk or posedge rst) begin
    if(rst) begin
        vax_reg <= 0;
        vay_reg <= 0;
    end
    else begin
        vax_reg <= dax*vax;
        vay_reg <= day*vay;
    end
end

// 공B 최종 속도
always @(posedge clk or posedge rst) begin
    if(rst) begin
        vbx_reg <= 0;
        vby_reg <= 0;
    end
    else begin
        vbx_reg <= dbx*vbx;
        vby_reg <= dby*vby;
    end
end

// 공A 중심 좌표 업데이트
always @(posedge clk or posedge rst) begin
    if(rst) begin
        cax <= BA_START_X;
        cay <= BA_START_Y;
    end
    else if(refr_tick) begin
        cax <= cax + vax_reg;
        cay <= cay + vay_reg;
    end
end

// 공B 중심 좌표 업데이트
always @(posedge clk or posedge rst) begin
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