`timescale 1ns / 1ps

module collision_detection(
    input clk, reset,
    input [4:0] y1,y2,y3,y4,
    input [4:0] y1n,y2n,y3n,y4n,
    input [3:0] x1,x2,x3,x4,
    input [3:0] x1n,x2n,x3n,x4n,
    output reg [3:0] x1_out, x2_out, x3_out, x4_out,
    output reg [4:0] y1_out, y2_out, y3_out, y4_out
    );

    reg [0:9] matrix [0:20];
    integer a, new_a;
    
    wire oob_down = matrix[y1+5'd1][x1] | matrix[y2+5'd1][x2] | matrix[y3+5'd1][x3] | matrix[y4+5'd1][x4];

    always @(posedge clk)
        begin
            if (reset)
                begin
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
                end
            else
                begin
                    if (oob_down)
                        begin
                            matrix[y1][x1] <= 1'b1;
                            matrix[y2][x2] <= 1'b1;
                            matrix[y3][x3] <= 1'b1;
                            matrix[y4][x4] <= 1'b1;
                        end
                    else
                        begin
                            matrix[y1][x1] <= 1'b0;
                            matrix[y2][x2] <= 1'b0;
                            matrix[y3][x3] <= 1'b0;
                            matrix[y4][x4] <= 1'b0;
                        end

                    for (a = 0; a < 20; a = a + 1)
                        begin
                            if (&matrix[a])
                                begin
                                    for (new_a = a; new_a > 0; new_a = new_a - 1)
                                        matrix[new_a] <= matrix[new_a - 1];

                                    matrix[0] <= {10{1'b0}};
                                end
                        end
                end
        end
    
    wire left_boundary = (x1n == 4'd15 | x1n == 4'd14) | (x2n == 4'd15 | x2n == 4'd14) | (x3n == 4'd15 | x3n == 4'd14) | (x4n == 4'd15 | x4n == 4'd14);
    wire right_boundary = x1n > 9 | x2n > 9 | x3n > 9 | x4n > 9;
    wire oob = matrix[y1n][x1n] | matrix[y2n][x2n] | matrix[y3n][x3n] | matrix[y4n][x4n];

    always @(*) 
        begin
            casex({left_boundary, right_boundary})
                2'b1x:  begin
                            x1_out = x1n + 2'd1;
                            x2_out = x2n + 2'd1;
                            x3_out = x3n + 2'd1;
                            x4_out = x4n + 2'd1;

                            y1_out = y1;
                            y2_out = y2;
                            y3_out = y3;
                            y4_out = y4;
                        end
                2'b01:  begin
                            x1_out = x1n - 2'd1;
                            x2_out = x2n - 2'd1;
                            x3_out = x3n - 2'd1;
                            x4_out = x4n - 2'd1;

                            y1_out = y1;
                            y2_out = y2;
                            y3_out = y3;
                            y4_out = y4;
                        end
                default:begin
                            if(oob)
                                begin
                                    x1_out = x1;
                                    x2_out = x2;
                                    x3_out = x3;
                                    x4_out = x4;

                                    y1_out = y1;
                                    y2_out = y2;
                                    y3_out = y3;
                                    y4_out = y4;
                                end
                            else    
                                begin
                                    x1_out = x1n;
                                    x2_out = x2n;
                                    x3_out = x3n;
                                    x4_out = x4n;

                                    y1_out = y1n;
                                    y2_out = y2n;
                                    y3_out = y3n;
                                    y4_out = y4n;
                                end
                        end
            endcase
        end    
endmodule