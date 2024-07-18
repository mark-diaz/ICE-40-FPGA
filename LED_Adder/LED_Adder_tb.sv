module LED_Adder_tb;

    reg sw1;
    reg sw2;
    reg sw3;
    reg sw4;
    wire LED_1;
    wire LED_2;
    wire LED_3;

    // Instantiate the Binary_Counter module
    LED_Adder uut (
        .sw1(sw1),
        .sw2(sw2),
        .sw3(sw3),
        .sw4(sw4),
        .LED_1(LED_1),
        .LED_2(LED_2),
        .LED_3(LED_3)
    );

    integer i;
    initial begin
        // Test all combinations of inputs
        for (i = 0; i < 16; i = i + 1) begin
          {sw2, sw1, sw4, sw3} = i;
            #10;
        end
        $finish;
    end

    initial begin
      $monitor("Time = %0t: Switches = %b%b + %b%b -> LEDs = %b%b%b",
                 $time, sw2, sw1, sw4, sw3, LED_1, LED_2, LED_3);
    end

endmodule
