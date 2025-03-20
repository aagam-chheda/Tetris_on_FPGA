`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 16:50:54
// Design Name: 
// Module Name: counter_10ms
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


module counter_10ms(
    input clk,
    input reset,
    output ms10
    );
    
    reg [19:0] count, next_count;
    
    always @(posedge clk) begin
        if (reset) count <= 0;
        else count <= next_count;
    end
    
    assign next_count = (count == 20'd999999) ? 20'd0 : count + 1'b1;
    
    assign ms10 = (count == 20'd999999) ? 1'b1 : 1'b0;
    
endmodule
