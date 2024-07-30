// Not necessarily practical to ever build a module for a mux/demux but it's good practice to learn :)
// 4:1 Mux
module mux (
    input data0_i,
    input data1_i,
    input data2_i,
    input data3_i,
    input sel0_i,
    input sel1_i,
    output data_o );

assign data_o = ~sel1_i & ~sel0_i ? data0_i :
                ~sel1_i & sel0_i ? data1_i :
                sel1_i & ~sel0_i ? data2_i : data3_i;

endmodule

// 1:4 Demux
module demux ( 
    input data_i,
    input sel0_i,
    input sel1_i,
    output data0_o,
    output data1_o,
    output data2_o,
    output data3_o );

    assign data0_o = ~sel1_i & ~sel0_i ? data_i : 1'b0;
    assign data1_o = ~sel1_i & sel0_i ? data_i : 1'b0;
    assign data2_o = sel1_i & ~sel0_i ? data_i : 1'b0;
    assign data3_o = sel1_i & sel0_i ? data_i : 1'b0;

endmodule
