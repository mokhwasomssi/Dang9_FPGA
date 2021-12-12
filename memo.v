`include "defines.v"

module collision(
    input clk,
    input rst, 

    input [9:0] x1, // ���� ���� �߽���ǥ
    input [9:0] y1,
    input [9:0] x2,
    input [9:0] y2,

    input signed [4:0] vax, // ���� ���� �ӵ�
    input signed [4:0] vay,
    input signed [4:0] vbx,
    input signed [4:0] vby,

    input signed [1:0] dax, // ���� ���� ����
    input signed [1:0] day,
    input signed [1:0] dbx,
    input signed [1:0] dby,

    output reg signed [4:0] vax_new, // �浹 �� ���� �ӵ�
    output reg signed [4:0] vay_new,
    output reg signed [4:0] vbx_new,
    output reg signed [4:0] vby_new,

    output reg signed [1:0] dax_new, // �浹 �� ���� ����
    output reg signed [1:0] day_new,
    output reg signed [1:0] dbx_new,
    output reg signed [1:0] dby_new,

    output collision
    );


// �浹 �÷���
assign collision = (`BALL_D*`BALL_D >= (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) ? 1 : 0;

real signed [9:0] delta_x;
real signed [9:0] delta_y;

real signed [9:0] vax_p;
real signed [9:0] vay_p;
real signed [9:0] vbx_p;
real signed [9:0] vby_p;

real signed [9:0] vax_buf;
real signed [9:0] vay_buf;
real signed [9:0] vbx_buf;
real signed [9:0] vby_buf;


// �浹 �� ���� �߽���ǥ ���� 
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        delta_x <= 0;
        delta_y <= 0;
    end
    else if(collision) begin
        delta_x <= x2-x1;
        delta_y <= y2-y1;
    end 
end

// �浹 ������ ������Ʈ �Ǹ� �浹 �� �ӵ� ���
always @ (*) begin
    vax_p = dbx*vbx*(delta_x/24) + dby*vby*(delta_y/24);
    vay_p = day*vay*(delta_x/24) - dax*vax*(delta_y/24);
    vbx_p = dax*vax*(delta_x/24) + day*vay*(delta_y/24);
    vby_p = dby*vby*(delta_x/24) - dbx*vbx*(delta_y/24);
    
    vax_buf = vax_p*(delta_x/24) - vay_p*(delta_y/24);
    vay_buf = vax_p*(delta_y/24) + vay_p*(delta_x/24);
    vbx_buf = vbx_p*(delta_x/24) - vby_p*(delta_y/24);
    vby_buf = vbx_p*(delta_y/24) + vby_p*(delta_x/24);

    /*
    vax_new = vax_buf[9]? ~(vax_buf-1):vax_buf;
    vay_new = vay_buf[9]? ~(vay_buf-1):vay_buf;
    vbx_new = vbx_buf[9]? ~(vbx_buf-1):vbx_buf;
    vby_new = vby_buf[9]? ~(vby_buf-1):vby_buf;
    */
    if (vax_buf[9] == 1'b1) vax_new =  int'(-1 * vax_buf);
    else vax_new = int'(vax_buf);
    if (vay_buf[9] == 1'b1) vay_new =  int'(-1 * vay_buf);
    else vay_new = int'(vay_buf);

    if (vbx_buf[9] == 1'b1) vbx_new = int'(-1 * vbx_buf);
    else vbx_new = int'(vbx_buf);
    if (vby_buf[9] == 1'b1) vby_new = int'(-1 * vby_buf);
    else vby_new = int'(vby_buf);
end

//update direction
always @(posedge clk or posedge rst) begin
    if (rst) begin
    end
    else begin
        if(delta_x > 0) begin //std Ball2, Hit R
            if (delta_y > 0) begin //std Ball2, Hit T -> RT
                dax_new <=  1;  day_new <= -1;
                dbx_new <= -1;  dby_new <=  1;
            end
            else if (delta_y < 0) begin//std Ball2, Hit B -> RB
                dax_new <=  1;  day_new <=  1;
                dbx_new <= -1;  dby_new <= -1;
            end
            else if (delta_y == 0) begin//std Ball2, Hit C -> RC
                dax_new <=  1;  day_new <= -1;
                dbx_new <= -1;  dby_new <=  1;
                
        end
        else if (delta_x < 0) begin //std Ball2, Hit L
            if (delta_y > 0) begin //std Ball2, Hit T -> LT
                dax_new <= -1;  day_new <= -1;
                dbx_new <=  1;  dby_new <=  1;
            end
            else if (delta_y < 0) begin//std Ball2, Hit B -> LB
                dax_new <= -1;  day_new <=  1;
                dbx_new <=  1;  dby_new <= -1;
            end
            else if (delta_y == 0) begin//std Ball2, Hit C -> LC
                dax_new <= -1;  day_new <= -1;
                dbx_new <=  1;  dby_new <=  1;
            end
        end
        else if (delta_x == 0) begin//std Ball2, Hit C
            if (delta_y > 0) begin //std Ball2, Hit T -> CT
                dax_new <= -1;  day_new <= -1;
                dbx_new <=  1;  dby_new <=  1;
            end
            else if (delta_y < 0) begin//std Ball2, Hit B -> CB
                dax_new <= -1;   day_new <=  1;
                dbx_new <=  1;   dby_new <= -1;
            end
        end
    end
end

endmodule