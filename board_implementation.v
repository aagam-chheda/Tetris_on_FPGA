`timescale 1ns / 1ps

module board_implementation(
    input clk,reset,
    input [9:0] x,y,
    output reg [3:0] x_b,
    output reg [4:0] y_b,
    output reg border_x, border_y
);

    always@(posedge clk)
        begin
            if(reset)
                begin
                    x_b <= 4'b0000;
                    y_b <= 5'b00000;
                    border_x <= 1'b0;
                    border_y <= 1'b0;
                end
            else
                begin
                    if(x>=204 && x<=225)
                        begin
                            x_b <= 4'b0000;
                            border_x <= 1'b0;
                        end
                    else if(x>=227 && x<=248)
                        begin
                            x_b <= 4'b0001;
                            border_x <= 1'b0;
                        end
                    else if(x>=250 && x<=271)
                        begin
                            x_b <= 4'b0010;
                            border_x <= 1'b0;
                        end
                    else if(x>=273 && x<=294)
                        begin
                            x_b <= 4'b0011;
                            border_x <= 1'b0;
                        end
                    else if(x>=296 && x<=317)
                        begin
                            x_b <= 4'b0100;
                            border_x <= 1'b0;
                        end
                    else if(x>=319 && x<=340)
                        begin
                            x_b <= 4'b0101;
                            border_x <= 1'b0;
                        end
                    else if(x>=342 && x<=363)
                        begin
                            x_b <= 4'b0110;
                            border_x <= 1'b0;
                        end
                    else if(x>=365 && x<=386)
                        begin
                            x_b <= 4'b0111;
                            border_x <= 1'b0;
                        end
                    else if(x>=388 && x<=409)
                        begin
                            x_b <= 4'b1000;
                            border_x <= 1'b0;
                        end
                    else if(x>=411 && x<=432)
                        begin
                            x_b <= 4'b1001;
                            border_x <= 1'b0;
                        end
                    else if(x==203 || x==226 || x==249 || x==272 || x==295 || x==318 || x==341 || x==364 || x==387 || x==410 || x==433)
                        begin
                            x_b <= 4'bzzzz;
                            border_x <= 1'b1;
                        end
                    else
                        begin
                            x_b <= 4'bzzzz;
                            border_x <= 1'b0;
                        end


                    if(y>=12 && y<=33)
                        begin
                            y_b <= 5'b00000;
                            border_y <= 1'b0;
                        end
                    else if(y>=35 && y<=56)
                        begin
                            y_b <= 5'b00001;
                            border_y <= 1'b0;
                        end
                    else if(y>=58 && y<=79)
                        begin
                            y_b <= 5'b00010;
                            border_y <= 1'b0;
                        end
                    else if(y>=81 && y<=102)
                        begin
                            y_b <= 5'b00011;
                            border_y <= 1'b0;
                        end
                    else if(y>=104 && y<=125)
                        begin
                            y_b <= 5'b00100;
                            border_y <= 1'b0;
                        end
                    else if(y>=127 && y<=148)
                        begin
                            y_b <= 5'b00101;
                            border_y <= 1'b0;
                        end
                    else if(y>=150 && y<=171)
                        begin
                            y_b <= 5'b00110;
                            border_y <= 1'b0;
                        end
                    else if(y>=173 && y<=194)
                        begin
                            y_b <= 5'b00111;
                            border_y <= 1'b0;
                        end
                    else if(y>=196 && y<=217)
                        begin
                            y_b <= 5'b01000;
                            border_y <= 1'b0;   
                        end
                    else if(y>=219 && y<=240)
                        begin
                            y_b <= 5'b01001;
                            border_y <= 1'b0;
                        end
                    else if(y>=242 && y<=263)
                        begin
                            y_b <= 5'b01010;
                            border_y <= 1'b0;
                        end
                    else if(y>=265 && y<=286)
                        begin
                            y_b <= 5'b01011;
                            border_y <= 1'b0;
                        end
                    else if(y>=288 && y<=309)
                        begin
                            y_b <= 5'b01100;
                            border_y <= 1'b0;
                        end
                    else if(y>=311 && y<=332)
                        begin
                            y_b <= 5'b01101;
                            border_y <= 1'b0;
                        end
                    else if(y>=334 && y<=355)
                        begin
                            y_b <= 5'b01110;
                            border_y <= 1'b0;
                        end
                    else if(y>=357 && y<=378)
                        begin
                            y_b <= 5'b01111;
                            border_y <= 1'b0;
                        end
                    else if(y>=380 && y<=401)
                        begin
                            y_b <= 5'b10000;
                            border_y <= 1'b0;
                        end
                    else if(y>=403 && y<=424)
                        begin
                            y_b <= 5'b10001;
                            border_y <= 1'b0;
                        end
                    else if(y>=426 && y<=447)
                        begin
                            y_b <= 5'b10010;
                            border_y <= 1'b0;
                        end
                    else if(y>=449 && y<=470)
                        begin
                            y_b <= 5'b10011;
                            border_y <= 1'b0;
                        end
                    else if(y==11 || y==34 || y==57 || y==80 || y==103 || y==126 || y==149 || y==172 || y==195 || y==218 || y==241 || y==264 || y==287 || y==310 || y==333 || y==356 || y==379 || y==402 || y==425 || y==448 || y==471)
                        begin
                            y_b <= 5'bzzzz;
                            border_y <= 1'b1;
                        end
                    else
                        begin
                            y_b <= 5'bzzzz;
                            border_y <= 1'b0;
                        end
                end
        end
endmodule