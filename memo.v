parameter Player1 = 0;
parameter Player1_Play = 1;
parameter Player2 = 2;
parameter Player2_Play = 3;
parameter Player1_win = 4;
parameter Player2_win = 5;

reg [4:0] status;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        status = Player1;
    end
    else begin
        case(status)
            Player1 : begin
                //deg_set_ba의 INPUT인자를 ba_hit_force_Buf, ba_hit_angle_Buf로 변경
                ba_hit_force_Buf = ba_hit_force;
                ba_hit_angle_Buf = ba_hit_angle;
                //deg_set_bb의 INPUT인자를 bb_hit_force_Buf, bb_hit_angle_Buf로 변경
                bb_hit_force_Buf = 0;
                bb_hit_angle_Buf = 0;

                if(key_pulse == 5'h10) begin
                    status = Player1_play;
                end
            end
            Player1_play : begin
                if(Ball_a_Hole_Flag)begin
                    status = Player2_win;
                end
                else if(Ball_b_Hole_Flag)begin
                    status = Player1_win;
                end
                else if((vax1 == 0) && (vay1 == 0) && (vbx1 == 0) && (vby1 == 0)) begin
                    status = Player2;
                end
            end
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
            Player1_win : begin
            end
            Player2_win : begin
            end
    end
end