// Shift Register: with direction, reset and enable
module shift_register #(parameter WIDTH = 8)
(
    input d_i,
    input clk_i,
    input en_i,
    input dir_i,
    input rstn_i,
    output reg [WIDTH-1:0] reg_o
)
always@(posedge clk_i)
    begin
        if(!rstn_i)
        begin
            reg_o <= 0;
        end
        else 
        begin
            if(en_i)
            begin
                // dir_i 1: left 0: right
                case (dir_i)
                    0: reg_o <= {reg_o[WIDTH-2:0], d_i};
                    1: reg_o <= {d_i, reg_o[WIDTH-1:1]};
                endcase
            end
            else
            begin
                out <= out;
            end
        end
    end
endmodule

// Linear Feedback Shift Register
module LSFR #(parameter WIDTH = 8)
(
    input clk_i,
    input rstn_i,
    output reg_o[WIDTH-1:0]
);
    reg [WIDTH-1:0] LSFR_r;
    wire xnor_w;

    always@(posedge clk_i)
    begin
        if(!rstn_i)
        begin
            reg_o <= 0;
        end
        else
        begin
            LSFR_r <= {LSFR_r[WIDTH-2:0], xnor_w};
        end
    end
    assign xnor_w = ~(LSFR_r[WIDTH-1] ^ LSFR_r[WIDTH-2]);

endmodule
