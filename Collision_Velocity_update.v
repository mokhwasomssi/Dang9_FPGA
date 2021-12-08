`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 19:22:02
// Design Name: 
// Module Name: Collision_Velocity_update
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

module Collision_Velocity_update(
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

    input [1:0] V1x_NOW,
    input [1:0] V1y_NOW,
    input [1:0] V2x_NOW,
    input [1:0] V2y_NOW,
    input [1:0] V3x_NOW,
    input [1:0] V3y_NOW,

    input [9:0] Ball1x,Ball1y;
    input [9:0] Ball2x,Ball2y;
    input [9:0] Ball3x,Ball3y;

    output reg [1:0] V1x_UPDATE,
    output reg [1:0] V1y_UPDATE,
    output reg [1:0] V2x_UPDATE,
    output reg [1:0] V2y_UPDATE,
    output reg [1:0] V3x_UPDATE,
    output reg [1:0] V3y_UPDATE
    );
    
    reg [1:0] V1x_now;
    reg [1:0] V1y_now;
    reg [1:0] V2x_now;
    reg [1:0] V2y_now;
    reg [1:0] V3x_now;
    reg [1:0] V3y_now;

    assign V1x_now = V1x_NOW;
    assign V1y_now = V1y_NOW;
    assign V2x_now = V2x_NOW;
    assign V2y_now = V2y_NOW;
    assign V3x_now = V3x_NOW;
    assign V3y_now = V3y_NOW;

    assign Collision_1_2 = ( FLAG[0] && FLAG[1] ) ? 1 : 0;
    assign Collision_1_3 = ( FLAG[0] && FLAG[2] ) ? 1 : 0;
    assign Collision_2_3 = ( FLAG[1] && FLAG[2] ) ? 1 : 0;

    always @(posedge clk or posedge rst)
        if(rst) begin     
        end
        else begin

        end
endmodule
//https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=since860321&logNo=130167398447