module VGA_Test_Patterns_Top
    (
        input clk_i,
        input UART_RX_i,
        output UART_TX_o,
        // 7 Segment 1
        output seg1_A_o,
        output seg1_B_o,
        output seg1_C_o,
        output seg1_D_o,
        output seg1_E_o,
        output seg1_F_o,
        output seg1_G_o,

        // 7 Segment 2
        output seg2_A_o,
        output seg2_B_o,
        output seg2_C_o,
        output seg2_D_o,
        output seg2_E_o,
        output seg2_F_o,
        output seg2_G_o,

        // VGA Outputs
        output VGA_Hsync_o,
        output VGA_Vsync_o,
        output VGA_Red_0_o,
        output VGA_Red_1_o,
        output VGA_Red_2_o,
        output VGA_Grn_0_o,
        output VGA_Grn_1_o,
        output VGA_Grn_2_o,
        output VGA_Blu_0_o,
        output VGA_Blu_1_o,
        output VGA_Blu_2_o
    );

    // 25 000 000 / 115 200 = 217
    parameter CLKS_PER_BIT = 217;

    // VGA Constants
    parameter VIDEO_WIDTH = 3;
    parameter TOTAL_COLS = 800;
    parameter TOTAL_ROWS = 525;
    parameter ACTIVE_COLS = 640;
    parameter ACTIVE_ROWS = 480;

    // UART
    wire rx_dv_w;
    wire [7:0] rx_byte_w;
    wire tx_active_w;
    wire tx_serial_w;

    // 7 Segment
    wire seg1_A_w, seg2_A_w;
    wire seg1_B_w, seg2_B_w;
    wire seg1_C_w, seg2_C_w;
    wire seg1_D_w, seg2_D_w;
    wire seg1_E_w, seg2_E_w;
    wire seg1_F_w, seg2_F_w;
    wire seg1_G_w, seg2_G_w;

    reg [3:0] Test_Pattern_r = 0;

    // Common VGA Signals
    wire [VIDEO_WIDTH-1:0] Red_Video_TP_w, Red_Video_Porch_w;
    wire [VIDEO_WIDTH-1:0] Grn_Video_TP_w, Grn_Video_Porch_w;
    wire [VIDEO_WIDTH-1:0] Blu_Video_TP_w, Blu_Video_Porch_w;

    // Receiver
    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_Inst
    (
        .clk_i(clk_i),
        .rx_serial_i(UART_RX_i),
        .rx_dv_o(rx_dv_w),
        .rx_byte_o(rx_byte_w)
    );

    // Transmitter
    UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_Inst
    (
        .clk_i(clk_i),
        .tx_dv_i(UART_TX_o),
        .tx_byte_i(rx_byte_w),
        .tx_active_o(tx_active_w),
        .tx_serial_o(tx_serial_w),
        .tx_done_o()
    );

    // Drive UART High when inactive
    assign UART_TX_o = tx_active_w ? tx_serial_w : 1'b1;

    // Convert binary to 7 segment display for seg1
    Binary_To_7Segment Binary_To_7Segment_seg1_inst
    (
        .clk_i(clk_i),
        .binary_num_i(rx_byte_w[7:4]),
        .seg_A_o(seg1_A_w),
        .seg_B_o(seg1_B_w),
        .seg_C_o(seg1_C_w),
        .seg_D_o(seg1_D_w),
        .seg_E_o(seg1_E_w),
        .seg_F_o(seg1_F_w),
        .seg_G_o(seg1_G_w)
    );

    // Because of 7 Segment Display Design, the signals have to be inverted to display correctly
    assign {seg1_A_o, seg1_B_o, seg1_C_o, seg1_D_o, seg1_E_o, seg1_F_o, seg1_G_o} = ~{seg1_A_w, seg1_B_w, seg1_C_w, seg1_D_w, seg1_E_w, seg1_F_w, seg1_G_w};

    // Convert binary to 7 segment display for seg2
    Binary_To_7Segment Binary_To_7Segment_seg2_inst
    (
        .clk_i(clk_i),
        .binary_num_i(rx_byte_w[3:0]),
        .seg_A_o(seg2_A_w),
        .seg_B_o(seg2_B_w),
        .seg_C_o(seg2_C_w),
        .seg_D_o(seg2_D_w),
        .seg_E_o(seg2_E_w),
        .seg_F_o(seg2_F_w),
        .seg_G_o(seg2_G_w)
    );

    // Because of 7 Segment Display Design, the signals have to be inverted to display correctly
    assign {seg2_A_o, seg2_B_o, seg2_C_o, seg2_D_o, seg2_E_o, seg2_F_o, seg2_G_o} = ~{seg2_A_w, seg2_B_w, seg2_C_w, seg2_D_w, seg2_E_w, seg2_F_w, seg2_G_w};

    // VGA Test Pattern

    // Only 4 MSB are needed since 6 patterns
    always @(posedge clk_i) 
    begin
        if (rx_dv_w == 1'b1)
            Test_Pattern_r <= rx_byte_w[3:0];
    end

    // Sync Pulse to run VGA
    // Instantiate VGA_Sync_Pulse
    VGA_Sync_Pulse #( .TOTAL_COLS(TOTAL_COLS),
                      .TOTAL_ROWS(TOTAL_ROWS),
                      .ACTIVE_COLS(ACTIVE_COLS),
                      .ACTIVE_ROWS(ACTIVE_ROWS) ) 
    VGA_Sync_Inst 
    (
        .clk_i(clk_i),
        .Hsync_o(Hsync_Start_w),
        .Vsync_o(Vsync_Start_w),
        .col_count_o(),
        .row_count_o()
    );

    // Instantiate Test_Pattern_Gen
    Test_Pattern_Gen #( .VIDEO_WIDTH(VIDEO_WIDTH),  // Use parameter directly
                        .TOTAL_COLS(TOTAL_COLS),
                        .TOTAL_ROWS(TOTAL_ROWS),
                        .ACTIVE_COLS(ACTIVE_COLS),
                        .ACTIVE_ROWS(ACTIVE_ROWS)
    ) Test_Pattern_Gen_Inst (
        .clk_i(clk_i),
        .pattern_i(Test_Pattern_r),
        .Hsync_i(Hsync_Start_w),
        .Vsync_i(Vsync_Start_w),
        .Hsync_o(Hsync_TP_w),
        .Vsync_o(Vsync_TP_w),
        .red_video_o(Red_Video_TP_w),
        .grn_video_o(Grn_Video_TP_w),
        .blu_video_o(Blu_Video_TP_w)
    );

    // Instantiate VGA_Sync_Porch
    VGA_Sync_Porch #(
        .VIDEO_WIDTH(VIDEO_WIDTH),  // Use parameter directly
        .TOTAL_COLS(TOTAL_COLS),
        .TOTAL_ROWS(TOTAL_ROWS),
        .ACTIVE_COLS(ACTIVE_COLS),
        .ACTIVE_ROWS(ACTIVE_ROWS)
    ) vga_sync_porch_inst (
        .clk_i(clk_i),
        .Hsync_i(Hsync_TP_w),
        .Vsync_i(Vsync_TP_w),
        .red_video_i(Red_Video_TP_w),
        .grn_video_i(Grn_Video_TP_w),
        .blu_video_i(Blu_Video_TP_w),
        .Hsync_o(Hsync_porch_w),
        .Vsync_o(Vsync_porch_w),
        .red_video_o(Red_Video_Porch_w),
        .grn_video_o(Grn_Video_Porch_w),
        .blu_video_o(Blu_Video_Porch_w)
    );

    assign VGA_Hsync_o = Hsync_porch_w;
    assign VGA_Vsync_o = Vsync_porch_w;

    assign VGA_Red_0_o = Red_Video_Porch_w[0];
    assign VGA_Red_1_o = Red_Video_Porch_w[1];
    assign VGA_Red_2_o = Red_Video_Porch_w[2];

    assign VGA_Grn_0_o = Grn_Video_Porch_w[0];
    assign VGA_Grn_1_o = Grn_Video_Porch_w[1];
    assign VGA_Grn_2_o = Grn_Video_Porch_w[2];

    assign VGA_Blu_0_o = Blu_Video_Porch_w[0];
    assign VGA_Blu_1_o = Blu_Video_Porch_w[1];
    assign VGA_Blu_2_o = Blu_Video_Porch_w[2];




endmodule