module 7_Segment_Display_tb;
    
    reg clk = 1'b0;
    reg sw_r = 1'b0;

    wire seg_A_w;
    wire seg_B_w;
    wire seg_C_w;
    wire seg_D_w;
    wire seg_E_w;
    wire seg_F_w;
    wire seg_G_w; 

    7_Segment_Top 7_Segment_Top_uut(
        .clk_i(clk),
        .sw_i(sw_r),
        .seg_A_o(seg_A_w),
        .seg_B_o(seg_B_w),
        .seg_C_o(seg_C_w),
        .seg_D_o(seg_D_w),
        .seg_E_o(seg_E_w),
        .seg_F_o(seg_F_w),
        .seg_G_o(seg_G_w)
    );

    // 50 Mhz clk
    always #10 clk <= ~clk;

    initial 
    begin
        $dumpfile("dump.vcd");
        $dumpvars(1, 7_Segment_Display_tb);   

        #100 sw_r = 1'b1;
        #100 sw_r = 1'b0;


        

    end




    
endmodule