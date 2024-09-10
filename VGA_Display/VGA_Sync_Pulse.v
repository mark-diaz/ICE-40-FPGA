module VGA_Sync_Pulse 
    #(parameter TOTAL_COLS = 800, 
    parameter TOTAL_ROWS = 525, 
    parameter ACTIVE_COLS = 640, 
    parameter ACTIVE_ROWS = 480)
(
    input clk_i,
    output Hsync_o,
    output Vsync_o,
    output reg [9:0] col_count_o = 0,
    output reg [9:0] row_count_o = 0
);

    // sweep through cols and rows
    always@(posedge clk_i)
    begin
        if (col_count_o == TOTAL_COLS - 1)
        begin
            col_count_o <= 0;
            if (row_count_o == TOTAL_ROWS - 1)
                row_count_o <= 0;
            else
                row_count_o <= row_count_o + 1;
        end
        else
            col_count_o <= col_count_o + 1;
    end

    // High if not currently in active cols/rows
    assign Hsync_o = col_count_o < ACTIVE_COLS - 1 ? 1'b1 : 1'b0;
    assign Vsync_o = row_count_o < ACTIVE_ROWS - 1 ? 1'b1 : 1'b0;

    
endmodule 