module collision_dectect(
    input [9:0] x1,
    input [9:0] y1,
    
    input [9:0] x2,
    input [9:0] y2,

    output collision
    );

assign collision = (12*12 >= (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) ? 1 : 0;

endmodule
