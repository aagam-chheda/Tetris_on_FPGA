`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 04:22:11 PM
// Design Name: 
// Module Name: collision_detection
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


module collision_detection(
    input [3:0] x1,x2,x3,x4,
    output reg [3:0] x1_out, x2_out, x3_out, x4_out
    );
    
    
    wire left_oob = (x1 == 4'd15 | x1 == 4'd14) | (x2 == 4'd15 | x2 == 4'd14) | (x3 == 4'd15 | x3 == 4'd14) | (x4 == 4'd15 | x4 == 4'd14);
    wire right_oob = x1 > 9 | x2 > 9 | x3 > 9 | x4 > 9;
        

    always @(*) begin
        casex({left_oob, right_oob})
            2'b1x: begin
                x1_out = x1 + 2'd1;
                x2_out = x2 + 2'd1;
                x3_out = x3 + 2'd1;
                x4_out = x4 + 2'd1;
            end
            2'b01: begin
                x1_out = x1 - 2'd1;
                x2_out = x2 - 2'd1;
                x3_out = x3 - 2'd1;
                x4_out = x4 - 2'd1;
            end
            default: begin
                x1_out = x1;
                x2_out = x2;
                x3_out = x3;
                x4_out = x4;
            end
        endcase
    end

endmodule
