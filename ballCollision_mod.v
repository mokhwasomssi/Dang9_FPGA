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

    output reg [9:0] Vx_UPDATE_a,
    output reg [9:0] Vy_UPDATE_a,
    output reg [9:0] Vx_UPDATE_b,
    output reg [9:0] Vy_UPDATE_b,

    output reg [9:0] Dx_UPDATE_a,
    output reg [9:0] Dy_UPDATE_a,
    output reg [9:0] Dx_UPDATE_b,
    output reg [9:0] Dy_UPDATE_b
    );
    parameter BALL_SIZE = 30;
    reg cos, sin;
    reg VaXp, VaYp;
    reg VbXp, VbYp;
    reg VaX,  VaY;
    reg VbX,  VbY; 

    always @(posedge clk or rst) begin
        if (rst == 1b'1) begin
            Vx_UPDATE_a = z;
            Vy_UPDATE_a = z;
            Vx_UPDATE_b = z;
            Vy_UPDATE_b = z;
            Dx_UPDATE_a = z;
            Dy_UPDATE_a = z;
            Dx_UPDATE_b = z;
            Dy_UPDATE_b = z;
        end
        else begin
            cos = (yBall_b - yBall_a) / BALL_SIZE;
            sin = (xBall_b - xBall_a) / BALL_SIZE;
            
            //need to check Human error (eq)
            VaXp = Vx_NOW_b*cos + Vy_NOW_b*sin;
            VaYp = Vy_NOW_a*cos - Vx_NOW_a*sin;
            VbXp = Vx_NOW_a*cos + Vy_NOW_a*sin;
            VbYp = Vy_NOW_b*cos - Vx_NOW_b*sin;

            VaX = VaXp*cos - VaYp*sin;
            VaY = VaXp*sin + VaYp*cos;
            abs_mod abs_inst1 (VaX,Vx_UPDATE_a); //Balla Vx
            abs_mod abs_inst2 (VaY,Vx_UPDATE_a); //Balla Vy
            
            VbX = VbXp * cos - VbYp * sin;
            VbY = VbXp * sin + VbYp * cos;
            abs_mod abs_inst3 (VbX,Vx_UPDATE_b); //Ballb Vx
            abs_mod abs_inst4 (VbY,Vy_UPDATE_b); //Ballb Vy

            Dx_UPDATE_a = (VaX/Vx_UPDATE_a);
            Dy_UPDATE_a = (VaY/Vy_UPDATE_a);
            Dx_UPDATE_b = (VbX/Vx_UPDATE_b);
            Dy_UPDATE_b = (VbY/Vy_UPDATE_b);
        end
    end
endmodule