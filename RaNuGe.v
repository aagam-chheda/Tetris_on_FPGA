`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2025 15:56:47
// Design Name: 
// Module Name: RaNuGe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This is a random number generator for randomly choosing the block and it's colour
// 
//////////////////////////////////////////////////////////////////////////////////


module RaNuGe(
    input clk, reset, block_new,
    output reg [2:0] random_number
    );
    
    reg [2:0] next;
    
    always @(*) begin
//        if (play) next = initial_count;
//        else
    next = {random_number[2]^random_number[1], random_number[2:1]};
    end
    
    always @(posedge clk) begin
        if (reset) random_number <= 1'b1;
        else begin
            if (block_new) random_number <= next;
            else random_number <= random_number;
        end
    end

endmodule
