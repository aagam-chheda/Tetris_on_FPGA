`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 05:26:05 PM
// Design Name: 
// Module Name: block_settling
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


module block_settling(
    input [3:0] x_vga2, 
    input [4:0] y_vga2,
    input clk, reset,
    input [4:0] y1,y2,y3,y4,
    input [3:0] x1,x2,x3,x4,
    input [2:0] block_type,
    output [11:0] color,
    output reg block_logic_reset
    );
    //localparam middle = 12'b1111_0111_0000;
    localparam middle = {12{1'b0}};
    localparam white = {12{1'b1}};
    reg [0:9] matrix [0:20];
    reg [3:0] color_matrix [0:19][0:9];
    
    
    wire [4:0] y1p, y2p, y3p, y4p;
    
    assign x1p = x1 + 4'd1;
    assign x2p = x2 + 4'd1;
    assign x3p = x3 + 4'd1;
    assign x4p = x4 + 4'd1;
    assign y1p = y1 + 5'd1;
    assign y2p = y2 + 5'd1;
    assign y3p = y3 + 5'd1;
    assign y4p = y4 + 5'd1;
    
    
    wire oob = matrix[y1p][x1] | matrix[y2p][x2] | matrix[y3p][x3] | matrix[y4p][x4];
    
    integer i,j,a,new_a,l,m;
    
    always @(posedge clk) begin
        if (reset) begin
            matrix[0] <= 0;
            matrix[1] <= 0;
            matrix[2] <= 0;
            matrix[3] <= 0;
            matrix[4] <= 0;
            matrix[5] <= 0;
            matrix[6] <= 0;
            matrix[7] <= 0;
            matrix[8] <= 0;
            matrix[9] <= 0;
            matrix[10]<= 0;
            matrix[11] <= 0;
            matrix[12] <= 0;
            matrix[13] <= 0;
            matrix[14] <= 0;
            matrix[15] <= 0;
            matrix[16] <= 0;
            matrix[17] <= 0;
            matrix[18] <= 0;
            matrix[19] <= 0;
            matrix[20] <= {10{1'b1}};
            block_logic_reset <= 1'b0;
            // for(i = 0; i < 20; i = i + 1)
            //     for(j = 0; j < 10; j = j + 1)
            //         color_matrix[i][j] = 4'd0;

        end
        else begin
            if (oob) begin
                matrix[y1][x1] <= 1'b1;
                matrix[y2][x2] <= 1'b1;
                matrix[y3][x3] <= 1'b1;
                matrix[y4][x4] <= 1'b1;
                color_matrix[y1][x1] <= block_type;
                color_matrix[y2][x2] <= block_type;
                color_matrix[y3][x3] <= block_type;
                color_matrix[y4][x4] <= block_type;
                block_logic_reset <= 1'b1;
            end
            else block_logic_reset <= 1'b0;

        for (a = 0; a < 20; a = a + 1)
                begin
                    if (&matrix[a])
                        begin
                            for (new_a = a; new_a > 0; new_a = new_a - 1)
                                begin
                                    matrix[new_a] <= matrix[new_a - 1];
                                    color_matrix[new_a][0] <= color_matrix[new_a - 1][0];
                                    color_matrix[new_a][1] <= color_matrix[new_a - 1][1];
                                    color_matrix[new_a][2] <= color_matrix[new_a - 1][2];
                                    color_matrix[new_a][3] <= color_matrix[new_a - 1][3];
                                    color_matrix[new_a][4] <= color_matrix[new_a - 1][4];
                                    color_matrix[new_a][5] <= color_matrix[new_a - 1][5];
                                    color_matrix[new_a][6] <= color_matrix[new_a - 1][6];
                                    color_matrix[new_a][7] <= color_matrix[new_a - 1][7];
                                    color_matrix[new_a][8] <= color_matrix[new_a - 1][8];
                                    color_matrix[new_a][9] <= color_matrix[new_a - 1][9];
                                    // for(m=0; m<10; m=m+1)
                                    //     color_matrix[new_a][m] = color_matrix[new_a - 1][m];

                                end
                                
                            matrix[0] <= {10{1'b0}};
                            color_matrix[0][0] <= 4'd0;
                            color_matrix[0][1] <= 4'd0;
                            color_matrix[0][2] <= 4'd0;
                            color_matrix[0][3] <= 4'd0;
                            color_matrix[0][4] <= 4'd0;
                            color_matrix[0][5] <= 4'd0;
                            color_matrix[0][6] <= 4'd0;
                            color_matrix[0][7] <= 4'd0;
                            color_matrix[0][8] <= 4'd0;
                            color_matrix[0][9] <= 4'd0;
                            // for(l=0; l<10; l=l+1)
                            //     color_matrix[0][l] = 4'd0;
                        end
                end
        end
    end
    
    localparam yellow = 12'b0000_1111_1111;
    localparam magenta = 12'b1111_0000_1111;
    localparam green = 12'b0000_1111_1000;
    localparam orange = 12'b0000_1000_1111;
    localparam red = 12'b0000_0000_1111;
    localparam blue = 12'b1111_0000_0000;
    localparam light_blue = 12'b1100_0000_0000;
    
    reg [11:0] color_out;
    
    always @(*) begin
        case(color_matrix[y_vga2][x_vga2])
            3'd0: color_out = middle;
            3'd1: color_out = blue;
            3'd2: color_out = yellow;
            3'd3: color_out = magenta;
            3'd4: color_out = green;
            3'd5: color_out = orange;
            3'd6: color_out = red;
            3'd7: color_out = light_blue;
            default: color_out = middle;
        endcase
    end
    
    //assign [11:0] colour_calc = ((x<=(block1_x + 10'd21) && x>=block1_x && y>=block1_y && y<=(block1_y + 10'd21))d ? block_colour : middle;
    assign color = (matrix[y_vga2][x_vga2]) ? color_out : middle;

endmodule