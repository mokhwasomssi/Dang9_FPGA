`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 19:22:02
// Design Name: 
// Module Name: Collision_Direction_update
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

module ballCollision_mod(
    input clk,
    input rst,

    input [9:0] xBall_a;
    input [9:0] yBall_a;
    input [9:0] xBall_b;
    input [9:0] yBall_b;
    
    input [9:0] Vx_NOW_a,
    input [9:0] Vy_NOW_a,
    input [9:0] Vx_NOW_b,
    input [9:0] Vy_NOW_b,

    output [9:0] Vx_UPDATE_a,
    output [9:0] Vy_UPDATE_a,
    output [9:0] Vx_UPDATE_b,
    output [9:0] Vy_UPDATE_b,

    output [9:0] Dx_UPDATE_a,
    output [9:0] Dy_UPDATE_a,
    output [9:0] Dx_UPDATE_b,
    output [9:0] Dy_UPDATE_b
    );
    parameter BALL_SIZE = 30;
    wire cos, sin;
    wire VaXp, VaYp;
    wire VbXp, VbYp;
    wire VaX,  VaY;
    wire VbX,  VbY; 

    assign cos = (yBall_b - yBall_a) / BALL_SIZE;
    assign sin = (xBall_b - xBall_a) / BALL_SIZE;
    
    //need to check Human error (eq)
    assign VaXp = Vx_NOW_b*cos + Vy_NOW_b*sin;
    assign VaYp = Vy_NOW_a*cos - Vx_NOW_a*sin;
    assign VbXp = Vx_NOW_a*cos + Vy_NOW_a*sin;
    assign VbYp = Vy_NOW_b*cos - Vx_NOW_b*sin;

    assign VaX = VaXp*cos - VaYp*sin;
    assign VaY = VaXp*sin + VaYp*cos;
    abs_mod abs_inst1 (VaX,Vx_UPDATE_a); //Balla Vx
    abs_mod abs_inst2 (VaY,Vx_UPDATE_a); //Balla Vy
    
    assign VbX = VbXp * cos - VbYp * sin;
    assign VbY = VbXp * sin + VbYp * cos;
    abs_mod abs_inst3 (VbX,Vx_UPDATE_b); //Ballb Vx
    abs_mod abs_inst4 (VbY,Vy_UPDATE_b); //Ballb Vy

    assign Dx_UPDATE_a = (VaX/Vx_UPDATE_a);
    assign Dy_UPDATE_a = (VaY/Vy_UPDATE_a);
    assign Dx_UPDATE_b = (VbX/Vx_UPDATE_b);
    assign Dy_UPDATE_b = (VbY/Vy_UPDATE_b);
endmodule