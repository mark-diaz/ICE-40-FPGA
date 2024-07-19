// Test bench Link: https://www.edaplayground.com/x/GnAu

module Ring_Counter_tb;
    reg sw;         // Using reg type for input signals
    reg clk;        // Using reg type for clock signal
    wire LED_1, LED_2, LED_3, LED_4; // Outputs as wire

    // Instantiate the Ring_Counter Module
    Ring_Counter uut (
        .sw(sw),
        .clk(clk),
        .LED_1(LED_1),
        .LED_2(LED_2),
        .LED_3(LED_3),
        .LED_4(LED_4)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(1, Ring_Counter_tb);
        // Initialize signals
        sw = 0;
        clk = 0;

        // Apply reset
        sw = 1;
        #5;
        sw = 0;

        // Simulate clock signal 16 times
        repeat (16) begin
            #5 clk = ~clk;  // Toggle clock every 5 time units
        end

        $finish;
    end

    initial begin
        $monitor("Time = %0t: LED_1 = %b, LED_2 = %b, LED_3 = %b, LED_4 = %b",
                 $time, LED_1, LED_2, LED_3, LED_4);
    end
endmodule
