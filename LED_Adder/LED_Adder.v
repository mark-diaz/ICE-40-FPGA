module LED_Adder
    (input sw1_i,
    input sw2_i,
    input sw3_i,
    input sw4_i,
    output LED_1_o,
    output LED_2_o,
    output LED_3_o, 
    output LED_4_o);
    
    wire sum_1;
    wire carry_1;
    wire sum_2;
    wire carry_2;

    // two operands to be added (2-Bit Adder)
    wire[1:0] op_1;
    wire[1:0] op_2;

    assign op_1 = {sw2_i, sw1_i};
    assign op_2 = {sw4_i, sw3_i};

    // Intermediate variable sum used for clarity
    wire[3:0] sum;
    assign sum = {1'b0, carry_2, sum_2, sum_1}; 
    assign {LED_1_o, LED_2_o, LED_3_o, LED_4_o} = sum;

    full_adder fa_1(.carry_in(1'b0), .in1(op_1[0]), .in2(op_2[0]), .sum(sum_1), .carry(carry_1));
    full_adder fa_2(.carry_in(carry_1), .in1(op_1[1]), .in2(op_2[1]), .sum(sum_2), .carry(carry_2));
endmodule

module full_adder
    (input carry_i,
     input in1_i,
     input in2_i,
     output sum_o,
     output carry_o);

     wire prop; // propagate
     wire gen; // generate
     wire carry_out;

    half_adder ha_1(.in1_i(in1_i), .in2_i(in2_i), .sum_o(prop), .carry_o(gen));
    half_adder ha_2(.in1_i(prop), .in2_i(carry_i), .sum_o(sum_o), .carry_o(carry_out));
    assign carry_o = carry_out | gen;
endmodule

module half_adder
    (input in1_i,
     input in2_i,
     output sum_o,
     output carry_o);

    assign sum_o = in1_i ^ in2_i;
    assign carry_o = in1_i & in2_i;
endmodule