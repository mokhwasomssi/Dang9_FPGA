`include "defines.v"

module ball(
    input clk, 
    input rst,

    input [9:0] x, 
    input [9:0] y, 
    
    input [4:0] key, 
    input [4:0] key_pulse, 

    output [9:0] ball_rgb
    );

// ��������
parameter BA_START_X = `MAX_X/3;
parameter BA_START_Y = `MAX_Y/2;
parameter BB_START_X = `MAX_X/3*2;
parameter BB_START_Y = `MAX_Y/2;

parameter MAX_ba_HIT_FORCE = 12;
parameter MAT_ba_HIT_ANGLE = 360;

// 60Hz clock
wire refr_tick; 
assign refr_tick = (y==`MAX_Y-1 && x==`MAX_X-1)? 1 : 0; 

// ��A�� ����
wire signed [1:0] dax, day;
reg signed [1:0] dax1, day1;  // ���� ����
wire signed [4:0] vax, vay;
reg signed [4:0] vax1, vay1;  // ���� �ӵ�
reg signed [9:0] vax_reg, vay_reg;
reg [9:0] cax, cay; // ��A �߽���ǥ
wire ba_top, ba_bottom, ba_left, ba_right;  // ��A-���̺� �浹 �÷���

// ��B�� ����
wire signed [1:0] dbx, dby; 
reg signed [1:0] dbx1, dby1; // ���� ����
wire signed [4:0] vbx, vby;
reg signed [4:0] vbx1, vby1;// ���� �ӵ�
reg signed [9:0] vbx_reg, vby_reg;
reg [9:0] cbx, cby; // ��B �߽���ǥ
wire bb_top, bb_bottom, bb_left, bb_right;  // ��B-���̺� �浹 �÷���

// �浹 ����
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
// �浹 ����
//
// <����>
//  ��-���̺� �浹 �Ǵ� ��A-��B �浹�� ����
/*---------------------------------------------------------*/

assign ba_top    = (`TABLE_IN_T >= (cay - `BALL_R)) ? 1 : 0;  // ��A-���̺� �浹 ����
assign ba_bottom = (`TABLE_IN_B <= (cay + `BALL_R)) ? 1 : 0;
assign ba_left   = (`TABLE_IN_L >= (cax - `BALL_R)) ? 1 : 0;
assign ba_right  = (`TABLE_IN_R <= (cax + `BALL_R)) ? 1 : 0;

assign bb_top    = (`TABLE_IN_T >= (cby - `BALL_R)) ? 1 : 0;// ��B-���̺� �浹 ����
assign bb_bottom = (`TABLE_IN_B <= (cby + `BALL_R)) ? 1 : 0;
assign bb_left   = (`TABLE_IN_L >= (cbx - `BALL_R)) ? 1 : 0;
assign bb_right  = (`TABLE_IN_R <= (cbx + `BALL_R)) ? 1 : 0;

assign ba_bb = (`BALL_D*`BALL_D >= (cbx-cax)*(cbx-cax) + (cby-cay)*(cby-cay)) ? 1 : 0;  // ��A-��B �浹 ����

/*---------------------------------------------------------*/
// ��A-��B �浹 �� �ӵ�
//
// <����>
//  ��A-��B �浹 �� �ӵ��� ����ϰ�?? ������Ʈ
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

    // ���� �ӵ� �����?? ��ȯ. ������ ���� ó��
    if (vax_buf[9] == 1'b1) vax_new = -1 * (vax_buf/12);
    else vax_new = (vax_buf/12);
    if (vay_buf[9] == 1'b1) vay_new = -1 * (vay_buf/12);
    else vay_new = (vay_buf/12);
    if (vbx_buf[9] == 1'b1) vbx_new = -1 * (vbx_buf/12);
    else vbx_new = (vbx_buf/12);
    if (vby_buf[9] == 1'b1) vby_new = -1 * (vby_buf/12);
    else vby_new = (vby_buf/12);

    //�ӵ� ����
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
// ��A �߻�
//
// <����>
//  Ű�е带 �̿��Ͽ� ��A�� �߻�. �ð��� ���� ��A�� �ӷ��� ���� �����ϰ� �ᱹ�� ����.
//
// <���۹�>
//  KEY[1] : �ݽð� �������� ���� ȸ��
//  KEY[7] : �ð� �������� ���� ȸ��
//  KEY[4] : ġ�� ��(�ӷ�) ����?
//  KEY[0] : ��A �߻�
//
// <NOTE>
//  ġ�� ���� ���� �ӷ����� ġȯ��
//  ���۰��� : 0��
//  �Էµ� ���� ������ deg_set�����?? ���� ���� �ӵ��� ��ȯ
/*---------------------------------------------------------*/
reg [6:0] cnt1, cnt2, cnt3;  // Ű �Է� ����
reg [5:0] ba_hit_force_t, ba_hit_force;
reg [8:0] ba_hit_angle_t, ba_hit_angle;

always @(posedge clk or posedge rst) begin // ġ�� �� ������Ʈ
   if(rst) begin
       ba_hit_force <= 0;
   end
   else if(refr_tick) begin
            //���Ŀ� ���⿡ if(status == Player1)
        if(key == 5'h14) begin// 4��Ű�� ������ ������ ġ�� ���� Ŀ��
            if(ba_hit_force_t < MAX_ba_HIT_FORCE && cnt1 > 5) begin
                ba_hit_force_t <= ba_hit_force_t + 1;
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (cnt2 == 20 && ba_hit_force > 0) begin// ġ�� ���� 0 �̻��̸� �ֱ������� �پ����??
            ba_hit_force <= ba_hit_force - 1;
            cnt2 <= 0;
        end
        else begin
            cnt2 <= cnt2 + 1;
        end
   end
   else if(key_pulse == 5'h10) begin // �����??
        ba_hit_force <= ba_hit_force_t;
        ba_hit_force_t <= 0;
   end
end

always @(posedge clk or posedge rst) begin// ġ�� ���� ������Ʈ
    if(rst) begin
        ba_hit_angle <= 0;
    end
    else if (refr_tick) begin
        if (key == 5'h11) begin // 1��Ű ������ ������ ���� ����
            if (cnt3 > 3) begin
                if (ba_hit_angle_t < 360) begin
                    ba_hit_angle_t <= ba_hit_angle_t + 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 360) begin // ���� ������ 360���̸� 0���� ��ȯ
                    ba_hit_angle_t <= 0;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
        if (key == 5'h17) begin  // 7��Ű ������ ������ ���� ����
            if (cnt3 > 3) begin
                if (ba_hit_angle_t > 0) begin
                    ba_hit_angle_t <= ba_hit_angle_t - 5;
                    cnt3 <= 0;
                end
                else if (ba_hit_angle_t == 0) begin // ���� ������ 0���̸� 360���� ��ȯ
                    ba_hit_angle_t <= 360;
                end
            end
            else begin
                cnt3 <= cnt3 + 1;
            end
        end
    end 
    else if(key_pulse == 5'h10) begin // �����??
        ba_hit_angle <= ba_hit_angle_t;
        ba_hit_angle_t <= 0;
    end
end

deg_set deg_set_ba (ba_hit_force, ba_hit_angle, vax, vay, dax, day);// ġ�� ���� ������ �޾Ƽ� ���ӵ� ���??

/*---------------------------------------------------------*/
// ��A-��B �浹 �� ��B�� �ӵ�
//
// <����>
//  ��A-��B �浹 �� ��B �ӵ� ������Ʈ
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

deg_set deg_set_bb (bb_hit_force, bb_hit_angle, vbx, vby, dbx, dby); // ġ�� ���� ������ �޾Ƽ� ���ӵ� ���??

/*---------------------------------------------------------*/
// ��A�� ��ġ
//
// <����>
//  �����?? �ӷ��� ����� ����. 
//  �����?? �ӷ��� ���ؼ� ���� �ӵ��� ��A�� �߽���ǥ ������Ʈ
/*---------------------------------------------------------*/
reg ba_collision;

always @(posedge clk or posedge rst) begin // ��A�� ����
    if(rst | key_pulse == 5'h10) begin 
        dax1 <= 0;
        day1 <= 0;
        ba_collision <= 0;
    end
    else begin
        if(ba_top) begin // ���̺� ���� �浹
            day1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_bottom) begin   // ���̺� �Ʒ��� �浹
            day1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_left) begin // ���̺� ���� �浹
            dax1 <= 1;
            ba_collision <= 1;
        end
        else if (ba_right) begin // ���̺� ������ �浹
            dax1 <= -1;
            ba_collision <= 1;
        end
        else if (ba_bb) begin // ��B�� �浹
            if (cbx-cax >= 0)     dax1 <= -1;
            else if (cbx-cax < 0) dax1 <=  1;
            if (cby-cay >= 0)     day1 <= -1;
            else if (cby-cay < 0) day1 <=  1;
            ba_collision <= 1;
        end
        else if(ba_collision == 0) begin// deg_set���� ����ϴ�?? ������ �־���
            dax1 <= dax;
            day1 <= day;
        end
    end
end

always @ (posedge clk or posedge rst) begin // ��A�� �ӷ�
    if(rst) begin
        vax1 <= 0;
        vay1 <= 0;
    end
    else begin
        vax1 <= vax;
        vay1 <= vay;
    end
end

always @(posedge clk or posedge rst) begin // ��A ���� �ӵ�
    if(rst) begin
        vax_reg <= 0;
        vay_reg <= 0;
    end
    else begin
        vax_reg <= dax1*vax1;
        vay_reg <= day1*vay1;
    end
end

always @(posedge clk or posedge rst) begin // ��A �߽� ��ǥ ������Ʈ
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
// ��B�� ��ġ
//
// <����>
//  �����?? �ӷ��� ����� ����. 
//  �����?? �ӷ��� ���ؼ� ���� �ӵ��� ��B�� �߽���ǥ ������Ʈ
/*---------------------------------------------------------*/
reg bb_collision;

always @(posedge clk or posedge rst) begin // ��B�� ����
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
        else if (ba_bb) begin // ??B?? ?��
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

always @ (posedge clk or posedge rst) begin // ��B�� �ӷ�
    if(rst) begin
        vbx1 <= 0;
        vby1 <= 0;
    end
    else begin
        vbx1 <= vbx;
        vby1 <= vby;
    end
end

always @(posedge clk or posedge rst) begin// ��B ���� �ӵ�
    if(rst) begin
        vbx_reg <= 0;
        vby_reg <= 0;
    end
    else begin
        vbx_reg <= dbx1*vbx1;
        vby_reg <= dby1*vby1;
    end
end

always @(posedge clk or posedge rst) begin // ��B �߽� ��ǥ ������Ʈ
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
        ha_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CA_X-cbx)*(HOLE_CA_X-cbx) + (HOLE_CA_Y-cby)*(HOLE_CA_Y-cby)) ? 1 : 0; // holeA-ballaB ?�� ????
        hb_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CB_X-cax)*(HOLE_CB_X-cax) + (HOLE_CB_Y-cay)*(HOLE_CB_Y-cay)) ? 1 : 0; // holeA-ballaA ?�� ????
        hb_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CB_X-cbx)*(HOLE_CB_X-cbx) + (HOLE_CB_Y-cby)*(HOLE_CB_Y-cby)) ? 1 : 0; // holeA-ballaB ?�� ????
        hc_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CC_X-cax)*(HOLE_CC_X-cax) + (HOLE_CC_Y-cay)*(HOLE_CC_Y-cay)) ? 1 : 0; // holeA-ballaA ?�� ????
        hc_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CC_X-cbx)*(HOLE_CC_X-cbx) + (HOLE_CC_Y-cby)*(HOLE_CC_Y-cby)) ? 1 : 0; // holeA-ballaB ?�� ????
        hd_ba = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CD_X-cax)*(HOLE_CD_X-cax) + (HOLE_CD_Y-cay)*(HOLE_CD_Y-cay)) ? 1 : 0; // holeA-ballaA ?�� ????
        hd_bb = (HOLE_SIZE * HOLE_SIZE >= (HOLE_CD_X-cbx)*(HOLE_CD_X-cbx) + (HOLE_CD_Y-cby)*(HOLE_CD_Y-cby)) ? 1 : 0; // holeA-ballaB ?�� ????

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
        status <= Player1;
        Player1_win_FLAG <= 0;
        Player2_win_FLAG <= 0;
        cue_1_flag <= 0;
    end
    else begin
        case(status)
            Player1 : begin
                 cue_1_flag <= 1;
                 if((vax1 != 0) || (vay1 != 0) || (vbx1 != 0) || (vby1 != 0)) status <= Player1_play;
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
            Player2 : begin
                 cue_2_flag <= 1;
                 if((vax1 != 0) || (vay1 != 0) || (vbx1 != 0) || (vby1 != 0)) status <= Player2_play;
            end
            Player2_play : begin
                cue_2_flag <= 0;
                if(Ball_a_Hole_Flag)begin
                    status <= Player1_win;
                end
                else if(Ball_b_Hole_Flag)begin
                    status <= Player2_win;
                end
                else if((vax1 == 0) && (vay1 == 0) && (vbx1 == 0) && (vby1 == 0)) begin
                    status <= Player1;
                end
            end
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
// text on screen 
/*---------------------------------------------------------*/
// P1_win region
wire [6:0] char_addr1;
reg [6:0] char_addr1_s1;
wire [2:0] bit_addr1;
reg [2:0] bit_addr1_s1;
wire [3:0] row_addr1, row_addr1_s1; 
wire P1_win_on1;

wire font_bit1;
wire [7:0] font_word1;
wire [10:0] rom_addr1;

parameter xFont = 235;
parameter yFont = 236;

font_rom_vhd font_rom_inst1 (clk, rom_addr1, font_word1);

assign rom_addr1 = {char_addr1, row_addr1};
assign font_bit1 = font_word1[~bit_addr1]; //ȭ�� x��ǥ�� ������ ������, rom�� bit�� �������� �����Ƿ� reverse

assign char_addr1 = (P1_win_on1)? char_addr1_s1 : 0;
assign row_addr1  = (P1_win_on1)? row_addr1_s1  : 0; 
assign bit_addr1  = (P1_win_on1)? bit_addr1_s1  : 0; 

// LINE1
wire [9:0] P1_win_x_l1, P1_win_y_t1;
assign P1_win_x_l1 = xFont; 
assign P1_win_y_t1 = yFont; 
assign P1_win_on1 = (y>=P1_win_y_t1 && y<P1_win_y_t1+16 && x>=P1_win_x_l1 && x<P1_win_x_l1+8*11)? 1 : 0; 
assign row_addr1_s1 = y-P1_win_y_t1;


always @ (*) begin
    if      (x>=P1_win_x_l1+8*0 && x<P1_win_x_l1+8*1) begin 
        if(Player1_win_FLAG || Player2_win_FLAG) begin bit_addr1_s1 = x-P1_win_x_l1-8*0; char_addr1_s1 = 7'b101_0000; end // P X50
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*1 && x<P1_win_x_l1+8*2) begin 
        if(Player1_win_FLAG || Player2_win_FLAG) begin bit_addr1_s1 = x-P1_win_x_l1-8*1; char_addr1_s1 = 7'b100_1100; end // L X4C
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*2 && x<P1_win_x_l1+8*3) begin 
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*2; char_addr1_s1 = 7'b100_0001; end // A X41
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*3 && x<P1_win_x_l1+8*4) begin 
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*3; char_addr1_s1 = 7'b101_1001; end // Y X59
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*4 && x<P1_win_x_l1+8*5) begin 
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*4; char_addr1_s1 = 7'b100_0101; end // E x45
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*5 && x<P1_win_x_l1+8*6) begin
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*5; char_addr1_s1 = 7'b101_0010; end // R x52
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end

    else if (x>=P1_win_x_l1+8*6 && x<P1_win_x_l1+8*7) begin
        if(Player1_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b011_0001; end // 1 x31
        else if(Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b011_0010; end // 2 x32
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end

    else if (x>=P1_win_x_l1+8*7 && x<P1_win_x_l1+8*8) begin //NULL
        bit_addr1_s1 = x-P1_win_x_l1-8*7; char_addr1_s1 = 7'b000_0000;
    end
    else if (x>=P1_win_x_l1+8*8 && x<P1_win_x_l1+8*9) begin
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*8; char_addr1_s1 = 7'b101_0111; end // W x57
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*9 && x<P1_win_x_l1+8*10) begin
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*9; char_addr1_s1 = 7'b100_1001; end // I x49
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else if (x>=P1_win_x_l1+8*10 && x<P1_win_x_l1+8*11) begin
        if(Player1_win_FLAG || Player2_win_FLAG)begin bit_addr1_s1 = x-P1_win_x_l1-8*10; char_addr1_s1 = 7'b100_1110; end // N x4e
        else begin  bit_addr1_s1 = x-P1_win_x_l1-8*6; char_addr1_s1 = 7'b000_0000; end
    end
    else begin bit_addr1_s1 = 0; char_addr1_s1 = 0; end                         
end

/*---------------------------------------------------------*/
// ��A, B, Hole, ť�� �׸���
/*---------------------------------------------------------*/
// Font
assign ball_rgb[0] = (font_bit1 & P1_win_on1)? 1 : 0;
//ball
assign ball_rgb[2] = (`BALL_R*`BALL_R >= (x-cax)*(x-cax) + (y-cay)*(y-cay)) ? 1 : 0;
assign ball_rgb[3] = (`BALL_R*`BALL_R >= (x-cbx)*(x-cbx) + (y-cby)*(y-cby)) ? 1 : 0;
//flag
assign ball_rgb[4] = (ba_bb || Player1_win_FLAG || Player1_win_FLAG); // Flag indicate
//hole
assign ball_rgb[5] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CA_X)*(x - HOLE_CA_X) + (y - HOLE_CA_Y)*(y - HOLE_CA_Y)) ? 1 : 0;
assign ball_rgb[6] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CB_X)*(x - HOLE_CB_X) + (y - HOLE_CB_Y)*(y - HOLE_CB_Y)) ? 1 : 0;
assign ball_rgb[7] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CC_X)*(x - HOLE_CC_X) + (y - HOLE_CC_Y)*(y - HOLE_CC_Y)) ? 1 : 0;
assign ball_rgb[8] = (HOLE_SIZE * HOLE_SIZE >= (x - HOLE_CD_X)*(x - HOLE_CD_X) + (y - HOLE_CD_Y)*(y - HOLE_CD_Y)) ? 1 : 0;

//cue
assign ball_rgb[9] = (cue_1_flag == 1) ? ((CUE_BALL_SIZE * CUE_BALL_SIZE >= (x - cue_x2)*(x - cue_x2) + (y - cue_y2)*(y - cue_y2)) ? 1 : 0) : 0;

endmodule 