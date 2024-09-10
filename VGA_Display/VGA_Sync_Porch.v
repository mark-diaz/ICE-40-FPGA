module VGA_Sync_Porch #(parameter VIDEO_WIDTH = 3,
                        parameter TOTAL_COLS = 3,
                        parameter TOTAL_ROWS = 3,
                        parameter ACTIVE_COLS = 2,
                        parameter ACTIVE_ROWS = 2)
(
    input clk_i,
    input Hsync_i,
    input Vsync_i,
    input [VIDEO_WIDTH-1:0] red_video_i,
    input [VIDEO_WIDTH-1:0] grn_video_i,
    input [VIDEO_WIDTH-1:0] blu_video_i,
    output reg Hsync_o,
    output reg Vsync_o,
    output reg [VIDEO_WIDTH-1:0] red_video_o,
    output reg [VIDEO_WIDTH-1:0] grn_video_o,
    output reg [VIDEO_WIDTH-1:0] blu_video_o
);

    // front and back porch constants
    parameter FRONT_PORCH_HORIZ = 18;
    parameter BACK_PORCH_HORIZ = 50;
    parameter FRONT_PORCH_VERT = 10;
    parameter BACK_PORCH_VERT = 33;

    wire Hsync_w;
    wire Vsync_w;

    wire [9:0] col_count_w;
    wire [9:0] row_count_w;

    reg [VIDEO_WIDTH-1:0] red_video_r = 0;
    reg [VIDEO_WIDTH-1:0] grn_video_r = 0;
    reg [VIDEO_WIDTH-1:0] blu_video_r = 0;

    Sync_Count #(.TOTAL_COLS(TOTAL_COLS),
                  .TOTAL_ROWS(TOTAL_ROWS)) UUT 
    (
        .clk_i(clk_i),
        .Hsync_i(Hsync_i),
        .Vsync_i(Vsnyc_i),
        .Hsync_o(Hsync_w),
        .Vsync_o(Vsync_w),
        .col_count_o(col_count_w),
        .row_count_o(row_count_w)
    );

    // Modify Hsync and Vsync signals to include front and back porch

    always @(posedge clk_i) 
    begin
        if ((col_count_w < FRONT_PORCH_HORIZ + ACTIVE_COLS) || (col_count_w > TOTAL_COLS - BACK_PORCH_HORIZ - 1))
            Hsync_o <= 1'b1;
        else
            Hsync_o <= Hsync_w;

        if ((row_count_w < FRONT_PORCH_VERT + ACTIVE_ROWS) || (row_count_w > TOTAL_ROWS - BACK_PORCH_VERT - 1))
            Vsync_o <= 1'b1;
        else
            Vsync_o <= Vsync_w;
    end

    // Delay two clock cycles
    always @(posedge clk_i) 
    begin
        red_video_r <= red_video_i;
        grn_video_r <= grn_video_i;
        blu_video_r <= blu_video_i;

        red_video_o <= red_video_r;
        grn_video_o <= grn_video_r;
        blu_video_o <= blu_video_r;
    end

endmodule