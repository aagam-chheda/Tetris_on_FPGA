module score_conversion(
    input [15:0] score,
    input clk, reset,
    output reg [3:0] units_place,
    output reg [3:0] tens_place,
    output reg [3:0] hundreds_place,
    output reg [3:0] thousands_place
);
    always@(posedge clk)
        begin
            if(reset)
                begin
                    thousands_place = 4'b0000;
                    hundreds_place = 4'b0000;
                    tens_place = 4'b0000;
                    units_place = 4'b0000;
                end
            else
                begin
                    thousands_place = score/1000;
                    hundreds_place = (score%1000)/100;
                    tens_place = (score%100)/10;
                    units_place = score%10;
                end
        end
endmodule