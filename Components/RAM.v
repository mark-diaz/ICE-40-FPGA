// Implementation of two port ram

module RAM #(parameter WIDTH = 16, DEPTH = 256)
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
        output reg [WIDTH-1:0] rd_data_o );

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