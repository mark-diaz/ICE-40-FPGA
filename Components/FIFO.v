module FIFO #(parameter WIDTH = 8, DEPTH = 256) 
    (
        input rstn_i,
        input clk_i,
        // write
        input wr_dv_i,
        input [WIDTH-1:0] wr_data_i,
        input [$clog2(DEPTH)-1:0] AF_level_i,
        output AF_flag_o,
        output full_o,

        // read
        input rd_en_i,
        output rd_dv_o,
        output reg [WIDTH-1:0] rd_data_o,
        input [$clog2(DEPTH)-1:0] AE_level_i,
        output AE_flag_o,
        output empty_o
    );

    reg [$clog2(DEPTH)-1:0] wr_addr_r, rd_addr_r;
    reg [$clog2(DEPTH):0] count_r; 

    wire rd_dv_w;
    wire [WIDTH-1:0] rd_data_w;

    // Utilizes 2 port RAM module to implement FIFO
    
    RAM_2Port #(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_inst
    (
        // write
        .wr_clk_i(clk_i),
        .wr_addr_i(wr_addr_r),
        .wr_dv_i(wr_dv_i),
        .wr_data_i(wr_data_i),

        // read
        .rd_clk_i(clk_i),
        .rd_addr_i(rd_addr_r),
        .rd_en_i(rd_en_i),
        .rd_dv_o(rd_dv_o),
        .rd_data_o(rd_data_w)
    );

    always @(posedge clk_i or negedge rstn_i)
    begin
        // handle reset (active low)
        if(~rstn_i)
        begin
            wr_addr_r <= 0;
            rd_addr_r <= 0;
            count_r <= 0;
        end
        else
        begin
            // write
            if(wr_dv_i)
            begin
                if (wr_addr_r == DEPTH - 1) // wrap around at last address
                    wr_addr_r <= 0;
                else
                    wr_addr_r <= wr_addr_r + 1; 
            end
            // read
            if(rd_en_i) 
            begin
                if(rd_addr_r == DEPTH - 1) // wrap around at last address
                    rd_addr_r <= 0;
                else
                    rd_addr_r = rd_addr_r + 1; 
            end
            // count words in FIFO

            // read no write
            if(rd_en_i & ~wr_dv_i)
            begin
                if(count_r != 0)
                    count_r <= count_r - 1;
            end

            // write no read
            if(wr_dv_i & ~rd_en_i)
            begin
                if(count_r != DEPTH)
                    count_r <= count_r + 1;
            end

            // read data
            if(rd_en_i)
            begin
                rd_data_o <= rd_data_w;
            end

        end

    end

    // currently full or going to be - writing with one available address 

    assign full_o = (count_r == DEPTH) || (count_r == DEPTH - 1 && wr_dv_i && !rd_en_i);
    assign empty_o = (count_r == 0);

    assign AF_flag_o = (count_r > DEPTH - AF_level_i);
    assign AE_flag_o = (count_r < AE_level_i);

    assign rd_dv_o = rd_dv_w;



endmodule

// Implementation of two port ram

module RAM_2Port #(parameter WIDTH = 16, DEPTH = 256)
    (
        // write
        input wr_clk_i,
        input [$clog2(DEPTH)-1:0] wr_addr_i,
        input wr_dv_i,
        input [WIDTH-1:0] wr_data_i,

        // read
        input rd_clk_i,
        input [$clog2(DEPTH)-1:0] rd_addr_i,
        input rd_en_i,
        output reg rd_dv_o,
        output reg [WIDTH-1:0] rd_data_o 
    );

    // memory
    reg[WIDTH-1:0] mem_r[DEPTH-1:0];

    always@(posedge wr_clk_i)
    begin
        if (wr_dv_i)
        begin
            mem_r[wr_addr_i] <= wr_data_i;
        end
    end

    always@(posedge rd_clk_i)
    begin
        rd_data_o <= mem_r[rd_addr_i];
        rd_dv_o <= rd_en_i;
    end

endmodule