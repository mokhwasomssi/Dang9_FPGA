reg [:] Vx,Vy;
reg [:] ratio;
reg [:] flag;

if(Vx > Vy) begin
    ratio = Vx / Vy;
    flag = 0;
end
else if (Vx < Vy) begin
    ratio = Vy / Vx;
    flag = 1;
end
else if( Vx == Vy) begin
    ratio = 1;
    flag = 2;
end
if(ratio == 0) begin
    ratio = 1;
    flag = 2;
end

if(flag == 0) begin
    Vx = Vx_buf - 1 * ratio;
    Vy = Vy_buf - 1;
end
else if(flag == 1) begin
    Vx = Vx_buf - 1;
    Vy = Vy_buf - 1 * ratio;
end
else if(flag == 2) begin
    Vx = Vx_buf - 1;
    Vy = Vy_buf - 1;
end