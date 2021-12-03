parameter Player1 = 0;
parameter Player1_Play = 1;
parameter Player2 = 2;
parameter Player2_Play = 3;
parameter Player1_win = 4;
parameter Player2_win = 5;

case (status)
    Player1: begin
        keypad keypad_inst (clk_6mhz, rst, key_io[7:4], key_io[3:0], key_tmp);
        debounce debounce_inst (clk_6mhz, rst, key_tmp, key, key_pulse);
        R_value_set R_value_set_inst (key_pulse,R); // 얼마나 쎼게 칠지 입력 받는 모듈
        deg_set deg_set_inst(key,deg); // 어떤 각도를 칠지 모듈
        Velocity_cal Velocity_cal_inst(R,deg,Vx,Vy, Dx,Dy); //제가 엑셀로 만든 그 것
        if(key_pulse[4]==1 && key_pulse[3:0]==4'hA) begin
            BALL_1_Dx = Dx;
            BALL_1_Dy = Dy;
            BALL_1Vy = BALL_1_Dx * Vx;
            BALL_1Vy = BALL_1_Dy * Vy;
            status = Player1_Playl;
        end
    end

    Player1_Playl : begin
        if ((BALL_1_Dx == 0)&&(BALL_1_Dy == 0)&&(BALL_2_Dx == 0)&&(BALL_2_Dy == 0)&&(BALL_3_Dx == 0)&&(BALL_3_Dy == 0)) begin
            status = Player2;
        end
        else if(공들어간 플래그 == 1) status = Player1_win
    end

    Player2: begin
        keypad keypad_inst (clk_6mhz, rst, key_io[7:4], key_io[3:0], key_tmp);
        debounce debounce_inst (clk_6mhz, rst, key_tmp, key, key_pulse);
        R_value_set R_value_set_inst (key_pulse,R);
        deg_set deg_set_inst(key,deg); 
        Velocity_cal Velocity_cal_inst(R,deg,Vx,Vy, Dx,Dy); //제가 엑셀로 만든 그 것
        if(key_pulse[4]==1 && key_pulse[3:0]==4'hA) begin
            BALL_2_Dx = Dx;
            BALL_2_Dy = Dy;
            BALL_2Vy = BALL_2_Dx * Vx;
            BALL_2Vy = BALL_2_Dy * Vy;
            status = Player2_Play;
        end
    end

    Player2_Play : begin
        if ((BALL_1_Dx == 0)&&(BALL_1_Dy == 0)&&(BALL_2_Dx == 0)&&(BALL_2_Dy == 0)&&(BALL_3_Dx == 0)&&(BALL_3_Dy == 0)) begin
            status = Player2;
        end
        else if(공들어간 플래그 == 1) status = Player2_win
    end

    Player1_win : begin
        //Player_win 
    end

    Player2_win : begin
        //Player_win 
    end
    default: 
endcase