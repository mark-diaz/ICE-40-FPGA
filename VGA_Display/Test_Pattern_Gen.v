module Test_Pattern_Gen
    #(parameter VIDEO_WIDTH = 3,
    parameter TOTAL_COLS = 800, 
    parameter TOTAL_ROWS = 525, 
    parameter ACTIVE_COLS = 640, 
    parameter ACTIVE_ROWS = 480)
    (
        input clk_i,
        input [3:0] pattern_i, // UART from keyboard
        input Hsync_i,
        input Vsync_i,
        output reg Hsync_o = 0,
        output reg Vsync_o = 0,
        output reg [VIDEO_WIDTH-1:0] red_video_o,
        output reg [VIDEO_WIDTH-1:0] grn_video_o,
        output reg [VIDEO_WIDTH-1:0] blu_video_o
    );

    wire Vsync_w;
    wire Hsync_w;

    // 16 Different patterns,
    wire [VIDEO_WIDTH-1:0] pattern_red[0:15];
    wire [VIDEO_WIDTH-1:0] pattern_grn[0:15];
    wire [VIDEO_WIDTH-1:0] pattern_blu[0:15];

    wire [9:0] col_count_w;
    wire [9:0] row_count_w;

    wire [6:0] bar_width_w;
    wire [2:0] bar_select_w;    

    Sync_Count #(.TOTAL_COLS(TOTAL_COLS),
                  .TOTAL_ROWS(TOTAL_ROWS))
    UUT (
    .clk_i(clk_i),
    .Hsync_i(Hsync_i),
    .Vsync_i(Vsync_i),
    .Hsync_o(Hsync_w),
    .Vsync_o(Vsync_w),
    .col_count_o(col_count_w),
    .row_count_o(row_count_w)
    );

    // Register syncs to align with output data
    always@ (posedge clk_i)
    begin
        Vsync_o <= Vsync_w;
        Hsync_o <= Hsync_w;
    end
    
    // Pattern 0: Disable
    assign pattern_red[0] = 0;
    assign pattern_blu[0] = 0;
    assign pattern_grn[0] = 0;

    // Pattern 1: All Red
    assign pattern_red[1] = (col_count_w < ACTIVE_COLS && row_count_w < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_grn[1] = 0;
    assign pattern_blu[1] = 0;

    // Pattern 2: All Green
    assign pattern_red[2] = 0;
    assign pattern_grn[2] = (col_count_w < ACTIVE_COLS && row_count_w < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_blu[2] = 0;

    // Pattern 3: All Blue
    assign pattern_red[3] = 0;
    assign pattern_blu[3] = 0;
    assign pattern_blu[3] = (col_count_w < ACTIVE_COLS && row_count_w < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;

    // Pattern 4: Checkerboard
    assign pattern_red[4] = col_count_w[5] ^ row_count_w[5] ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_grn[4] = pattern_red[4];
    assign pattern_blu[4] = pattern_red[4];

    // Pattern 5: Color Bars
    // Divides active area into 8 Equal Bars and colors them accordingly
    // Colors Each According to this Truth Table:
    // R G B  w_Bar_Select  Ouput Color
    // 0 0 0       0        Black
    // 0 0 1       1        Blue
    // 0 1 0       2        Green
    // 0 1 1       3        Turquoise
    // 1 0 0       4        Red
    // 1 0 1       5        Purple
    // 1 1 0       6        Yellow
    // 1 1 1       7        White

    // divide active area into 8 equal bars
    assign bar_width_w = ACTIVE_COLS/8;

    assign bar_select_w =   col_count_w < bar_width_w * 1 ? 0:
                            col_count_w < bar_width_w * 2 ? 1:
                            col_count_w < bar_width_w * 3 ? 2:
                            col_count_w < bar_width_w * 4 ? 3:
                            col_count_w < bar_width_w * 5 ? 4:
                            col_count_w < bar_width_w * 6 ? 5:
                            col_count_w < bar_width_w * 7 ? 6: 7;

    assign pattern_red[5] = (bar_select_w == 4 || bar_select_w == 5 || bar_select_w == 6 || bar_select_w == 7 ) ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_blu[5] = (bar_select_w == 2 || bar_select_w == 3 || bar_select_w == 6 || bar_select_w == 7 ) ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_blu[5] = (bar_select_w == 1 || bar_select_w == 3 || bar_select_w == 5 || bar_select_w == 7 ) ? {VIDEO_WIDTH{1'b1}} : 0;

    // Pattern 6: Black with white border
    assign pattern_red[6] = (row_count_w <= 1 || row_count_w >= ACTIVE_ROWS-1-1 || col_count_w <= 1 || col_count_w >= ACTIVE_COLS-1-1) ? {VIDEO_WIDTH{1'b1}} : 0;
    assign pattern_blu[6] = pattern_red[4];
    assign pattern_blu[6] = pattern_red[4];

    // select test pattern
    always @(posedge clk_i) 
    begin
        case (pattern_i)
            4'h0: 
            begin
                red_video_o <= pattern_red[0];
                grn_video_o <= pattern_grn[0];
                blu_video_o <= pattern_blu[0];
            end

            4'h1: 
            begin
                red_video_o <= pattern_red[1];
                grn_video_o <= pattern_grn[1];
                blu_video_o <= pattern_blu[1];
            end

            4'h2: 
            begin
                red_video_o <= pattern_red[2];
                grn_video_o <= pattern_grn[2];
                blu_video_o <= pattern_blu[2];         
            end

            4'h3: 
            begin
                red_video_o <= pattern_red[3];
                grn_video_o <= pattern_grn[3];
                blu_video_o <= pattern_blu[3];       
            end

            4'h4: 
            begin
                red_video_o <= pattern_red[4];
                grn_video_o <= pattern_grn[4];
                blu_video_o <= pattern_blu[4];   
            end

            4'h5: 
            begin
                red_video_o <= pattern_red[5];
                grn_video_o <= pattern_grn[5];
                blu_video_o <= pattern_blu[5];        
            end

            4'h6: 
            begin
                red_video_o <= pattern_red[6];
                grn_video_o <= pattern_grn[6];
                blu_video_o <= pattern_blu[6];
            end

            default:
            begin
                red_video_o <= pattern_red[0];
                grn_video_o <= pattern_grn[0];
                blu_video_o <= pattern_blu[0];
            end
        endcase
    end
endmodule