`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/14 01:09:58
// Design Name: 
// Module Name: cue_deg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cue_deg(
    input [9:0] DEG,
    input [9:0] STD_x,
    input [9:0] STD_y,
    
    output reg signed [9:0] x2,
    output reg signed [9:0] y2
);

reg signed [9:0]  x2_BUF, y2_BUF;

always @(DEG) begin // rom
    case(DEG)
        0	:	begin	x2_BUF	=	-70	;	y2_BUF	=	0	;	end
        5	:	begin	x2_BUF	=	-69	;	y2_BUF	=	6	;	end
        10	:	begin	x2_BUF	=	-68	;	y2_BUF	=	12	;	end
        15	:	begin	x2_BUF	=	-67	;	y2_BUF	=	18	;	end
        20	:	begin	x2_BUF	=	-65	;	y2_BUF	=	23	;	end
        25	:	begin	x2_BUF	=	-63	;	y2_BUF	=	29	;	end
        30	:	begin	x2_BUF	=	-60	;	y2_BUF	=	35	;	end
        35	:	begin	x2_BUF	=	-57	;	y2_BUF	=	40	;	end
        40	:	begin	x2_BUF	=	-53	;	y2_BUF	=	44	;	end
        45	:	begin	x2_BUF	=	-49	;	y2_BUF	=	49	;	end
        50	:	begin	x2_BUF	=	-44	;	y2_BUF	=	53	;	end
        55	:	begin	x2_BUF	=	-40	;	y2_BUF	=	57	;	end
        60	:	begin	x2_BUF	=	-35	;	y2_BUF	=	60	;	end
        65	:	begin	x2_BUF	=	-29	;	y2_BUF	=	63	;	end
        70	:	begin	x2_BUF	=	-23	;	y2_BUF	=	65	;	end
        75	:	begin	x2_BUF	=	-18	;	y2_BUF	=	67	;	end
        80	:	begin	x2_BUF	=	-12	;	y2_BUF	=	68	;	end
        85	:	begin	x2_BUF	=	-6	;	y2_BUF	=	69	;	end
        90	:	begin	x2_BUF	=	0	;	y2_BUF	=	70	;	end
        95	:	begin	x2_BUF	=	7	;	y2_BUF	=	69	;	end
        100	:	begin	x2_BUF	=	13	;	y2_BUF	=	68	;	end
        105	:	begin	x2_BUF	=	19	;	y2_BUF	=	67	;	end
        110	:	begin	x2_BUF	=	24	;	y2_BUF	=	65	;	end
        115	:	begin	x2_BUF	=	30	;	y2_BUF	=	63	;	end
        120	:	begin	x2_BUF	=	35	;	y2_BUF	=	60	;	end
        125	:	begin	x2_BUF	=	41	;	y2_BUF	=	57	;	end
        130	:	begin	x2_BUF	=	45	;	y2_BUF	=	53	;	end
        135	:	begin	x2_BUF	=	50	;	y2_BUF	=	49	;	end
        140	:	begin	x2_BUF	=	54	;	y2_BUF	=	44	;	end
        145	:	begin	x2_BUF	=	58	;	y2_BUF	=	40	;	end
        150	:	begin	x2_BUF	=	61	;	y2_BUF	=	35	;	end
        155	:	begin	x2_BUF	=	64	;	y2_BUF	=	29	;	end
        160	:	begin	x2_BUF	=	66	;	y2_BUF	=	23	;	end
        165	:	begin	x2_BUF	=	68	;	y2_BUF	=	18	;	end
        170	:	begin	x2_BUF	=	69	;	y2_BUF	=	12	;	end
        175	:	begin	x2_BUF	=	70	;	y2_BUF	=	6	;	end
        180	:	begin	x2_BUF	=	70	;	y2_BUF	=	0	;	end
        185	:	begin	x2_BUF	=	70	;	y2_BUF	=	-7	;	end
        190	:	begin	x2_BUF	=	69	;	y2_BUF	=	-13	;	end
        195	:	begin	x2_BUF	=	68	;	y2_BUF	=	-19	;	end
        200	:	begin	x2_BUF	=	66	;	y2_BUF	=	-24	;	end
        205	:	begin	x2_BUF	=	64	;	y2_BUF	=	-30	;	end
        210	:	begin	x2_BUF	=	61	;	y2_BUF	=	-35	;	end
        215	:	begin	x2_BUF	=	58	;	y2_BUF	=	-41	;	end
        220	:	begin	x2_BUF	=	54	;	y2_BUF	=	-45	;	end
        225	:	begin	x2_BUF	=	50	;	y2_BUF	=	-50	;	end
        230	:	begin	x2_BUF	=	45	;	y2_BUF	=	-54	;	end
        235	:	begin	x2_BUF	=	41	;	y2_BUF	=	-58	;	end
        240	:	begin	x2_BUF	=	35	;	y2_BUF	=	-61	;	end
        245	:	begin	x2_BUF	=	30	;	y2_BUF	=	-64	;	end
        250	:	begin	x2_BUF	=	24	;	y2_BUF	=	-66	;	end
        255	:	begin	x2_BUF	=	19	;	y2_BUF	=	-68	;	end
        260	:	begin	x2_BUF	=	13	;	y2_BUF	=	-69	;	end
        265	:	begin	x2_BUF	=	7	;	y2_BUF	=	-70	;	end
        270	:	begin	x2_BUF	=	1	;	y2_BUF	=	-70	;	end
        275	:	begin	x2_BUF	=	-6	;	y2_BUF	=	-70	;	end
        280	:	begin	x2_BUF	=	-12	;	y2_BUF	=	-69	;	end
        285	:	begin	x2_BUF	=	-18	;	y2_BUF	=	-68	;	end
        290	:	begin	x2_BUF	=	-23	;	y2_BUF	=	-66	;	end
        295	:	begin	x2_BUF	=	-29	;	y2_BUF	=	-64	;	end
        300	:	begin	x2_BUF	=	-35	;	y2_BUF	=	-61	;	end
        305	:	begin	x2_BUF	=	-40	;	y2_BUF	=	-58	;	end
        310	:	begin	x2_BUF	=	-44	;	y2_BUF	=	-54	;	end
        315	:	begin	x2_BUF	=	-49	;	y2_BUF	=	-50	;	end
        320	:	begin	x2_BUF	=	-53	;	y2_BUF	=	-45	;	end
        325	:	begin	x2_BUF	=	-57	;	y2_BUF	=	-41	;	end
        330	:	begin	x2_BUF	=	-60	;	y2_BUF	=	-35	;	end
        335	:	begin	x2_BUF	=	-63	;	y2_BUF	=	-30	;	end
        340	:	begin	x2_BUF	=	-65	;	y2_BUF	=	-24	;	end
        345	:	begin	x2_BUF	=	-67	;	y2_BUF	=	-19	;	end
        350	:	begin	x2_BUF	=	-68	;	y2_BUF	=	-13	;	end
        355	:	begin	x2_BUF	=	-69	;	y2_BUF	=	-7	;	end
        360	:	begin	x2_BUF	=	-70	;	y2_BUF	=	-1	;	end
        endcase
 end

always @(*) begin
    x2 = STD_x + x2_BUF; y2 = STD_y + y2_BUF;
end
endmodule
