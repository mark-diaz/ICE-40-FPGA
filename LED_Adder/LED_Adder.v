module LED_Adder
    (input sw1,
    input sw2,
    input sw3,
    input sw4,
    output LED_1,
    output LED_2,
    output LED_3);
    
    wire sum_1;
    wire carry_1;
    wire sum_2;
    wire carry_2;

    wire[2:0] sum;
    assign sum = {carry_2, sum_2, sum_1}; //carry_2 is the MSB
  assign {LED_1, LED_2, LED_3} = sum;

    full_adder fa_1(.carry_in(1'b0), .in1(sw1), .in2(sw3), .sum(sum_1), .carry(carry_1));
    full_adder fa_2(.carry_in(carry_1), .in1(sw2), .in2(sw4), .sum(sum_2), .carry(carry_2));


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