// È¦ ÁÂÇ¥
module hole (
    input clk, 
    input rst, 
    
    input [9:0] x, 
    input [9:0] y, 
    
    output [3:0] hole_rgb
    );
    
assign hole_rgb[0] = (`HOLE_R * `HOLE_R >= (x - `HOLE_CA_X)*(x - `HOLE_CA_X) + (y - `HOLE_CA_Y)*(y - `HOLE_CA_Y)) ? 1 : 0;
assign hole_rgb[1] = (`HOLE_R * `HOLE_R >= (x - `HOLE_CB_X)*(x - `HOLE_CB_X) + (y - `HOLE_CB_Y)*(y - `HOLE_CB_Y)) ? 1 : 0;
assign hole_rgb[2] = (`HOLE_R * `HOLE_R >= (x - `HOLE_CC_X)*(x - `HOLE_CC_X) + (y - `HOLE_CC_Y)*(y - `HOLE_CC_Y)) ? 1 : 0;
assign hole_rgb[3] = (`HOLE_R * `HOLE_R >= (x - `HOLE_CD_X)*(x - `HOLE_CD_X) + (y - `HOLE_CD_Y)*(y - `HOLE_CD_Y)) ? 1 : 0;

endmodule