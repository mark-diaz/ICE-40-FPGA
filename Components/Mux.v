// Not necessarily practical to ever build a module for a mux/demux but for own understanding
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

// 16:1 Mux using case statement
module mux_16_1 (
    input [15:0] data_i,
    input [3:0] sel_i,
    output reg data_o 
);

    always @(*) begin
        case(sel_o)
            4'b0000: data_o = data_i[0];
            4'b0001: data_o = data_i[1];
            4'b0010: data_o = data_i[2];
            4'b0011: data_o = data_i[3];
            4'b0100: data_o = data_i[4];
            4'b0101: data_o = data_i[5];
            4'b0110: data_o = data_i[6];
            4'b0111: data_o = data_i[7];
            4'b1000: data_o = data_i[8];
            4'b1001: data_o = data_i[9];
            4'b1010: data_o = data_i[10];
            4'b1011: data_o = data_i[11];
            4'b1100: data_o = data_i[12];
            4'b1101: data_o = data_i[13];
            4'b1110: data_o = data_i[14];
            4'b1111: data_o = data_i[15];
            default: data_o = 1'b0; 
        endcase
    end

endmodule
