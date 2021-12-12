`define BALL_R 12
`define BALL_D 24

`define WHITE 3'b111
`define BLACK 3'b000
`define RED   3'b100
`define GREEN 3'b010
`define BLUE  3'b001

`define MAX_X 640
`define MAX_Y 480

`define TABLE_OUT_L 20
`define TABLE_OUT_R 620
`define TABLE_OUT_T 20
`define TABLE_OUT_B 460

`define TABLE_IN_L 40
`define TABLE_IN_R 600
`define TABLE_IN_T 40
`define TABLE_IN_B 440

`define COS(dx) (dx/24) // 충돌 각도의 cos, sin
`define SIN(dy) (dy/24)

//`define MAX_HIT_FORCE 12