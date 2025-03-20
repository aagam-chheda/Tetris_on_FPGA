`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 17:20:24
// Design Name: 
// Module Name: early_debouncer
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


module early_debouncer(
    input sw, clk, reset,
    output db
    );
    
    wire ms10;
    counter_10ms count(clk, reset, ms10);
    
    localparam one = 3'b0, wait1_10 = 3'd1, wait1_20 = 3'd2, wait1_30 = 3'd3, zero = 3'd4, wait0_10 = 3'd5, wait0_20 = 3'd6, wait0_30 = 3'd7;
    
    reg [2:0] current_state, next_state;
    
    always @(*) begin
        case(current_state)
            zero: next_state = (sw) ? wait1_10 : zero;
            wait1_10 : next_state = (ms10) ? wait1_20 : wait1_10;
            wait1_20: next_state = (ms10) ? wait1_30 : wait1_20;
            wait1_30: next_state = (ms10) ? one : wait1_30;
            one: next_state = (sw) ? one : wait0_10;
            wait0_10 : next_state = (ms10) ? wait0_20 : wait0_10;
            wait0_20: next_state = (ms10) ? wait0_30 : wait0_20;
            wait0_30: next_state = (ms10) ? zero : wait1_30;
            default: next_state = zero;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) current_state <= zero;
        else current_state <= next_state;
    end
    
    assign db = current_state == one | current_state == wait1_10 | current_state == wait1_20  | current_state == wait1_30;
    
endmodule
