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

module Collision_V_update(
    input clk,
    input rst,
    input [1:0] V1x_NOW,
    input [1:0] V1y_NOW,
    input [1:0] V2x_NOW,
    input [1:0] V2y_NOW,
    input [1:0] V3x_NOW,
    input [1:0] V3y_NOW,

    output reg [1:0] V1x_UPDATE,
    output reg [1:0] V1y_UPDATE,
    output reg [1:0] V2x_UPDATE,
    output reg [1:0] V2y_UPDATE,
    output reg [1:0] V3x_UPDATE,
    output reg [1:0] V3y_UPDATE

    output reg [1:0] D1x_UPDATE,
    output reg [1:0] D1y_UPDATE,
    output reg [1:0] D2x_UPDATE,
    output reg [1:0] D2y_UPDATE,
    output reg [1:0] D3x_UPDATE,
    output reg [1:0] D3y_UPDATE
    );

    reg ball12_LTRB;
    reg ball12_RTLB;
    reg ball12_LBRT;
    reg ball12_RBLT;
    reg ball12_LCRC;
    reg ball12_RCLC;
    reg ball12_CTCB;
    reg ball12_CBCT;

    reg ball13_LTRB;
    reg ball13_RTLB;
    reg ball13_LBRT;
    reg ball13_RBLT;
    reg ball13_LCRC;
    reg ball13_RCLC;
    reg ball13_CTCB;
    reg ball13_CBCT;

    reg ball23_LTRB;
    reg ball23_RTLB;
    reg ball23_LBRT;
    reg ball23_RBLT;
    reg ball23_LCRC; 
    reg ball23_RCLC; 
    reg ball23_CTCB;
    reg ball23_CBCT;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
        end
        else begin
            if (ball12_LTRB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if ( ball12_RTLB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_LBRT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_RBLT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end 
            else if (ball12_LCRC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_RCLC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_CTCB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_CBCT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_LTRB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_RTLB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_LBRT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_RBLT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end 
            else if (ball13_LCRC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_RCLC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_CTCB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball13_CBCT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end//
        end  
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
        end
        else begin
            if (ball12_LTRB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_RTLB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_LBRT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_RBLT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end 
            else if (ball12_LCRC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_RCLC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_CTCB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball12_CBCT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball23_LTRB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RTLB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_LBRT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RBLT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end 
            else if (ball23_LCRC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RCLC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_CTCB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_CBCT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end//
        end  
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
        end
        else begin
            if (ball13_LTRB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_RTLB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_LBRT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_RBLT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end 
            else if (ball13_LCRC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_RCLC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_CTCB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball13_CBCT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V2x_NOW;
                V1y_UPDATE = V2y_NOW;
            end
            else if (ball23_LTRB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RTLB) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_LBRT) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RBLT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= 1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end 
            else if (ball23_LCRC) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_RCLC) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_CTCB) begin 
                D1x_UPDATE <= -1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end
            else if (ball23_CBCT) begin 
                D1x_UPDATE <= 1;
                D1y_UPDATE <= -1;
                V1x_UPDATE = V3x_NOW;
                V1y_UPDATE = V3y_NOW;
            end//
        end  
    end
endmodule