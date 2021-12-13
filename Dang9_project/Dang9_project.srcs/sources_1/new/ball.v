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

// ????????
parameter BA_START_X = `MAX_X/3;
parameter BA_START_Y = `MAX_Y/2;
parameter BB_START_X = `MAX_X/3*2;
parameter BB_START_Y = `MAX_Y/2;

parameter MAX_ba_HIT_FORCE = 12;
parameter MAT_ba_HIT_ANGLE = 360;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// ??A?? ????
wire signed [1:0] dax, day;
reg signed [1:0] dax1, day1; // ???? ????
wire signed [4:0] vax, vay;
reg signed [4:0] vax1, vay1; // ???? ???
reg signed [9:0] vax_reg, vay_reg;
reg [9:0] cax, cay; // ??A ??????
wire ba_top, ba_bottom, ba_left, ba_right; // ??A-????? ?תפ ?¡À???

// ??B?? ????
wire signed [1:0] dbx, dby; 
reg signed [1:0] dbx1, dby1; // ???? ????
wire signed [4:0] vbx, vby;
reg signed [4:0] vbx1, vby1; // ???? ???
reg signed [9:0] vbx_reg, vby_reg;
reg [9:0] cbx, cby; // ??B ??????
wire bb_top, bb_bottom, bb_left, bb_right; // ??B-????? ?תפ ?¡À???

// ?תפ ????
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
// ?תפ ????
//
// <????>
//  ??-????? ?תפ ??? ??A-??B ?תפ?? ????
/*---------------------------------------------------------*/

assign ba_top    = (`TABLE_IN_T >= (cay - `BALL_R)) ? 1 : 0; // ??A-????? ?תפ ????
assign ba_bottom = (`TABLE_IN_B <= (cay + `BALL_R)) ? 1 : 0;
assign ba_left   = (`TABLE_IN_L >= (cax - `BALL_R)) ? 1 : 0;
assign ba_right  = (`TABLE_IN_R <= (cax + `BALL_R)) ? 1 : 0;

assign bb_top    = (`TABLE_IN_T >= (cby - `BALL_R)) ? 1 : 0; // ??B-????? ?תפ ????
assign bb_bottom = (`TABLE_IN_B <= (cby + `BALL_R)) ? 1 : 0;
assign bb_left   = (`TABLE_IN_L >= (cbx - `BALL_R)) ? 1 : 0;
assign bb_right  = (`TABLE_IN_R <= (cbx + `BALL_R)) ? 1 : 0;

assign ba_bb = (`BALL_D*`BALL_D >= (cbx-cax)*(cbx-cax) + (cby-cay)*(cby-cay)) ? 1 : 0; // ??A-??B ?תפ ????

