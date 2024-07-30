module mux_demux_tb;

    // Inputs for mux
    reg [3:0] data_i;
    reg r_Sel0, r_Sel1;
    wire data_o;

    // Outputs for demux
    wire [3:0] demux_out;

    // Instantiate the mux
    mux uut_mux (
        .data0_i(data_i[0]),
        .data1_i(data_i[1]),
        .data2_i(data_i[2]),
        .data3_i(data_i[3]),
        .sel0_i(r_Sel0),
        .sel1_i(r_Sel1),
        .data_o(data_o)
    );

    // Instantiate the demux
    demux uut_demux (
        .data_i(data_o),
        .sel0_i(r_Sel0),
        .sel1_i(r_Sel1),
        .data0_o(demux_out[0]),
        .data1_o(demux_out[1]),
        .data2_o(demux_out[2]),
        .data3_o(demux_out[3])
    );

    // Task to set select inputs
    task set_select(input reg [1:0] sel);
        #1;
        r_Sel1 = sel[1];
        r_Sel0 = sel[0];
        #1;
    endtask

    initial begin
        // VCD file generation
        $dumpfile("mux_demux_tb.vcd");
        $dumpvars(0, mux_demux_tb);

        // Test cases for mux
        data_i = 4'b0101;

        // Test mux
        set_select(2'b00); assert(data_o == data_i[0]);
        set_select(2'b01); assert(data_o == data_i[1]);
        set_select(2'b10); assert(data_o == data_i[2]);
        set_select(2'b11); assert(data_o == data_i[3]);

        // Test demux
        set_select(2'b00); assert(demux_out == 4'b0001);
        set_select(2'b01); assert(demux_out == 4'b0010);
        set_select(2'b10); assert(demux_out == 4'b0100);
        set_select(2'b11); assert(demux_out == 4'b1000);

        $finish;
    end

endmodule
