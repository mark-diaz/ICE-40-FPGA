module 7Segment_Top
(
    input clk_i,
    input sw_i,
    output seg_A_o,
    output seg_B_o,
    output seg_C_o,
    output seg_D_o,
    output seg_E_o,
    output seg_F_o,
    output seg_G_o
);

    // store switch state and count
    wire sw_w;
    reg sw_r = 1'b0;
    reg [3:0] count_r = 4'b0000;

    wire seg_A_w;
    wire seg_B_w;
    wire seg_C_w;
    wire seg_D_w;
    wire seg_E_w;
    wire seg_F_w;
    wire seg_G_w; 

    // Debounce Filter
    Debounced_Switch Debounced_Switch_inst (
        .clk_i(clk_i), 
        .sw_i(sw_i),
        .sw_o(sw_w)
    );
    
    always @(posedge clk_i)
    begin
        sw_r <= sw_w;

        // increment counter if switch is pressed
        if (sw_w == 1'b1 && sw_r == 1'b0)
        begin
            if (count_r == 9) // reset at 9
                count_r <= 0;
            else
                count_r = count_r + 1; 
        end
    end

    // convert binary to 7 segement display
    Binary_To_7Segment Binary_To_7Segment_inst
    (
        .clk_i(clk_i),
        .binary_num_i(count_r),
        .seg_A_o(seg_A_w),
        .seg_B_o(seg_B_w),
        .seg_C_o(seg_C_w),
        .seg_D_o(seg_D_w),
        .seg_E_o(seg_E_w),
        .seg_F_o(seg_F_w),
        .seg_G_o(seg_G_w);
    );
    
    // Because of 7 Segment Display Design the signals have to be inverted to be display correctly
    assign {seg_A_o, seg_B_o, seg_C_o, seg_D_o, seg_E_o, seg_F_o, seg_G_o} = ~{seg_A_w, seg_B_w, seg_C_w, seg_D_w, seg_E_w, seg_F_w, seg_G_w}

endmodule