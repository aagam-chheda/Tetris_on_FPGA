`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 11:05:05
// Design Name: 
// Module Name: segment7
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


module segment7(
    input [3:0] number,
    output reg a,b,c,d,e,f,g,h,i,j,k,l,m
    );
    // aaa
    //f   b
    //f   b
    // ggg
    //e   c
    //e   c
    // ddd
    always @(*) begin
        case(number)
            4'd0: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0};
            4'd1: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
            4'd2: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1};
            4'd3: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1};
            4'd4: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1};
            4'd5: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1};
            4'd6: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
            4'd7: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0};
            4'd8: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
            4'd9: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1};
            default: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
        endcase
    end
endmodule