/*---------------------------------------------------------*/
// ??A-??B ?תפ ?? ???
//
// <????>
//  ??A-??B ?תפ ?? ????? ?????? ???????
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

    // ???? ??? ????? ???. ?????? ???? ???
    if (vax_buf[9] == 1'b1) vax_new = -1 * (vax_buf/12);
    else vax_new = (vax_buf/12);
    if (vay_buf[9] == 1'b1) vay_new = -1 * (vay_buf/12);
    else vay_new = (vay_buf/12);
    if (vbx_buf[9] == 1'b1) vbx_new = -1 * (vbx_buf/12);
    else vbx_new = (vbx_buf/12);
    if (vby_buf[9] == 1'b1) vby_new = -1 * (vby_buf/12);
    else vby_new = (vby_buf/12);

    //??? ????
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
// ??A ???
//
// <????>
//  ??¬Ö? ?????? ??A?? ???. ?©£??? ???? ??A?? ????? ???? ??????? ???? ????.
//
// <?????>
//  KEY[1] : ??©£? ???????? ???? ???
//  KEY[7] : ?©£? ???????? ???? ???
//  KEY[4] : ??? ??(???) ?????
//  KEY[0] : ??A ???
//
// <NOTE>
//  ??? ???? ???? ??????? ????
//  ??????? : 0??
//  ???? ???? ?????? deg_set????? ???? ???? ????? ???
/*---------------------------------------------------------*/
reg [6:0] cnt1, cnt2, cnt3; // ? ??? ????
reg [5:0] ba_hit_force_t, ba_hit_force;
reg [8:0] ba_hit_angle_t, ba_hit_angle;

always @(posedge clk or posedge rst) begin // ??? ?? ???????
   if(rst) begin
       ba_hit_force <= 0;
   end
   else if(refr_tick) begin
        if(key == 5'h14) begin // 4????? ?????? ?????? ??? ???? ¨¨??
            if(ba_hit_force_t < MAX_ba_HIT_FORCE && cnt1 > 5) begin
                ba_hit_force_t <= ba_hit_force_t + 1;
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (cnt2 == 20 && ba_hit_force > 0) begin // ??? ???? 0 ?????? ????????? ??????
            ba_hit_force <= ba_hit_force - 1;
            cnt2 <= 0;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
   end
   else if(key_pulse == 5'h10) begin // ?????
        ba_hit_force <= ba_hit_force_t;
        ba_hit_force_t <= 0;
   end
end

always @(posedge clk or posedge rst) begin // ??? ???? ???????
    if(rst) begin
        ba_hit_angle <= 0;
    end
    else if (refr_tick) begin
        if (key == 5'h11) begin // 1??? ?????? ?????? ???? ????
            if (cnt3 > 3) begin
                if (ba_hit_angle_t < 360) begin
                    ba_hit_angle_t <= ba_hit_angle_t + 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 360) begin // ???? ?????? 360????? 0???? ???
                    ba_hit_angle_t <= 0;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
        if (key == 5'h17) begin // 7??? ?????? ?????? ???? ????
            if (cnt3 > 3) begin
                if (ba_hit_angle_t > 0) begin
                    ba_hit_angle_t <= ba_hit_angle_t - 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 0) begin // ???? ?????? 0????? 360???? ???
                    ba_hit_angle_t <= 360;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
    end 
    else if(key_pulse == 5'h10) begin // ?????
        ba_hit_angle <= ba_hit_angle_t;
        ba_hit_angle_t <= 0;
    end
end

deg_set deg_set_ba (ba_hit_force, ba_hit_angle, vax, vay, dax, day); // ??? ???? ?????? ???? ????? ???

/*---------------------------------------------------------*/
// ??A-??B ?תפ ?? ??B?? ???
//
// <????>
//  ??A-??B ?תפ ?? ??B ??? ???????
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
        bb_hit_angle <= ba_hit_angle;
    end
end

deg_set deg_set_bb (bb_hit_force, bb_hit_angle, vbx, vby, dbx, dby); // ?תפ ?? ??B?? ??? ???????

/*---------------------------------------------------------*/
// ??A?? ???
//
// <????>
//  ????? ????? ?????? ????. 
//  ????? ????? ????? ???? ????? ??A?? ?????? ???????
/*---------------------------------------------------------*/
reg ba_collision;

always @(posedge clk or posedge rst) begin // ??A?? ????
    if(rst | key_pulse == 5'h10) begin 
        dax1 <= 0;
        day1 <= 0;
        ba_collision <= 0;
    end
    else begin
        if(ba_top) begin // ????? ???? ?תפ
            day1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_bottom) begin  // ????? ????? ?תפ
            day1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_left) begin // ????? ???? ?תפ
            dax1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_right) begin // ????? ?????? ?תפ
            dax1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_bb) begin // ??B?? ?תפ
            if (cbx-cax >= 0)     dax1 <= -1;
            else if (cbx-cax < 0) dax1 <=  1;
            if (cby-cay >= 0)     day1 <= -1;
            else if (cby-cay < 0) day1 <=  1;
            ba_collision <= 1;
        end
        else if(ba_collision == 0) begin // deg_set???? ?????? ?????? ?????
            dax1 <= dax;
            day1 <= day;
        end
    end
end

always @ (posedge clk or posedge rst) begin // ??A?? ???
    if(rst) begin
        vax1 <= 0;
        vay1 <= 0;
    end
    else begin
        vax1 <= vax;
        vay1 <= vay;
    end
end

always @(posedge clk or posedge rst) begin // ??A ???? ???
    if(rst) begin
        vax_reg <= 0;
        vay_reg <= 0;
    end
    else begin
        vax_reg <= dax1*vax1;
        vay_reg <= day1*vay1;
    end
end

always @(posedge clk or posedge rst) begin // ??A ??? ??? ???????
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
// ??B?? ???
//
// <????>
//  ????? ????? ?????? ????. 
//  ????? ????? ????? ???? ????? ??B?? ?????? ???????
/*---------------------------------------------------------*/
reg bb_collision;

always @(posedge clk or posedge rst) begin // ??B?? ????
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
        else if (ba_bb) begin // ??B?? ?תפ
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

always @ (posedge clk or posedge rst) begin // ??B?? ???
    if(rst) begin
        vbx1 <= 0;
        vby1 <= 0;
    end
    else begin
        vbx1 <= vbx;
        vby1 <= vby;
    end
end

always @(posedge clk or posedge rst) begin // ??B ???? ???
    if(rst) begin
        vbx_reg <= 0;
        vby_reg <= 0;
    end
    else begin
        vbx_reg <= dbx1*vbx1;
        vby_reg <= dby1*vby1;
    end
end

always @(posedge clk or posedge rst) begin // ??B ??? ??? ???????
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
// ???? BALL_R ????
/*---------------------------------------------------------*/
parameter HOLE_CA_X = 40;
parameter HOLE_CA_Y = 40;
parameter HOLE_CB_X = 600;
parameter HOLE_CB_Y = 40;
parameter HOLE_CC_X = 40;
parameter HOLE_CC_Y = 440;
parameter HOLE_CD_X = 600;
parameter HOLE_CD_Y = 440;

reg ha_ba, ha_bb;
reg hb_ba, hb_bb;
reg hc_ba, hc_bb;
reg hd_ba, hd_bb;

always @(posedge clk or posedge rst) begin
    if (rst) begin

    end
    else begin
        ha_ba = (50*50 >= (HOLE_CA_X-cax)*(HOLE_CA_X-cax) + (HOLE_CA_Y-cay)*(HOLE_CA_Y-cay)) ? 1 : 0; // holeA-ballaA ?תפ ????
        ha_bb = (50*50 >= (HOLE_CA_X-cbx)*(HOLE_CA_X-cbx) + (HOLE_CA_Y-cby)*(HOLE_CA_Y-cby)) ? 1 : 0; // holeA-ballaB ?תפ ????
        //if(ha_ba || ha_bb ) ba_bb = 1; //Just test
    end
end

/*---------------------------------------------------------*/
// ??A, B ?????
/*---------------------------------------------------------*/
assign ball_rgb[0] = (`BALL_R*`BALL_R >= (x-cax)*(x-cax) + (y-cay)*(y-cay)) ? 1 : 0;
assign ball_rgb[1] = (`BALL_R*`BALL_R >= (x-cbx)*(x-cbx) + (y-cby)*(y-cby)) ? 1 : 0;
assign ball_rgb[2] = (ba_bb || ha_ba || ha_bb); // ??A-??B ?תפ?? ?????? ???? ??? (???)

endmodule 