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
    wire [3:0] units_place, tens_place, hundreds_place, thousands_place;
    score_conversion SC(score, clk, reset, units_place, tens_place, hundreds_place, thousands_place);
    
    
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
    
    // localparam thsnd_left = 10'd50, thsnd_right = 10'd69;
    // localparam thsnd_f_right = 10'd54, thsnd_b_left = 10'd65;
    
    // localparam hndrd_left = 10'd75, hndrd_right = 10'd94;
    // localparam hndrd_f_right = 10'd79, hndrd_b_left = 10'd90;
    
    // localparam tens_left = 10'd100, tens_right = 10'd119;
    // localparam tens_f_right = 10'd104, tens_b_left = 10'd115;
    
    // localparam units_left = 10'd125, units_right = 10'd144;
    // localparam units_f_right = 10'd129, units_b_left = 10'd140;
    
    // localparam a_top = 10'd139, a_bottom = 10'd145, b_top = 146, b_bottom = 152;
    // localparam g_top = 10'd153, g_bottom = 10'd159, c_top = 160, c_bottom = 166;
    // localparam d_top = 10'd167, d_bottom = 10'd173;

    localparam thsnd_x1=50, thsnd_x2=54, thsnd_x3=55, thsnd_x4=64, thsnd_x5=65, thsnd_x6=69;
    localparam hndrd_x1=75, hndrd_x2=79, hndrd_x3=80, hndrd_x4=89, hndrd_x5=90, hndrd_x6=94;
    localparam tens_x1=100, tens_x2=104, tens_x3=105, tens_x4=114, tens_x5=115, tens_x6=119;
    localparam units_x1=125, units_x2=129, units_x3=130, units_x4=139, units_x5=140, units_x6=144;

    localparam y_1=139, y_2=143, y_3=144, y_4=153, y_5=154, y_6=158, y_7=159, y_8=168, y_9=169, y_10=173;
    
    wire thsnd_a, thsnd_b, thsnd_c, thsnd_d, thsnd_e, thsnd_f, thsnd_g,thsnd_h,thsnd_i, thsnd_j, thsnd_k, thsnd_l, thsnd_m;
    wire hndrd_a, hndrd_b, hndrd_c, hndrd_d, hndrd_e, hndrd_f, hndrd_g,hndrd_h,hndrd_i, hndrd_j, hndrd_k, hndrd_l, hndrd_m;
    wire tens_a, tens_b, tens_c, tens_d, tens_e, tens_f, tens_g, tens_h, tens_i, tens_j, tens_k, tens_l, tens_m;
    wire units_a, units_b, units_c, units_d, units_e, units_f, units_g, units_h, units_i, units_j, units_k, units_l, units_m;
    
    segment7 thousands_(thousands_place, thsnd_a, thsnd_b, thsnd_c, thsnd_d, thsnd_e, thsnd_f, thsnd_g);
    segment7 hundreds_(hundreds_place, hndrd_a, hndrd_b, hndrd_c, hndrd_d, hndrd_e, hndrd_f, hndrd_g);
    segment7 tens_(tens_place, tens_a, tens_b, tens_c, tens_d, tens_e, tens_f, tens_g);
    segment7 units_(units_place, units_a, units_b, units_c, units_d, units_e, units_f, units_g);
    
    wire [12:0] scrn_at_thsnd = {(x>=thsnd_x5 && x<=thsnd_x6 && y>=y_1 && y<=y_2), //a
                                (x>=thsnd_x5 && x<=thsnd_x6 && y>=y_3 && y<=y_4), //b
                                (x>=thsnd_x5 && x<=thsnd_x6 && y>=y_5 && y<=y_6), //c
                                (x>=thsnd_x5 && x<=thsnd_x6 && y>=y_7 && y<=y_8), //d
                                (x>=thsnd_x5 && x<=thsnd_x6 && y>=y_9 && y<=y_10), //e
                                (x>=thsnd_x3 && x<=thsnd_x4 && y>=y_9 && y<=y_10), //f
                                (x>=thsnd_x1 && x<=thsnd_x2 && y>=y_9 && y<=y_10), //g
                                (x>=thsnd_x1 && x<=thsnd_x2 && y>=y_7 && y<=y_8), //h
                                (x>=thsnd_x1 && x<=thsnd_x2 && y>=y_5 && y<=y_6), //i
                                (x>=thsnd_x1 && x<=thsnd_x2 && y>=y_3 && y<=y_4), //j
                                (x>=thsnd_x1 && x<=thsnd_x2 && y>=y_1 && y<=y_2), //k
                                (x>=thsnd_x3 && x<=thsnd_x4 && y>=y_1 && y<=y_2), //l
                                (x>=thsnd_x3 && x<=thsnd_x4 && y>=y_5 && y<=y_6), //m
                            };
    
    
    wire [12:0] scrn_at_hndrd = {(x>=hndrd_x5 && x<=hndrd_x6 && y>=y_1 && y<=y_2), //a
                                (x>=hndrd_x5 && x<=hndrd_x6 && y>=y_3 && y<=y_4), //b
                                (x>=hndrd_x5 && x<=hndrd_x6 && y>=y_5 && y<=y_6), //c
                                (x>=hndrd_x5 && x<=hndrd_x6 && y>=y_7 && y<=y_8), //d
                                (x>=hndrd_x5 && x<=hndrd_x6 && y>=y_9 && y<=y_10), //e
                                (x>=hndrd_x3 && x<=hndrd_x4 && y>=y_9 && y<=y_10), //f
                                (x>=hndrd_x1 && x<=hndrd_x2 && y>=y_9 && y<=y_10), //g
                                (x>=hndrd_x1 && x<=hndrd_x2 && y>=y_7 && y<=y_8), //h
                                (x>=hndrd_x1 && x<=hndrd_x2 && y>=y_5 && y<=y_6), //i
                                (x>=hndrd_x1 && x<=hndrd_x2 && y>=y_3 && y<=y_4), //j
                                (x>=hndrd_x1 && x<=hndrd_x2 && y>=y_1 && y<=y_2), //k
                                (x>=hndrd_x3 && x<=hndrd_x4 && y>=y_1 && y<=y_2), //l
                                (x>=hndrd_x3 && x<=hndrd_x4 && y>=y_5 && y<=y_6), //m
                            };
    
    
    wire [12:0] scrn_at_tens = { (x>=tens_x5 && x<=tens_x6 && y>=y_1 && y<=y_2), //a
                                (x>=tens_x5 && x<=tens_x6 && y>=y_3 && y<=y_4), //b
                                (x>=tens_x5 && x<=tens_x6 && y>=y_5 && y<=y_6), //c
                                (x>=tens_x5 && x<=tens_x6 && y>=y_7 && y<=y_8), //d
                                (x>=tens_x5 && x<=tens_x6 && y>=y_9 && y<=y_10), //e
                                (x>=tens_x3 && x<=tens_x4 && y>=y_9 && y<=y_10), //f
                                (x>=tens_x1 && x<=tens_x2 && y>=y_9 && y<=y_10), //g
                                (x>=tens_x1 && x<=tens_x2 && y>=y_7 && y<=y_8), //h
                                (x>=tens_x1 && x<=tens_x2 && y>=y_5 && y<=y_6), //i
                                (x>=tens_x1 && x<=tens_x2 && y>=y_3 && y<=y_4), //j
                                (x>=tens_x1 && x<=tens_x2 && y>=y_1 && y<=y_2), //k
                                (x>=tens_x3 && x<=tens_x4 && y>=y_1 && y<=y_2), //l
                                (x>=tens_x3 && x<=tens_x4 && y>=y_5 && y<=y_6), //m
                            };
    
    
    wire [12:0] scrn_at_units = {(x>=units_x5 && x<=units_x6 && y>=y_1 && y<=y_2), //a
                                (x>=units_x5 && x<=units_x6 && y>=y_3 && y<=y_4), //b
                                (x>=units_x5 && x<=units_x6 && y>=y_5 && y<=y_6), //c
                                (x>=units_x5 && x<=units_x6 && y>=y_7 && y<=y_8), //d
                                (x>=units_x5 && x<=units_x6 && y>=y_9 && y<=y_10), //e
                                (x>=units_x3 && x<=units_x4 && y>=y_9 && y<=y_10), //f
                                (x>=units_x1 && x<=units_x2 && y>=y_9 && y<=y_10), //g
                                (x>=units_x1 && x<=units_x2 && y>=y_7 && y<=y_8), //h
                                (x>=units_x1 && x<=units_x2 && y>=y_5 && y<=y_6), //i
                                (x>=units_x1 && x<=units_x2 && y>=y_3 && y<=y_4), //j
                                (x>=units_x1 && x<=units_x2 && y>=y_1 && y<=y_2), //k
                                (x>=units_x3 && x<=units_x4 && y>=y_1 && y<=y_2), //l
                                (x>=units_x3 && x<=units_x4 && y>=y_5 && y<=y_6), //m
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
            5'b10000: colour_calc = (scrn_at_thsnd[12]&&thsnd_a || scrn_at_thsnd[11]&&thsnd_b || scrn_at_thsnd[10]&&thsnd_c || scrn_at_thsnd[9]&&thsnd_d || scrn_at_thsnd[8]&&thsnd_e || scrn_at_thsnd[7]&&thsnd_f || scrn_at_thsnd[6]&&thsnd_g ||scrn_at_thsnd[5]&&thsnd_h ||scrn_at_thsnd[4]&&thsnd_i ||scrn_at_thsnd[3]&&thsnd_j ||scrn_at_thsnd[2]&&thsnd_k ||scrn_at_thsnd[1]&&thsnd_l ||scrn_at_thsnd[0]&&thsnd_m) ? white : background;
            // 5'b01000: colour_calc = (scrn_at_hndrd[6]&&hndrd_a || scrn_at_hndrd[5]&&hndrd_b || scrn_at_hndrd[4]&&hndrd_c || scrn_at_hndrd[3]&&hndrd_d || scrn_at_hndrd[2]&&hndrd_e || scrn_at_hndrd[1]&&hndrd_f || scrn_at_hndrd[0]&&hndrd_g) ? white : background;
            // 5'b00100: colour_calc = (scrn_at_tens[6]&&tens_a || scrn_at_tens[5]&&tens_b || scrn_at_tens[4]&&tens_c || scrn_at_tens[3]&&tens_d || scrn_at_tens[2]&&tens_e || scrn_at_tens[1]&&tens_f || scrn_at_tens[0]&&tens_g) ? white : background;
            // 5'b00010: colour_calc = (scrn_at_units[6]&&units_a || scrn_at_units[5]&&units_b || scrn_at_units[4]&&units_c || scrn_at_units[3]&&units_d || scrn_at_units[2]&&units_e || scrn_at_units[1]&&units_f || scrn_at_units[0]&&units_g) ? white : background;

            5'b01000: begin
                colour_calc = (scrn_at_hndrd[12]&&hndrd_a || scrn_at_hndrd[11]&&hndrd_b || scrn_at_hndrd[10]&&hndrd_c || scrn_at_hndrd[9]&&hndrd_d || scrn_at_hndrd[8]&&hndrd_e || scrn_at_hndrd[7]&&hndrd_f || scrn_at_hndrd[6]&&hndrd_g ||scrn_at_hndrd[5]&&hndrd_h ||scrn_at_hndrd[4]&&hndrd_i ||scrn_at_hndrd[3]&&hndrd_j ||scrn_at_hndrd[2]&&hndrd_k ||scrn_at_hndrd[1]&&hndrd_l ||scrn_at_hndrd[0]&&hndrd_m) ? white : background;
            end

            5'b00100: begin
                colour_calc = (scrn_at_tens[12]&&tens_a || scrn_at_tens[11]&&tens_b || scrn_at_tens[10]&&tens_c || scrn_at_tens[9]&&tens_d || scrn_at_tens[8]&&tens_e || scrn_at_tens[7]&&tens_f || scrn_at_tens[6]&&tens_g ||scrn_at_tens[5]&&tens_h ||scrn_at_tens[4]&&tens_i ||scrn_at_tens[3]&&tens_j ||scrn_at_tens[2]&&tens_k ||scrn_at_tens[1]&&tens_l ||scrn_at_tens[0]&&tens_m) ? white : background;
            end

            5'b00010: begin
                colour_calc = (scrn_at_units[12]&&units_a || scrn_at_units[11]&&units_b || scrn_at_units[10]&&units_c || scrn_at_units[9]&&units_d || scrn_at_units[8]&&units_e || scrn_at_units[7]&&units_f || scrn_at_units[6]&&units_g ||scrn_at_units[5]&&units_h ||scrn_at_units[4]&&units_i ||scrn_at_units[3]&&units_j ||scrn_at_units[2]&&units_k ||scrn_at_units[1]&&units_l ||scrn_at_units[0]&&units_m) ? white : background;
            end

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