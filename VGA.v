`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 09:17:30 PM
// Design Name: 
// Module Name: VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Code for using the VGA port on FPGA at 640X480 resolution
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA(
    input clk, reset,
    input [11:0] SW,
    output reg hsync, vsync,
    output reg [11:0] vga,
    output [9:0] x,y
    );
    
    reg [1:0] clk_vga;
    
    always @(posedge clk) begin
        if (reset) clk_vga <= 0;
        else clk_vga <= clk_vga + 1'b1;
    end
    
    wire tick_25M = (clk_vga == 2'b11) ? 1 : 0;

   localparam HD = 640;  // horizontal display area
   localparam HF = 16;   // h. front porch
   localparam HB = 48;   // h. back porch
   localparam HR = 96;   // h. retrace
   localparam HT = HD+HF+HB+HR; // horizontal total (800)
   localparam VD = 480;  // vertical display area
   localparam VF = 10;   // v. front porch
   localparam VB = 33;   // v. back porch
   localparam VR = 2;    // v. retrace
   localparam VT = VD+VF+VB+VR; // vertical total (525)
   
   reg [9:0] hcount, vcount;
   reg [9:0] hcount_next, vcount_next;
   
   always @(*) begin
    if (tick_25M) begin
        hcount_next = (hcount==HT-1) ? 0 : hcount + 1;
        if (hcount == HT-1) vcount_next = (vcount==VT-1) ? 0 : vcount + 1;
        else vcount_next = vcount;
    end
    else begin
        hcount_next = hcount;
        vcount_next = vcount;
    end
   end
   
   always @(posedge clk) begin
    if (reset) {hcount,vcount} <= 'b0;
    else begin
        hcount <= hcount_next;
        vcount <= vcount_next;
    end
   end
   
   wire display_area_on = (hcount < HD) && (vcount < VD);
   
   wire hsync_next = ((hcount>=(HD+HF)) && (hcount<=(HD+HF+HR-1))) ? 0 : 1;
   wire vsync_next = ((vcount>=(VD+VF)) && (vcount<=(VD+VF+VR-1))) ? 0 : 1;
   wire [11:0] vga_next = (display_area_on) ? SW : 0;
   
   always @(posedge clk) begin
    if (reset) {hsync,vsync,vga} <= 0;
    else begin
        hsync <= hsync_next;
        vsync <= vsync_next;
        vga <= vga_next;
    end
   end
   
   assign x = hcount;
   assign y = vcount;

endmodule
