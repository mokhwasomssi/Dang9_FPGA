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

module Collision_Direction_update(
    input clk,
    input rst,
    input [2:0] FLAG,
    //  FLAG[0], FLAG[1], FLAG[2] are balls 1, 2, 3.
    //
    //  ex1)
    //  If you collide with ball 1 and ball 2, set the flag as below.
    //  FLAG = {1,1,0};
    //  
    //  ex2)
    //  If ball 1 and ball 3 collide, set the flag as below.
    //  FLAG = {1,0,1};

    input [1:0] D1x_NOW,
    input [1:0] D1y_NOW,
    input [1:0] D2x_NOW,
    input [1:0] D2y_NOW,
    input [1:0] D3x_NOW,
    input [1:0] D3y_NOW,

    output reg [1:0] D1x_UPDATE,
    output reg [1:0] D1y_UPDATE,
    output reg [1:0] D2x_UPDATE,
    output reg [1:0] D2y_UPDATE,
    output reg [1:0] D3x_UPDATE,
    output reg [1:0] D3y_UPDATE
    );
    
    reg [1:0] D1x_now;
    reg [1:0] D1y_now;
    reg [1:0] D2x_now;
    reg [1:0] D2y_now;
    reg [1:0] D3x_now;
    reg [1:0] D3y_now;

    assign D1x_now = D1x_NOW;
    assign D1y_now = D1y_NOW;
    assign D2x_now = D2x_NOW;
    assign D2y_now = D2y_NOW;
    assign D3x_now = D3x_NOW;
    assign D3y_now = D3y_NOW;

    assign Collision_1_2 = ( FLAG[0] && FLAG[1] ) ? 1 : 0;
    assign Collision_1_3 = ( FLAG[0] && FLAG[2] ) ? 1 : 0;
    assign Collision_2_3 = ( FLAG[1] && FLAG[2] ) ? 1 : 0;

    always @(posedge clk or posedge rst)
        if(rst) begin     
        end
        else begin
            if (Collision_1_2) begin
                D1x_UPDATE = -1 * D1x_now;
                D1y_UPDATE = -1 * D1y_now;
            end
            else if (Collision_1_3) begin
                D2x_UPDATE = -1 * D1x_now;
                D2y_UPDATE = -1 * D1y_now;
            end
            else if (Collision_2_3) begin
                D3x_UPDATE = -1 * D1x_now;
                D3y_UPDATE = -1 * D1y_now;
            end
        end
endmodule
