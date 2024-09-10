
module Sync_Count 
    #(parameter TOTAL_COLS = 800,
    parameter TOTAL_ROWS = 525)
(
    input clk_i,
    input Hsync_i,
    input Vsync_i,
    output reg Hsync_o = 0,
    output reg Vsync_o = 0,
    output reg [9:0] col_count_o = 0,
    output reg [9:0] row_count_o = 0
);

    wire frame_start_w;

    // align sync with output
    always@(posedge clk_i)
    begin
        Vsync_o <= Vsync_i;
        Hsync_o <= Hsync_i;
    end

    // keep track rows and cols
    always @(posedge clk_i) 
    begin
        if (frame_start_w == 1'b1)
        begin
            col_count_o <= 0;
            row_count_o <= 0;
        end
        else
        begin
            if (col_count_o == TOTAL_COLS - 1)
            begin
                if (row_count_o == TOTAL_ROWS - 1)
                begin
                    row_count_o <= 0;
                end
                else
                begin
                    row_count_o <= row_count_o + 1;
                end
                col_count_o <= 0;
            end
            else
            begin
                col_count_o <= col_count_o + 1;                
            end
        end
    end

    // rising edge on vync resets counters
    assign frame_start_w = (~Vsync_o & Vsync_i);
    
endmodule