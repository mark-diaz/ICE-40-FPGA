module Ring_Counter_tb;
    reg clk_i;
    reg sw_i;
    wire LED_1_o;
    wire LED_2_o;
    wire LED_3_o;
    wire LED_4_o;

    // Instantiate the Ring_Counter module
    Ring_Counter uut (
        .clk_i(clk_i),
        .sw_i(sw_i),
        .LED_1_o(LED_1_o),
        .LED_2_o(LED_2_o),
        .LED_3_o(LED_3_o),
        .LED_4_o(LED_4_o)
    );

    // Clock generation
    always #20 clk_i = ~clk_i; // 25 MHz clock

    initial begin
      	$dumpfile("test.vcd");
   		$dumpvars(1, Ring_Counter_tb);
        // Initialize inputs
        clk_i = 0;
        sw_i = 0;

        // Test scenario
        #100 sw_i = 1; // Press switch
       	#500 sw_i = 0; // Release switch
      	#5000;
        
        // Add more test scenarios as needed

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t, LED_1_o = %b, LED_2_o = %b, LED_3_o = %b, LED_4_o = %b",
                 $time, LED_1_o, LED_2_o, LED_3_o, LED_4_o);
    end

endmodule
