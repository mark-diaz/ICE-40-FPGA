module FIFO_tb;

    localparam DEPTH = 4;
    localparam WIDTH = 8;

    reg clk = 1'b0;
    reg rstn_r = 1'b0;

    reg wr_dv_r = 1'b0;
    reg rd_en_r = 1'b0;
    reg [WIDTH-1:0] wr_data_r;

    reg [$clog2(DEPTH)-1:0] AF_level_r = DEPTH - 1;
    reg [$clog2(DEPTH)-1:0] AE_level_r = 1;

    wire AF_flag_w, AE_flag_w, full_w, empty_w, rd_dv_w;

    wire [WIDTH-1:0] rd_data_w;

    FIFO#(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_uut
    (
        .rstn_i(rstn_r),
        .clk_i(clk),
        // write
        .wr_dv_i(wr_dv_r),
        .wr_data_i(wr_data_r),
        .AF_level_i(AF_level_r),
        .AF_flag_o(AF_flag_w),
        .full_o(full_w),

        // read
        .rd_en_i(rd_en_r),
        .rd_dv_o(rd_dv_w),
        .rd_data_o(rd_data_w),
        .AE_level_i(AE_level_r),
        .AE_flag_o(AE_flag_w),
        .empty_o(empty_w)
    );

    // 50 Mhz clock
    always #10 clk <= ~clk;

    task reset_fifo();
        @(posedge clk);
            rstn_r <= 1'b0;
            wr_dv_r <= 0;
            rd_en_r <= 0;
        @(posedge clk);
            rstn_r <= 1'b1;
        @(posedge clk);
        @(posedge clk);
    endtask

    initial
    begin
       	integer i;
        $dumpfile("dump.vcd");
        $dumpvars(1, FIFO_tb);

        reset_fifo();

        // write a test word
        wr_dv_r <= 1'b1;
        wr_data_r <= 8'hBB;
        @(posedge clk);
            wr_dv_r <= 1'b0;
        @(posedge clk);
            assert(!empty_w);

        repeat(4) @(posedge clk);

        // read from FIFO
        rd_en_r = 1'b1;
        @(posedge clk);
            rd_en_r = 1'b0;
        @(posedge clk);
            assert(rd_dv_w);
            assert(empty_w);
            assert(rd_data_w == 8'hBB)

        // Fill FIFO with a incrementing pattern
        reset_fifo();

        // Hex: BB => Binary: 1011 1011
        wr_data_r <= 8'hBB;
      
        repeat(DEPTH)
        begin
            wr_dv_r <= 1'b1;
            @(posedge clk);
                wr_dv_r <= 1'b0;
            @(posedge clk);
                wr_data_r <= wr_data_r + 1;
        end 

        wr_dv_r <= 1'b0;
        @(posedge clk);
            assert(full_w);
        @(posedge clk);
        
        // read out and verify
    
        for (i = 8'hBB; i < 8'hBB + DEPTH; i = i + 1)
        begin
            rd_en_r <= 1'b1;
            @(posedge clk);
                rd_en_r <= 1'b0;
            @(posedge clk);
                assert(rd_dv_w);
                assert(rd_data_w == i) else $error("rd_data is: %d, i is: %d", rd_data_w, i);
            @(posedge clk);

        end
        
        assert(empty_w);

        // test read and writing at the same time
        reset_fifo();
        rd_en_r <= 1'b1; 
        wr_dv_r <= 1'b1;

        @(posedge clk);
        @(posedge clk);
            rd_en_r <= 1'b0;
        
        repeat(DEPTH)
          @(posedge clk);
      	
      	assert(full_w);
     	rd_en_r <= 1'b1;
      	@(posedge clk);
      		assert(full_w);
      	@(posedge clk);
      		assert(full_w);
     		wr_dv_r <= 1'b0;
      		rd_en_r <= 1'b0;

        // test AE: almost empty and AF: almost full flags
        reset_fifo();
        assert(AE_flag_w);
        assert(~AF_flag_w);

        wr_dv_r <= 1'b1;
        @(posedge clk);
            assert(AE_flag_w);
            assert(~AF_flag_w);
        @(posedge clk);
            assert(~AE_flag_w);
            assert(~AF_flag_w);
        @(posedge clk);
            assert(~AE_flag_w);
            assert(AF_flag_w);
        @(posedge clk);
            assert(~AE_flag_w);
            assert(AF_flag_w);
            assert(full_w);


        $finish();

    end

    
endmodule