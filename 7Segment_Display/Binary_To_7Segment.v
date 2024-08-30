// converts a binary number to drive a 7 Segment Display output

module Binary_To_7Segment
(
    input clk_i,
    input [3:0] binary_num_i,
    output seg_A_o,
    output seg_B_o,
    output seg_C_o,
    output seg_D_o,
    output seg_E_o,
    output seg_F_o,
    output seg_G_o
);
    reg [6:0] hex_encoding_r = 7'h00;

    always @(posedge clk_i)
    begin
        case(binary_num_i)
            4'b0000 : hex_encoding_r <= 7'h7E; // 0 : 0x7E -> 111 1110
            4'b0001 : hex_encoding_r <= 7'h30; // 1 
            4'b0010 : hex_encoding_r <= 7'h6D; // 2
            4'b0011 : hex_encoding_r <= 7'h79; // 3
            4'b0100 : hex_encoding_r <= 7'h33; // 4
            4'b0101 : hex_encoding_r <= 7'h5B; // 5
            4'b0110 : hex_encoding_r <= 7'h5F; // 6
            4'b0111 : hex_encoding_r <= 7'h70; // 7
            4'b1000 : hex_encoding_r <= 7'h7F; // 8
            4'b1001 : hex_encoding_r <= 7'h7B; // 9
            4'b1010 : hex_encoding_r <= 7'h77; // A
            4'b1011 : hex_encoding_r <= 7'h1F; // B
            4'b1100 : hex_encoding_r <= 7'h4E; // C
            4'b1101 : hex_encoding_r <= 7'h3D; // D
            4'b1110 : hex_encoding_r <= 7'h4F; // E
            4'b1111 : hex_encoding_r <= 7'h47; // F

            default : hex_encoding_r <= 7'h00;
        endcase

    end

    assign {seg_A_o, seg_B_o, seg_C_o, seg_D_o, seg_E_o, seg_F_o, seg_G_o} = hex_encoding_r;


endmodule