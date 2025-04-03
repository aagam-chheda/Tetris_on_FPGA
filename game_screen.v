`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2025 12:59:03
// Design Name: 
// Module Name: game_screen
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

//[203,11]  [433,11]
//[203,471] [433, 471]
// each box 22 pixels in length and breadth
//border length 1

module game_screen(
    input clk, resetn,
    input clockwise_db, anti_clkwise_db, down_db,left_db,right_db,
    input [1:0] velocity,
    input [9:0] x, y,
    output reg [11:0] colour_calc,
    input ce,
    output game_over_logic
    );
    //wire clockwise_db, anti_clkwise_db, down_db, left_db, right_db;
    
    wire game_over = game_over_logic;
    
    wire block_settling_reset;
    
    wire [4:0] changed_y1, changed_y2, changed_y3, changed_y4;
    
    wire reset = ~resetn | game_over;
    
    wire [3:0] x1_next_out, x2_next_out, x3_next_out, x4_next_out;
    wire [4:0] y1_next_out, y2_next_out, y3_next_out, y4_next_out;
    
    wire random_block_reset = reset | block_settling_reset;
    
    wire [15:0] score;
    
    
    wire [2:0] block_type;
    RaNuGe random(clk, reset, random_block_reset, block_type, ce);
    
//    debouncing_circuit for_clockwise (clk, reset, clockwise, clockwise_db);
//    debouncing_circuit for_anti_clkwise (clk, reset, anti_clkwise, anti_clkwise_db);
//    debouncing_circuit for_down (clk, reset, down, down_db);
//    debouncing_circuit for_left (clk, reset, left, left_db);
//    debouncing_circuit for_right (clk, reset, right, right_db);
    
    
    //reg [11:0] colour_calc;
    //wire [9:0] x, y;
    //localparam background = 12'b1000_0100_0100;
    localparam background = 12'b0;
    //localparam middle = 12'b1111_0111_0000;
    localparam middle = {12{1'b0}};
    localparam white = {12{1'b1}};
    localparam left_x = 10'd203, right_x = 10'd433, top = 10'd11, bottom = 10'd471;
    
    localparam thsnd_left = 10'd50, thsnd_right = 10'd69;
    localparam thsnd_f_right = 10'd54, thsnd_b_left = 10'd65;
    
    localparam hndrd_left = 10'd75, hndrd_right = 10'd94;
    localparam hndrd_f_right = 10'd79, hndrd_b_left = 10'd90;
    
    localparam tens_left = 10'd100, tens_right = 10'd119;
    localparam tens_f_right = 10'd104, tens_b_left = 10'd115;
    
    localparam units_left = 10'd125, units_right = 10'd144;
    localparam units_f_right = 10'd129, units_b_left = 10'd140;
    
    localparam a_top = 10'd139, a_bottom = 10'd145, b_top = 146, b_bottom = 152;
    localparam g_top = 10'd153, g_bottom = 10'd159, c_top = 160, c_bottom = 166;
    localparam d_top = 10'd167, d_bottom = 10'd173;
    
    wire thsnd_a, thsnd_b, thsnd_c, thsnd_d, thsnd_e, thsnd_f, thsnd_g;
    wire hndrd_a, hndrd_b, hndrd_c, hndrd_d, hndrd_e, hndrd_f, hndrd_g;
    wire tens_a, tens_b, tens_c, tens_d, tens_e, tens_f, tens_g;
    wire units_a, units_b, units_c, units_d, units_e, units_f, units_g;
    
    segment7 thousands(score[15:12], thsnd_a, thsnd_b, thsnd_c, thsnd_d, thsnd_e, thsnd_f, thsnd_g);
    segment7 hundreds(score[11:8], hndrd_a, hndrd_b, hndrd_c, hndrd_d, hndrd_e, hndrd_f, hndrd_g);
    segment7 tens_place(score[7:4], tens_a, tens_b, tens_c, tens_d, tens_e, tens_f, tens_g);
    segment7 units_place(score[3:0], units_a, units_b, units_c, units_d, units_e, units_f, units_g);
    
    wire [6:0] scrn_at_thsnd = {(x<=thsnd_right && x>=thsnd_left && y>=a_top && y<=a_bottom), //a
                                (x<=thsnd_right && x>=thsnd_b_left && y>=b_top && y<=b_bottom), //b
                                (x<=thsnd_right && x>=thsnd_b_left && y>=c_top && y<=c_bottom), //c
                                (x<=thsnd_right && x>=thsnd_left && y>=d_top && y<=d_bottom), //d
                                (x<=thsnd_f_right && x>=thsnd_left && y>=c_top && y<=c_bottom), //e
                                (x<=thsnd_f_right && x>=thsnd_left && y>=b_top && y<=b_bottom), //f
                                (x<=thsnd_right && x>=thsnd_left && y>=g_top && y<=g_bottom) //g
    };
    
    
    wire [6:0] scrn_at_hndrd = {(x<=hndrd_right && x>=hndrd_left && y>=a_top && y<=a_bottom), //a
                                (x<=hndrd_right && x>=hndrd_b_left && y>=b_top && y<=b_bottom), //b
                                (x<=hndrd_right && x>=hndrd_b_left && y>=c_top && y<=c_bottom), //c
                                (x<=hndrd_right && x>=hndrd_left && y>=d_top && y<=d_bottom), //d
                                (x<=hndrd_f_right && x>=hndrd_left && y>=c_top && y<=c_bottom), //e
                                (x<=hndrd_f_right && x>=hndrd_left && y>=b_top && y<=b_bottom), //f
                                (x<=hndrd_right && x>=hndrd_left && y>=g_top && y<=g_bottom) //g
    };
    
    
    wire [6:0] scrn_at_tens = {(x<=tens_right && x>=tens_left && y>=a_top && y<=a_bottom), //a
                                (x<=tens_right && x>=tens_b_left && y>=b_top && y<=b_bottom), //b
                                (x<=tens_right && x>=tens_b_left && y>=c_top && y<=c_bottom), //c
                                (x<=tens_right && x>=tens_left && y>=d_top && y<=d_bottom), //d
                                (x<=tens_f_right && x>=tens_left && y>=c_top && y<=c_bottom), //e
                                (x<=tens_f_right && x>=tens_left && y>=b_top && y<=b_bottom), //f
                                (x<=tens_right && x>=tens_left && y>=g_top && y<=g_bottom) //g
    };
    
    
    wire [6:0] scrn_at_units = {(x<=units_right && x>=units_left && y>=a_top && y<=a_bottom), //a
                                (x<=units_right && x>=units_b_left && y>=b_top && y<=b_bottom), //b
                                (x<=units_right && x>=units_b_left && y>=c_top && y<=c_bottom), //c
                                (x<=units_right && x>=units_left && y>=d_top && y<=d_bottom), //d
                                (x<=units_f_right && x>=units_left && y>=c_top && y<=c_bottom), //e
                                (x<=units_f_right && x>=units_left && y>=b_top && y<=b_bottom), //f
                                (x<=units_right && x>=units_left && y>=g_top && y<=g_bottom) //g
    };
    
    wire scrn_in_middle = ((x <= right_x) && (x >= left_x) && (y <= bottom) && (y >= top));
    
    
    
    //VGA vga_circuit(clk, reset, colour_calc, hsync, vsync, vga, x, y);
    
    
    wire [3:0] x1, x2, x3, x4;
    wire [4:0] y1, y2, y3, y4;
    
    wire [9:0] block1_x, block2_x, block3_x, block4_x;
    wire [9:0] block1_y, block2_y, block3_y, block4_y;
    
    wire [3:0] changed_x1, changed_x2, changed_x3, changed_x4;
    
    assign block1_x = 10'd203 + (10'd23)*(x1);
    assign block2_x = 10'd203 + (10'd23)*(x2);
    assign block3_x = 10'd203 + (10'd23)*(x3);
    assign block4_x = 10'd203 + (10'd23)*(x4);
    
    assign block1_y = 10'd11 + (10'd23)*(y1);
    assign block2_y = 10'd11 + (10'd23)*(y2);
    assign block3_y = 10'd11 + (10'd23)*(y3);
    assign block4_y = 10'd11 + (10'd23)*(y4);
    
    reg [3:0] movement; //  000 clockwise, 001 anti-clockwise, 010 down, 011 left, 100 right, 101 nothing

    always@(*) begin
        case({clockwise_db, anti_clkwise_db, down_db, left_db, right_db})
            5'b10000: movement = 4'b0000; //rotate clockwise
            5'b01000: movement = 4'b0001; // rotate anticlowise
            5'b00100: movement = 4'b0010; // move down quickly
            5'b00010: movement = 4'b0011; // move left
            5'b00001: movement = 4'b0100; // move right
            default: movement = 4'b0101; // on no input will move down automatically at a certain velocity
        endcase
    end
    
    reg [11:0] block_colour;
    
    localparam yellow = 12'b0000_1111_1111;
    localparam magenta = 12'b1111_0000_1111;
    localparam green = 12'b0000_1111_1000;
    localparam orange = 12'b0000_1000_1111;
    localparam red = 12'b0000_0000_1111;
    localparam blue = 12'b1111_0000_0000;
    localparam light_blue = 12'b1101_1101_0100;
    
    
    
    block_logic blocks(clk, reset, movement, block_type, x1,x2,x3,x4, y1,y2,y3,y4, velocity, block_settling_reset, x1_next_out, x2_next_out, x3_next_out, x4_next_out, y1_next_out, y2_next_out, y3_next_out, y4_next_out, changed_x1, changed_x2, changed_x3, changed_x4, changed_y1, changed_y2, changed_y3, changed_y4, ce);
    
    always @(*) begin
        case(block_type)
            3'd1: block_colour = blue;
            3'd2: block_colour = yellow;
            3'd3: block_colour = magenta;
            3'd4: block_colour = green;
            3'd5: block_colour = orange;
            3'd6: block_colour = red;
            3'd7: block_colour = light_blue;
            default: block_colour = middle;
        endcase
    end
    
    wire [11:0] middle_color; 
    
    wire [3:0] x_b;
    wire [4:0] y_b;
    wire border_x, border_y;
    
    board_implementation BoIm(clk, reset, x, y, x_b, y_b, border_x, border_y, ce);
    
    
    
    
    block_settling BS(x_b, y_b, clk, reset, y1, y2, y3, y4, x1, x2, x3, x4, block_type, middle_color, block_settling_reset, x1_next_out, x2_next_out, x3_next_out, x4_next_out, y1_next_out, y2_next_out, y3_next_out, y4_next_out, movement, changed_x1, changed_x2, changed_x3, changed_x4, changed_y1, changed_y2, changed_y3, changed_y4, score, ce, game_over_logic);
    
       
    localparam border_color = 12'b0001_0001_0001;
    
    always @(*) begin
    
        case({|scrn_at_thsnd, |scrn_at_hndrd, |scrn_at_tens, |scrn_at_units, scrn_in_middle})
            5'b10000: colour_calc = (scrn_at_thsnd[6]&&thsnd_a || scrn_at_thsnd[5]&&thsnd_b || scrn_at_thsnd[4]&&thsnd_c || scrn_at_thsnd[3]&&thsnd_d || scrn_at_thsnd[2]&&thsnd_e || scrn_at_thsnd[1]&&thsnd_f || scrn_at_thsnd[0]&&thsnd_g) ? white : background;
            5'b01000: colour_calc = (scrn_at_hndrd[6]&&hndrd_a || scrn_at_hndrd[5]&&hndrd_b || scrn_at_hndrd[4]&&hndrd_c || scrn_at_hndrd[3]&&hndrd_d || scrn_at_hndrd[2]&&hndrd_e || scrn_at_hndrd[1]&&hndrd_f || scrn_at_hndrd[0]&&hndrd_g) ? white : background;
            5'b00100: colour_calc = (scrn_at_tens[6]&&tens_a || scrn_at_tens[5]&&tens_b || scrn_at_tens[4]&&tens_c || scrn_at_tens[3]&&tens_d || scrn_at_tens[2]&&tens_e || scrn_at_tens[1]&&tens_f || scrn_at_tens[0]&&tens_g) ? white : background;
            5'b00010: colour_calc = (scrn_at_units[6]&&units_a || scrn_at_units[5]&&units_b || scrn_at_units[4]&&units_c || scrn_at_units[3]&&units_d || scrn_at_units[2]&&units_e || scrn_at_units[1]&&units_f || scrn_at_units[0]&&units_g) ? white : background;
            5'b00001: begin
                
                if (x1 == x_b & y1 == y_b || x2 == x_b & y2 == y_b || x3 == x_b & y3 == y_b || x4 == x_b & y4 == y_b) begin
                    colour_calc = (border_x | border_y) ? border_color: block_colour;
                end
                else colour_calc = (border_x | border_y) ? border_color: middle_color;
            end
            default: colour_calc = background;
        endcase
    end
    
endmodule