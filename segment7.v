`timescale 1ns / 1ps

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
        case(number)                         // {a,b,c,d,e,f,g,h,i,j,k,l,m}
            4'd0: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,1,1,0,1,0,1,1,1,0,1,0};
            4'd1: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1,1,1,1,1,0,0,0,0,0,0,0,0};
            4'd2: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,0,0,1,1,0,1,0,0,1,1,1};
            4'd3: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,0,1,0,1,1,0,0,0,1,1,1};
            4'd4: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1,1,0,1,1,0,0,0,0,1,1,0,1};
            4'd5: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1,0,0,1,0,1,1,0,0,1,0,1,1};
            4'd6: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {1,0,0,1,0,1,0,1,0,1,0,1,1};
            4'd7: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,1,1,1,0,0,0,0,0,1,1,0};
            4'd8: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,0,1,0,1,0,1,0,1,0,1,1};
            4'd9: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,0,1,0,1,1,0,0,1,0,1,1};
            default: {a,b,c,d,e,f,g,h,i,j,k,l,m} = {0,1,1,1,0,1,0,1,1,1,0,1,0};
        endcase
    end
endmodule