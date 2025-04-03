`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 13:09:03
// Design Name: 
// Module Name: block_logic
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

module block_logic(
    input clk, reset, 
    input [2:0] movement, //  000 clockwise, 001 anti-clockwise, 010 down, 011 left, 100 right, 101 nothing
    input [2:0] block_type,
    output reg [3:0] x1,x2,x3,x4,
    output reg [4:0] y1,y2,y3,y4,
    input [1:0] velocity,
    input block_settling_reset,
    output [3:0] x1_next_out, x2_next_out, x3_next_out, x4_next_out, 
    output [4:0] y1_next_out, y2_next_out, y3_next_out, y4_next_out,
    input [3:0] changed_x1, changed_x2, changed_x3, changed_x4,
    input [4:0] changed_y1, changed_y2, changed_y3, changed_y4,
    input ce
    );
    
    reg [24:0] speed, speed_next;
    
    always @(posedge clk) begin
        if (reset) speed <= 0;
        else if (ce) speed <= speed_next;
    end
    reg [1:0] velocity_reg, velocity_next;
    
    reg [2:0] block_current, block_next;
    
    reg [24:0] speed_wanted;
    
    always @(*) begin
        case(speed == speed_wanted)
            1'b1: speed_next = 0;
            1'b0: speed_next = speed + 1'b1;
        endcase
    end
    
    always @(*) begin
        case (velocity_reg)
            2'b00: speed_wanted = 25'b1111000000000000000000000;
            2'b01: speed_wanted = 25'b1110000000000000000000000;
            2'b10: speed_wanted = 25'b1000000010101010001000000;
            2'b11: speed_wanted = 25'b0000010010101010001000000;
        endcase
    end
    
    wire speed_reached = (speed == speed_wanted) ? 1'b1 : 1'b0;
    
    wire block_reset = (block_current != block_next) | reset | block_settling_reset | (velocity_next != velocity_reg);
    //wire block_reset = reset | block_settling_reset;

    
    //1: line, 2: square, 3: inverted T, 4: S, 5: Z, 6: J, 7: L;
    // config 00, 01 are 0 and 180 degree configurations
    // config 10 and 11 are 90 and 270 degree configurations
    reg [1:0] config_current, config_next;    
    
    reg [3:0] x1_next,x2_next,x3_next,x4_next; 
    reg [4:0] y1_next,y2_next,y3_next,y4_next;

    
    
    always @(*) begin
        case(config_current)
            2'b00: begin
                case (movement)
                    3'b000: config_next = 2'b10;
                    3'b001: config_next = 2'b11;
                    default: config_next = config_current;
                endcase
            end
            2'b01: begin
                case (movement)
                    3'b000: config_next = 2'b11;
                    3'b001: config_next = 2'b10;
                    default: config_next = config_current;
                endcase
            end
            2'b10: begin
                case (movement)
                    3'b000: config_next = 2'b01;
                    3'b001: config_next = 2'b00;
                    default: config_next = config_current;
                endcase
            end
            2'b11: begin
                case (movement)
                    3'b000: config_next = 2'b00;
                    3'b001: config_next = 2'b01;
                    default: config_next = config_current;
                endcase
            end
            default: config_next = config_current;
        endcase
    end
    
    
    always @(*) begin
        x1_next = x1;
        x2_next = x2;
        x3_next = x3;
        x4_next = x4;
        
        y1_next = y1;
        y2_next = y2;
        y3_next = y3;
        y4_next = y4;
        
        case(block_type)
            3'd1: begin // line
                casex(movement)
                    3'b00x: begin 
                        casex(config_current)
                            2'b0x: begin
                                x1_next = x1 + 4'd2;
                                x2_next = x2 + 4'd1;
                                x3_next = x3;
                                x4_next = x4 - 4'd1;
                                
                                y1_next = y1 - 5'd2;
                                y2_next = y2 - 5'd1;
                                y3_next = y3;
                                y4_next = y4 + 5'd1;

                            end
                            
                            2'b1x: begin
                                x1_next = x4 - 4'd1;
                                x2_next = x3;
                                x3_next = x2 + 4'd1;
                                x4_next = x1 + 4'd2;
                                
                                y1_next = y4 - 5'd1;
                                y2_next = y3;
                                y3_next = y2 + 5'd1;
                                y4_next = y1 + 5'd2;

                            end
                           
                        endcase  
                    end
                    
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1;

                    end
                    
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4;

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin // No input case
                        if (speed_reached) begin // no input case
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end                  
                endcase
            end
           // end for line
           // start for square 
            3'd2: begin // square
                casex(movement)
                    
                    3'b00x: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1; 

                    end
                    
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin
                        if (speed_reached) begin // no input case
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end
                endcase
            end
            
            // end of square
            // start of inverted T
            
            3'd3: begin // inverted T
                case(movement)
                    3'b000: begin // clockwise
                        case(config_current)
                            2'b00: begin 
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2 + 4'd1;
                                y2_next = y2;
                                
                                x3_next = x3 + 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4 - 4'd1;
                                y4_next = y4 + 5'd1;
                            end
                            2'b01: begin
                                x1_next = x1 + 4'd1;
                                y1_next = y1 - 5'd1;
                                
                                x2_next = x2 - 4'd1;
                                y2_next = y2;
                                
                                x3_next = x3 - 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4;
                                y4_next = y4;

                            end
                            2'b10: begin
                                x1_next = x1 - 4'd1;
                                y1_next = y1 + 5'd1;
                                
                                x2_next = x2;
                                y2_next = y2;
                                
                                x3_next = x3;
                                y3_next = y3;
                                
                                x4_next = x4;
                                y4_next = y4;

                            end
                            2'b11: begin
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2;
                                y2_next = y2;
                                
                                x3_next = x3;
                                y3_next = y3;
                                
                                x4_next = x4 + 4'd1;
                                y4_next = y4 - 5'd1;

                            end
                        endcase
                    end
                    3'b001: begin // anticlockwise
                        case(config_current)
                            2'b00: begin 
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2;
                                y2_next = y2;
                                
                                x3_next = x3;
                                y3_next = y3;
                                
                                x4_next = x4 - 4'd1;
                                y4_next = y4 + 5'd1;

                            end
                            2'b01: begin
                                x1_next = x1 + 4'd1;
                                y1_next = y1 - 5'd1;
                                
                                x2_next = x2;
                                y2_next = y2;
                                
                                x3_next = x3;
                                y3_next = y3;
                                
                                x4_next = x4;
                                y4_next = y4;

                            end
                            2'b10: begin
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2 - 4'd1;
                                y2_next = y2;
                                
                                x3_next = x3 - 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4 + 4'd1;
                                y4_next = y4 - 5'd1;

                            end
                            2'b11: begin
                                x1_next = x1 - 4'd1;
                                y1_next = y1 + 5'd1;
                                
                                x2_next = x2 + 4'd1;
                                y2_next = y2;
                                
                                x3_next = x3 + 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4;
                                y4_next = y4;

                            end
                        endcase
                    end
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1;
                    end
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin // no input case
                        if (speed_reached) begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end
                endcase
            end
            
///////////////////////////////////////////////////////////////////////////// end of inverted T
            // start of S
            3'd4: begin // S
                casex(movement)
                    3'b00x: begin // clockwise and anticlockwise
                        casex(config_current)
                            2'b0x: begin 
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2 - 4'd1;
                                y2_next = y2 + 5'd1;
                                
                                x3_next = x3 + 4'd2;
                                y3_next = y3;
                                
                                x4_next = x4 + 4'd1;
                                y4_next = y4 + 5'd1;

                            end
                            
                            2'b1x: begin
                                x1_next = x1;
                                y1_next = y1;
                                
                                x2_next = x2 + 4'd1;
                                y2_next = y2 - 5'd1;
                                
                                x3_next = x3 - 4'd2;
                                y3_next = y3;
                                
                                x4_next = x4 - 4'd1;
                                y4_next = y4 - 5'd1;

                            end
                           
                        endcase
                    end
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1;

                    end
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin // no input case
                        if (speed_reached) begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end
                endcase
            end
            
//////////////////////////////////////////////////////////////////////////// end of S
            // start of Z
            3'd5: begin // z
                casex(movement)
                    3'b00x: begin // clockwise and anticlockwise
                        casex(config_current)
                            2'b0x: begin 
                                x1_next = x1 + 4'd2;
                                y1_next = y1;
                                
                                x2_next = x2;
                                y2_next = y2 + 5'd1;
                                
                                x3_next = x3 + 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4 - 4'd1;
                                y4_next = y4 + 5'd1;

                            end
                            
                            2'b1x: begin
                                x1_next = x1 - 4'd2;
                                y1_next = y1;
                                
                                x2_next = x2;
                                y2_next = y2 - 5'd1;
                                
                                x3_next = x3 - 4'd1;
                                y3_next = y3;
                                
                                x4_next = x4 + 4'd1;
                                y4_next = y4 - 5'd1;

                            end
                           
                        endcase
                    end
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1;

                    end
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin // no input case
                        if (speed_reached) begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end
                endcase
            end
            
            // end of Z
            // start of J
            
            3'd6: begin // J
                casex(movement)
                    3'b000: begin // clockwise
                        casex(config_current)
                            2'b00: begin
                                x1_next = x1 - 4'd1;
                                x2_next = x2 + 4'd1;
                                x3_next = x3;
                                x4_next = x4;
                                
                                y1_next = y1;
                                y2_next = y2;
                                y3_next = y3 + 5'd1;
                                y4_next = y4 + 5'd1;
                            end
                            
                            2'b01: begin
                                x1_next = x1;
                                x2_next = x2;
                                x3_next = x3 - 4'd1;
                                x4_next = x4 + 4'd1;
                                
                                y1_next = y1 - 5'd1;
                                y2_next = y2 - 5'd1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                            
                            2'b10: begin
                                x1_next = x1 - 4'd1;
                                x2_next = x2;
                                x3_next = x3 + 4'd1;
                                x4_next = x4 - 4'd2;
                                
                                y1_next = y1 + 5'd1;
                                y2_next = y2;
                                y3_next = y3 - 5'd1;
                                y4_next = y4;
                            end
                            
                            2'b11: begin
                                x1_next = x1 + 4'd2;
                                x2_next = x2 - 4'd1;
                                x3_next = x3;
                                x4_next = x4 + 4'd1;
                                
                                y1_next = y1;
                                y2_next = y2 + 5'd1;
                                y3_next = y3;
                                y4_next = y4 - 5'd1;
                            end

                        endcase  
                    end
                    
                    3'b001: begin // anticlockwise
                        casex(config_current)
                            2'b00: begin
                                x1_next = x1 - 4'd2;
                                x2_next = x2 + 4'd1;
                                x3_next = x3;
                                x4_next = x4 - 4'd1;
                                
                                y1_next = y1;
                                y2_next = y2 - 5'd1;
                                y3_next = y3;
                                y4_next = y4 + 5'd1;
                            end
                            
                            2'b01: begin
                                x1_next = x1 + 4'b1;
                                x2_next = x2;
                                x3_next = x3 - 4'd1;
                                x4_next = x4 + 4'd2;
                                
                                y1_next = y1 - 5'd1;
                                y2_next = y2;
                                y3_next = y3 + 5'd1;
                                y4_next = y4;
                            end
                            
                            2'b10: begin
                                x1_next = x1 + 4'd1;
                                x2_next = x2 - 4'd1;
                                x3_next = x3;
                                x4_next = x4;
                                
                                y1_next = y1;
                                y2_next = y2;
                                y3_next = y3 - 5'd1;
                                y4_next = y4 - 5'd1;
                            end
                            
                            2'b11: begin
                                x1_next = x1;
                                x2_next = x2;
                                x3_next = x3 + 4'd1;
                                x4_next = x4 - 4'd1;
                                
                                y1_next = y1 + 5'd1;
                                y2_next = y2 + 5'd1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                        endcase  
                    end
                    
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1; 
                    end
                    
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b101: begin // No input case
                        if (speed_reached) begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 
                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;
                            end
                    end                  
                endcase
            end
            
            // end of J
/////////////////////////////////////////////////////////////////////////////////// start of L
            
            3'd7: begin // L
                casex(movement)
                    3'b000: begin // clockwise
                        casex(config_current)
                            2'b00: begin
                                x1_next = x1 + 4'd1;
                                x2_next = x2 + 4'd2;
                                x3_next = x3;
                                x4_next = x4 - 4'd1;
                                
                                y1_next = y1;
                                y2_next = y2-1;
                                y3_next = y3;
                                y4_next = y4 + 5'd1;
                            end
                            
                            2'b01: begin
                                x1_next = x1+1;
                                x2_next = x2;
                                x3_next = x3 - 4'd2;
                                x4_next = x4-1;
                                
                                y1_next = y1-1;
                                y2_next = y2;
                                y3_next = y3+1;
                                y4_next = y4;
                            end
                            
                            2'b10: begin
                                x1_next = x1 - 4'd1;
                                x2_next = x2 - 4'd1;
                                x3_next = x3 + 4'd1;
                                x4_next = x4 + 4'd1;
                                
                                y1_next = y1+1;
                                y2_next = y2+1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                            
                            2'b11: begin
                                x1_next = x1-1;
                                x2_next = x2-1;
                                x3_next = x3+1;
                                x4_next = x4 + 4'd1;
                                
                                y1_next = y1+1;
                                y2_next = y2+1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                            
                            default: begin
                                x1_next = x1;
                                x2_next = x2;
                                x3_next = x3;
                                x4_next = x4;
                                
                                y1_next = y1;
                                y2_next = y2;
                                y3_next = y3;
                                y4_next = y4;
                            end
                        endcase  
                    end
                    
                    3'b001: begin // anticlockwise
                        casex(config_current)
                            2'b00: begin
                                x1_next = x1 + 4'd1;
                                x2_next = x2+1;
                                x3_next = x3-1;
                                x4_next = x4 - 4'd1;
                                
                                y1_next = y1-1;
                                y2_next = y2-1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                            
                            2'b01: begin
                                x1_next = x1+1;
                                x2_next = x2+1;
                                x3_next = x3 - 4'd1;
                                x4_next = x4-1;
                                
                                y1_next = y1-1;
                                y2_next = y2-1;
                                y3_next = y3;
                                y4_next = y4;
                            end
                            
                            2'b10: begin
                                x1_next = x1-1;
                                x2_next = x2-2;
                                x3_next = x3;
                                x4_next = x4+1;
                                
                                y1_next = y1;
                                y2_next = y2+1;
                                y3_next = y3;
                                y4_next = y4 - 5'd1;
                            end
                            
                            2'b11: begin
                                x1_next = x1-1;
                                x2_next = x2;
                                x3_next = x3+2;
                                x4_next = x4+1;
                                
                                y1_next = y1+1;
                                y2_next = y2;
                                y3_next = y3-1;
                                y4_next = y4;
                            end
                        endcase  
                    end
                    
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1; 
                    end
                    
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b101: begin // no input case
                        if (speed_reached) begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 
                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;
                        end
                    end                  
                endcase
            end
            default: begin // square
                casex(movement)
                    
                    3'b00x: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 
                    end
                    
                    3'b010: begin
                        x1_next = x1;
                        x2_next = x2;
                        x3_next = x3;
                        x4_next = x4;
                        
                        y1_next = y1 + 5'd1;
                        y2_next = y2 + 5'd1;
                        y3_next = y3 + 5'd1;
                        y4_next = y4 + 5'd1; 

                    end
                    
                    3'b011: begin
                        x1_next = x1 - 4'd1;
                        x2_next = x2 - 4'd1;
                        x3_next = x3 - 4'd1;
                        x4_next = x4 - 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b100: begin
                        x1_next = x1 + 4'd1;
                        x2_next = x2 + 4'd1;
                        x3_next = x3 + 4'd1;
                        x4_next = x4 + 4'd1;
                        
                        y1_next = y1;
                        y2_next = y2;
                        y3_next = y3;
                        y4_next = y4; 

                    end
                    
                    3'b101: begin
                        if (speed_reached) begin // no input case
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1 + 5'd1;
                            y2_next = y2 + 5'd1;
                            y3_next = y3 + 5'd1;
                            y4_next = y4 + 5'd1; 

                        end
                        else begin
                            x1_next = x1;
                            x2_next = x2;
                            x3_next = x3;
                            x4_next = x4;
                            
                            y1_next = y1;
                            y2_next = y2;
                            y3_next = y3;
                            y4_next = y4;

                            end
                    end
                endcase
            end
           
        endcase
    end
    
   localparam sq1_initial = {4'd4,5'd0}, sq2_initial = {4'd5, 5'd0};
    localparam sq3_initial = {4'd4, 5'd1}, sq4_initial = {4'd5, 5'd1};
    
    localparam invT1_initial = {4'd4, 5'd0}, invT2_initial = {4'd3, 5'd1};
    localparam invT3_initial = {4'd4, 5'd1}, invT4_initial = {4'd5, 5'd1};
    
    localparam line1_initial = {4'd3, 5'd0}, line2_initial = {4'd4, 5'd0};
    localparam line3_initial = {4'd5, 5'd0}, line4_initial = {4'd6, 5'd0};
    
    localparam z1_initial = {4'd4,5'd0}, z2_initial = {4'd5, 5'd0};
    localparam z3_initial = {4'd5, 5'd1}, z4_initial = {4'd6, 5'd1};
    
    localparam s1_initial = {4'd5,5'd0}, s2_initial = {4'd6, 5'd0};
    localparam s3_initial = {4'd4, 5'd1}, s4_initial = {4'd5, 5'd1};
    
    localparam l1_initial = {4'd3, 5'd0}, l2_initial = {4'd3, 5'd1};
    localparam l3_initial = {4'd4, 5'd1}, l4_initial = {4'd5, 5'd1};
    
    localparam j1_initial = {4'd6, 5'd0}, j2_initial = {4'd4, 5'd1};
    localparam j3_initial = {4'd5, 5'd1}, j4_initial = {4'd6, 5'd1};
    
    wire [3:0] x1_next_constrained;
    wire [3:0] x2_next_constrained;
    wire [3:0] x3_next_constrained;
    wire [3:0] x4_next_constrained;
    
    collision_detection CD(x1_next, x2_next, x3_next, x4_next, x1_next_constrained, x2_next_constrained, x3_next_constrained, x4_next_constrained);
    
//    reg [3:0] x1_next_p;
//    reg [3:0] x2_next_p;
//    reg [3:0] x3_next_p;
//    reg [3:0] x4_next_p;
    
//    wire [0:9] matrix_y1 = block_settling_matrix[y1_next];
    
//    always @(*) begin
//        if (matrix_y1[x1_next_constrained]) begin
            
//        end
//    end
    
    //1: line, 2: square, 3: inverted T, 4: S, 5: Z, 6: J, 7: L
    always @(posedge clk) begin
        if (block_reset) begin
            case(block_type)
                3'd1: {x1,y1,x2,y2,x3,y3,x4,y4} <= {line1_initial, line2_initial, line3_initial, line4_initial};
                3'd2: {x1,y1,x2,y2,x3,y3,x4,y4} <= {sq1_initial, sq2_initial, sq3_initial, sq4_initial};
                3'd3: {x1,y1,x2,y2,x3,y3,x4,y4} <= {invT1_initial, invT2_initial, invT3_initial, invT4_initial};
                3'd4: {x1,y1,x2,y2,x3,y3,x4,y4} <= {s1_initial, s2_initial, s3_initial, s4_initial};
                3'd5: {x1,y1,x2,y2,x3,y3,x4,y4} <= {z1_initial, z2_initial, z3_initial, z4_initial};
                3'd6: {x1,y1,x2,y2,x3,y3,x4,y4} <= {j1_initial, j2_initial, j3_initial, j4_initial};
                3'd7: {x1,y1,x2,y2,x3,y3,x4,y4} <= {l1_initial, l2_initial, l3_initial, l4_initial};
            endcase
            config_current <= 2'b00;
            block_current <= block_next;
            velocity_reg <= velocity_next;
        end
        else if (ce) begin
            x1 <= changed_x1;
            x2 <= changed_x2;
            x3 <= changed_x3;
            x4 <= changed_x4;
            y1 <= changed_y1;
            y2 <= changed_y2;
            y3 <= changed_y3;
            y4 <= changed_y4;
            config_current <= config_next;
            block_next <= block_type;
            block_current <= block_next;
            velocity_next <= velocity;
            velocity_reg <= velocity_next;
        end
    end    
    
    assign x2_next_out = x2_next_constrained;
    assign x1_next_out = x1_next_constrained;
    assign x3_next_out = x3_next_constrained;
    assign x4_next_out = x4_next_constrained;
    
    assign y2_next_out = y2_next;
    assign y1_next_out = y1_next;
    assign y3_next_out = y3_next;
    assign y4_next_out = y4_next;
endmodule