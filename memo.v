`define COS(dx) (dx/(12*2)) // 충돌 각도의 cos, sin
`define SIN(dy) (dy/(12*2))

`define BALL_D 24

module collision(
    input clk,
    input rst, 

    input [9:0] x1, // 현재 공의 중심좌표
    input [9:0] y1,
    input [9:0] x2,
    input [9:0] y2,

    input [9:0] vax, // 현재 공의 속도
    input [9:0] vay,
    input [9:0] vbx,
    input [9:0] vby,

    input [9:0] dax, // 현재 공의 방향
    input [9:0] day,
    input [9:0] dbx,
    input [9:0] dby,

    output reg signed [9:0] vax_new, // 충돌 후 공의 속도
    output reg signed [9:0] vay_new,
    output reg signed [9:0] vbx_new,
    output reg signed [9:0] vby_new,

    output reg signed [9:0] dax_new, // 충돌 후 공의 방향
    output reg signed [9:0] day_new,
    output reg signed [9:0] dbx_new,
    output reg signed [9:0] dby_new,

    output collision
    );


// 충돌 플래그
assign collision = (`BALL_D*`BALL_D >= (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) ? 1 : 0;

reg signed [9:0] delta_x;
reg signed [9:0] delta_y;

reg signed [9:0] vax_p;
reg signed [9:0] vay_p;
reg signed [9:0] vbx_p;
reg signed [9:0] vby_p;

reg signed [9:0] vax_buf;
reg signed [9:0] vay_buf;
reg signed [9:0] vbx_buf;
reg signed [9:0] vby_buf;

// 충돌 시 공의 중심좌표 저장 
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

// 충돌 각도가 업데이트 되면 충돌 후 속도 계산
always @ (`COS(delta_x) or `SIN(delta_y)) begin
    vax_p = vbx*`COS(delta_x) + vby*`SIN(delta_y);
    vay_p = vay*`COS(delta_x) - vax*`SIN(delta_y);
    vbx_p = vax*`COS(delta_x) + vay*`SIN(delta_y);
    vby_p = vby*`COS(delta_x) - vbx*`SIN(delta_y);
    
    /*
    vax_new = vax_p*`COS(delta_x) - vay_p*`SIN(delta_y);
    vay_new = vax_p*`SIN(delta_y) + vay_p*`COS(delta_x);
    vbx_new = vbx_p*`COS(delta_x) - vby_p*`SIN(delta_y);
    vby_new = vbx_p*`SIN(delta_y) + vby_p*`COS(delta_x);
    */
    
    vax_buf = vax_p*`COS(delta_x) - vay_p*`SIN(delta_y);
    vay_buf = vax_p*`SIN(delta_y) + vay_p*`COS(delta_x);
    vbx_buf = vbx_p*`COS(delta_x) - vby_p*`SIN(delta_y);
    vby_buf = vbx_p*`SIN(delta_y) + vby_p*`COS(delta_x);

    if (vax_buf[9] == 1'b1) vax_new = -1 * vax_buf;
    else vax_new = vax_buf;
    if (vay_buf[9] == 1'b1) vay_new = -1 * vay_buf;
    else vay_new = vay_buf;

    if (vbx_buf[9] == 1'b1) vbx_new = -1 * vbx_buf;
    else vbx_new = vbx_buf;
    if (vby_buf[9] == 1'b1) vby_new = -1 * vby_buf;
    else vby_new = vby_buf;
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