`timescale 1ns / 1ps

module segment7(
    input clk, reset,
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
    always @(posedge clk)
        begin
            if(reset)
                {a,b,c,d,e,f,g,h,i,j,k,l,m} <= 12'b000000000000;
            else
                case(number)                         // {a,b,c,d,e,f,g,h,i,j,k,l,m}
                4'd0: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0};
                4'd1: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
                4'd2: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1};
                4'd3: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1};
                4'd4: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1};
                4'd5: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1};
                4'd6: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
                4'd7: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0};
                4'd8: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
                4'd9: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1};
                default: {a,b,c,d,e,f,g,h,i,j,k,l,m} <= {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
            endcase
        end
endmodule