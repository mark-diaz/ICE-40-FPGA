module LED_Adder
    (input sw1,
    input sw2,
    input sw3,
    input sw4,
    output LED_1,
    output LED_2,
    output LED_3, 
    output LED_4);
    
    wire sum_1;
    wire carry_1;
    wire sum_2;
    wire carry_2;

    // two operands to be added (2-Bit Adder)
    wire[1:0] op_1;
    wire[1:0] op_2;

    assign op_1 = {sw2, sw1};
    assign op_2 = {sw4, sw3};

    wire[3:0] sum;
    
    // MSB: LED_1 
    assign sum = {1'b0, carry_2, sum_2, sum_1}; 
    assign {LED_1, LED_2, LED_3, LED_4} = sum;

    full_adder fa_1(.carry_in(1'b0), .in1(op_1[0]), .in2(op_2[0]), .sum(sum_1), .carry(carry_1));
    full_adder fa_2(.carry_in(carry_1), .in1(op_1[1]), .in2(op_2[1]), .sum(sum_2), .carry(carry_2));
endmodule

module full_adder
    (input carry_in,
     input in1,
     input in2,
     output sum,
     output carry);

     wire prop; // propagate
     wire gen; // generate
     wire carry_out;

    half_adder ha_1(.in1(in1), .in2(in2), .sum(prop), .carry(gen));
    half_adder ha_2(.in1(prop), .in2(carry_in), .sum(sum), .carry(carry_out));
    assign carry = carry_out | gen;
endmodule

module half_adder
    (input in1,
     input in2,
     output sum,
     output carry);

    assign sum = in1 ^ in2;
    assign carry = in1 & in2;
endmodule