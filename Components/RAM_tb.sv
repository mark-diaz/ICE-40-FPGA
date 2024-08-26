module RAM_tb;

    // parameters
    localparam DEPTH = 4; 
    localparam WIDTH = 8; 

    reg clk = 1'b0;
    reg wr_dv_r, rd_en_r = 1'b0;
    
    // log2(4) = 2 bit addresses
    reg [$clog2(DEPTH)-1:0] wr_addr_r = 0, rd_addr_r = 0;

    // 8 bits of data at each address
    reg [WIDTH-1:0] wr_data_r = 0;
    wire [WIDTH-1:0] rd_data_w;
    wire rd_dv_w;

    // 25 Mhz clock
    always #20 clk = ~clk;

    RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM_uut(
        .wr_clk_i(clk),
        .wr_addr_i(wr_addr_r),
        .wr_dv_i(wr_dv_r),
        .wr_data_i(wr_data_r),
        .rd_clk_i(clk),
        .rd_addr_i(rd_addr_r),
        .rd_en_i(rd_en_r),
        .rd_dv_o(rd_dv_w),
        .rd_data_o(rd_data_w)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, RAM_tb);

        repeat(4) @(posedge clk);

        // Fill in memory
        repeat(DEPTH) 
        begin
            wr_dv_r = 1'b1; // data valid bit set
            @(posedge clk)
                wr_data_r = wr_data_r + 1; // increment data and address
                wr_addr_r = wr_addr_r + 1;
        end
        wr_dv_r = 1'b0; // data no longer valid

        // read from memory
        repeat(DEPTH)
        begin
            rd_en_r <= 1'b1;
            @(posedge clk);
                rd_addr_r = rd_addr_r + 1;
        end
        rd_en_r = 1'b0;
       
        repeat(4) @(posedge clk); 

        // Test reading and writing at the same time
        wr_addr_r <= 1;
        wr_data_r <= 84;
        rd_addr_r <= 1;
        rd_en_r <= 1'b1;
        wr_dv_r <= 1'b1;

        @(posedge clk);
            rd_en_r <= 1'b0;
            wr_dv_r <= 1'b0;

        repeat(3) @(posedge clk);
            rd_en_r <= 1'b1;

        @(posedge clk);
            rd_en_r <= 1'b0;

        repeat(3) @(posedge clk);

        $finish();
    end 

endmodule