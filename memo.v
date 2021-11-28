always @ (posedge clk or posedge rst) begin
    if(rst) begin
        BALL_1_Dx <= -1;
        BALL_1_Dy <= 1;
        ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
    end
    else begin
        if (ball1_reach_top) begin//ball1_vy_reg <= BALL_1Vy; //õ�忡 �ε����� ���Ʒ���..
            BALL_1_Dy <= 1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end 
        else if (ball1_reach_bottom) begin//ball1_vy_reg <= -1*BALL_1Vy; //�ٴڿ� �ε����� ����
            BALL_1_Dy <= -1;
            ball1_vy_reg <= BALL_1_Dy * BALL_1Vy;
        end
        else if (ball1_reach_left) begin//ball1_vx_reg <= BALL_1Vx; //���� �ε����� ����������
            BALL_1_Dx <= 1;
            ball1_vx_reg <= BALL_1_Dx * BALL_1Vx;
        end
        else if (ball1_reach_right) begin//ball1_vx_reg <= -1*BALL_1Vx; //�ٿ� ƨ��� ��������
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

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball2_vx_reg <= BALL_2Vx; ////game�� ���߸� �������� 
        ball2_vy_reg <= -1*BALL_2Vy; //game�� ���߸� �Ʒ���
    end
    else begin
        if (ball2_reach_top) begin//ball2_vy_reg <= BALL_2Vy; //õ�忡 �ε����� ���Ʒ���..
            BALL_2_Dy <= 1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end 
        else if (ball2_reach_bottom) begin//ball2_vy_reg <= -1*BALL_2Vy; //�ٴڿ� �ε����� ����
            BALL_2_Dy <= -1;
            ball2_vy_reg <= BALL_2_Dy * BALL_2Vy;
        end
        else if (ball2_reach_left) begin//ball2_vx_reg <= BALL_2Vx; //���� �ε����� ����������
            BALL_2_Dx <= 1;
            ball2_vx_reg <= BALL_2_Dx * BALL_2Vx;
        end
        else if (ball2_reach_right) begin//ball2_vx_reg <= -1*BALL_2Vx; //�ٿ� ƨ��� ��������
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
        //반전
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

// ��3 ���� ������Ʈ
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        ball3_vx_reg <= BALL_3Vx; ////game�� ���߸� �������� 
        ball3_vy_reg <= BALL_3Vy; //game�� ���߸� �Ʒ���
    end
    else begin
        if (ball3_reach_top) begin//ball3_vy_reg <= BALL_3Vy; //õ�忡 �ε����� ���Ʒ���..
            BALL_3_Dy <= 1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end 
        else if (ball3_reach_bottom) begin//ball3_vy_reg <= -1*BALL_3Vy; //�ٴڿ� �ε����� ����
            BALL_3_Dy <= -1;
            ball3_vy_reg <= BALL_3_Dy * BALL_3Vy;
        end
        else if (ball3_reach_left) begin//ball3_vx_reg <= BALL_3Vx; //���� �ε����� ����������
            BALL_3_Dx <= 1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
        end
        else if (ball3_reach_right) begin//ball3_vx_reg <= -1*BALL_3Vx; //�ٿ� ƨ��� ��������
            BALL_3_Dx <= -1;
            ball3_vx_reg <= BALL_3_Dx * BALL_3Vx;
        end
        //with ball
        else if (ball23_LTRB || ball13_LTRB) begin 
            BALL_3_Dx <= -1;
            BALL_3_Dy <= 1;
            ball3_vx_reg -<= BALL_3_Dx * BALL_3Vx;
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