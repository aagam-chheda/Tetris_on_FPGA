`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 06:31:25 PM
// Design Name: 
// Module Name: full_game
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


module full_game(
    input clk, resetn, clockwise, anti_clkwise, down, left, right, select,
    output hsync, vsync,
    output [11:0] vga    
    );
    
    wire reset = ~resetn;
    wire [1:0] velocity = 2'b00;
    wire [11:0] colour_calc_gs, colour_calc_play, colour_calc_go;
    reg [11:0] colour_calc;
    wire [9:0] x, y;
    reg [1:0] current, next;
    wire clockwise_db, anti_clkwise_db, down_db, left_db, right_db, select_db;
    reg [1:0] velocity_current, velocity_next;
    debouncing_circuit for_clockwise (clk, reset, clockwise, clockwise_db);
    debouncing_circuit for_anti_clkwise (clk, reset, anti_clkwise, anti_clkwise_db);
    debouncing_circuit for_down (clk, reset, down, down_db);
    debouncing_circuit for_left (clk, reset, left, left_db);
    debouncing_circuit for_right (clk, reset, right, right_db);
    debouncing_circuit select_pin (clk, reset, select, select_db);
    
    localparam start = 2'b0, play = 2'b01, over = 2'b10;
    
    always @(*) begin
        case (current)
            start: colour_calc = colour_calc_gs;
            play: colour_calc = colour_calc_play;
            over: colour_calc = colour_calc_go;
            default: colour_calc = colour_calc_gs;
        endcase
    end
    
    wire clk_en_ss = (current == 2'b0);
    
    wire clk_en_gs = (current == 2'b01);
    
    wire clk_en_go = (current == 2'b10);
    
    
    VGA vga_circuit(clk, reset, colour_calc2, hsync, vsync, vga, x, y);
    wire game_over_logic;
    game_screen GS (clk, resetn, clockwise_db, anti_clkwise_db, down_db, left_db, right_db, velocity_current, x, y, colour_calc_play, clk_en_gs, game_over_logic);
    level1bmp_rom LR (clk, y, x, colour_calc_gs, clk_en_ss);
    game_over GO (clk, y, x, colour_calc_go, clk_en_go);
    
    
    always @(*) begin
        case (current)
            start: next = (select_db) ? play : start;
            play: next = (game_over_logic) ? over : play;
            over: next = (select_db) ? start : over;
            default: next = start;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) current <= start;
        else current <= next;
    end
    
    localparam l1_leftx = 277, l1_rightx = 280;
    localparam l1_topy = 200, l1_bottomy = 203;
    
    localparam l2_leftx = 251, l2_rightx = 257;
    localparam l2_topy = 233, l2_bottomy = 239;
    
    localparam l3_leftx = 223, l3_rightx = 233;
    localparam l3_topy = 273, l3_bottomy = 283;
    
    
    
    wire l1_box = (x<= l1_rightx && x>=l1_leftx && y<=l1_bottomy && y>=l1_topy) && current == 2'b00;
    wire l2_box = (x<= l2_rightx && x>=l2_leftx && y<=l2_bottomy && y>=l2_topy) && current == 2'b00;
    wire l3_box = (x<= l3_rightx && x>=l3_leftx && y<=l3_bottomy && y>=l3_topy) && current == 2'b00;
    
    always @(*) begin
        case(velocity_current)
            2'b00: velocity_next = (down_db && current == 2'b0) ? 2'b01: 2'b00;
            2'b01: velocity_next = (down_db && current == 2'b0) ? 2'b10: 2'b01;
            2'b10: velocity_next = (down_db && current == 2'b0) ? 2'b00: 2'b10;     
            default: velocity_next = 2'b00;     
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) velocity_current <= 2'b00;
        else velocity_current <= velocity_next;
    end
    
    localparam white = {12{1'b1}};
    
    reg [11:0] colour_calc2;
    
    always @(*) begin
        case ({l1_box,l2_box,l3_box})
            3'b100: colour_calc2 = (velocity_current == 2'b00) ? white : 0;
            3'b010: colour_calc2 = (velocity_current == 2'b01) ? white : 0;
            3'b001: colour_calc2 = (velocity_current == 2'b10) ? white : 0;
            default: colour_calc2 = colour_calc;
        endcase
    end
        
endmodule
